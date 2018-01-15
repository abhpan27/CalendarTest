//
//  CTAgendaViewSectionUIData.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import UIKit

final class CTAgendaViewRowUIData {

	struct AttendeeData {
		let name:String
		let email:String
		let color:UIColor
	}

	enum TypeOfRow {
		case fullInfo, titleAndLocation, titleAndPeople, onlytitle
	}

	let uniqueID:String
	let eventTitle:String
	let eventStartTime:Date
	let eventEndTime:Date
	let isAllDay:Bool
	let attendeesInfo:[AttendeeData]
	let locationString:String
	let calColor:UIColor
	let typeOfRow:TypeOfRow

	var heightNeededForRow:CGFloat {
		switch self.typeOfRow {
		case .fullInfo:
			return 115
		case .titleAndPeople:
			return 95
		case .titleAndLocation:
			return 75
		case .onlytitle:
			return 45
		}
	}

	var startTimeText:String {
		if self.isAllDay {
			return "All Day"
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mma"
		return dateFormatter.string(from: self.eventStartTime).replacingOccurrences(of: ":00", with: "")
	}

	var timeRangeText:String {
		if self.isAllDay {
			return ""
		}
		return self.eventEndTime.differenceText(from: self.eventStartTime)
	}

	init(uniqueID:String, eventTitle:String, eventStartTime:Date, eventEndTime:Date, isAllDay:Bool, attendeesInfo:[AttendeeData], locationString:String, calColor:UIColor) {
		self.uniqueID = uniqueID
		self.eventTitle = eventTitle
		self.eventStartTime = eventStartTime
		self.eventEndTime = eventEndTime
		self.isAllDay = isAllDay
		self.attendeesInfo = attendeesInfo
		self.locationString = locationString
		self.calColor = calColor

		//type of row
		if attendeesInfo.count > 0 && !locationString.isEmpty {
			self.typeOfRow = .fullInfo
		}else if locationString.isEmpty && attendeesInfo.count > 0 {
			self.typeOfRow = .titleAndPeople
		}else if !locationString.isEmpty && attendeesInfo.count == 0 {
			self.typeOfRow = .titleAndLocation
		}else {
			self.typeOfRow = .onlytitle
		}
	}
}

final class CTAgendaViewSectionUIData {

	let dateOfSection:Date
	let arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]

	init(dateOfSection:Date, arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]) {
		self.dateOfSection = dateOfSection
		self.arrayOfEventsRowUIDataOnDay = arrayOfEventsRowUIDataOnDay
	}

	var backgroundColor:UIColor {
		if dateOfSection.isToday {
			return UIColor(red: 206/255, green: 226/255, blue: 246/255, alpha: 1.0)
		}

		return UIColor(red: 247/255, green: 245/255, blue: 247/255, alpha: 1.0)
	}
}
