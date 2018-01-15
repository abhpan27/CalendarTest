//
//  CTUIController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This class if responsible for replacing root view controller. It also holds reference to new root view controller so that different part of apps can access it when needed. This way there is central control for every UI element created in App.
*/
final class CTUIController {

	///root view controller, which will replace actual root view created by iOS on app launch.
	let rootViewController:CTAppRootViewController

	init(appState:AppDataState) {
		self.rootViewController = CTAppRootViewController(appDataState: appState)
		//replace already created root controller with our own root controller.
		(UIApplication.shared.delegate as! AppDelegate).window!.rootViewController = rootViewController
	}
}
