//
//  CTCalDataGenerator.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

internal enum WeekDayNumber:Int {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

final class CTCalTableViewData {

	let monthName:String
	let noOfDifferentWeeksInMonth:Int

	init(monthName:String, noOfDifferentWeeksInMonth:Int) {
		self.monthName = monthName
		self.noOfDifferentWeeksInMonth = noOfDifferentWeeksInMonth
	}
}

final class CTCalViewDataHelper {

	var calCollectionViewUIData = [[CTCalCollectionViewCellUIData]]()
	var calTableViewUIData = [CTCalTableViewData]()
	private let dbQueryHelper = CTDBQueryDataHelper()
	let noOfDatesToQueryEachTime = 30

	final func loadBaicUIdata() {
		self.calCollectionViewUIData = getBasicCollectionViewCalData()
		self.calTableViewUIData = getBasicTableViewCalData()
	}

	private func getBasicCollectionViewCalData() -> [[CTCalCollectionViewCellUIData]] {
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		var currentDay = 1
		var shouldFillGrey = false
		var currentDateInIteration = minMaxDateInfo.minDate
		let endDate = minMaxDateInfo.maxDate
		var currentRowData = [CTCalCollectionViewCellUIData]()
		var completeCalUIData = [[CTCalCollectionViewCellUIData]]()

		//fill first row intial empty days
		while currentDay < currentDateInIteration.weekDay {
			//Empty date string means blank date
			let emptyCell = CTCalCollectionViewCellUIData(dateEpoch: -1, shouldDrawInGrey: false)
			currentRowData.append(emptyCell)
			currentDay += 1
		}

		//fill all other row and coloums of cal data
		while currentDateInIteration <= endDate {
			//row fill -- no of days in week is 7 - 1..8 (1- sunday 7- saturday)
			while currentDay < 8 {
				//next date can be empty cell if last row is in iteration
				let nextCellUIData = currentDateInIteration <= endDate ? CTCalCollectionViewCellUIData(dateEpoch: currentDateInIteration.timeIntervalSince1970, shouldDrawInGrey: shouldFillGrey) : CTCalCollectionViewCellUIData(dateEpoch: -1, shouldDrawInGrey: false)
				currentRowData.append(nextCellUIData)
				let nextDate = currentDateInIteration.nextDate.startOfDate
				if !nextDate.isInSameMonth(with: currentDateInIteration) {
					shouldFillGrey = !shouldFillGrey
				}
				currentDateInIteration = nextDate
				currentDay += 1
			}

			completeCalUIData.append(currentRowData)

			//next row to be filled now
			currentRowData = [CTCalCollectionViewCellUIData]()
			currentDay = 1
		}

		return completeCalUIData
	}

	private func getBasicTableViewCalData() -> [CTCalTableViewData] {
		var calTableViewData =  [CTCalTableViewData]()
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		var currentDateInIteration = minMaxDateInfo.minDate

		while(currentDateInIteration <= minMaxDateInfo.maxDate) {

			var noOfWeeksToShowForCurrentMonth = currentDateInIteration.numberOfWeeksInCurrentMonth
			let lastDayOfMonth = Calendar.current.endOfMonth(currentDateInIteration).weekDay

			//if last day of current month is not on saturday and this is not last month in iteration then we will not inlcude last row for hight calculation in month
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

	final func loadEventAvailabiltyForShowingDots(completion:@escaping () -> ()) {
		let nextStartDate = CTAppConstants.shared.minMaxDate.minDate
		let nextEndDate = nextStartDate.nextDateAfter(days: self.noOfDatesToQueryEachTime)
		loadEventAvailablityInCalData(fromDate: nextStartDate, toDate: nextEndDate, completion: completion)
	}

	private func loadEventAvailablityInCalData(fromDate:Date, toDate:Date, completion:@escaping () -> ()) {

		let maxDate = CTAppConstants.shared.minMaxDate.maxDate

		if fromDate > maxDate {
			completion()
			return
		}

		//fill current range
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .calViewdata)
		dbQueryHelper.dictionaryOfEventAvalabilty(forContentRequest: contentRequest) {
			[weak self]
			(availabiltyDict, error)
			in

			guard let blockSelf = self
				else {
					return
			}

			if availabiltyDict != nil {
				blockSelf.appendEventAvailabilityInCurrentCalData(availabiltyDict: availabiltyDict!, tillEndDate: toDate)
			}

			let nextStartDate = contentRequest.toDate.nextDate
			let nextEndDate = nextStartDate.nextDateAfter(days: blockSelf.noOfDatesToQueryEachTime)
			blockSelf.loadEventAvailablityInCalData(fromDate: nextStartDate, toDate: nextEndDate, completion: completion)
		}
	}

	private func appendEventAvailabilityInCurrentCalData(availabiltyDict:[Date:Int], tillEndDate:Date) {
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
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.lightGrey.rawValue
					}else if noOfEventsOnDay == 2 {
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.mediumGrey.rawValue
					}else {
						self.calCollectionViewUIData[rowIndex][coloumnIndex].eventAvailabilityColor = CalendarViewCellEventAvailablityColor.darkGrey.rawValue
					}
				}
			}
		}
	}

	final func indexPathForDate(date:Date) -> IndexPath? {
		let firstDateInfo = self.getFirstDateInfo()!
		if date.isInSameWeek(with: firstDateInfo.date) {
			let daysBetween = date.days(from: firstDateInfo.date)
			return IndexPath(row: firstDateInfo.indexPath.row + daysBetween, section: 0)
		}

		let numberOfWeeks = date.numberOfWeeks(from: firstDateInfo.date)
		let rowOfDate = date.weekDay - 1
		let sectionOfDate = date.weekDay != WeekDayNumber.saturday.rawValue ? numberOfWeeks + 1 : numberOfWeeks

		guard sectionOfDate < self.calCollectionViewUIData.count && rowOfDate < 8
			else {
				return nil
		}

		return IndexPath(row: rowOfDate, section: sectionOfDate)
	}

	final func getFirstDateInfo() -> (date:Date, indexPath:IndexPath)? {
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
