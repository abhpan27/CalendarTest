//
//  CTDBQueryContentRequest.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation


/**
This class is used to provide parameters for querying core data. Only CTDBQueryDataHelper can query DB and CTDBQueryDataHelper only accepts object of this class. Using values in this class, predictes of core data queries, logic for DB query etc are decided.
Currently only fromDate and toDate are supported. These value specify date range for which data is requested.
More properties can be added for more sophisticated queries.
*/

final class CTDBQueryContentRequest {

	/**
	Type of data needed from query. Data for agenda view or calendar view
	*/
	enum typeOfData {

		///Data requested for agenda view
		case agendaViewData

		///Data requested for calendar view
		case calViewdata
	}

	///Start time of query
	let fromDate:Date

	///End time of query
	let toDate:Date

	///Type of data needed
	let typeOfDataNeeded:typeOfData

	init(fromDate:Date, endDate:Date, type:typeOfData) {
		let minMaxDate = CTAppConstants.shared.minMaxDate

		//from date can't be less than minimum date supported by app.
		self.fromDate = fromDate >= minMaxDate.minDate ?  fromDate : minMaxDate.minDate

		//to date can't be more than maximum date supported by app.
		self.toDate = endDate <= minMaxDate.maxDate ? endDate : minMaxDate.maxDate

		self.typeOfDataNeeded = type
	}

}
