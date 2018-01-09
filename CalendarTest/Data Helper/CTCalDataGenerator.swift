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
	let dateEpoch:TimeInterval //this will be -1 for blank dates
	let dateNumberString:String // only date number i.e. 1,2, 30 etc
	let fullDateString:String // for start of month

	var isBlankDay:Bool {
		return self.fullDateString.isEmpty
	}

	init(dateEpoch:TimeInterval, shouldDrawInGrey:Bool) {
		self.dateEpoch = dateEpoch
		self.shouldDrawInGrey = shouldDrawInGrey

		//getting all the UI data here so that no need to calculate it at runtime thus smooth scroll will be achived
		if  dateEpoch != -1 {
			let date = Date(timeIntervalSince1970: dateEpoch)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "d"
			dateNumberString = dateFormatter.string(from: date)

			//full date string
			if date.isFirstDateOfMonth {
				if date.isInCurrentYear {
					dateFormatter.dateFormat = "d#MMM"
				}else {
					dateFormatter.dateFormat = "MMM#d#yyyy"
				}
			}else {
				dateFormatter.dateFormat = "d"
			}
			self.fullDateString = dateFormatter.string(from: date).replacingOccurrences(of: "#", with: "\n")
		}else {
			dateNumberString = ""
			fullDateString = ""
		}
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
			let emptyCell = CTCellUIData(dateEpoch: -1, shouldDrawInGrey: false)
			currentRowData.append(emptyCell)
			currentDay += 1
		}

		//fill all other row and coloums of cal data
		while currentDateInIteration <= endDate {
			//row fill -- no of days in week is 7 - 1..8 (1- sunday 8- saturday)
			while currentDay < 8 {
				//next date can be empty cell if last row is in iteration

				let nextCellUIData = currentDateInIteration <= endDate ? CTCellUIData(dateEpoch: currentDateInIteration.timeIntervalSince1970, shouldDrawInGrey: shouldFillGrey) : CTCellUIData(dateEpoch: -1, shouldDrawInGrey: false)
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
			currentRowData = [CTCellUIData]()
			currentDay = 1
		}

		return completeCalUIData
	}

	private func minMaxDateToShow() -> (minDate:Date, maxDate:Date) {
		let minDate = Calendar.current.pastMonth(noOfMonths: 3, date: Date()).startOfDate
		let maxDate = Calendar.current.futureMonth(noOfMonths: 12, date: Date()).startOfDate
		return (minDate, maxDate)
	}
}
