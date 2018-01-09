//
//  CTUIController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

final class CTUIController {

	let centralContainerViewController:CTCentralContainerViewController

	init(minimumCalData:[[CTCellUIData]], minimumAgendaViewData:[CTAgendaViewRowUIData]) {
		self.centralContainerViewController = CTCentralContainerViewController(minimumCalData: minimumCalData, minimumAgendaViewData: minimumAgendaViewData)
		(UIApplication.shared.delegate as! AppDelegate).window!.rootViewController = centralContainerViewController
	}
}
