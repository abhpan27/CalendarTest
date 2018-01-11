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

	let uniqueID:String
	let eventTitle:String
	let eventStartTime:Date
	let eventEndTime:Date
	let isAllDay:Bool
	let attendeesInfo:[AttendeeData]
	let locationString:String

	var heightNeededForRow:CGFloat {
		if self.attendeesInfo.count > 0 && !self.locationString.isEmpty {
			return 110
		}else if  !self.locationString.isEmpty {
			return 60
		}else {
			return 40
		}
	}

	init(uniqueID:String, eventTitle:String, eventStartTime:Date, eventEndTime:Date, isAllDay:Bool, attendeesInfo:[AttendeeData], locationString:String) {
		self.uniqueID = uniqueID
		self.eventTitle = eventTitle
		self.eventStartTime = eventStartTime
		self.eventEndTime = eventEndTime
		self.isAllDay = isAllDay
		self.attendeesInfo = attendeesInfo
		self.locationString = locationString
	}
}

final class CTAgendaViewSectionUIData {

	let dateOfSection:Date
	let arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]

	init(dateOfSection:Date, arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]) {
		self.dateOfSection = dateOfSection
		self.arrayOfEventsRowUIDataOnDay = arrayOfEventsRowUIDataOnDay
	}
}
