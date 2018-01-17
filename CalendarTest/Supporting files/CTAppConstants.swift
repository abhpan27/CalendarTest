//
//  CTAppConstants.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
This class holds some global constants which are used by many different modules.
*/
final class CTAppConstants {

	///singelton reference
	static let shared = CTAppConstants()

	///Minimum and Maximum date which can be shown in app. Currently Minimum date is 7 year past from current date and Maximum is 1 year future from current date, this can be changed to increase range of date shown.
	var minMaxDate:(minDate:Date, maxDate:Date) {
		let minDate = Calendar.current.pastMonth(noOfMonths: 12*7, date: Date()).startOfDate
		let maxDate = Calendar.current.futureMonth(noOfMonths: 12, date: Date()).startOfDate
		return (minDate, maxDate)
	}
}
