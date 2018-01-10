//
//  CTCalendar+CoreDataProperties.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//
//

import Foundation
import CoreData


extension CTCalendar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTCalendar> {
        return NSFetchRequest<CTCalendar>(entityName: "CTCalendar")
    }

	static var entityName:String {
		return "CTCalendar"
	}

    @NSManaged public var uniqueID: String
    @NSManaged public var colorHex: String
    @NSManaged public var name: String

}
