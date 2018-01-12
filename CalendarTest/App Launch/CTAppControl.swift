//
//  CTAppControl.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

internal enum AppDataState {
	case intialization
	case creatingDummyData
	case finishedDummyDataCreation
	case creatingDummyAppDataFailed
	case persistentStoreFailed
}

internal enum userDefaultKeys:String {
	case has_filled_dummy_data
}

final class CTAppControl {

	let uiController:CTUIController
	let coreDataController:CTCoreDataController
	lazy var dummyDatafiller = CTIntialDummyDataFiller()
	static weak var current: CTAppControl?

	init() {
		self.uiController = CTUIController(appState: .intialization)
		self.coreDataController = CTCoreDataController()
		CTAppControl.current = self
		self.coreDataController.loadPersistentStore { (error) in
			guard error == nil
				else{
					self.uiController.rootViewController.appDataState = .persistentStoreFailed
					return
			}

			//persistent store loaded, now try to fill dummy data iff not already filled
			if !UserDefaults.standard.bool(forKey: userDefaultKeys.has_filled_dummy_data.rawValue) {
				self.uiController.rootViewController.appDataState = .creatingDummyData
				self.dummyDatafiller.fillDummyData(completion: { (error) in
					mainQueueAsync {
						guard error == nil
							else{
								self.uiController.rootViewController.appDataState = .creatingDummyAppDataFailed
								return
						}

						//successfully created dummy data, now we can go ahead show calendar and agenda UI
						UserDefaults.standard.set(true, forKey:  userDefaultKeys.has_filled_dummy_data.rawValue)
						self.uiController.rootViewController.appDataState = .finishedDummyDataCreation
					}
				})
				return
			}
			//already created dummy data, just show calendar and agenda view now
			self.uiController.rootViewController.appDataState = .finishedDummyDataCreation
		}
	}
}
