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
	var calUIDataHelper:CTCalViewDataHelper!
	var dbQueryHelper:CTDBQueryDataHelper!

    override func setUp() {
		let minMaxDate = CTAppConstants.shared.minMaxDate
		self.minDateToShowInCal = minMaxDate.minDate
		self.maxDateToShowInCal = minMaxDate.maxDate
		self.calUIDataHelper = CTCalViewDataHelper()
		self.dbQueryHelper = CTDBQueryDataHelper()
        super.setUp()
    }
    
    override func tearDown() {
     	self.maxDateToShowInCal = nil
		self.maxDateToShowInCal = nil
		self.dbQueryHelper = nil
        super.tearDown()
    }

	func testCollectionViewDataForCalendarView() {
		calUIDataHelper.loadBaicUIdata()

		//till min date in first row there should be blank cells
		let firstRow = calUIDataHelper.calCollectionViewUIData.first!
		for cellData in firstRow {
			if Date(timeIntervalSince1970: cellData.dateEpoch) < minDateToShowInCal && !cellData.isBlankDay {
				XCTFail("Non blank date before min date")
			}
		}

		//after maxDate in last cell there should be only blank cells
		let lastRow = calUIDataHelper.calCollectionViewUIData.last!
		for cellData in lastRow {
			if Date(timeIntervalSince1970: cellData.dateEpoch) > maxDateToShowInCal && !cellData.isBlankDay {
				XCTFail("Non blank date before min date")
			}
		}

		var currentLastDate:Date?
		//dates should be in sequence
		for section in 0 ... calUIDataHelper.calCollectionViewUIData.count - 1 {
			for row in 0 ... 6 {
				let currData = calUIDataHelper.calCollectionViewUIData[section][row]
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
		calUIDataHelper.loadBaicUIdata()

		var currentMonthDate = self.minDateToShowInCal!
		var calTableMonthDataIndex = 0

		while currentMonthDate <= self.maxDateToShowInCal {
			let expectedMonthName = currentMonthDate.monthName
			let monthNameInData = calUIDataHelper.calTableViewUIData[calTableMonthDataIndex].monthName

			XCTAssert(expectedMonthName == monthNameInData, "Mismatch between dates shown in collection view and month name shown in overlay tableview")

			currentMonthDate = Calendar.current.nextMonthEndDate(currentMonthDate)
			calTableMonthDataIndex += 1
		}

		//there should be same no of months in collection view and overlay month tableview
		let noMonthsBetweenMinAndMaxDates = self.maxDateToShowInCal!.months(from: self.minDateToShowInCal!)
		XCTAssert((noMonthsBetweenMinAndMaxDates + 1) == calTableMonthDataIndex, "Mismatch bewtween no of months to show in collection view and data generated for overlay table view")
	}

	func testEventAvailabilityDataForCalCollectionView() {
		calUIDataHelper.loadBaicUIdata()

		let expectation = self.expectation(description: "Async DB fetch for event availability")

		let completeRangeContentRequest = CTDBQueryContentRequest(fromDate: CTAppConstants.shared.minMaxDate.minDate, endDate: CTAppConstants.shared.minMaxDate.maxDate, type: .calViewdata)
		dbQueryHelper.dictionaryOfEventAvalabilty(forContentRequest: completeRangeContentRequest) {
			[weak self]
			(expectedEventAvailabiltyDict, error)
			in
			guard let blockSelf = self
				else {
					return
			}
			
			//event availabilty dict should not be nil and error should be nil
			XCTAssert(expectedEventAvailabiltyDict != nil, "Event availability was nil")
			XCTAssert(error == nil, "Got error while quering DB for event availability")

			//now load using UI data helper
			blockSelf.calUIDataHelper.loadEventAvailabiltyForShowingDots {
				[weak self]
				in
				guard let blockSelf = self
					else {
						return
				}

				blockSelf.validateEventAvailability(withExpectedAvailability: expectedEventAvailabiltyDict!)
				expectation.fulfill()
			}
		}

		waitForExpectations(timeout: 5.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	private func validateEventAvailability(withExpectedAvailability:[Date:Int]) {
		for row in 0 ... self.calUIDataHelper.calCollectionViewUIData.count - 1 {
			for coloum in 0 ... 6 {
				let currCellData = self.calUIDataHelper.calCollectionViewUIData[row][coloum]
				guard !currCellData.isBlankDay
					else {
						continue
				}

				let dateForCurrCell = Date(timeIntervalSince1970: currCellData.dateEpoch)
				if let expectedAvailabilty = withExpectedAvailability[dateForCurrCell]  {
					XCTAssert(expectedAvailabilty >= 1, "expected availabilty should not be less then zero, it should be either nil or more than 0")

					if expectedAvailabilty == 1 {
						XCTAssert(currCellData.eventAvailabilityColor == CalendarViewCellEventAvailablityColor.lightGrey.rawValue, "For only one event on day event availability dot color should be light grey")
					}

					if expectedAvailabilty == 2 {
						XCTAssert(currCellData.eventAvailabilityColor == CalendarViewCellEventAvailablityColor.mediumGrey.rawValue, "For two events on day event availability dot color should be medium grey")
					}

					if expectedAvailabilty >= 3 {
						XCTAssert(currCellData.eventAvailabilityColor == CalendarViewCellEventAvailablityColor.darkGrey.rawValue, "For three events on day event availability dot color should be dark grey")
					}
				}else {
						XCTAssert(currCellData.eventAvailabilityColor == CalendarViewCellEventAvailablityColor.clear.rawValue, "For no events on day event availability dot color should be clear color")
				}
			}
		}
	}
}
