//
//  CTCompleteInfoTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This cell is used when all information (title, location and attendees) are present for event. This can also be used when title and attendees are present but location is not present by clipping it's bottom.
*/
class CTCompleteInfoTableViewCell: UITableViewCell {

	///Lable to show start time of event
	var startTimeLabel:UILabel!

	///Lable to show duration of event
	var eventDurationLabel:UILabel!

	///Label to show color of calendar to which this event belongs.
	var circleView:UIView!

	///Label to show title of event
	var titleLabel:UILabel!

	///Lable used to show whether this is first upcoming event today
	var arrowLabelForUpcomingEvent:UILabel!

	///Label to show location of event
	var locationLabel:UILabel!

	///first attendee label
	var firstAttendeeLabel:UILabel!

	///second attendee lable
	var secondAttendeeLabel:UILabel!

	///Third attendee label
	var thirdAttendeeLabel:UILabel!

	///Remaining count attendee label. This is used when there are more than 3 attendees.
	var remainingAttendeeCountLabel:UILabel!

	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTCompleteInfoTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
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
		self.arrowLabelForUpcomingEvent = uiLayoutHelper.addFirstUpComingEventIndicator(inCell: self)
		self.circleView = uiLayoutHelper.addCalColorCircleView(inCell: self, centerAlignedWith: self.startTimeLabel!)
		self.titleLabel = uiLayoutHelper.addTitleLabel(inCell: self, centerAlignedWith: circleView!, inRightOf: circleView!)
		let attendeeInfoViews = uiLayoutHelper.addAttendeesLabels(inCell: self, alignLeftTo: self.titleLabel, below: self.titleLabel)
		self.firstAttendeeLabel = attendeeInfoViews.first
		self.secondAttendeeLabel = attendeeInfoViews.second
		self.thirdAttendeeLabel = attendeeInfoViews.third
		self.remainingAttendeeCountLabel = attendeeInfoViews.fourth
		self.locationLabel = uiLayoutHelper.addLocationLabel(inCell: self, alignLeftTo: self.titleLabel, below: self.firstAttendeeLabel)
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
		self.locationLabel.text = !uiData.locationString.isEmpty ? "⚲ " + uiData.locationString : ""
		self.arrowLabelForUpcomingEvent.isHidden = !uiData.isFistUpcomingEventToday

		//Logic for showing attendee first name and color
		//first hide all labels
		self.firstAttendeeLabel.isHidden = true
		self.secondAttendeeLabel.isHidden = true
		self.thirdAttendeeLabel.isHidden = true
		self.remainingAttendeeCountLabel.isHidden = true

		var attendees = uiData.attendeesInfo

		//There will always be atleast one attendee, other wise this cell will not be used
		//get first attendee and show
		let firstAttendee = attendees[0]
		self.firstAttendeeLabel.isHidden = false
		self.firstAttendeeLabel.text = firstAttendee.name.first!.description
		self.firstAttendeeLabel.backgroundColor = firstAttendee.color
		///remove first attendee from list
		attendees.remove(at: 0)

		//check and show second attendee, remove after showing
		if attendees.count > 0 {
			let secondAttendee = attendees[0]
			self.secondAttendeeLabel.isHidden = false
			self.secondAttendeeLabel.text = secondAttendee.name.first!.description
			self.secondAttendeeLabel.backgroundColor = secondAttendee.color
			attendees.remove(at: 0)
		}

		//check and show third attendee, remove after showing
		if attendees.count > 0 {
			let thirdAttendee = attendees[0]
			self.thirdAttendeeLabel.isHidden = false
			self.thirdAttendeeLabel.text = thirdAttendee.name.first!.description
			self.thirdAttendeeLabel.backgroundColor = thirdAttendee.color
			attendees.remove(at: 0)
		}

		//Still more attendees left then show remaining count label
		if attendees.count > 0 {
			self.remainingAttendeeCountLabel.isHidden = false
			self.remainingAttendeeCountLabel.text = "+" + "\(attendees.count)"
		}
	}
}
