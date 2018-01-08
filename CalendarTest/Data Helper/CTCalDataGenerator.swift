//
//  CTCalDataGenerator.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

final class CTCellUIData {

	let shouldDrawInGrey:Bool
	let dateString:String

	var isBlankDay:Bool {
		return self.dateString.isEmpty
	}

	init(dateString:String, shouldDrawInGrey:Bool) {
		self.dateString = dateString
		self.shouldDrawInGrey = shouldDrawInGrey
	}

	//formatting of date
	convenience init(date:Date, shouldUseGreyColor:Bool) {
		let dateFormatter = DateFormatter()
		if date.isFirstDateOfMonth {
			if date.isInCurrentYear {
				dateFormatter.dateFormat = "d MMM"
			}else {
				dateFormatter.dateFormat = "MMM d yyyy"
			}
		}else {
			dateFormatter.dateFormat = " d"
		}
		let dateString = dateFormatter.string(from: date).replacingOccurrences(of: " ", with: "\n")
		self.init(dateString: dateString, shouldDrawInGrey: shouldUseGreyColor)
	}
}

final class CTCalDataGenerator {

	final func getBasicCalData() -> [[CTCellUIData]] {
		let minMaxDateInfo = self.minMaxDateToShow()
		var currentDay = 1
		var shouldFillGrey = false
		var currentDateInIteration = minMaxDateInfo.minDate
		let endDate = minMaxDateInfo.maxDate
		var currentRowData = [CTCellUIData]()
		var completeCalUIData = [[CTCellUIData]]()

		//fill first row intial empty days
		while currentDay < currentDateInIteration.day {
			//Empty date string means blank date
			let emptyCell = CTCellUIData(dateString: "", shouldDrawInGrey: false)
			currentRowData.append(emptyCell)
			currentDay += 1
		}

		//fill all other row and coloums of cal data
		while currentDateInIteration <= endDate {
			//row fill -- no of days in week is 7 - 1..8 (1- sunday 8- saturday)
			while currentDay < 8 {
				//next date can be empty cell if last row is in iteration
				let nextCellUIData = currentDateInIteration <= endDate ? CTCellUIData(date: currentDateInIteration, shouldUseGreyColor: shouldFillGrey) : CTCellUIData(dateString: "", shouldDrawInGrey: false)
				currentRowData.append(nextCellUIData)
				let nextDate = currentDateInIteration.nextDate.startOfDate
				if nextDate.isInSameMonth(withDate: currentDateInIteration) {
					shouldFillGrey = !shouldFillGrey
				}
				currentDateInIteration = nextDate
				currentDay += 1
			}

			completeCalUIData.append(currentRowData)

			//next row to be filled now
			currentRowData = [CTCellUIData]()
			currentDay = 1
		}

		return completeCalUIData
	}

	private func minMaxDateToShow() -> (minDate:Date, maxDate:Date) {
		let minDate = Calendar.current.pastMonth(noOfMonths: 3, date: Date()).startOfDate
		let maxDate = Calendar.current.futureMonth(noOfMonths: 11, date: Date()).startOfDate
		return (minDate, maxDate)
	}
}
