//
//  CTCalendarViewDataTest.swift
//  CalendarTestTests
//
//  Created by Abhishek on 14/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import XCTest
@testable import CalendarTest

class CTCalendarViewDataTest: XCTestCase {

	var minDateToShowInCal:Date!
	var maxDateToShowInCal:Date!

    override func setUp() {
		let minMaxDate = CTAppConstants.shared.minMaxDate
		self.minDateToShowInCal = minMaxDate.minDate
		self.maxDateToShowInCal = minMaxDate.maxDate
        super.setUp()
    }
    
    override func tearDown() {
     	self.maxDateToShowInCal = nil
		self.maxDateToShowInCal = nil
        super.tearDown()
    }

	func testCollectionViewDataForCalendarView() {
		let dataForCalCollectionView = CTCalViewDataHelper().getBasicCollectionViewCalData()

		//till min date in first row there should be blank cells
		let firstRow = dataForCalCollectionView.first!
		for cellData in firstRow {
			if Date(timeIntervalSince1970: cellData.dateEpoch) < minDateToShowInCal && !cellData.isBlankDay {
				XCTFail("Non blank date before min date")
			}
		}

		//after maxDate in last cell there should be only blank cells
		let lastRow = dataForCalCollectionView.last!
		for cellData in lastRow {
			if Date(timeIntervalSince1970: cellData.dateEpoch) > maxDateToShowInCal && !cellData.isBlankDay {
				XCTFail("Non blank date before min date")
			}
		}

		var currentLastDate:Date?
		//dates should be in sequence
		for section in 0 ... dataForCalCollectionView.count - 1 {
			for row in 0 ... 6 {
				let currData = dataForCalCollectionView[section][row]
				let currentDateEpoch = currData.dateEpoch
				if currentDateEpoch != -1 {
					let currentDate = Date(timeIntervalSince1970: currentDateEpoch)
					if let lastDate = currentLastDate {
						XCTAssert(currentDate > lastDate, "Dates are not in sequence")
					}
					currentLastDate = currentDate
				}
			}
		}
	}

	func testMonthOverlayTableViewDataForCalendarView() {
		let calMonthTableViewData = CTCalViewDataHelper().getBasicTableViewCalData()

		var currentMonthDate = self.minDateToShowInCal!
		var calTableMonthDataIndex = 0

		while currentMonthDate <= self.maxDateToShowInCal {
			let expectedMonthName = currentMonthDate.monthName
			let monthNameInData = calMonthTableViewData[calTableMonthDataIndex].monthName

			XCTAssert(expectedMonthName == monthNameInData, "Mismatch between dates shown in collection view and month name shown in overlay tableview")

			currentMonthDate = Calendar.current.nextMonthEndDate(currentMonthDate)
			calTableMonthDataIndex += 1
		}

		//there should be same no of months in collection view and overlay month tableview
		let noMonthsBetweenMinAndMaxDates = self.maxDateToShowInCal!.months(from: self.minDateToShowInCal!)
		XCTAssert((noMonthsBetweenMinAndMaxDates + 1) == calTableMonthDataIndex, "Mismatch bewtween no of months to show in collection view and data generated for overlay table view")
	}

}
