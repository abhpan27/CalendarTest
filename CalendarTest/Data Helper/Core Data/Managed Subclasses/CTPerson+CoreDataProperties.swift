//
//  CTPerson+CoreDataProperties.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//
//

import Foundation
import CoreData


extension CTPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTPerson> {
        return NSFetchRequest<CTPerson>(entityName: "CTPerson")
    }

	static var entityName:String {
		return "CTPerson"
	}

    @NSManaged public var uniqueID: String
    @NSManaged public var name: String
    @NSManaged public var emailID: String

}
