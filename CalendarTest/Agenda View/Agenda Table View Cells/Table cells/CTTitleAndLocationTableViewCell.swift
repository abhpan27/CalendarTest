//
//  CTTitleAndLocationTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTTitleAndLocationTableViewCell: UITableViewCell {

	var startTimeLabel:UILabel!
	var eventDurationLabel:UILabel!
	var circleView:UIView!
	var titleLabel:UILabel!
	var locationLabel:UILabel!

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTTitleAndLocationTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
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
		self.locationLabel = uiLayoutHelper.addLocationLabel(inCell: self, alignLeftTo: self.titleLabel, below: self.titleLabel)
	}

	final func updateWithUIData(uiData:CTAgendaViewRowUIData) {
		self.startTimeLabel.text = uiData.startTimeText
		self.eventDurationLabel.text = uiData.timeRangeText
		self.circleView.backgroundColor = uiData.calColor
		self.titleLabel.text = uiData.eventTitle
		self.locationLabel.text = "⚲ " + uiData.locationString
	}
    
}
