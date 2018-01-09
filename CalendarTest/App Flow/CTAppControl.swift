//
//  CTAppControl.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

final class CTAppControl {

	let uiController:CTUIController

	init() {
		let calMinimumUIData = CTCalDataGenerator().getBasicCalData()
		let agendaViewMinimumUIdata = CTAgendaDataHelper().getBasicAgendaViewData()
		self.uiController = CTUIController(minimumCalData: calMinimumUIData, minimumAgendaViewData: agendaViewMinimumUIdata)
	}
}
