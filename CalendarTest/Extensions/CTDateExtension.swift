//
//  CTDateUtilities.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
Extension for date object. Many convenient computed properties and methods are added here.
*/
extension Date {

	///first moment of day. Sets time to 00:00:00
	var startOfDate:Date {
		return Calendar.current.startOfDay(for: self)
	}

	///Last moment of day. Sets time to 23:59:59
	var endOfDate: Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfDate)!
	}

	///Next date from current date
	var nextDate:Date {
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self)
		return tomorrow!
	}

	///Week day for date. Sunday - 1, Saturday - 7
	var weekDay: Int {
		return Calendar.current.component(.weekday, from: self)
	}

	///Bool to show if date is in current year.
	var isInCurrentYear:Bool {
		return self.isInSameYear(with: Date())
	}

	///Number of different week in current month
	var numberOfWeeksInCurrentMonth:Int {
		return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
	}

	///Bool to show if date is first date of month
	var isFirstDateOfMonth:Bool {
		let firstMonthDay = Calendar.current.startOfMonth(self).startOfDate
		return self.startOfDate == firstMonthDay.startOfDate
	}

	///Month name string from date
	var monthName:String {
		let dateFormatter = DateFormatter()
		if self.isInCurrentYear {
			dateFormatter.dateFormat = "MMMM"
		}else {
			dateFormatter.dateFormat = "MMMM yyyy"
		}
		return dateFormatter.string(from: self)
	}

	///Bool to show if date is tomorrow.
	var isTomorrow:Bool {
		return Calendar.current.isDateInTomorrow(self)
	}

	///Bool to show if date is today
	var isToday:Bool {
		return Calendar.current.isDateInToday(self)
	}

	///Bool to show if date is yesterday
	var isYesterday:Bool {
		return Calendar.current.isDateInYesterday(self)
	}

	///String to show for date
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

	///String for date in full form
	var logDate:String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm"
		return dateFormatter.string(from: self)
	}

	/**
	This method returns past date after given number of days

	- Parameter days: Number of days to subtract from current date.
	- Returns: Date before given number of days
	*/
	func pastDateBefore(days:Int) -> Date {
		let pastDayAfetrDate = Calendar.current.date(byAdding: .day, value: -days, to: self)
		return pastDayAfetrDate!
	}

	/**
	This method returns future date after given numbe of days

	- Parameter days: Number of days to add to current date.
	- Returns: Date after given number of days.
	*/
	func nextDateAfter(days:Int) -> Date {
		let nextDayAfetrDate = Calendar.current.date(byAdding: .day, value: days, to: self)
		return nextDayAfetrDate!
	}

	/**
	This method returns if given date is in same year as current date

	- Parameter date: Date which needs to checked.
	- Returns: Bool to show if dates are in same year.
	*/
	func isInSameYear(with date:Date) -> Bool {
		let yearComponentOfSelf = Calendar.current.component(.year, from: self)
		let yearComponentOfDate = Calendar.current.component(.year, from: date)
		return (yearComponentOfSelf == yearComponentOfDate)
	}


	/**
	This method returns if given date is in same month as current date

	- Parameter date: Date which needs to checked.
	- Returns: Bool to show if dates are in same month.
	*/
	func isInSameMonth(with date:Date) -> Bool {
		let yearComponentOfSelf = Calendar.current.component(.year, from: self)
		let yearComponentOfDate = Calendar.current.component(.year, from: date)
		let monthComponentOfSelf = Calendar.current.component(.month, from: self)
		let monthComponentOfDate = Calendar.current.component(.month, from: date)
		return (yearComponentOfSelf == yearComponentOfDate && monthComponentOfSelf == monthComponentOfDate)
	}

	/**
	This method returns if given date is in same week as current date

	- Parameter date: Date which needs to checked.
	- Returns: Bool to show if dates are in same week.
	*/
	func isInSameWeek(with date:Date) -> Bool {
		let yearOfSelf = Calendar.current.component(.year, from: self)
		let monthOfSelf = Calendar.current.component(.month, from: self)
		let weekOfSelf = Calendar.current.component(.weekOfMonth, from: self)

		let yearOfDate = Calendar.current.component(.year, from: date)
		let monthOfDate = Calendar.current.component(.month, from: date)
		let weekOfDate = Calendar.current.component(.weekOfMonth, from: date)

		return (yearOfDate == yearOfSelf && monthOfDate == monthOfSelf && weekOfDate == weekOfSelf)
	}

	/**
	This method returns number of weeks from given date

	- Parameter date: Date from which difference of weeks needs to be calculated.
	- Returns: Difference bewtween dates in weeks.
	*/
	func numberOfWeeks(from date:Date) -> Int {
		let weekYears =  Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
		return self.weekDay < date.weekDay ? weekYears + 1 : weekYears
	}

	/**
	This method set hour, minute and seconds for current date

	- Parameter hours: Hours to be set.
	- Parameter hours: minutes to be set.
	- Parameter seconds: seconds to be set.
	- Returns: Date after settinig hour, minute and second.
	*/
	func setHourMinuteAndSec(hours:Int, mintues:Int, seconds:Int) -> Date {
		let calendar = Calendar.current
		return calendar.date(bySettingHour: hours, minute: mintues, second: seconds, of: self)!
	}

	/**
	This method returns number of weeks from given date

	- Parameter date: Date from which difference of days needs to be calculated.
	- Returns: Difference bewtween dates in days.
	*/
	func days(from date: Date) -> Int {
		return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
	}

	/**
	This method returns number of hours and minutes from given date

	- Parameter date: Date from which difference of weeks needs to be calculated.
	- Returns: Tuple of Difference bewtween dates in hours and minutes.
	*/
	func hourAndMinutes(from date: Date) -> (Int, Int) {
		let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date, to: self)
		let hour =  dateComponent.hour ?? 0
		let min = dateComponent.minute ?? 0
		return (hour, min)
	}

	/**
	This method returns number of weeks from hours date

	- Parameter date: Date from which difference of hours needs to be calculated.
	- Returns: Difference bewtween dates in hours.
	*/
	func hours(from date: Date) -> Int {
		let dateComponent = Calendar.current.dateComponents([.hour], from: date, to: self)
		return dateComponent.hour ?? 0
	}

	/**
	This method returns number of minutes from given date

	- Parameter date: Date from which difference of minutes needs to be calculated.
	- Returns: Difference bewtween dates in minutes.
	*/
	func minutes(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}

	/**
	This method returns number of seconds from given date

	- Parameter date: Date from which difference of seconds needs to be calculated.
	- Returns: Difference bewtween dates in seconds.
	*/
	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}

	/**
	This method returns number of months from given date

	- Parameter date: Date from which difference of months needs to be calculated.
	- Returns: Difference bewtween dates in months.
	*/
	func months(from date:Date) -> Int {
		return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
	}

	/**
	This method returns difference between dates in human readable format

	- Parameter date: Date from which diffence text needs to be created.
	- Returns: Difference between dates in human readable format.
	- Note: Currently maximum supported unit for difference is Days. More bigger units such as Months and years can also be added.
	*/
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

