//
//  CTAgendaViewDataTest.swift
//  CalendarTestTests
//
//  Created by Abhishek on 15/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import XCTest
@testable import CalendarTest

/**
Unit tests for method used in agenda view for loading data.
*/
class CTAgendaViewDataTest: XCTestCase {

	///Minimum date shown in agenda view
	var minDateToShowInAgenda:Date!

	///Maximum data shown in agenda view
	var maxDateToShowInAgenda:Date!

	///UI Data helper object whoes methods will be tested here
	var uiContentLoaderForAgendaView:CTAgendaListUIHelper!

	///DB query helper object, which will be tested here
	var dbQueryHelper:CTDBQueryDataHelper!

    override func setUp() {
		let minMaxDateInfo = CTAppConstants.shared.minMaxDate
		//Test for minimum and maximum date supported by app.
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

	/**
	Unit test to check if DB query object is loading correct data if correct content request is provided.
	*/
	func testLoadContentFromDBQuery() {
		let fromDate = dateFromText(fullDateText: "Jan 14, 2018 12:00:00")
		let toDate = dateFromText(fullDateText: "Feb 28, 2018 12:00:00")
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .agendaViewData)

		//this is an async call, so expection-wait structure is used.
		let expectation = self.expectation(description: "Async DB fetch")

		self.dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(listOfData, error)
			in

			guard let blockSelf = self
				else{
					return
			}

			//Error should be nil
			XCTAssert(error == nil, "Returning data for wrong content request")

			//data should not be nil
			XCTAssert(listOfData != nil, "Data is nil for valid content request")

			//validate if data loaded is correct
			blockSelf.validateArrayOfSectionUIData(arrayOfSectionUIData: listOfData!)
			expectation.fulfill()
		}

		//2 sec should be more than enough for DB query call
		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}


	/**
	Unit test to check if DB query object is giving error if wrong content request is provided.
	*/
	func testAgendaViewDataLoadingWithWrongContentRequest() {
		let fromDate = dateFromText(fullDateText: "Jan 14, 2018 12:00:00")
		let toDate = dateFromText(fullDateText: "Jan 13, 2018 12:00:00")
		let contentRequest = CTDBQueryContentRequest(fromDate: fromDate, endDate: toDate, type: .agendaViewData)

		//this is an async call, so expection-wait structure is used.
		let expectation = self.expectation(description: "Async DB fetch")

		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(listOfData, error)
			in

			guard let _ = self
				else{
					return
			}

			//data should be nil
			XCTAssert(listOfData == nil, "Returning data for wrong content request")

			//error should not be nil
			XCTAssert(error != nil, "Error is not thorwn for wrong content request")
			expectation.fulfill()
		}

		//2 sec should be more than enough for DB query call
		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}


	/**
	Unit test to check if intial loading of data is correct for agenda view.
	*/
	func testAgendaViewIntialContentLoad() {
		//this is an async call, so expection-wait structure is used.
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

		//2 sec should be more than enough for DB query call
		waitForExpectations(timeout: 2.0) { (error) in
			if let error = error {
				XCTFail("waiting with error: \(error.localizedDescription)")
			}
		}
	}

	/**
	Unit test to check if past loading of data is correct for agenda view. Note that intial loading must be completed before past loading
	*/
	func testAgendaViewIntialAndPastContentLoad() {
		let expectation = self.expectation(description: "Async content load")

		//intial load first
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

			//intial load done do past load now
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

	/**
	Unit test to check if future loading of data is correct for agenda view. Note that intial loading must be completed before future loading
	*/
	func testAgendaViewIntialAndFutureContentLoad() {
		let expectation = self.expectation(description: "Async content load")

		//first intial load
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

			//intial load done, now do future load
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

	/**
	Test if current array of section UI data is correct or not
	*/
	private func validateDataAfterLoadingContent() {
		self.validateArrayOfSectionUIData(arrayOfSectionUIData: self.uiContentLoaderForAgendaView.arrayOfSectionUIData)
	}

	/**
	Test if given array of section UI data is correct or not

	- Parameter arrayOfSectionUIData: array of section UI data which needs to checked for correctness.
	*/
	private func validateArrayOfSectionUIData(arrayOfSectionUIData:[CTAgendaViewSectionUIData]) {
		var lastSectionUIData:CTAgendaViewSectionUIData?
		for index in 0 ... arrayOfSectionUIData.count - 1 {
			let currSectionUiData = arrayOfSectionUIData[index]

			//every date should be first moment of day (time = 00:00:00)
			XCTAssert(currSectionUiData.dateOfSection.startOfDate == currSectionUiData.dateOfSection, "Section UI data doesn't contains first moment of day")

			if let lastSectionData = lastSectionUIData {
				//data should be in chronological order and there should not be any missing date in between
				XCTAssert(lastSectionData.dateOfSection.nextDate == currSectionUiData.dateOfSection , "Dates are not in chronological order after load")
			}
			lastSectionUIData = currSectionUiData
		}
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
    
}
