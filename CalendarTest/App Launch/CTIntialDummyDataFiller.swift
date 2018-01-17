//
//  CTIntialDummyDataFiller.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import CoreData
import Foundation

/**
enum for Errors encountered during dummy app data creation
*/
internal enum DummyDataFillerErrors:Error {
	//thrown when static dummy app data creation failed for some reason.
	case dummyDataCreationFailed
}

/**
This class is responsible for creating static app data on first launch of the app.
it creates static app data in core data. It tries to create good mixture of different kind of events,
such as - All day event, event with only title, event with title and location, event without location etc.
*/
final class CTIntialDummyDataFiller {

	//list of dummy titles. Title of events are picked randomly from this list.
	let arrayOfDummyTitles =  ["Physics lecture on photoelectric effect",
							   "Brainstorming how edison cheated tesla",
							   "Interview with AK Media",
							   "Discussion on gravity, newton vs edison",
							   "Fixing water leakage from rooftop",
							   "Discussion with students on blackholes",
							   "Lecture on relativity theory",
							   "Car service visit",
							   "Dental checkup",
							   "Meetup with Arthur",
							   "Mathamatics student summit"]

	//list of dummy locations. Location of events are picked randomly from this list.
	let arrayOfDummyLocations = ["Brew beer cafe, 14th Main, london",
								 "Cofee cafe, MG road, london",
								 "Oxford central hall, London",
								 "Opposite queen palace, London , UK"]

	//list of dummy Poeple name email pair. For each element in this list, there will be one person object in core data.
	let arrayOfDummyPeopleNameEmailPair = [["Newton","newton@royalsociety.com"],
										   ["Tesla", "tesla@royalsociety.com"],
										   ["Eienstine", "einstine@royalsociety.com"],
										   ["Ramanumjam", "ramanumjam@royalcociety.com"],
										   ["Galileo", "galileo@romangov.com"],
										   ["C.V. Raman", "raman@iisc.coom"]]

	//list of dummy Colors. Color of events and color of attendees are picked randomly from this list.
	let arrayOfDummyColors = 	["#2F80ED",
								  "#EB5757",
								  "#9B51E0",
								  "#219653",
								  "#BB6BD9"]

	//List of dummy calendar names. For each name in this list, there will be one calendar object.
	let arrayOfCalNames = ["Work",
						   "Personnal",
						   "University"]

	/**
	This method is wrapper around createDummyData method of this class.
	- Parameter completion: completion handler. Once dummy app data is created this completion handler will be called.
	- Parameter error:Any error during app data creation
	*/
	final func fillDummyData(completion:@escaping (_ error:Error?) -> ()) {
		//Create app data in background context to avoid delay in app lauch time.
		CTAppControl.current!.coreDataController.coreDataContainer.performBackgroundTask {
			[weak self]
			(context)
			in
			guard let blockSelf = self
				else {
					return
			}
			//start filling dummy app data
			blockSelf.createDummyData(context: context, completion: { (error) in
				guard error == nil
					else{
						//something is wrong while return error, this will be handled by caller
						completion(error)
						return
				}

				//fillig dummy data successful
				completion(nil)
			})
		}
	}

	/**
	This method does actual task of creating static dummy app data in core data.
	It first creates dummy calendars objects, then dummy person objects, and then using this obejcts, it creates dummy events.

	- Parameter context: NSManagedObjectContext object used in creating app data.
	- Parameter completion: Completion handler. Called when dummy app data is created
	- Parameter error:Any error during app data creation
	*/
	private func createDummyData(context:NSManagedObjectContext, completion:@escaping (_ error:Error?) -> ()) {
		let dummyCalendars = self.getDummyCalendars(inContext: context)
		let dummyPersons = self.getDummyPersons(inContext: context)
		var arrayOfDummyEvents = [CTEvent]()

		//data will be created for dates between past 12 month and future 12 months. Which is good enough to showcase UI.
		var startDate = Calendar.current.pastMonth(noOfMonths: 12, date: Date()).startOfDate
		let maxDate = Calendar.current.futureMonth(noOfMonths: 12, date: Date()).startOfDate

		while(startDate < maxDate) {

			let randomValue = randomNumber(inRange: 0 ... 3)
			//for 0 there is no event

			//for 0 just one all day event
			if randomValue == 1 {
				let allDayDummy = self.getDummyEvent(onDate: startDate, isAllDay: true, person: dummyPersons, calendar: dummyCalendars.last!, inContext: context)
				arrayOfDummyEvents.append(contentsOf: [allDayDummy])
			}

			//for 2 one all day one timed event
			if randomValue == 2 {
				let allDayDummy = self.getDummyEvent(onDate: startDate, isAllDay: true, person: dummyPersons, calendar: dummyCalendars.last!, inContext: context)
				let timedDummy = self.getDummyEvent(onDate: startDate, isAllDay: false, person: dummyPersons, calendar: dummyCalendars.first!, inContext: context)
				arrayOfDummyEvents.append(contentsOf: [allDayDummy, timedDummy])
			}

			//for 3 one all day two timed events
			if randomValue == 3 {
				let allDayDummy = self.getDummyEvent(onDate: startDate, isAllDay: true, person: dummyPersons, calendar: dummyCalendars[1], inContext: context)
				let timedDummy1 = self.getDummyEvent(onDate: startDate, isAllDay: false, person: dummyPersons, calendar: dummyCalendars[0], inContext: context)
				let timedDummy2 = self.getDummyEvent(onDate: startDate, isAllDay: false, person: dummyPersons, calendar: dummyCalendars[2], inContext: context)
				arrayOfDummyEvents.append(contentsOf: [allDayDummy, timedDummy1, timedDummy2])
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

	/**
	Creates array of dummy calendar. Each calendar will have different names. Color of calendar will be any randomly picked color value.

	- Parameter inContext: NSManagedObjectContext object used in creating app data.
	- Returns: Array of CTCalendar objects.
	*/
	private func getDummyCalendars(inContext:NSManagedObjectContext) -> [CTCalendar] {
		var listOfDummyCals = [CTCalendar]()
		for index in 0 ... self.arrayOfCalNames.count - 1 {
			let calObj = NSEntityDescription.insertNewObject(forEntityName: CTCalendar.entityName, into: inContext) as! CTCalendar
			calObj.uniqueID = UUID().uuidString
			calObj.name = self.arrayOfCalNames[index]
			calObj.colorHex = self.randomizedCalColorHexString()
			listOfDummyCals.append(calObj)
		}
		return listOfDummyCals
	}

	/**
	Creates array of dummy person. Each person will have different name and email. These person objects will be treated as attendees of events.

	- Parameter inContext: NSManagedObjectContext object used in creating app data.
	- Returns: Array of CTPerson objects.
	*/
	private func getDummyPersons(inContext:NSManagedObjectContext) -> [CTPerson] {
		var listOfDummyPeople = [CTPerson]()
		for index in 0 ... self.arrayOfDummyPeopleNameEmailPair.count - 1 {
			let personObj = NSEntityDescription.insertNewObject(forEntityName: CTPerson.entityName, into: inContext) as! CTPerson
			personObj.name = self.arrayOfDummyPeopleNameEmailPair[index][0]
			personObj.emailID = self.arrayOfDummyPeopleNameEmailPair[index][0]
			personObj.uniqueID = UUID().uuidString
			personObj.colorHex = self.randomizedCalColorHexString()
			listOfDummyPeople.append(personObj)
		}
		return listOfDummyPeople
	}

	/**
	Creates single event.

	- Parameter onDate: Date on which event will be created.
	- Parameter isAllDay: is this event all day.
	- Parameter person: Array of persons. Randomly any number of person will be picked. note that no person can also be picked.
	- Returns: dummy event.
	*/
	private func getDummyEvent(onDate:Date, isAllDay:Bool, person:[CTPerson], calendar:CTCalendar, inContext:NSManagedObjectContext) -> CTEvent {

		let dummyEvent = NSEntityDescription.insertNewObject(forEntityName: CTEvent.entityName, into: inContext) as! CTEvent
		let randomizedStartEndTime = self.getRandomizedStartEndTime(onDate: onDate, isAllDay: isAllDay)
		dummyEvent.uniqueID = UUID().uuidString
		dummyEvent.startTime = randomizedStartEndTime.startTime.timeIntervalSince1970
		dummyEvent.endTime = randomizedStartEndTime.endTime.timeIntervalSince1970
		dummyEvent.isAllDay = isAllDay
		dummyEvent.loactionString = self.getRandomizedDummyLocation()
		dummyEvent.attendees = self.getRandomizedArrayOfPeople(originalArrayOfPeople: person)
		dummyEvent.title = self.getRandomizedDummyTitle()
		dummyEvent.calendar = calendar
		return dummyEvent
	}

	/**
	Returns any randomly picked title from the list of events title.

	- Returns: Randomly picked event title.
	*/
	private func getRandomizedDummyTitle() -> String {
		let randomIndex = randomNumber(inRange: 0 ... self.arrayOfDummyTitles.count - 1)
		let title = arrayOfDummyTitles[randomIndex]
		return title
	}

	/**
	Returns any randomly picked location from the list of locations. It can also return nil. It means there is no location for event.

	- Returns: Optional randomly picked location.
	*/
	private func getRandomizedDummyLocation() -> String? {
		let randomIndex = randomNumber(inRange: 0 ... self.arrayOfDummyLocations.count)
		let location:String? = randomIndex < self.arrayOfDummyLocations.count ?  arrayOfDummyLocations[randomIndex] : nil
		return location
	}

	/**
	Returns any randomly picked Set of people objects. It can also return empty set. It means there is no attendee for event.

	- Returns: randomly selected set of people.
	*/
	private func getRandomizedArrayOfPeople(originalArrayOfPeople:[CTPerson]) -> NSSet {
		let randomPersonIndex = randomNumber(inRange: 0 ... originalArrayOfPeople.count)
		let setOfPeople = randomPersonIndex < originalArrayOfPeople.count ?  NSSet(array: Array(originalArrayOfPeople[0...randomPersonIndex])) : NSSet()
		return setOfPeople
	}

	/**
	Returns any randomly picked start and end time for event. it pickes any start time between 8hr to 17hr and end time will always be 1 hr after start time.

	- Returns: start end time pair for event.
	*/
	private func getRandomizedStartEndTime(onDate:Date, isAllDay:Bool) -> (startTime:Date, endTime:Date) {
		var startTime = onDate.startOfDate
		var endTime = onDate.endOfDate
		if !isAllDay {
			let randomHrValue = randomNumber(inRange: 8...17)// in range 8 to 17
			startTime = startTime.setHourMinuteAndSec(hours: randomHrValue, mintues: 0, seconds: 0)
			endTime = startTime.setHourMinuteAndSec(hours: randomHrValue+1, mintues: 0, seconds: 0)
		}

		return (startTime, endTime)
	}

	/**
	Returns any randomly picked color hex string.

	- Returns: color hex string.
	*/
	private func randomizedCalColorHexString() -> String {
		let randomIndex = randomNumber(inRange: 0 ... self.arrayOfDummyColors.count - 1)
		return self.arrayOfDummyColors[randomIndex]
	}
}
