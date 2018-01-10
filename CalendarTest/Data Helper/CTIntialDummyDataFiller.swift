//
//  CTIntialDummyDataFiller.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import CoreData
import Foundation

internal enum DummyDataFillerErrors:Error {
	case dummyDataCreationFailed
}

final class CTIntialDummyDataFiller {

	final func fillDummyData(completion:@escaping (_ error:Error?) -> ()) {
		CTAppControl.current!.coreDataController.coreDataContainer.performBackgroundTask {
			[weak self]
			(context)
			in
			guard let blockSelf = self
				else {
					return
			}
			//fill dummy data
			blockSelf.createDummyData(context: context, completion: { (error) in
				guard error == nil
					else{
						//something is wrong while filling dummy data
						completion(error)
						return
				}

				//fillig dummy data successful
				completion(nil)
			})
		}
	}

	private func createDummyData(context:NSManagedObjectContext, completion:@escaping (_ error:Error?) -> ()) {

		let dummyCalendars = self.getDummyCalendars(inContext: context)
		let dummyPersons = self.getDummyPersons(inContext: context)
		var arrayOfDummyEvents = [CTEvent]()

		//fill dummy events - every monday - 2 events, every friday and today- 3 events with random title, location, start and end times,
		var startDate = CTAppConstants.shared.minMaxDate.minDate
		let maxDate = CTAppConstants.shared.minMaxDate.maxDate

		while(startDate < maxDate) {
			if startDate.day == 1 {
				//add two events every monday one with people and one without
				let dummyEvent1 = self.getDummyEvent(onDate: startDate, isAllDay: false, person: [CTPerson](), calendar: dummyCalendars.first!, inContext: context)
				let dummyEvent2 = self.getDummyEvent(onDate: startDate, isAllDay: true, person: dummyPersons, calendar: dummyCalendars.last!, inContext: context)
				arrayOfDummyEvents.append(contentsOf: [dummyEvent1, dummyEvent2])
			}else if startDate.day == 7 || startDate.isToday {
				let dummyEvent1 = self.getDummyEvent(onDate: startDate, isAllDay: false, person: [CTPerson](), calendar: dummyCalendars[0], inContext: context)
				let dummyEvent2 = self.getDummyEvent(onDate: startDate, isAllDay: true, person: dummyPersons, calendar: dummyCalendars[1], inContext: context)
				let dummyEvent3 = self.getDummyEvent(onDate: startDate, isAllDay: false, person: dummyPersons, calendar: dummyCalendars[2], inContext: context)
				arrayOfDummyEvents.append(contentsOf: [dummyEvent1, dummyEvent2, dummyEvent3])
			}

			startDate = startDate.nextDate.startOfDate
		}

		do {
			try context.save()
			completion(nil)
		}catch {
			Swift.print("Error while creating dummy data - \(error)")
			completion(DummyDataFillerErrors.dummyDataCreationFailed)
		}

	}

	private func getDummyCalendars(inContext:NSManagedObjectContext) -> [CTCalendar] {
		let calObj1 = NSEntityDescription.insertNewObject(forEntityName: CTCalendar.entityName, into: inContext) as! CTCalendar
		calObj1.name = "Work"
		calObj1.uniqueID = UUID().uuidString
		calObj1.colorHex = "#2F80ED"

		let calObj2 = NSEntityDescription.insertNewObject(forEntityName: CTCalendar.entityName, into: inContext) as! CTCalendar
		calObj2.name = "Personal"
		calObj2.uniqueID = UUID().uuidString
		calObj2.colorHex = "#EB5757"

		let calObj3 = NSEntityDescription.insertNewObject(forEntityName: CTCalendar.entityName, into: inContext) as! CTCalendar
		calObj3.name = "Random"
		calObj3.uniqueID = UUID().uuidString
		calObj3.colorHex = "#9B51E0"

		return [calObj1, calObj2, calObj3]
	}

	private func getDummyPersons(inContext:NSManagedObjectContext) -> [CTPerson] {
		let personObj1 = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
		personObj1.name = "Newton"
		personObj1.emailID = "newton@royalsociety.com"
		personObj1.uniqueID = UUID().uuidString

		let personObj2 = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
		personObj2.name = "Tesla"
		personObj2.emailID = "tesla@royalsociety.com"
		personObj2.uniqueID = UUID().uuidString

		let personObj3 = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
		personObj3.name = "Einstein"
		personObj3.emailID = "einstein@royalsociety.com"
		personObj3.uniqueID = UUID().uuidString

		let personObj4 = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
		personObj4.name = "Raman"
		personObj4.emailID = "raman@royalsociety.com"
		personObj4.uniqueID = UUID().uuidString

		let personObj5 = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
		personObj5.name = "Ramanujam"
		personObj5.emailID = "ramanujam@royalsociety.com"
		personObj5.uniqueID = UUID().uuidString

		return [personObj1, personObj2, personObj3, personObj4, personObj5]
	}

	private func getDummyEvent(onDate:Date, isAllDay:Bool, person:[CTPerson], calendar:CTCalendar, inContext:NSManagedObjectContext) -> CTEvent {
		var startTime = onDate.startOfDate
		var endTime = onDate.endOfDate
		if !isAllDay {
			let randomHrValue = randomNumber(inRange: 8...17)// in range 8 to 17
			startTime = startTime.setHourMinuteAndSec(hours: randomHrValue, mintues: 0, seconds: 0)
			endTime = startTime.setHourMinuteAndSec(hours: randomHrValue+1, mintues: 0, seconds: 0)
		}

		let titleLocationInfo = getRandomEventTitleAndLocation()
		let dummyEvent = NSEntityDescription.insertNewObject(forEntityName: CTEvent.entityName, into: inContext) as! CTEvent
		dummyEvent.title = titleLocationInfo.title
		dummyEvent.uniqueID = UUID().uuidString
		dummyEvent.startTime = startTime.timeIntervalSince1970
		dummyEvent.endTime = endTime.timeIntervalSince1970
		dummyEvent.isAllDay = isAllDay
		dummyEvent.loactionString = titleLocationInfo.location
		if person.count > 0 {
			dummyEvent.attendees = NSSet(array: person)
		}
		dummyEvent.calendar = calendar
		return dummyEvent
	}

	private func getRandomEventTitleAndLocation() -> (title:String, location:String?) {
		var arrayOfTitles = ["Brainstorming on Membeship",
							 "Meeting with UK queen",
							 "e=mc2 Brainstorming",
							 "Brainstorming on blackholes",
							 "Brainstorming with students",
							 "Brainstorming on gravity newton vs Einstein"
							]

		var arrayOfLocations = ["Brew beer cafe, 14th Main, london",
								"Cofee cafe, MG road, london",
								"Oxford central hall, London",
								"Opposite queen palace, London , UK"
							   ]
		let randomIndex = randomNumber(inRange: 1...5)
		let title = arrayOfTitles[randomIndex]
		let location:String? = randomIndex <= 3 ? arrayOfLocations[randomIndex] : nil
		return (title, location)
	}
}
