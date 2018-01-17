//
//  CTAppControl.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
Different app states during launch of app. Used by UIController to show different kind of UI to user.
*/
internal enum AppDataState {

	/// intialization of UIController
	case intialization

	/// Creating dummy app data currently
	case creatingDummyData

	/// Dummy app data creation completed
	case finishedDummyDataCreation

	/// Dummy app data creaton failed
	case creatingDummyAppDataFailed

	/// Can't load persistent store of core data
	case persistentStoreFailed

}

/**
Keys uses for storing values in user defaults. Currently thers is only one value. More keys can be added as app grows.
*/
internal enum UserDefaultKeys:String {

	/// Is dummy app data alreay created
	case has_filled_dummy_data
}

/**
This class if responsible for intiation of UI, intialization of core data stack and dummy data creation. It takes over app as soon as appDidLaunched is called. It's reference is kept so that different part of modules can interact with each other through this object. eg - Calendar view can access core data controller through this object.
*/
final class CTAppControl {

	///handles flow of UI through different app states
	let uiController:CTUIController

	///Handles operations on core data.
	let coreDataController:CTCoreDataController

	///Used to fill dummy app data on first launch of app. It is used only once for each app installation.
	lazy var dummyDatafiller = CTIntialDummyDataFiller()

	///reference to current object of app control. There will one only one such object
	static weak var current: CTAppControl?

	init() {
		self.uiController = CTUIController(appState: .intialization)
		self.coreDataController = CTCoreDataController()
		CTAppControl.current = self

		//load core data persistent store
		self.coreDataController.loadPersistentStore { (error) in
			guard error == nil
				else{
					//failed to create persistent store, update UI
					self.uiController.rootViewController.appDataState = .persistentStoreFailed
					return
			}

			//persistent store loaded, now try to fill dummy data if not already filled
			if !UserDefaults.standard.bool(forKey: UserDefaultKeys.has_filled_dummy_data.rawValue) {
				self.uiController.rootViewController.appDataState = .creatingDummyData
				self.dummyDatafiller.fillDummyData(completion: { (error) in
					mainQueueAsync {
						guard error == nil
							else{
								//failed to create dummy app data
								self.uiController.rootViewController.appDataState = .creatingDummyAppDataFailed
								return
						}

						//successfully created dummy data, now we can go ahead show calendar and agenda UI
						UserDefaults.standard.set(true, forKey:  UserDefaultKeys.has_filled_dummy_data.rawValue)
						self.uiController.rootViewController.appDataState = .finishedDummyDataCreation
					}
				})
				return
			}
			//already created dummy data, just intiate launch of calendar and agenda view.
			self.uiController.rootViewController.appDataState = .finishedDummyDataCreation
		}
	}
}
