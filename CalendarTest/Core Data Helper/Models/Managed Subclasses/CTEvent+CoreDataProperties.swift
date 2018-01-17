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

/**
This auto generated subclass of CTEvent.
*/
extension CTEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTEvent> {
        return NSFetchRequest<CTEvent>(entityName: "CTEvent")
    }

	static var entityName:String {
		return "CTEvent"
	}

	///title of event
	@NSManaged public var title: String

	///unique ID of event
    @NSManaged public var uniqueID: String

	///Unix epoch for start time
    @NSManaged public var startTime: Double

	///Unix epoch for end time
    @NSManaged public var endTime: Double

	///Bool which shows wheteher current event is All Day event
    @NSManaged public var isAllDay: Bool

	///Optional location of event
    @NSManaged public var loactionString: String?

	///optional set of attendees of event
    @NSManaged public var attendees: NSSet?

	///Calendar to which this event belongs to.
    @NSManaged public var calendar: CTCalendar

	/*
	Many more properties can be added here based on features supported by app.
	For example one property called type of event (birthday, flight, meeting, date etc) can be added.
	*/

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
