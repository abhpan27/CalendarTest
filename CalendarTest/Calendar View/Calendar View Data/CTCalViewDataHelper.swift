//
//  CTCalDataGenerator.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
Mapping between day name and day no - Sunday is 1 saturday is 7
*/
internal enum WeekDayNumber:Int {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}


/**
This class is used by overlay table view rows in Calendar view. As soon as user starts scrolling Calendar view a table view with some transparancy is shown above calendar collection view. Object of this class represents one month in that table view.
*/
final class CTCalTableViewData {

	///Name of month shown in overlay table view.
	let monthName:String

	///No of different week in any month. Used to calculate height for row for this month
	let noOfDifferentWeeksInMonth:Int

	init(monthName:String, noOfDifferentWeeksInMonth:Int) {
		self.monthName = monthName
		self.noOfDifferentWeeksInMonth = noOfDifferentWeeksInMonth
	}
}

/**
This class loads data which is used to create and update Calendar view.
*/
final class CTCalViewDataHelper {

	///Data for UI of collection view of Calendar view.
	var calCollectionViewUIData = [[CTCalCollectionViewCellUIData]]()

	///Data for UI of Overlay table view of Calendar view.
	var calTableViewUIData = [CTCalTableViewData]()

	///Helps in querying Core data. Used to load availability of events on any date
	private let dbQueryHelper = CTDBQueryDataHelper()

	///No of days queried from DB in single call
	let noOfDatesToQueryEachTime = 30

	/**
	This method load minimal UI Data. Minimal UI data is used to Draw barebones of collection view and Overlay table view.
	After loading Minimal UI data, core data is queried in background thread and event availabilty dot colors are added.
	*/
	final func loadBaicUIdata() {
		self.calCollectionViewUIData = getBasicCollectionViewCalData()
		self.calTableViewUIData = getBasicTableViewCalData()
	}


	/**
	This method loads Barebone UI data for collection view. It is a 2D array where each row represents 1 Week. So no of coloumns in each row is 7 (equal to no of day in week).
	2D array of CTCalCollectionViewCellUIData is generated in form of -
	- - - - d d d
	d d d d d d d
	.
	.
	.
	d d d d d d d
	d d d - - - -

	where d represent data and - represents blank cell. Only first and last row will have blank cells

	 - Returns: 2D array of CTCalCollectionViewCellUIData.
	*/
	private func getBasicCollectionViewCalData() -> [[CTCalCollectionViewCellUIData]] {
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		var currentDay = WeekDayNumber.sunday.rawValue
		var shouldFillGrey = false
		var currentDateInIteration = minMaxDateInfo.minDate
		let endDate = minMaxDateInfo.maxDate
		var currentRowData = [CTCalCollectionViewCellUIData]()
		var completeCalUIData = [[CTCalCollectionViewCellUIData]]()

		//fill blank cells in first row
		while currentDay < currentDateInIteration.weekDay {
			//Date epoch -1 means blank cell
			let emptyCell = CTCalCollectionViewCellUIData(dateEpoch: -1, shouldDrawInGrey: false)
			currentRowData.append(emptyCell)
			currentDay += 1
		}

		//fill all other row and coloums of cal data
		while currentDateInIteration <= endDate {
			//Fill each row. Current day will be in range (1-8) 1- sunday 8- saturday
			while currentDay <= WeekDayNumber.saturday.rawValue {
				//next date can be blank cell also if this is last row and currentDateInIteration is after endDate
				let nextCellUIData = currentDateInIteration <= endDate ? CTCalCollectionViewCellUIData(dateEpoch: currentDateInIteration.timeIntervalSince1970, shouldDrawInGrey: shouldFillGrey) : CTCalCollectionViewCellUIData(dateEpoch: -1, shouldDrawInGrey: false)

				currentRowData.append(nextCellUIData)

				let nextDate = currentDateInIteration.nextDate.startOfDate
				if !nextDate.isInSameMonth(with: currentDateInIteration) {
					//change color when month changes. It will be used to draw months in white and grey color alternatively
					shouldFillGrey = !shouldFillGrey
				}
				currentDateInIteration = nextDate
				currentDay += 1
			}

			completeCalUIData.append(currentRowData)

			//next row to be filled now
			currentRowData = [CTCalCollectionViewCellUIData]()
			currentDay = WeekDayNumber.sunday.rawValue
		}
		return completeCalUIData
	}


	/**
	This method generates UI data for semi transparent overlay table shown above calendar collection view. Each element of array returned represents one Row of Overlay table.

	- Returns: Array of CTCalTableViewData.
	*/
	private func getBasicTableViewCalData() -> [CTCalTableViewData] {
		var calTableViewData =  [CTCalTableViewData]()
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		var currentDateInIteration = minMaxDateInfo.minDate

		while(currentDateInIteration <= minMaxDateInfo.maxDate) {

			//no of different weeks in a month can be 4 or 5
			var noOfWeeksToShowForCurrentMonth = currentDateInIteration.numberOfWeeksInCurrentMonth
			let lastDayOfMonth = Calendar.current.endOfMonth(currentDateInIteration).weekDay

			//if last day of current month is not on saturday and this is not last month in iteration then this row in collection view is shared by some intial dates of next month, we will not include such row in current month
			if (lastDayOfMonth != WeekDayNumber.saturday.rawValue && currentDateInIteration != minMaxDateInfo.maxDate) {
				noOfWeeksToShowForCurrentMonth -= 1 //remove last week row as it is shared by next month in UI
			}

			let newCalTableUIData = CTCalTableViewData(monthName: currentDateInIteration.monthName, noOfDifferentWeeksInMonth: noOfWeeksToShowForCurrentMonth)
			calTableViewData.append(newCalTableUIData)

			//process next month now
			currentDateInIteration = Calendar.current.nextMonthEndDate(currentDateInIteration)
		}
		return calTableViewData
	}


	/**
	This method loads color of dots shown in each cell of collection view. Color of dot shown in cell depends of no of events avaiable on that date.
	During intial UI creation (using getBasicCollectionViewCalData) color of dots for each cell is set as clear color. After call to this method each cell will have actual colors.

	- Parameter completion: Completion handler called when loading dot color of every cell is completed.
	- Note: This should not be done in main thread. There can be many events and so doing such DB query in Main thread will cuase mejor lag in UI.
	*/
	final func loadEventAvailabiltyForShowingDots(completion:@escaping () -> ()) {
		let nextStartDate = CTAppConstants.shared.minMaxDate.minDate
		let nextEndDate = nextStartDate.nextDateAfter(days: self.noOfDatesToQueryEachTime)
		//call for chunk of intial 30 days
		loadEventAvailablityInCalData(fromDate: nextStartDate, toDate: nextEndDate, completion: completion)
	}


	/**
	This method does actual task of querying no of events on dates. It queries core data in chunk of 30 days and calls appendEventAvailabilityInCurrentCalData to change color of dots of cells in that range.
	it keeps celling itself recursively untill every cell has dot color.
	It runs in background context to avoid any lag in Main thread.

	 - Parameter fromDate: Minimum date for query.
	 - Parameter toDate: Maximum date for query.
	 - Parameter completion: Completion handler called at the end of recursion.
	*/
	private func loadEventAvailablityInCalData(fromDate:Date, toDate:Date, completion:@escaping () -> ()) {

		let maxDate = CTAppConstants.shared.minMaxDate.maxDate

		if fromDate > maxDate {
			completion()
			return
		}

		//DB content reuest for current chunk
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .calViewdata)
		//get dictonary of event available on dates of current range
		dbQueryHelper.dictionaryOfEventAvalabilty(forContentRequest: contentRequest) {
			[weak self]
			(availabiltyDict, error)
			in

			guard let blockSelf = self
				else {
					completion()
					return
			}

			if availabiltyDict != nil {
				blockSelf.appendEventAvailabilityInCurrentCalData(availabiltyDict: availabiltyDict!, tillEndDate: toDate)
			}

			//even if there was some error for current chunk, try for next chunk of 30 days
			let nextStartDate = contentRequest.toDate.nextDate
			let nextEndDate = nextStartDate.nextDateAfter(days: blockSelf.noOfDatesToQueryEachTime)
			blockSelf.loadEventAvailablityInCalData(fromDate: nextStartDate, toDate: nextEndDate, completion: completion)
		}
	}

	/**
	This method changes data for each calCollectionViewUIData which is already loaded during intial UI creation.

	- Parameter availabiltyDict: Key value pair of type [Date:Int]. It represents how many events are present on particular date
	- Parameter tillEndDate: Maximum date present in availabiltyDict.
	*/
	private func appendEventAvailabilityInCurrentCalData(availabiltyDict:[Date:Int], tillEndDate:Date) {
		//go to each cell and update it's dot color
		for rowIndex in 0 ... self.calCollectionViewUIData.count - 1 {
			for coloumnIndex in 0 ... 6 {
				let cellData = self.calCollectionViewUIData[rowIndex][coloumnIndex]
				if cellData.isBlankDay {
					continue
				}

				if cellData.dateEpoch > tillEndDate.timeIntervalSince1970 {
					return
				}

				let dateForCell = Date(timeIntervalSince1970: cellData.dateEpoch)
				if let noOfEventsOnDay = availabiltyDict[dateForCell] {
					if noOfEventsOnDay == 1 {
						//if no of events on date is 1, use light grey color for dot
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.lightGrey.rawValue
					}else if noOfEventsOnDay == 2 {
						//if no of events on date is 2, use medium grey color for dot
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.mediumGrey.rawValue
					}else {
						//if no of events on date is 3 or more than 3, then use dark grey color for dot
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.darkGrey.rawValue
					}
					//by default dot's color for each cell is already set to clear color, so need to check for 0 events, process next item
				}
			}
		}
	}


	/**
	This method returns Indexpath of cell for date.
	It has to be very fast because it is used for selecting date on scoll of agenda view.
	Linear search won't work here due to O(n) time, we are using date component based calculations.

	- Parameter date: Date for which indexpath is needed.
	- Returns: optional index path for date. It may be nil if some invalid date is passed.
	*/
	final func indexPathForDate(date:Date) -> IndexPath? {
		//get first non blank date shown in first row
		let firstDateInfo = self.getFirstDateInfo()!
		//if date is in dame week then just return index path
		if date.isInSameWeek(with: firstDateInfo.date) {
			let daysBetween = date.days(from: firstDateInfo.date)
			return IndexPath(row: firstDateInfo.indexPath.row + daysBetween, section: 0)
		}

		//get no of weeks between first date shown in first row and Date passes as parameter
		let numberOfWeeksBetweenDates = date.numberOfWeeks(from: firstDateInfo.date)
		let rowOfDate = date.weekDay - 1 //week days are in range (1..7) rows are in range (0...6)

		//Section of date is simply week between dates
		let sectionOfDate = numberOfWeeksBetweenDates

		guard sectionOfDate < self.calCollectionViewUIData.count && rowOfDate < 7
			else {
				return nil
		}
		return IndexPath(row: rowOfDate, section: sectionOfDate)
	}

	/**
	This method returns minimum date that is shown in collection view.

	- Returns: tuple of date and index path of first non blank Cell of first row.
	*/
	private func getFirstDateInfo() -> (date:Date, indexPath:IndexPath)? {
		let firstRow = self.calCollectionViewUIData[0]
		for index in 0 ... 6 {
			if firstRow[index].dateEpoch != -1 {
				let indexPath = IndexPath(row: index, section: 0)
				let date = Date(timeIntervalSince1970: firstRow[index].dateEpoch)
				return (date, indexPath)
			}
		}
		return nil
	}

	/**
	This method returns Index path for date.

	- Parameter date: indexPath for which date is needed.
	- Returns: optional date for index path. It can be nil if invalid index path is passed.
	*/
	final func dateForIndexPath(indexPath:IndexPath) -> Date? {
		let row = indexPath.section
		let coloumn = indexPath.row

		if coloumn < 7 && coloumn >= 0 {
			if row >= 0 && row < self.calCollectionViewUIData.count {
				let epoch = self.calCollectionViewUIData[row][coloumn].dateEpoch
				return Date(timeIntervalSince1970: epoch).startOfDate
			}
		}
		return nil
	}
}
