//
//  CTCoreDataController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import CoreData
import Foundation

final class CTCoreDataController {

	private(set) var uiContext: NSManagedObjectContext!
	internal let coreDataContainer: NSPersistentContainer

	init() {
		coreDataContainer = NSPersistentContainer(name: "CTEventModel")
	}

	final func loadPersistentStore(completion: @escaping (_ error:Error?) -> ()) {
		coreDataContainer.loadPersistentStores { (storeDescription, error) in
			guard error == nil
				else {
					completion(error!)
					return
			}
			Swift.print("persitent store created at:\(storeDescription.url!.absoluteString)")
			mainQueueAsync {
				self.uiContext = self.coreDataContainer.viewContext
				self.uiContext.automaticallyMergesChangesFromParent = true
				completion(nil)
			}
		}
	}
}


