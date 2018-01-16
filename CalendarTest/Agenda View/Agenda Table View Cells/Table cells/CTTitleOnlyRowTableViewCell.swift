//
//  CTTitleOnlyRowTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTTitleOnlyRowTableViewCell: UITableViewCell {

	var startTimeLabel:UILabel!
	var circleView:UIView!
	var titleLabel:UILabel!

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTTitleOnlyRowTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		addCommonUIElements()
    }

	private func addCommonUIElements() {
		let uiLayoutHelper = CTAgendaViewCellCommonUIHelper()
		self.startTimeLabel = uiLayoutHelper.addStartTimeLable(inCell: self)
		self.circleView = uiLayoutHelper.addCalColorCircleView(inCell: self, centerAlignedWith: self.startTimeLabel!)
		self.titleLabel = uiLayoutHelper.addTitleLabel(inCell: self, centerAlignedWith: circleView!, inRightOf: circleView!)
	}

	final func updateWithUIData(uiData:CTAgendaViewRowUIData) {
		self.startTimeLabel.text = uiData.startTimeText
		self.circleView.backgroundColor = uiData.calColor
		self.titleLabel.text = uiData.eventTitle
	}
    
}
