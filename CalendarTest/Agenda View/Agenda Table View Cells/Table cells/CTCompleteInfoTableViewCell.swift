//
//  CTCompleteInfoTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCompleteInfoTableViewCell: UITableViewCell {

	var startTimeLabel:UILabel!
	var eventDurationLabel:UILabel!
	var circleView:UIView!
	var titleLabel:UILabel!
	var locationLabel:UILabel!
	var firstAttendeeLabel:UILabel!
	var secondAttendeeLabel:UILabel!
	var thirdAttendeeLabel:UILabel!
	var remaingAttendeeCountLabel:UILabel!

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTCompleteInfoTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		addUIElements()
	}

	private func addUIElements() {
		let uiLayoutHelper = CTAgendaViewCellCommonUIHelper()
		self.startTimeLabel = uiLayoutHelper.addStartTimeLable(inCell: self)
		self.eventDurationLabel = uiLayoutHelper.addEventDurationLabel(inCell: self, below: startTimeLabel!, leftAlignedTo: startTimeLabel!)
		self.circleView = uiLayoutHelper.addCalColorCircleView(inCell: self, centerAlignedWith: self.startTimeLabel!)
		self.titleLabel = uiLayoutHelper.addTitleLabel(inCell: self, centerAlignedWith: circleView!, inRightOf: circleView!)
		let attendeeInfoViews = uiLayoutHelper.addAttendeesLabels(inCell: self, alignLeftTo: self.titleLabel, below: self.titleLabel)
		self.firstAttendeeLabel = attendeeInfoViews.first
		self.secondAttendeeLabel = attendeeInfoViews.second
		self.thirdAttendeeLabel = attendeeInfoViews.third
		self.remaingAttendeeCountLabel = attendeeInfoViews.fourth
		self.locationLabel = uiLayoutHelper.addLocationLabel(inCell: self, alignLeftTo: self.titleLabel, below: self.firstAttendeeLabel)
	}

	final func updateWithUIData(uiData:CTAgendaViewRowUIData) {
		self.startTimeLabel.text = uiData.startTimeText
		self.eventDurationLabel.text = uiData.timeRangeText
		self.circleView.backgroundColor = uiData.calColor
		self.titleLabel.text = uiData.eventTitle
		self.locationLabel.text = !uiData.locationString.isEmpty ? "⚲ " + uiData.locationString : ""

		//hide first because cell is getting reused
		firstAttendeeLabel.isHidden = true
		secondAttendeeLabel.isHidden = true
		thirdAttendeeLabel.isHidden = true
		remaingAttendeeCountLabel.isHidden = true

		var attendees = uiData.attendeesInfo

		let firstAttendee = attendees[0]
		firstAttendeeLabel.isHidden = false
		firstAttendeeLabel.text = firstAttendee.name.first!.description
		firstAttendeeLabel.backgroundColor = firstAttendee.color
		attendees.remove(at: 0)

		if attendees.count > 0 {
			let secondAttendee = attendees[0]
			secondAttendeeLabel.isHidden = false
			secondAttendeeLabel.text = secondAttendee.name.first!.description
			secondAttendeeLabel.backgroundColor = secondAttendee.color
			attendees.remove(at: 0)
		}

		if attendees.count > 0 {
			let thirdAttendee = attendees[0]
			thirdAttendeeLabel.isHidden = false
			thirdAttendeeLabel.text = thirdAttendee.name.first!.description
			thirdAttendeeLabel.backgroundColor = thirdAttendee.color
			attendees.remove(at: 0)
		}

		if attendees.count > 0 {
			remaingAttendeeCountLabel.isHidden = false
			remaingAttendeeCountLabel.text = "+" + "\(attendees.count)"
		}

	}
    
}
