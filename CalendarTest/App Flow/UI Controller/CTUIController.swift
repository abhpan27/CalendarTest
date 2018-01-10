//
//  CTUIController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

final class CTUIController {

	let rootViewController:CTAppRootViewController

	init(appState:AppDataState) {
		self.rootViewController = CTAppRootViewController(appDataState: appState)
		(UIApplication.shared.delegate as! AppDelegate).window!.rootViewController = rootViewController
	}
}
