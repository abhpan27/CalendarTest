//
//  CTAgendaListUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import UIKit

/**
This enum represents different satges of data load into agenda view.
*/
internal enum AgendaViewContentLoadState {

	///Loading of more events from past dates. This adds more event at top of list
	case loadPastContent

	///Loading of more events from future dates. This add more events at bottom of list
	case loadFutureContent

	///Loading of events on first launch of agenda view, This loads some events on first launch. Also inclues today date
	case loadContentOnLaunch

	///Loading of events when some date is selected in Calendar view.
	case loadContentForDateSelectionInCalendar(date:Date)

}

/**
This class is responsible for providing data and table view cells to table view of agenda view. This takes help from CTDBQueryHelper class and dynamically add events on top or bottom of list as user scrolls.
*/
final class CTAgendaListUIHelper {

	///This is **sorted** list of data for sections of Table view. Every date in table view is shown as a section. And events are shown as rows in that section.
	var arrayOfSectionUIData = [CTAgendaViewSectionUIData]()

	///Db query helper class which takes request for DB query and returns data from DB.
	private let dbQueryHelper = CTDBQueryDataHelper()

	/**
	This method loads data for table view on first launch of agenda view.

	- Parameter completion: Completion handler called when loading of events from DB is completed
	- Parameter error: Any error while loading events from DB.
	*/
	final func loadOnFirstLaunch(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequestForDB = self.contentRequest(contentLoadState: .loadContentOnLaunch)
		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequestForDB) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self
				else {
					completion(nil)
					return
			}

			guard error == nil
				else {
					completion(error)
					return
			}

			if sectionUIDataList != nil {
				blockSelf.arrayOfSectionUIData = sectionUIDataList!
				completion(nil)
			}
		}
	}


	/**
	This method loads future events. This will eventually add more events in bottom of agenda view.

	- Parameter completion: Completion handler called when loading of events from DB is completed
	- Parameter error: Any error while loading events from DB.
	*/
	final func loadFutureUIData(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequestForDB = self.contentRequest(contentLoadState: .loadFutureContent)
		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequestForDB) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self
				else {
					completion(nil)
					return
			}

			guard error == nil
				else {
					completion(error)
					return
			}

			if let futuredaysData = sectionUIDataList {
				//just append events after current list of events
				blockSelf.arrayOfSectionUIData.append(contentsOf: futuredaysData)
				completion(nil)
			}
		}
	}


	/**
	This method loads past events. This will eventually add more events at top of agenda view.

	- Parameter completion: Completion handler called when loading of events from DB is completed
	- Parameter error: Any error while loading events from DB.
	*/
	final func loadPastUIData(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequest = self.contentRequest(contentLoadState: .loadPastContent)
		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self
				else {
					completion(nil)
					return
			}

			guard error == nil
				else {
					completion(error)
					return
			}

			if var pastDaysData = sectionUIDataList {
				//add this list before current list of events
				pastDaysData.append(contentsOf: blockSelf.arrayOfSectionUIData)
				blockSelf.arrayOfSectionUIData = pastDaysData
				completion(nil)
			}
		}
	}

	/**
	This method loads events when user selects some date in calendar view. It is possible that date selected in calendar view is not yet added in agenda view

	- Parameter completion: Completion handler called when loading of events from DB is completed
	- Parameter selectedDateInCalendar: Date selected in calendar view.
	- Parameter error: Any error while loading events from DB
	*/
	final func loadDataForDateSelectionInCalendar(selectedDateInCalendar:Date, completion: @escaping (_ error: Error?, _ selectedDate:Date) -> ()) {

		let contentRequest = self.contentRequest(contentLoadState: .loadContentForDateSelectionInCalendar(date: selectedDateInCalendar))

		dbQueryHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self
				else {
					completion(nil, selectedDateInCalendar)
					return
			}

			guard error == nil
				else {
					completion(error, selectedDateInCalendar)
					return
			}

			//if past date is selected then we need to add this data above current list other wise below current list
			let isPastDateSelected =  sectionUIDataList!.first!.dateOfSection < blockSelf.arrayOfSectionUIData.first!.dateOfSection

			if var calSelectionData = sectionUIDataList {
				if isPastDateSelected{
					//add above current list
					calSelectionData.append(contentsOf: blockSelf.arrayOfSectionUIData)
					blockSelf.arrayOfSectionUIData = calSelectionData
				}else {
					//add below current list
					blockSelf.arrayOfSectionUIData.append(contentsOf: calSelectionData)
				}
				completion(nil, selectedDateInCalendar)
			}
		}
	}

	/**
	This is a handy method to create CTDBQueryContentRequest object for different event load states. DBQueryHelper class only accepts CTDBQueryContentRequest object so for every load state there will be one CTDBQueryContentRequest object.

	- Parameter contentLoadState: Load state for which content request is needed.
	- Returns: CTDBQueryContentRequest object which can be used to query DB.
	*/
	private func contentRequest(contentLoadState:AgendaViewContentLoadState) -> CTDBQueryContentRequest {
		let todayDate = Date().startOfDate

		switch contentLoadState {
			
		case .loadContentOnLaunch:
			//intially load 30 days data 15 day past and 15 day future
			let startDate = todayDate.pastDateBefore(days: 15)
			let endDate = todayDate.nextDateAfter(days: 15)
			return CTDBQueryContentRequest(fromDate: startDate, endDate: endDate, type: .agendaViewData)

		case .loadFutureContent:
			//load future 30 day data
			let startDate = self.arrayOfSectionUIData.last!.dateOfSection.nextDate
			let endDate = startDate.nextDateAfter(days: 30)
			return CTDBQueryContentRequest(fromDate: startDate, endDate: endDate, type: .agendaViewData)

		case .loadPastContent:
			//load past 30 days
			let endDate = self.arrayOfSectionUIData.first!.dateOfSection.pastDateBefore(days: 1)
			let startDate = endDate.pastDateBefore(days: 30)
			return CTDBQueryContentRequest(fromDate: startDate, endDate: endDate, type: .agendaViewData)

		case .loadContentForDateSelectionInCalendar(let dateSelectedInCal):
			//there should be minimum 15 days above and 15 days below loaded in list from dateSelectedInCal
			let minDateLoadedCurrently = self.arrayOfSectionUIData.first!.dateOfSection
			let maxDateLoadedCurrently = self.arrayOfSectionUIData.last!.dateOfSection
			let minNumberOfDayBeforeAndAfter = 15
			var startDateForContentRequest = dateSelectedInCal
			var endDateForContentRequest = dateSelectedInCal

			if dateSelectedInCal < minDateLoadedCurrently || (minDateLoadedCurrently < dateSelectedInCal && dateSelectedInCal.days(from: minDateLoadedCurrently) <= minNumberOfDayBeforeAndAfter) {
				//if date selected is not yet loaded or it is loaded but there are less than 15 days loaded above it, then load more events between (dateSelectedInCal - 15 days) to top most date loaded currently
				startDateForContentRequest = dateSelectedInCal.pastDateBefore(days: minNumberOfDayBeforeAndAfter)
				endDateForContentRequest = self.arrayOfSectionUIData.first!.dateOfSection.pastDateBefore(days: 1)
			}else if dateSelectedInCal > maxDateLoadedCurrently || (dateSelectedInCal < maxDateLoadedCurrently && maxDateLoadedCurrently.days(from: dateSelectedInCal) <= minNumberOfDayBeforeAndAfter) {
				//if date selected is not yet loaded or it is loaded but there are less than 15 days loaded below it, then load more events between bottom most date loaded and (dateSelectedInCal + 15)
				startDateForContentRequest = self.arrayOfSectionUIData.last!.dateOfSection.nextDate
				endDateForContentRequest = dateSelectedInCal.nextDateAfter(days: minNumberOfDayBeforeAndAfter)
			}
			return CTDBQueryContentRequest(fromDate: startDateForContentRequest, endDate: endDateForContentRequest, type: .agendaViewData)
		}
	}

	/**
	This Method returns index path of table view for date. It linearly searches in current loaded list of events.

	- Parameter date: Date for which index path is needed
	- Returns: Optional index path for date. If date is not yet loaded in list then nil will be returned.
	*/
	final func indexPathForDate(date:Date) -> IndexPath? {
		for index in stride(from: 0, to: self.arrayOfSectionUIData.count, by: 1) {
			if self.arrayOfSectionUIData[index].dateOfSection == date.startOfDate {
				return IndexPath(row: 0, section: index)
			}
		}
		return nil
	}

	/**
	This Method returns date shown at Index path of table view.

	- Parameter indexPath: Index path for which date is needed.
	- Returns: Optional Date for index path. If invalid index path is passed then nil will be returned.
	*/
	final func dateForIndexPath(indexPath:IndexPath) -> Date? {
		let section = indexPath.section
		guard section >= 0 && section < self.arrayOfSectionUIData.count
			else {
				return nil
		}
		return self.arrayOfSectionUIData[section].dateOfSection
	}
}