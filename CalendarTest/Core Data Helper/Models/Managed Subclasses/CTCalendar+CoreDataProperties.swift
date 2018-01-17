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

/**
This auto generated subclass of CTCalendar.
*/
extension CTCalendar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTCalendar> {
        return NSFetchRequest<CTCalendar>(entityName: "CTCalendar")
    }

	static var entityName:String {
		return "CTCalendar"
	}

	///Unique ID of calendar
    @NSManaged public var uniqueID: String

	///Hex color string for calenar
    @NSManaged public var colorHex: String

	///Name of calendar
    @NSManaged public var name: String

}
