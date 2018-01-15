//
//  CTDBQueryContentRequest.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation


final class CTDBQueryContentRequest {

	enum typeOfData {
		case agendaViewData, calViewdata
	}

	let fromDate:Date
	let toDate:Date
	let typeOfDataNeeded:typeOfData

	init(fromDate:Date, endDate:Date, type:typeOfData) {
		let minMaxDate = CTAppConstants.shared.minMaxDate
		self.fromDate = fromDate >= minMaxDate.minDate ?  fromDate : minMaxDate.minDate
		self.toDate = endDate <= minMaxDate.maxDate ? endDate : minMaxDate.maxDate
		self.typeOfDataNeeded = type
	}

}
