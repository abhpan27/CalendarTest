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

final class CTCalDataGenerator {

	final func getBasicCollectionViewCalData() -> [[CTCalCollectionViewCellUIData]] {
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
				if !nextDate.isInSameMonth(withDate: currentDateInIteration) {
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

	final func getBasicTableViewCalData() -> [CTCalTableViewData] {
		var calTableViewData =  [CTCalTableViewData]()
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		var currentDateInIteration = minMaxDateInfo.minDate

		while(currentDateInIteration <= minMaxDateInfo.maxDate) {

			var noOfWeeksToShowForCurrentMonth = currentDateInIteration.numberOfWeeksInCurrentMonth
			let lastDayOfMonth = Calendar.current.endOfMonth(currentDateInIteration).weekDay

			//if last day of current month is not on saturday and this is not last month in iteration then we will not inlcude last row for hight calculation in month
			if (lastDayOfMonth != WeekDayNumber.saturday.rawValue && currentDateInIteration != minMaxDateInfo.maxDate) {
				noOfWeeksToShowForCurrentMonth -= 1 //remove last week
			}

			let newCalTableUIData = CTCalTableViewData(monthName: currentDateInIteration.monthName, noOfDifferentWeeksInMonth: noOfWeeksToShowForCurrentMonth)
			calTableViewData.append(newCalTableUIData)

			//process next month now
			currentDateInIteration = Calendar.current.nextMonthEndDate(currentDateInIteration)
		}
		return calTableViewData
	}
}
