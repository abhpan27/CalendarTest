//
//  CTDateUtilities.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

extension Date {

	var startOfDate:Date {
		return Calendar.current.startOfDay(for: self)
	}

	var endOfDate: Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfDate)!
	}

	var nextDate:Date {
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self)
		return tomorrow!
	}

	var weekDay: Int {
		return Calendar.current.component(.weekday, from: self)
	}

	var isInCurrentYear:Bool {
		let yearComponentOfDate = Calendar.current.component(.year, from: self)
		let yearComponentOfCurrentDate = Calendar.current.component(.year, from: Date())
		return yearComponentOfDate == yearComponentOfCurrentDate
	}

	var numberOfWeeksInCurrentMonth:Int {
		return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
	}

	var isFirstDateOfMonth:Bool {
		let firstMonthDay = Calendar.current.startOfMonth(self).startOfDate
		return self.startOfDate == firstMonthDay.startOfDate
	}

	var monthName:String {
		let dateFormatter = DateFormatter()
		if self.isInCurrentYear {
			dateFormatter.dateFormat = "MMMM"
		}else {
			dateFormatter.dateFormat = "MMMM yyyy"
		}
		return dateFormatter.string(from: self)
	}

	var isTomorrow:Bool {
		return Calendar.current.isDateInTomorrow(self)
	}

	var isToday:Bool {
		return Calendar.current.isDateInToday(self)
	}

	var isYesterday:Bool {
		return Calendar.current.isDateInTomorrow(self)
	}

	var displayDateText:String {
		let dateFormatter = DateFormatter()
		if self.isInCurrentYear {
			dateFormatter.dateFormat = "EEEE, MMM d"
		}else {
			dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
		}

		let dateString = dateFormatter.string(from: self)

		if self.isToday {
			return "Today" + " • " + dateString
		}else if self.isTomorrow {
			return "Tomorrow" + " • " + dateString
		}else if self.isYesterday {
			return "Yesterday" + " • " + dateString
		}

		return dateString
	}

	var logDate:String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm"
		return dateFormatter.string(from: self)
	}

	func pastDateBefore(days:Int) -> Date {
		let pastDayAfetrDate = Calendar.current.date(byAdding: .day, value: -days, to: self)
		return pastDayAfetrDate!
	}

	func nextDateAfter(days:Int) -> Date {
		let nextDayAfetrDate = Calendar.current.date(byAdding: .day, value: days, to: self)
		return nextDayAfetrDate!
	}

	func isInSameMonth(withDate:Date) -> Bool {
		let monthComponentOfSelf = Calendar.current.component(.month, from: self)
		let monthComponentOfDate = Calendar.current.component(.month, from: withDate)
		return monthComponentOfSelf == monthComponentOfDate
	}

	func setHourMinuteAndSec(hours:Int, mintues:Int, seconds:Int) -> Date {
		let calendar = Calendar.current
		return calendar.date(bySettingHour: hours, minute: mintues, second: seconds, of: self)!
	}
	
}

