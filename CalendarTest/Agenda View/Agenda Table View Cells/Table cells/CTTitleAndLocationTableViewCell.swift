//
//  CTTitleAndLocationTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This cell is used to show event which has title and location only. No attendees.
*/
class CTTitleAndLocationTableViewCell: UITableViewCell {

	/// label used to show start time of event
	var startTimeLabel:UILabel!

	///lable used to show duration of event
	var eventDurationLabel:UILabel!

	///circuler view used show calendar of color to which this event belongs
	var circleView:UIView!

	///Label used to show title of event
	var titleLabel:UILabel!

	///label used to show location of event
	var locationLabel:UILabel!

	///Lable used to show whether this is first upcoming event today
	var arrowLabelForUpcomingEvent:UILabel!


	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTTitleAndLocationTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		self.addUIElements()
	}

	/**
	This method adds and layout subviews in this cell. It takes help from CTAgendaViewCellCommonUIHelper
	*/
	private func addUIElements() {
		let uiLayoutHelper = CTAgendaViewCellCommonUIHelper()
		self.startTimeLabel = uiLayoutHelper.addStartTimeLable(inCell: self)
		self.eventDurationLabel = uiLayoutHelper.addEventDurationLabel(inCell: self, below: startTimeLabel!, leftAlignedTo: startTimeLabel!)
		self.circleView = uiLayoutHelper.addCalColorCircleView(inCell: self, centerAlignedWith: self.startTimeLabel!)
		self.titleLabel = uiLayoutHelper.addTitleLabel(inCell: self, centerAlignedWith: circleView!, inRightOf: circleView!)
		self.locationLabel = uiLayoutHelper.addLocationLabel(inCell: self, alignLeftTo: self.titleLabel, below: self.titleLabel)
		self.arrowLabelForUpcomingEvent = uiLayoutHelper.addFirstUpComingEventIndicator(inCell: self)
	}

	/**
	This method customizes reusable cell with UI Data for this cell.
	- Parameter uiData: Row UI data object, which contains UI related information for each cell.
	*/
	final func updateWithUIData(uiData:CTAgendaViewRowUIData) {
		self.startTimeLabel.text = uiData.startTimeText
		self.eventDurationLabel.text = uiData.timeRangeText
		self.circleView.backgroundColor = uiData.calColor
		self.titleLabel.text = uiData.eventTitle
		self.locationLabel.text = "⚲ " + uiData.locationString
		self.arrowLabelForUpcomingEvent.isHidden = !uiData.isFistUpcomingEventToday
	}
    
}
