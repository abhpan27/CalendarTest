//
//  CTDateUtilityTest.swift
//  CalendarTestTests
//
//  Created by Abhishek on 14/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import XCTest
@testable import CalendarTest

/**
Unit tests for Date extension.
*/
class CTDateUtilityTest: XCTestCase {

	override func setUp() {
        super.setUp()
    }

	/**
	Unit test for getting next date from date
	*/
	func testNextDateUtility() {
		let firstDate = dateFromText(fullDateText: "Jan 14, 2018 12:00:00")
		let secondDateSameTime = dateFromText(fullDateText: "Jan 15, 2018 12:00:00")
		let thirdDateDifferentTime = dateFromText(fullDateText: "Jan 15, 2018 12:00:01")

		//next date should give next date with exact same time as current date
		XCTAssert(firstDate.nextDate == secondDateSameTime, "Next date is not same as expected")
		XCTAssert(firstDate.nextDate != thirdDateDifferentTime, "Next date with different time is accepted")
	}


	/**
	Unit test for getting first moment of any day
	*/
	func testStartOfDateUtility() {
		let endOfDate = dateFromText(fullDateText: "Jan 14, 2018 23:59:59")
		let expectedStartOfDate = dateFromText(fullDateText: "Jan 14, 2018 00:00:00")

		//start of date should give first moment of day
		XCTAssert(endOfDate.startOfDate == expectedStartOfDate, "Start of date not returnig first moment of day")
	}

	/**
	Unit test for getting last moment of any day
	*/
	func testEndOfDayUtility() {
		let startOfDay = dateFromText(fullDateText: "Jan 14, 2018 00:00:00")
		let expectedEndOfDay = dateFromText(fullDateText: "Jan 14, 2018 23:59:59")

		//end of day will return day with time 23:59:59
		XCTAssert(startOfDay.endOfDate == expectedEndOfDay, "End of day is not returning last moment of day")
	}

	/**
	Unit test for checking if dates are in same year
	*/
	func testIsInSameYearUtility() {
		let firstDayOfYear = dateFromText(fullDateText: "Jan 1, 2018 00:00:00")
		let lastDayOfYear = dateFromText(fullDateText: "Dec 31, 2018 23:59:59")
		let firstDayOfNextYear = dateFromText(fullDateText: "Jan 1, 2019 00:00:00")

		//first day with 00:00:00 and last date with 23:59:59 of same year
		XCTAssert(firstDayOfYear.isInSameYear(with: lastDayOfYear), "First and last day of year are not in same year")

		//last day of year with 23:59:59 and first day of next year with 00:00:00
		XCTAssert(!lastDayOfYear.isInSameYear(with: firstDayOfNextYear), "First day of next and last day of current year are detected in same year")
	}

	/**
	Unit test for checking if dates are in same month
	*/
	func testIsInSameMonthUtility() {
		let firstDate = dateFromText(fullDateText: "Jan 4, 2018 00:00:00")
		let dateInSameYearSameMonth = dateFromText(fullDateText: "Jan 25, 2018 00:00:00")
		let dateInSameYearDiffMonth = dateFromText(fullDateText: "Feb 25, 2018 00:00:00")
		let dateInSameMonthDiffYear = dateFromText(fullDateText: "Jan 25, 2019 00:00:00")

		//same month same year
		XCTAssert(firstDate.isInSameMonth(with: dateInSameYearSameMonth), "Same month date are not detected")
		//same year different month
		XCTAssert(!firstDate.isInSameMonth(with: dateInSameYearDiffMonth), "Different month of same year are detected as in same month")
		//same month different year
		XCTAssert(!firstDate.isInSameMonth(with: dateInSameMonthDiffYear), "Different month with same year are detected in same month")
	}

	/**
	Unit test for checking if dates are in same week
	*/
	func testIsInSameWeekUtility() {
		let firstDate = dateFromText(fullDateText: "Jan 4, 2018 00:00:00")
		let sameWeekSameMonthSameYear = dateFromText(fullDateText: "Jan 1, 2018 00:00:00")
		let diffWeekSameMonthSameYear = dateFromText(fullDateText: "Jan 14, 2018 00:00:00")
		let diffWeekDiffMonthSameYear = dateFromText(fullDateText: "Jan 24, 2018 00:00:00")
		let sameWeekDifferentYear = dateFromText(fullDateText: "Jan 4, 2019 00:00:00")

		//Two dates are in same week iff they both belong to same year same month and same week
		XCTAssert(firstDate.isInSameWeek(with: sameWeekSameMonthSameYear), "Dates in same week are not detected as same")
		XCTAssert(!firstDate.isInSameWeek(with: diffWeekSameMonthSameYear), "Different weeks in same month are detected as same")
		XCTAssert(!firstDate.isInSameWeek(with: diffWeekDiffMonthSameYear), "Different weeks in different month are detected as same")
		XCTAssert(!firstDate.isInSameWeek(with: sameWeekDifferentYear), "Same weeks in different year are detected as same")
	}

	/**
	This method returns date from string. It expects date in format - "MMM d, yyyy HH:mm:ss"

	- Parameter fullDateText: String in format "MMM d, yyyy HH:mm:ss"
	- Note: This will crash if correct string is not passed.
	*/
	private func dateFromText(fullDateText:String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
		return dateFormatter.date(from: fullDateText)!
	}
    
    override func tearDown() {
        super.tearDown()
    }
}
