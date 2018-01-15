//
//  CTDBQueryDataHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CTDBQueryDataHelper {

	enum dbQueryError:Error {
		case failedToFetchEvents
		case inValidContentRequest
	}

	typealias agendaViewDBQueryCompletionHandlerType = (_ list:[CTAgendaViewSectionUIData]?, _ error:Error?) -> ()
	typealias calViewDBQueryCompletionHandlerType = (_ dictionary:[Date:Int]?, _ error:Error?) -> ()

	func arrayOfAgendaSectionUIData(forContentRequest:CTDBQueryContentRequest, completion:@escaping agendaViewDBQueryCompletionHandlerType) {

		guard forContentRequest.toDate > forContentRequest.fromDate else {
			completion(nil, dbQueryError.inValidContentRequest)
			return
		}

		let uiContext = CTAppControl.current!.coreDataController.uiContext!
		guard let listOfEvents = try? self.getAllEventsFromDB(forContentRequest: forContentRequest, inContext: uiContext)
			else {
				completion(nil, dbQueryError.failedToFetchEvents)
				return
		}

		let arrayOfSectionUIDataForRequest = self.convertListOfDBEventObjectIntoSectionUIData(dbEventList: listOfEvents, forContentRequest: forContentRequest)
		completion(arrayOfSectionUIDataForRequest, nil)
	}

	func dictionaryOfEventAvalabilty(forContentRequest:CTDBQueryContentRequest, completion:@escaping calViewDBQueryCompletionHandlerType) {

		guard forContentRequest.toDate > forContentRequest.fromDate else {
			completion(nil, dbQueryError.inValidContentRequest)
			return
		}

		CTAppControl.current!.coreDataController.coreDataContainer.performBackgroundTask {
			[weak self]
			(backgroundContext)
			in
			guard let blockSelf = self
				else {
					completion(nil, dbQueryError.failedToFetchEvents)
					return
			}

			guard let listOfEvents = try? blockSelf.getAllEventsFromDB(forContentRequest: forContentRequest, inContext: backgroundContext)
				else {
					completion(nil, dbQueryError.failedToFetchEvents)
					return
			}

			let availabilityDictonary = blockSelf.covertListOfDBEventObjectsIntoCalEventAvailability(dbEventList: listOfEvents)
			completion(availabilityDictonary, nil)
		}
	}

	private func getAllEventsFromDB(forContentRequest:CTDBQueryContentRequest, inContext:NSManagedObjectContext) throws -> [CTEvent] {

		let fetchRequest = NSFetchRequest<CTEvent>(entityName: CTEvent.entityName)
		let startTime = forContentRequest.fromDate.startOfDate.timeIntervalSince1970
		let endTime = forContentRequest.toDate.endOfDate.timeIntervalSince1970
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
		fetchRequest.returnsObjectsAsFaults = false
		let predicate = NSPredicate(format: "startTime >= %@ AND endTime <= %@", NSNumber(value: startTime), NSNumber(value: endTime))
		fetchRequest.predicate = predicate

		do {
			let eventList = try inContext.fetch(fetchRequest)
			return eventList
		}catch {
			throw dbQueryError.failedToFetchEvents
		}
	}

	private func covertListOfDBEventObjectsIntoCalEventAvailability(dbEventList:[CTEvent]) -> [Date:Int] {

		var eventAvailability = [Date:Int]()

		for event in dbEventList {
			let startDateOfEvent = Date(timeIntervalSince1970: TimeInterval(event.startTime)).startOfDate
			if eventAvailability[startDateOfEvent] ==  nil {
				eventAvailability[startDateOfEvent] = 1
			}else {
				eventAvailability[startDateOfEvent]! += 1
			}
		}

		return eventAvailability
	}

	private func convertListOfDBEventObjectIntoSectionUIData(dbEventList:[CTEvent], forContentRequest:CTDBQueryContentRequest) -> [CTAgendaViewSectionUIData] {

		var eventsGroupBasedOnDates = [Date: [CTEvent]]()

		var loopStartDate = forContentRequest.fromDate.startOfDate
		let loopEndDate = forContentRequest.toDate.startOfDate
		while loopStartDate <= loopEndDate {
			eventsGroupBasedOnDates[loopStartDate] = [CTEvent]()
			loopStartDate = loopStartDate.nextDate
		}

		for event in dbEventList {
			let startDateOfEvent = Date(timeIntervalSince1970: TimeInterval(event.startTime)).startOfDate
			if eventsGroupBasedOnDates[startDateOfEvent] !=  nil {
				eventsGroupBasedOnDates[startDateOfEvent]?.append(event)
			}
		}

		var arrayOfSectionUIData = [CTAgendaViewSectionUIData]()
		let sortedGroupBasedOnDates =  eventsGroupBasedOnDates.sorted(by: {$0.0.timeIntervalSince1970 < $1.0.timeIntervalSince1970})
		for (date, arrayOfEvent) in sortedGroupBasedOnDates {

			var listOfRowEventUIDataOnDay = [CTAgendaViewRowUIData]()

			for index in stride(from: 0, to: arrayOfEvent.count, by: 1){
				let dbEventData = arrayOfEvent[index]
				listOfRowEventUIDataOnDay.append(getRowUIDataForDBEventObj(dbEvent: dbEventData))
			}

			let sectionUIData = CTAgendaViewSectionUIData(dateOfSection: date, arrayOfEventsRowUIDataOnDay: listOfRowEventUIDataOnDay)
			arrayOfSectionUIData.append(sectionUIData)
		}

		return arrayOfSectionUIData
	}

	private func getRowUIDataForDBEventObj(dbEvent:CTEvent) -> CTAgendaViewRowUIData {
		let listOfAttendees = getArrayOfAttendeeDataForEvent(dbEvent: dbEvent)
		let startDateTime = Date(timeIntervalSince1970: TimeInterval(dbEvent.startTime))
		let endDateTime = Date(timeIntervalSince1970: TimeInterval(dbEvent.endTime))
		let calColor = UIColor(hex: dbEvent.calendar.colorHex) ?? UIColor.gray

		return CTAgendaViewRowUIData(uniqueID: dbEvent.uniqueID, eventTitle: dbEvent.title, eventStartTime: startDateTime, eventEndTime: endDateTime, isAllDay: dbEvent.isAllDay, attendeesInfo: listOfAttendees, locationString: dbEvent.loactionString ?? "", calColor: calColor)

	}

	private func getArrayOfAttendeeDataForEvent(dbEvent:CTEvent) -> [CTAgendaViewRowUIData.AttendeeData] {
		var listOfAttendeeData = [CTAgendaViewRowUIData.AttendeeData]()
		if let attendees = dbEvent.attendees {
			for attendee in attendees {
				if let personAsAttendee = attendee as? CTPerson {
					let color = UIColor(hex: personAsAttendee.colorHex) ?? UIColor.gray
					let attendeeData = CTAgendaViewRowUIData.AttendeeData(name: personAsAttendee.name, email: personAsAttendee.emailID, color:color)
					listOfAttendeeData.append(attendeeData)
				}
			}
		}
		return listOfAttendeeData
	}
}
