//
//  CTAgendaViewSectionUIData.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import UIKit

/**
For every section of table view of agenda view, one object of this class will be created. In agenda view every date is represented as section, and events on that date is represented as rows. This class holds date of section and array of events on that day.
*/
final class CTAgendaViewSectionUIData {

	/// Date of the section
	let dateOfSection:Date

	/// **Sorted by start time** Array of events on the date of section
	let arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]

	init(dateOfSection:Date, arrayOfEventsRowUIDataOnDay:[CTAgendaViewRowUIData]) {
		self.dateOfSection = dateOfSection
		self.arrayOfEventsRowUIDataOnDay = arrayOfEventsRowUIDataOnDay
	}

	var backgroundColor:UIColor {
		//if it's today section then color should be different.
		if self.dateOfSection.isToday {
			return UIColor(red: 206/255, green: 226/255, blue: 246/255, alpha: 1.0)
		}

		return UIColor(red: 247/255, green: 245/255, blue: 247/255, alpha: 1.0)
	}
}
