//
//  CTCoreDataController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import CoreData
import Foundation

/**
This class is responsible for intialization of core data stack.
*/
final class CTCoreDataController {

	///View context of core data persistent container.
	private(set) var uiContext: NSManagedObjectContext!

	///Persistent container
	internal let coreDataContainer: NSPersistentContainer

	init() {
		self.coreDataContainer = NSPersistentContainer(name: "CTEventModel")
	}

	/**
	This method loads persistent store.

	- Parameter completion: Completion handler called after loading persistent store or on some error.
	- Parameter error: Any error during load of persistent store
	*/
	final func loadPersistentStore(completion: @escaping (_ error:Error?) -> ()) {
		self.coreDataContainer.loadPersistentStores { (storeDescription, error) in
			guard error == nil
				else {
					completion(error!)
					return
			}
			mainQueueAsync {
				self.uiContext = self.coreDataContainer.viewContext
				self.uiContext.automaticallyMergesChangesFromParent = true
				completion(nil)
			}
		}
	}
}
