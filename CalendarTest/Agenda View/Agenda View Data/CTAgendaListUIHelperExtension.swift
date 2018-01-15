//
//  CTAgendaListUIHelperExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 16/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is extension for Agenda list UI helper. It helps providing tableview essential UI information such as no of rows, no of sections, height, cell etc.
*/
extension CTAgendaListUIHelper {

	/**
	This method register different kind of cells to be used in tabel view of agenda view
	*/
	func registerCells(inTableView:UITableView) {
		//Register header of each section. this shows date in list.
		CTAgendaSectionHeader.registerHeader(tableView: inTableView, forReuseIdentifier: "CTAgendaSectionHeader")

		//Register cell with only title
		CTTitleOnlyRowTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTTitleOnlyRowTableViewCell")

		//Register Cell with no event.
		CTAgendaViewNoEventTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTAgendaViewNoEventTableViewCell")

		//Register cell for Title and location, no attendees.
		CTTitleAndLocationTableViewCell.registerCell(inTableView: inTableView, withIdentifier: "CTTitleAndLocationTableViewCell")

		//Register cell for title, location and attendees. This can also be used for Tile and attendees with no location.
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
		//bsed on information available for events, different kind of cells are used. These cells differ in layout from each other.
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
			//no event row
			return 40
		}else {
			let rowData = sectionData.arrayOfEventsRowUIDataOnDay[atIndexPath.row]
			return rowData.heightNeededForRow
		}
	}
}
