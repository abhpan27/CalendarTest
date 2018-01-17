//
//  AppDelegate.swift
//  CalendarTest
//
//  Created by Abhishek on 08/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit
/**
App Delegate.
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	///Main window of app.
	var window: UIWindow?

	//App control object which creates meta data and intiate UI.
	var appControl:CTAppControl?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		//Create App control object and let it take over from here.
		self.appControl = CTAppControl()
		return true
	}
}

