//
//  CTAppConstants.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

final class CTAppConstants {

	static let shared = CTAppConstants() //singelton
	
	var minMaxDate:(minDate:Date, maxDate:Date) {
		let minDate = Calendar.current.pastMonth(noOfMonths: 3, date: Date()).startOfDate
		let maxDate = Calendar.current.futureMonth(noOfMonths: 12, date: Date()).startOfDate
		return (minDate, maxDate)
	}
}
