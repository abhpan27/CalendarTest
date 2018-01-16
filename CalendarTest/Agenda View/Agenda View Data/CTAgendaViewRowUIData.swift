//
//  CTAgendaViewRowUIData.swift
//  CalendarTest
//
//  Created by Abhishek on 16/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import UIKit

/**
This class represent single event in Agenda view. For every row in agenda view there will be one object of this class.
*/
final class CTAgendaViewRowUIData {

	/**
	Represents Attendees if event. More attributes such as RSVP status etc can be added. But for now only name, email and color is added.
	*/
	struct AttendeeData {
		let name:String
		let email:String
		let color:UIColor
	}

	/**
	This enum represents kind of information available for any particular row.
	*/
	enum TypeOfRow {

		///Title location attendees all three are present
		case fullInfo

		///Title and location is available, Attendees are not availble
		case titleAndLocation

		///Title and attendees are available, location is not available.
		case titleAndPeople

		///only tile is available, attendees and location both are not available
		case onlytitle

	}

	///unique ID of Event
	let uniqueID:String

	///Title of event
	let eventTitle:String

	///start time of event
	let eventStartTime:Date

	///end time of event
	let eventEndTime:Date

	///Bool shows if it is an All day event
	let isAllDay:Bool

	///array of attendees, this can be empty
	let attendeesInfo:[AttendeeData]

	///Location String for Event. This can be empty
	let locationString:String

	///Color of calendar to which this event belongs to. Used to show calendar color dot in row.
	let calColor:UIColor

	///Holds kind of row
	let typeOfRow:TypeOfRow

	///height neede for drawing this Row
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

	///start time string of event
	var startTimeText:String {
		if self.isAllDay {
			//for all day just say All day
			return "All Day"
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mma"
		//strins like 10:00 will be converted to 10
		return dateFormatter.string(from: self.eventStartTime).replacingOccurrences(of: ":00", with: "")
	}

	///Duration of event in string format
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
