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
}

//mark:Table UI delegate info
extension CTAgendaListUIHelper {

	func registerCells(inTableView:UITableView) {
		CTTitleOnlyRowTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTTitleOnlyRowTableViewCell")
		CTAgendaSectionHeader.registerHeader(tableView: inTableView, forReuseIdentifier: "CTAgendaSectionHeader")
	}

	final func numberOfSections() -> Int {
		return self.arrayOfSectionUIData.count
	}

	func numberOfRowsInSection(section:Int) -> Int {
		return self.arrayOfSectionUIData[section].arrayOfEventsRowUIDataOnDay.count
	}

	func cellForRow(indexPath:IndexPath, inTableView:UITableView) -> UITableViewCell {
		let sectionData = self.arrayOfSectionUIData[indexPath.section]
		let rowData = sectionData.arrayOfEventsRowUIDataOnDay[indexPath.row]
		let cell = inTableView.dequeueReusableCell(withIdentifier: "CTTitleOnlyRowTableViewCell") as! CTTitleOnlyRowTableViewCell
		cell.titleLabel?.text = rowData.eventTitle
		return cell
	}

	func sectionHeaderFor(forSection:Int, inTabelView:UITableView) -> UIView {
		let sectionHeader = inTabelView.dequeueReusableHeaderFooterView(withIdentifier: "CTAgendaSectionHeader") as! CTAgendaSectionHeader
		let sectionData = self.arrayOfSectionUIData[forSection]
		sectionHeader.dateLabel?.text = sectionData.dateOfSection.displayDateText
		return sectionHeader
	}

	func heightForRow(atIndexPath:IndexPath) -> CGFloat {
		return 40
		let sectionData = self.arrayOfSectionUIData[atIndexPath.section]
		let rowData = sectionData.arrayOfEventsRowUIDataOnDay[atIndexPath.row]
		return rowData.heightNeededForRow
	}
}
