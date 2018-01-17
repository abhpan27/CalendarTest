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

/**
This is autogenrated subclass of CTPerson. This object is used as attendee in event.
*/

extension CTPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTPerson> {
        return NSFetchRequest<CTPerson>(entityName: "CTPerson")
    }

	static var entityName:String {
		return "CTPerson"
	}

	///unique ID of person
    @NSManaged public var uniqueID: String

	///Name of person
    @NSManaged public var name: String

	///Email ID of person
    @NSManaged public var emailID: String

	///Hex color string for person.
	@NSManaged public var colorHex: String

	/*
	Many more properties can be added here based on features supported by app.
	For example one property called RSVP status (going, not going, etc) can be added.
	*/

}
