//
//  CTAgendaViewCellCommonUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This class is a helper utility for adding subviews in cells of agenda table view. Some elements are common across all the cells so these logic for adding these elemets are kept at one place here.
*/
final class CTAgendaViewCellCommonUIHelper {

	/**
	Adds start time lable in cell.
	In X Direction --- (left of cell - 15pt gap - Label)
	In Y Direction --- (top of cell - 15pt gap - Label)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Returns: Start time label.
	*/
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


	/**
	Adds label to indicate that this is the first upcoming event today.
	In X Direction --- (left of cell - Label)
	In Y Direction --- (top of cell - 15pt gap - Label)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Returns: Start time label.
	*/
	func addFirstUpComingEventIndicator(inCell:UITableViewCell) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		label.text = "▶"
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: inCell, attribute: .left, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: inCell, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])

		return label
	}

	/**
	Adds event duration lable in cell.
	In X Direction --- (left align to start time label)
	In Y Direction --- (Bottom of start time label - 8pt gap - Label)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter below: Label below which this event duration label should be added.
	- Parameter leftAlignedTo: Label to which event duration label will be left aligned.
	- Returns: Event duration label.
	*/
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


	/**
	Adds circuler dot kind of view which will be used to show color of calendar of event.
	In X Direction --- (left of cell - 80pt gap)
	In Y Direction --- (Center align with start time label)
	width --- 12
	height --- 12

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter centerAlignedWith: Label to which this circuler view should be cnter aligned
	- Returns: Circuler view.
	*/
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
		//make it circuler
		circleView.layer.cornerRadius = circleView.frame.height / 2
		return circleView
	}


	/**
	Adds Label for title of event.
	In X Direction --- (right of circuler dot - 15pt gap - Label - 15pt gap - right of cell)
	In Y Direction --- (Center align with circuler dot view)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter centerAlignedWith: UIView to which this label should be center aligned.
	- Parameter inRightOf: UIView object in right of which this label will be added.
	- Returns: Title label.
	*/
	func addTitleLabel(inCell:UITableViewCell, centerAlignedWith:UIView, inRightOf:UIView) -> UILabel {
		let label = UILabel()
		inCell.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 17, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: inRightOf, attribute: .right, multiplier: 1.0, constant: 15)
		let centerAlignY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: centerAlignedWith, attribute: .centerY, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: inCell, attribute: .right, multiplier: 1.0, constant: -15)
		NSLayoutConstraint.activate([left, centerAlignY, right])

		return label
	}


	/**
	Adds Label for location of event. This label may not always be added.
	In X Direction --- (left of title of event label - Label - 15pt gap - right of cell)
	In Y Direction --- (bottom of title or attendees label - 8pt gap - label)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter alignLeftTo: Label to which this should be left aligned.
	- Parameter below: UIView below which this label should be added. This can be attendee label or title label
	- Returns: Location label.
	*/
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

	/**
	Adds Labels for attendees of event. There can be maximum four label. Three labels will show first three attendees and last label will show remaining attendee count.
	In X Direction --- (left of title of event label - first label - 5pt gap - second label - 5pt gap - third label - 5pt gap - fourth label)
	In Y Direction --- (title of event label - 8pt gap - Top of first label) (Center align all other labels to first label)

	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter alignLeftTo: Label to which this should be left aligned.
	- Parameter below: UIView below which this label should be added. This can be attendee label or title label
	- Returns: Tuple having first, second, third and fourth Label.
	*/
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

	/**
	This method returns A UIlabel object which is used to show color and First letter of name of attendee.
	- Parameter inCell: UITableViewCell object in which start time lable needs to added.
	- Parameter isForCount: Bool to show whether this lable will be used to show count or First letter of attendee name.
	- Returns: Attendee label. It can be for showing remaing also.
	*/
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
