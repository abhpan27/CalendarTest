//
//  CTCalendarExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

extension Calendar {

	func startOfMonth(_ date: Date) -> Date {
		return self.date(from: self.dateComponents([.year, .month], from: date))!
	}

	func endOfMonth(_ date: Date) -> Date {
		return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
	}

	func pastMonthStartDate(_ date: Date) -> Date {
		return self.date(byAdding: DateComponents(month: -1, day: 0), to: self.startOfMonth(date))!
	}

	func nextMonthEndDate(_ date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: 2, day: -1), to: self.startOfMonth(date))!
	}

	func pastMonth(noOfMonths:Int, date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: -(noOfMonths), day: 0), to: self.startOfMonth(date))!
	}

	func futureMonth(noOfMonths:Int, date:Date) -> Date {
		return self.date(byAdding: DateComponents(month: (noOfMonths + 1), day: -1), to: self.startOfMonth(date))!
	}

}
