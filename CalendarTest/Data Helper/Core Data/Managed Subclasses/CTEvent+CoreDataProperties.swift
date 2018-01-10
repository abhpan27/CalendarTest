//
//  CTEvent+CoreDataProperties.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//
//

import Foundation
import CoreData


extension CTEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTEvent> {
        return NSFetchRequest<CTEvent>(entityName: "CTEvent")
    }

	static var entityName:String {
		return "CTEvent"
	}

	@NSManaged public var title: String
    @NSManaged public var uniqueID: String
    @NSManaged public var startTime: Double
    @NSManaged public var endTime: Double
    @NSManaged public var isAllDay: Bool
    @NSManaged public var loactionString: String?
    @NSManaged public var attendees: NSSet?
    @NSManaged public var calendar: CTCalendar

}

// MARK: Generated accessors for attendees
extension CTEvent {

    @objc(addAttendeesObject:)
    @NSManaged public func addToAttendees(_ value: CTPerson)

    @objc(removeAttendeesObject:)
    @NSManaged public func removeFromAttendees(_ value: CTPerson)

    @objc(addAttendees:)
    @NSManaged public func addToAttendees(_ values: NSSet)

    @objc(removeAttendees:)
    @NSManaged public func removeFromAttendees(_ values: NSSet)

}
