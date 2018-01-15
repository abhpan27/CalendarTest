//
//  CTAgendaViewDataTest.swift
//  CalendarTestTests
//
//  Created by Abhishek on 15/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import XCTest
@testable import CalendarTest

class CTAgendaViewDataTest: XCTestCase {

	var minDateToShowInAgenda:Date!
	var maxDateToShowInAgenda:Date!
	var uiContentLoaderForAgendaView:CTAgendaListUIHelper!
	var dbQueryHelper:CTDBQueryDataHelper!

    override func setUp() {
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		self.minDateToShowInAgenda = minMaxDateInfo.minDate
		self.maxDateToShowInAgenda = minMaxDateInfo.maxDate
		self.uiContentLoaderForAgendaView = CTAgendaListUIHelper()
		self.dbQueryHelper = CTDBQueryDataHelper()
        super.setUp()
    }
    
    override func tearDown() {
		self.minDateToShowInAgenda = nil
		self.maxDateToShowInAgenda = nil
		self.uiContentLoaderForAgendaView = nil
		self.dbQueryHelper = nil
        super.tearDown()
    }

	func testLoadContentFromDBQuery() {
		let fromDate = dateFromText(fullDateText: "Jan 14, 2018 12:00:00")
		let toDate = dateFromText(fullDateText: "Feb 28, 2018 12:00:00")
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .agendaViewData)

		let expectation = self.expectation(description: "Async DB fetch")

		self.dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(listOfData, error)
			in

			guard let blockSelf = self
				else{
					return
			}

			//date should be nil
			XCTAssert(error == nil, "Returning data for wrong content request")

			//data should not be nil
			XCTAssert(listOfData != nil, "Data is nil for valid content request")

			//validate integrity of data
			blockSelf.validateArrayOfSectionUIData(arrayOfSectionUIData: listOfData!)
			expectation.fulfill()
		}

		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	func testAgendaViewDataLoadingWithWrongContentRequest() {
		let fromDate = dateFromText(fullDateText: "Jan 14, 2018 12:00:00")
		let toDate = dateFromText(fullDateText: "Jan 13, 2018 12:00:00")
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .agendaViewData)
		let expectation = self.expectation(description: "Async DB fetch")

		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(listOfData, error)
			in

			guard let _ = self
				else{
					return
			}

			//date should be nil
			XCTAssert(listOfData == nil, "Returning data for wrong content request")

			//error should not be nil
			XCTAssert(error != nil, "Error is not thorwn for wrong content request")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	func testAgendaViewIntialContentLoad() {
		let expectation = self.expectation(description: "Async content load")

		uiContentLoaderForAgendaView.loadOnFirstLaunch {
			[weak self]
			(error)
			in

			guard let blockSelf = self
				else{
					return
			}

			//error should be nil
			XCTAssert(error == nil, "Error on intial load of events")
			//validate integrity of data
			blockSelf.validateDataAfterLoadingContent()
			expectation.fulfill()
		}

		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	func testAgendaViewIntialAndPastContentLoad() {
		let expectation = self.expectation(description: "Async content load")

		//intial load
		uiContentLoaderForAgendaView.loadOnFirstLaunch {
			[weak self]
			(error)
			in

			guard let blockSelf = self
				else{
					return
			}

			//error should be nil
			XCTAssert(error == nil, "Error on intial load of events")

			//intial load done do past load
			blockSelf.uiContentLoaderForAgendaView.loadPastUIData(completion: {
				[weak self]
				(error)
				in

				guard let blockSelf = self
					else{
						return
				}

				//error should be nil
				XCTAssert(error == nil, "Error on past load of events after intial load")
				//validate integrity of data
				blockSelf.validateDataAfterLoadingContent()
				expectation.fulfill()
			})
		}

		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	func testAgendaViewIntialAndFutureContentLoad() {
		let expectation = self.expectation(description: "Async content load")

		//first intial load then future load
		self.uiContentLoaderForAgendaView.loadOnFirstLaunch {
			[weak self]
			(error)
			in

			guard let blockSelf = self
				else{
					return
			}

			//error should be nil
			XCTAssert(error == nil, "Error on intial load of events")

			blockSelf.uiContentLoaderForAgendaView.loadFutureUIData(completion: {
				[weak self]
				(error)
				in

				guard let blockSelf = self
					else{
						return
				}
				//error should be nil
				XCTAssert(error == nil, "Error on future load of events after intial load")

				//validate integrity of data
				blockSelf.validateDataAfterLoadingContent()
				expectation.fulfill()
			})
		}

		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	private func validateDataAfterLoadingContent() {
		self.validateArrayOfSectionUIData(arrayOfSectionUIData: self.uiContentLoaderForAgendaView.arrayOfSectionUIData)
	}

	private func validateArrayOfSectionUIData(arrayOfSectionUIData:[CTAgendaViewSectionUIData]) {
		var lastSectionUIData:CTAgendaViewSectionUIData?
		for index in 0 ... arrayOfSectionUIData.count - 1 {
			let currSectionUiData = arrayOfSectionUIData[index]

			//every date should be first moment of day
			XCTAssert(currSectionUiData.dateOfSection.startOfDate == currSectionUiData.dateOfSection, "Section UI data doesn't contains first moment of day")

			if let lastSectionData = lastSectionUIData {
				//data should be in chronological order
				XCTAssert(lastSectionData.dateOfSection.nextDate == currSectionUiData.dateOfSection , "Dates are not in chronological order after load")
			}
			lastSectionUIData = currSectionUiData
		}
	}

	private func dateFromText(fullDateText:String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
		return dateFormatter.date(from: fullDateText)!
	}
    
}
