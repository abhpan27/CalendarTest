//
//  CTTitleOnlyRowTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTTitleOnlyRowTableViewCell: UITableViewCell {

	var startTimeLabel:UILabel?
	var circleView:UIView?
	var titleLabel:UILabel?

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTTitleOnlyRowTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		addUIElements()
    }

	private func addUIElements() {
		addStartTimeLabel()
		addCalendarColorCircle()
		addTitleLabel()
	}

	private func addStartTimeLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "All Day"

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])

		self.startTimeLabel = label
	}

	private func addCalendarColorCircle() {
		let circleView = UIView()
		self.addSubview(circleView)
		circleView.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: circleView, attribute: .left, relatedBy: .equal, toItem: startTimeLabel!, attribute: .right, multiplier: 1.0, constant: 25)
		let topAlign = NSLayoutConstraint(item: circleView, attribute: .top, relatedBy: .equal, toItem: startTimeLabel!, attribute: .top, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
		let width = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
		NSLayoutConstraint.activate([left, topAlign, height, width])

		circleView.layoutIfNeeded()
		circleView.layer.cornerRadius = circleView.frame.height / 2
		self.circleView = circleView
	}

	private func addTitleLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self.circleView!, attribute: .right, multiplier: 1.0, constant: 25)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: circleView!, attribute: .top, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -15)
		NSLayoutConstraint.activate([left, top, right])
		self.titleLabel = label
	}
    
}
