//
//  CTAgendaListUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import UIKit

internal enum agendaViewContentLoadState {
	case loadPastContent, loadFutureContent, loadContentOnLaunch
}

final class CTAgendaListUIHelper {

	var arrayOfSectionUIData = [CTAgendaViewSectionUIData]()
	private let agendaViewDataHelper = CTAgendaViewDataHelper()

	final func loadOnFirstLaunch(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequestForDB = self.contentRequest(contentLoadState: .loadContentOnLaunch)
		agendaViewDataHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequestForDB) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self else {
				completion(nil)
				return
			}

			guard error == nil else {
				completion(error)
				return
			}

			if sectionUIDataList != nil {
				blockSelf.arrayOfSectionUIData = sectionUIDataList!
				completion(nil)
			}
		}
	}

	final func loadFutureUIData(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequestForDB = self.contentRequest(contentLoadState: .loadFutureContent)
		agendaViewDataHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequestForDB) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self else {
				completion(nil)
				return
			}

			guard error == nil else {
				completion(error)
				return
			}

			if let futuredaysData = sectionUIDataList {
				blockSelf.arrayOfSectionUIData.append(contentsOf: futuredaysData)
				completion(nil)
			}
		}
	}

	final func loadPastUIData(completion: @escaping (_ error: Error?) -> ()) {
		let contentRequest = self.contentRequest(contentLoadState: .loadPastContent)
		agendaViewDataHelper.arrayOfAgendaSectionUIData(forContentRequest: contentRequest) {
			[weak self]
			(sectionUIDataList, error)
			in

			guard let blockSelf = self else {
				completion(nil)
				return
			}

			guard error == nil else {
				completion(error)
				return
			}

			if var pastDaysData = sectionUIDataList {
				pastDaysData.append(contentsOf: blockSelf.arrayOfSectionUIData)
				blockSelf.arrayOfSectionUIData = pastDaysData
				completion(nil)
			}
		}
	}

	private func contentRequest(contentLoadState:agendaViewContentLoadState) -> CTDBQueryContentRequest {
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
		}
	}

	//linear search
	final func indexPathForDate(date:Date) -> IndexPath? {
		for index in stride(from: 0, to: self.arrayOfSectionUIData.count, by: 1) {
			if self.arrayOfSectionUIData[index].dateOfSection == date.startOfDate {
				return IndexPath(row: 0, section: index)
			}
		}
		return nil
	}

	final func dateForIndexPath(indexPath:IndexPath) -> Date? {
		let section = indexPath.section
		guard section >= 0 && section < self.arrayOfSectionUIData.count
			else {
				return nil
		}

		return self.arrayOfSectionUIData[section].dateOfSection
	}
}

//Mark:Table UI delegate info
extension CTAgendaListUIHelper {

	func registerCells(inTableView:UITableView) {
		CTTitleOnlyRowTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTTitleOnlyRowTableViewCell")
		CTAgendaSectionHeader.registerHeader(tableView: inTableView, forReuseIdentifier: "CTAgendaSectionHeader")
		CTAgendaViewNoEventTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTAgendaViewNoEventTableViewCell")
		CTTitleAndLocationTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTTitleAndLocationTableViewCell")
		CTCompleteInfoTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTCompleteInfoTableViewCell")
	}

	final func numberOfSections() -> Int {
		return self.arrayOfSectionUIData.count
	}

	func numberOfRowsInSection(section:Int) -> Int {
		let numberOfEventsOnDay = self.arrayOfSectionUIData[section].arrayOfEventsRowUIDataOnDay.count
		return numberOfEventsOnDay > 0 ? numberOfEventsOnDay : 1
	}

	func cellForRow(indexPath:IndexPath, inTableView:UITableView) -> UITableViewCell {

		let sectionData = self.arrayOfSectionUIData[indexPath.section]

		//no event on day show no event row
		if sectionData.arrayOfEventsRowUIDataOnDay.count == 0 {
			let noEventRow = inTableView.dequeueReusableCell(withIdentifier: "CTAgendaViewNoEventTableViewCell") as! CTAgendaViewNoEventTableViewCell
			return noEventRow
		}

		let rowData = sectionData.arrayOfEventsRowUIDataOnDay[indexPath.row]

		switch rowData.typeOfRow {
		case .onlytitle:
			let titleOnlyCell = inTableView.dequeueReusableCell(withIdentifier: "CTTitleOnlyRowTableViewCell") as! CTTitleOnlyRowTableViewCell
			titleOnlyCell.updateWithUIData(uiData: rowData)
			return titleOnlyCell
		case .titleAndPeople:
			let titleAndPeopleRow = inTableView.dequeueReusableCell(withIdentifier: "CTCompleteInfoTableViewCell") as! CTCompleteInfoTableViewCell
			titleAndPeopleRow.updateWithUIData(uiData: rowData)
			return titleAndPeopleRow
		case .titleAndLocation:
			let titleAndLocationRow = inTableView.dequeueReusableCell(withIdentifier: "CTTitleAndLocationTableViewCell") as! CTTitleAndLocationTableViewCell
			titleAndLocationRow.updateWithUIData(uiData: rowData)
			return titleAndLocationRow
		case .fullInfo:
			let fullInfoCell = inTableView.dequeueReusableCell(withIdentifier: "CTCompleteInfoTableViewCell") as! CTCompleteInfoTableViewCell
			fullInfoCell.updateWithUIData(uiData: rowData)
			return fullInfoCell
		}
	}

	func sectionHeaderFor(forSection:Int, inTabelView:UITableView) -> UIView {
		let sectionHeader = inTabelView.dequeueReusableHeaderFooterView(withIdentifier: "CTAgendaSectionHeader") as! CTAgendaSectionHeader
		let sectionData = self.arrayOfSectionUIData[forSection]
		sectionHeader.dateLabel?.text = sectionData.dateOfSection.displayDateText
		sectionHeader.customBackgroundView?.backgroundColor = sectionData.backgroundColor
		return sectionHeader
	}

	func heightForRow(atIndexPath:IndexPath) -> CGFloat {
		let sectionData = self.arrayOfSectionUIData[atIndexPath.section]
		if sectionData.arrayOfEventsRowUIDataOnDay.count == 0 {
			return 40
		}else {
			let rowData = sectionData.arrayOfEventsRowUIDataOnDay[atIndexPath.row]
			return rowData.heightNeededForRow
		}
	}
}
