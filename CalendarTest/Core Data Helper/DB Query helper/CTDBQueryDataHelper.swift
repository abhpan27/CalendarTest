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

/**
This class is responisble to querying core data. This is single point of all DB query done anywhere in App.
This class only accepts object of type CTDBQueryContentRequest for any DB query request.
*/
final class CTDBQueryDataHelper {

	/**
	Enum to represent any error encountered during DB query.
	*/
	enum dbQueryError:Error {

		///Event fetch failed
		case failedToFetchEvents

		///Content request object is invalid.
		case inValidContentRequest
	}

	///Type alias for completion handler used by agenda view
	typealias agendaViewDBQueryCompletionHandlerType = (_ list:[CTAgendaViewSectionUIData]?, _ error:Error?) -> ()

	///Type alias for completion handler used by Calendar View.
	typealias calViewDBQueryCompletionHandlerType = (_ dictionary:[Date:Int]?, _ error:Error?) -> ()


	/**
	This method provides array of CTAgendaViewSectionUIData objects for any content request object.

	- Parameter forContentRequest: CTDBQueryContentRequest object which specifies conditions for DB query.
	- Parameter completion: Completion handler. Called when DB query is completed or some error occurred.
	*/
	func arrayOfAgendaSectionUIData(forContentRequest:CTDBQueryContentRequest, completion:@escaping agendaViewDBQueryCompletionHandlerType) {

		//validate that content request object
		guard forContentRequest.toDate > forContentRequest.fromDate else {
			completion(nil, dbQueryError.inValidContentRequest)
			return
		}

		//query for agenda view is done in Main thread.
		let uiContext = CTAppControl.current!.coreDataController.uiContext!

		//get all events for given content request object
		guard let listOfEvents = try? self.getAllEventsFromDB(forContentRequest: forContentRequest, inContext: uiContext)
			else {
				completion(nil, dbQueryError.failedToFetchEvents)
				return
		}

		//convert Array of CTEvent into array of CTAgendaViewSectionUIData
		let arrayOfSectionUIDataForRequest = self.convertListOfDBEventObjectIntoSectionUIData(dbEventList: listOfEvents, forContentRequest: forContentRequest)
		completion(arrayOfSectionUIDataForRequest, nil)
	}


	/**
	This method provides information about number of event present on dates.

	- Parameter forContentRequest: CTDBQueryContentRequest object which specifies conditions for DB query.
	- Parameter completion: Completion handler. Called when DB query is completed or some error occurred.
	*/
	func dictionaryOfEventAvalabilty(forContentRequest:CTDBQueryContentRequest, completion:@escaping calViewDBQueryCompletionHandlerType) {

		//validate that content request object
		guard forContentRequest.toDate > forContentRequest.fromDate else {
			completion(nil, dbQueryError.inValidContentRequest)
			return
		}

		//query for agenda view is done in background thread.
		CTAppControl.current!.coreDataController.coreDataContainer.performBackgroundTask {
			[weak self]
			(backgroundContext)
			in
			guard let blockSelf = self
				else {
					completion(nil, dbQueryError.failedToFetchEvents)
					return
			}

			//get all events for given content request object
			guard let listOfEvents = try? blockSelf.getAllEventsFromDB(forContentRequest: forContentRequest, inContext: backgroundContext)
				else {
					completion(nil, dbQueryError.failedToFetchEvents)
					return
			}

			//convert Array of CTEvent into dictonary of type [Date:Int] which represents number of events available(value) on any specific date(key).
			let availabilityDictonary = blockSelf.covertListOfDBEventObjectsIntoCalEventAvailability(dbEventList: listOfEvents)
			completion(availabilityDictonary, nil)
		}
	}

	/**
	This method returns all the events in DB which satisfies conditions specified in content request object.

	- Parameter forContentRequest: CTDBQueryContentRequest object which specifies conditions for DB query
	- Parameter inContext: NSManagedObjectContext object which will be used for querying
	- Returns: Array of CTEvent objects which satisfies conditions of content request
	- Throws: Any error encountered during fetch operation
	*/
	private func getAllEventsFromDB(forContentRequest:CTDBQueryContentRequest, inContext:NSManagedObjectContext) throws -> [CTEvent] {

		let fetchRequest = NSFetchRequest<CTEvent>(entityName: CTEvent.entityName)
		let startTime = forContentRequest.fromDate.startOfDate.timeIntervalSince1970
		let endTime = forContentRequest.toDate.endOfDate.timeIntervalSince1970
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
		fetchRequest.returnsObjectsAsFaults = false

		//get all events which starts at or after given start time and ends at or before given end time.
		let predicate = NSPredicate(format: "startTime >= %@ AND endTime <= %@", NSNumber(value: startTime), NSNumber(value: endTime))
		fetchRequest.predicate = predicate

		do {
			let eventList = try inContext.fetch(fetchRequest)
			return eventList
		}catch {
			throw dbQueryError.failedToFetchEvents
		}
	}


	/**
	This method converts array of CTEvent into dictonary of type [Date:Int] which represents number of events available(value) on any specific date(key).

	- Parameter dbEventList: array of CTEvent object
	- Returns: Dictonary of which holds number of event on given date.
	*/
	private func covertListOfDBEventObjectsIntoCalEventAvailability(dbEventList:[CTEvent]) -> [Date:Int] {

		var eventAvailability = [Date:Int]()

		for event in dbEventList {
			let startDateOfEvent = Date(timeIntervalSince1970: TimeInterval(event.startTime)).startOfDate
			if eventAvailability[startDateOfEvent] ==  nil {
				//if first event for date set as 1
				eventAvailability[startDateOfEvent] = 1
			}else {
				//if already has some event on date, increase it by one.
				eventAvailability[startDateOfEvent]! += 1
			}
		}
		return eventAvailability
	}

	/**
	This method converts array of CTEvent into array of type CTAgendaViewSectionUIData which can used by aganeda view to create UI.

	- Parameter dbEventList: array of CTEvent object
	- Returns: **Sorted by Date** array of type CTAgendaViewSectionUIData.
	*/
	private func convertListOfDBEventObjectIntoSectionUIData(dbEventList:[CTEvent], forContentRequest:CTDBQueryContentRequest) -> [CTAgendaViewSectionUIData] {

		//Array of events on give date. For every date in given date range there will array of events. If there are no events on date then there will be empty array.
		var eventsGroupBasedOnDates = [Date: [CTEvent]]()

		var loopStartDate = forContentRequest.fromDate.startOfDate
		let loopEndDate = forContentRequest.toDate.startOfDate
		//for every date in given range, intialize it as empty array
		while loopStartDate <= loopEndDate {
			eventsGroupBasedOnDates[loopStartDate] = [CTEvent]()
			loopStartDate = loopStartDate.nextDate
		}

		//for every date in given range,empty array added, now add actual events
		for event in dbEventList {
			let startDateOfEvent = Date(timeIntervalSince1970: TimeInterval(event.startTime)).startOfDate
			if eventsGroupBasedOnDates[startDateOfEvent] !=  nil {
				//append into already created array of events on date. This steps groups all event on same date together.
				eventsGroupBasedOnDates[startDateOfEvent]?.append(event)
			}
		}

		var arrayOfSectionUIData = [CTAgendaViewSectionUIData]()

		//sort group of event by date.
		let sortedGroupBasedOnDates =  eventsGroupBasedOnDates.sorted(by: {$0.0.timeIntervalSince1970 < $1.0.timeIntervalSince1970})

		for (date, arrayOfEvent) in sortedGroupBasedOnDates {

			//array of CTAgendaViewRowUIData on given date. Each date is section and events on date is row.
			var listOfRowEventUIDataOnDay = [CTAgendaViewRowUIData]()

			for index in stride(from: 0, to: arrayOfEvent.count, by: 1){
				let dbEventData = arrayOfEvent[index]
				//create array of events on this date
				listOfRowEventUIDataOnDay.append(getRowUIDataForDBEventObj(dbEvent: dbEventData))
			}

			//Create and append section ui data from row data for this date
			let sectionUIData = CTAgendaViewSectionUIData(dateOfSection: date, arrayOfEventsRowUIDataOnDay: listOfRowEventUIDataOnDay)
			arrayOfSectionUIData.append(sectionUIData)
		}
		return arrayOfSectionUIData
	}


	/**
	This method returns object of type CTAgendaViewRowUIData for CTEvent. For every CTEvent object there will be one row in TableView. UI Of that row will be created from object of CTAgendaViewRowUIData

	- Parmeter dbEvent: CTEvent object which needs to be converetd into CTAgendaViewRowUIData
	- Returns: CTAgendaViewRowUIData object for given CTEvent
	*/
	private func getRowUIDataForDBEventObj(dbEvent:CTEvent) -> CTAgendaViewRowUIData {
		let listOfAttendees = getArrayOfAttendeeDataForEvent(dbEvent: dbEvent)
		let startDateTime = Date(timeIntervalSince1970: TimeInterval(dbEvent.startTime))
		let endDateTime = Date(timeIntervalSince1970: TimeInterval(dbEvent.endTime))
		let calColor = UIColor(hex: dbEvent.calendar.colorHex) ?? UIColor.gray

		return CTAgendaViewRowUIData(uniqueID: dbEvent.uniqueID, eventTitle: dbEvent.title, eventStartTime: startDateTime, eventEndTime: endDateTime, isAllDay: dbEvent.isAllDay, attendeesInfo: listOfAttendees, locationString: dbEvent.loactionString ?? "", calColor: calColor)

	}


	/**
	This is returns array of AttendeeData for givent array. It may be empty if there are no attendee for event.

	- Parmeter dbEvent: CTEvent object for which array of AttendeeData is needed.
	- Returns: array of CTAgendaViewRowUIData.AttendeeData. It used by rows of table view. It can be empty if there is no attendee for event.
	*/
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
