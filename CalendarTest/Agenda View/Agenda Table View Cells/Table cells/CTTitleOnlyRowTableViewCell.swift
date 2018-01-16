//
//  CTTitleOnlyRowTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This cell is used to show event which has only title. No location and no attendees.
*/
class CTTitleOnlyRowTableViewCell: UITableViewCell {

	/// label used to show start time of event
	var startTimeLabel:UILabel!

	///circuler view used show calendar of color to which this event belongs
	var circleView:UIView!

	///Lable used to show title of event
	var titleLabel:UILabel!

	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTTitleOnlyRowTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		addCommonUIElements()
    }

	/**
	This method adds and layout subviews in this cell. It takes help from CTAgendaViewCellCommonUIHelper
	*/
	private func addCommonUIElements() {
		let uiLayoutHelper = CTAgendaViewCellCommonUIHelper()
		self.startTimeLabel = uiLayoutHelper.addStartTimeLable(inCell: self)
		self.circleView = uiLayoutHelper.addCalColorCircleView(inCell: self, centerAlignedWith: self.startTimeLabel!)
		self.titleLabel = uiLayoutHelper.addTitleLabel(inCell: self, centerAlignedWith: circleView!, inRightOf: circleView!)
	}

	/**
	This method customizes reusable cell with UI Data for this cell.
	- Parameter uiData: Row UI data object, which contains UI related information for each cell.
	*/
	final func updateWithUIData(uiData:CTAgendaViewRowUIData) {
		self.startTimeLabel.text = uiData.startTimeText
		self.circleView.backgroundColor = uiData.calColor
		self.titleLabel.text = uiData.eventTitle
	}
}
