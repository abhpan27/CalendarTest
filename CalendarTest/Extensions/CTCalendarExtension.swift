//
//  CTCalendarExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
Some convenient for Calculations on calendar
*/
extension Calendar {

	/**
	This method returns first date of month of given date

	- Parameter date: Date for which first date of month needs to be found.
	- Returns: Date object for first date of month of given date
	*/
	func startOfMonth(_ date: Date) -> Date {
		return self.date(from: self.dateComponents([.year, .month], from: date))!
	}

	/**
	This method returns last date of month of given date

	- Parameter date: Date for which last date of month needs to be found.
	- Returns: Date object for last date of month of given date
	*/
	func endOfMonth(_ date: Date) -> Date {
		return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
	}


	/**
	This method returns last date of next month of given date

	- Parameter date: Date for which last date of next month needs to be found.
	- Returns: Date object for last date of next month of given date
	*/
	func nextMonthEndDate(_ date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: 2, day: -1), to: self.startOfMonth(date))!
	}

	/**
	This method returns start of month of date obtained after subtracting given number of months from given Date.

	- Parameter noOfMonths: No of months to be subtracted from given date
	- Parameter date: Date from which given number of months will be subtracted.
	- Returns: Date object for start of month of date obtained after subtracting given number of months from given Date.
	*/
	func pastMonth(noOfMonths:Int, date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: -(noOfMonths), day: 0), to: self.startOfMonth(date))!
	}


	/**
	This method returns start of month of date obtained after adding given number of months to given Date.

	- Parameter noOfMonths: No of months to be added to given date
	- Parameter date: Date to which given number of months will be added.
	- Returns: Date object for start of month of date obtained after adding given number of months to given Date.
	*/
	func futureMonth(noOfMonths:Int, date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: (noOfMonths + 1), day: -1), to: self.startOfMonth(date))!
	}

}
