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
		return Calendar.current.isDateInYesterday(self)
	}

	var displayDateText:String {
		let dateFormatter = DateFormatter()
		if self.isInCurrentYear {
			dateFormatter.dateFormat = "EEEE, MMM d"
		}else {
			dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
		}

		let dateString = dateFormatter.string(from: self)
		var extraText = ""
		if self.isToday {
			extraText =  "Today" + " • "
		}else if self.isTomorrow {
			extraText =  "Tomorrow" + " • "
		}else if self.isYesterday {
			extraText = "Yesterday" + " • "
		}

		return extraText + dateString
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

	func days(from date: Date) -> Int {
		return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
	}

	func hourAndMinutes(from date: Date) -> (Int, Int) {
		let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date, to: self)
		let hour =  dateComponent.hour ?? 0
		let min = dateComponent.minute ?? 0
		return (hour, min)
	}

	func hours(from date: Date) -> Int {
		let dateComponent = Calendar.current.dateComponents([.hour], from: date, to: self)
		return dateComponent.hour ?? 0
	}

	func minutes(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}

	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}

	func differenceText(from date: Date) -> String {
		if days(from: date) > 0 {
			let value = days(from: date)
			return value > 1 ? "\(value) Days" : "\(value) Day"
		}

		let (hour, min) = hourAndMinutes(from: date)
		if hour > 0 {
			var value = hour > 1 ? "\(hour) Hours" : "\(hour) Hour"
			if min > 0 {
				value = value + " " + "\(min) Mins"
			}
			return value
		}

		if minutes(from: date) > 0 {
			let value = minutes(from: date)
			return value > 1 ? "\(value) Mins" : "\(value) Min"
		}

		if seconds(from: date) > 0 {
			let value = seconds(from: date)
			return value > 1 ? "\(value) Seconds" : "\(value) Second"
		}
		return ""
	}
}

