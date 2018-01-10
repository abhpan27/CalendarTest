//
//  CTTopBarOnCentralView.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTTopBarOnCentralView: UIView {

	var monthLabel:UILabel?

	static func loadTopBarView() ->  CTTopBarOnCentralView {
		return Bundle.loadView(fromNib: "CTTopBarView", withType: CTTopBarOnCentralView.self)
	}

	override func awakeFromNib() {
		addMonthLabel()
		addWeekDayLabels()
		updateMonthLabel(date: Date())
		self.backgroundColor = UIColor(red: 0, green: 119/255, blue: 189/255, alpha: 1.0)
	}

	final func updateMonthLabel(date:Date) {
		let dateFormatter = DateFormatter()
		if date.isInCurrentYear {
			dateFormatter.dateFormat = "MMMM"
		}else {
			dateFormatter.dateFormat = "MMMM yyyy"
		}
		self.monthLabel?.text = dateFormatter.string(from: date)
	}

	private func addMonthLabel() {
		monthLabel = UILabel()
		monthLabel?.textColor = UIColor.white
		monthLabel?.font = CTFont.systemFont(ofSize: 22, weight: .Bold)
		monthLabel?.text = "January"
		monthLabel?.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(monthLabel!)
		let left = NSLayoutConstraint(item: monthLabel!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let bottom = NSLayoutConstraint(item: monthLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -25)
		NSLayoutConstraint.activate([left, bottom])
	}

	private func addWeekDayLabels() {
		let arrayOfWeekDayLabels = [getWeekLabel(withText: "SUN"), getWeekLabel(withText: "MON"), getWeekLabel(withText: "TUE"), getWeekLabel(withText: "WED"), getWeekLabel(withText: "THU"), getWeekLabel(withText: "FRI"), getWeekLabel(withText: "SAT")]

		var listOfConstraintsToAdd = [NSLayoutConstraint]()

		//add sunday left and saturday right constraints
		let sundayLabelLeft = NSLayoutConstraint(item: arrayOfWeekDayLabels.first!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
		let saturdayLabelRight = NSLayoutConstraint(item: arrayOfWeekDayLabels.last!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)

		listOfConstraintsToAdd.append(sundayLabelLeft)
		listOfConstraintsToAdd.append(saturdayLabelRight)

		//equal widths of every label
		for index in 1 ... arrayOfWeekDayLabels.count - 1 {
			let equalWidth = NSLayoutConstraint(item: arrayOfWeekDayLabels[index], attribute: .width, relatedBy: .equal, toItem: arrayOfWeekDayLabels.first!, attribute: .width, multiplier: 1.0, constant: 0)
			listOfConstraintsToAdd.append(equalWidth)
		}

		//attach right and left of labels
		var lastLabel = arrayOfWeekDayLabels.first!
		for index in 1 ... arrayOfWeekDayLabels.count - 1 {
			let currentItem = arrayOfWeekDayLabels[index]
			let leftOfCurrent = NSLayoutConstraint(item: currentItem, attribute: .left, relatedBy: .equal, toItem: lastLabel, attribute: .right, multiplier: 1.0, constant: 0)
			listOfConstraintsToAdd.append(leftOfCurrent)
			lastLabel = currentItem
		}

		//attach bottom of every label to view
		for index in 0 ... arrayOfWeekDayLabels.count - 1 {
			let bottom = NSLayoutConstraint(item: arrayOfWeekDayLabels[index], attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -3)
			listOfConstraintsToAdd.append(bottom)
		}

		NSLayoutConstraint.activate(listOfConstraintsToAdd)
	}

	private func getWeekLabel(withText:String) -> UILabel {
		let label = UILabel()
		label.textColor = UIColor.white
		label.font = CTFont.systemFont(ofSize: 11, weight: .Regular)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = withText
		self.addSubview(label)
		return label
	}

}
