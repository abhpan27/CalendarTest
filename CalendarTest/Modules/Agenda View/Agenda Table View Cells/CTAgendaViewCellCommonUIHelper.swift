//
//  CTAgendaViewCellCommonUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

final class CTAgendaViewCellCommonUIHelper {

	func addStartTimeLable(inCell:UITableViewCell) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: inCell, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: inCell, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])

		return label
	}

	func addEventDurationLabel(inCell:UITableViewCell, below:UILabel, leftAlignedTo:UILabel) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 12, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: leftAlignedTo, attribute: .left, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		NSLayoutConstraint.activate([left, top])

		return label
	}

	func addCalColorCircleView(inCell:UITableViewCell, centerAlignedWith:UILabel) -> UIView {
		let circleView = UIView()
		inCell.addSubview(circleView)
		circleView.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: circleView, attribute: .left, relatedBy: .equal, toItem: inCell, attribute: .left, multiplier: 1.0, constant: 80)
		let centerAlignY = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: centerAlignedWith, attribute: .centerY, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
		let width = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
		NSLayoutConstraint.activate([left, centerAlignY, height, width])

		circleView.layoutIfNeeded()
		circleView.layer.cornerRadius = circleView.frame.height / 2
		return circleView
	}


	func addTitleLabel(inCell:UITableViewCell, centerAlignedWith:UIView, leftAlignWith:UIView) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 17, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: leftAlignWith, attribute: .right, multiplier: 1.0, constant: 15)
		let centerAlignY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: centerAlignedWith, attribute: .centerY, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: inCell, attribute: .right, multiplier: 1.0, constant: -15)
		NSLayoutConstraint.activate([left, centerAlignY, right])

		return label
	}

	func addLocationLabel(inCell:UITableViewCell, alignLeftTo:UILabel, below:UIView) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: alignLeftTo, attribute: .left, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: inCell, attribute: .right, multiplier: 1.0, constant: -15)
		NSLayoutConstraint.activate([left, top, right])

		return label
	}

	func addAttendeesLabels(inCell:UITableViewCell, alignLeftTo:UILabel, below:UIView) -> (first:UILabel, second:UILabel, third:UILabel, fourth:UILabel) {
		let firstLabel = labelForAttendees(incell: inCell, isForCount: false)
		let secondLabel = labelForAttendees(incell: inCell, isForCount: false)
		let thirdLabel = labelForAttendees(incell: inCell, isForCount: false)
		let fourthLabel = labelForAttendees(incell: inCell, isForCount: true)

		let leftOfFirst = NSLayoutConstraint(item: firstLabel, attribute: .left, relatedBy: .equal, toItem: alignLeftTo, attribute: .left, multiplier: 1.0, constant: 0)
		let leftOfSecond = NSLayoutConstraint(item: secondLabel, attribute: .left, relatedBy: .equal, toItem: firstLabel, attribute: .right, multiplier: 1.0, constant: 5)
		let leftOfThird = NSLayoutConstraint(item: thirdLabel, attribute: .left, relatedBy: .equal, toItem: secondLabel, attribute: .right, multiplier: 1.0, constant: 5)
		let leftOfFourth = NSLayoutConstraint(item: fourthLabel, attribute: .left, relatedBy: .equal, toItem: thirdLabel, attribute: .right, multiplier: 1.0, constant: 5)

		let topOfFirst = NSLayoutConstraint(item: firstLabel, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 8)
		let centerYSecond = NSLayoutConstraint(item: secondLabel, attribute: .centerY, relatedBy: .equal, toItem: firstLabel, attribute: .centerY, multiplier: 1.0, constant: 0)
		let centerYThird = NSLayoutConstraint(item: thirdLabel, attribute: .centerY, relatedBy: .equal, toItem: firstLabel, attribute: .centerY, multiplier: 1.0, constant: 0)
		let centerYFourth = NSLayoutConstraint(item: fourthLabel, attribute: .centerY, relatedBy: .equal, toItem: firstLabel, attribute: .centerY, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([leftOfFirst, leftOfSecond, leftOfThird, leftOfFourth, topOfFirst, centerYSecond, centerYThird, centerYFourth])
		return (firstLabel, secondLabel, thirdLabel, fourthLabel)

	}

	private func labelForAttendees(incell:UITableViewCell, isForCount:Bool) -> UILabel {
		let label = UILabel()
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = isForCount ? UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0) : UIColor.white
		incell.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false

		let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 34)
		let height = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 34)
		NSLayoutConstraint.activate([width, height])

		label.layer.cornerRadius = 17
		label.layer.borderWidth = isForCount ? 1 : 0
		label.layer.borderColor = isForCount ?  UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0).cgColor : UIColor.clear.cgColor
		label.textAlignment = .center
		label.layer.masksToBounds = true
		return label
	}
}
