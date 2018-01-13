//
//  CTTopBarOnCentralView.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

protocol CTTopBarDelegate:NSObjectProtocol {
	func didSelectedWeatherInfoButton()
}

class CTTopBarOnCentralView: UIView {

	var monthLabel:UILabel?
	weak var delegate:CTTopBarDelegate?

	static func loadTopBarView() ->  CTTopBarOnCentralView {
		return Bundle.loadView(fromNib: "CTTopBarView", withType: CTTopBarOnCentralView.self)
	}

	override func awakeFromNib() {
		addMonthLabel()
		addWeekDayLabels()
		addWeatherInfoButton()
		updateMonthLabel(date: Date())
		self.backgroundColor = UIColor.white
	}

	@objc func didSelectedWeatherInfoButton(sender: UIButton!) {
		delegate?.didSelectedWeatherInfoButton()
	}

	final func updateMonthLabel(date:Date) {
		let dateFormatter = DateFormatter()
		if date.isInCurrentYear {
			dateFormatter.dateFormat = "MMMM"
		}else {
			dateFormatter.dateFormat = "MMMM yyyy"
		}
		self.monthLabel?.text = date.monthName
	}

	private func addWeatherInfoButton() {
		let weatherInfoButton = UIButton()
		weatherInfoButton.setTitle("☼", for: .normal)
		weatherInfoButton.titleLabel?.font = CTFont.systemFont(ofSize: 28, weight: .Bold)
		weatherInfoButton.setTitleColor(UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0), for: .normal)
		self.addSubview(weatherInfoButton)
		weatherInfoButton.translatesAutoresizingMaskIntoConstraints = false
		weatherInfoButton.addTarget(self, action: #selector(CTTopBarOnCentralView.didSelectedWeatherInfoButton(sender:)), for: .touchUpInside)

		let right = NSLayoutConstraint(item: weatherInfoButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: weatherInfoButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: weatherInfoButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
		let width = NSLayoutConstraint(item: weatherInfoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
		NSLayoutConstraint.activate([right, top, bottom, width])

	}

	private func addMonthLabel() {
		monthLabel = UILabel()
		monthLabel?.textColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		monthLabel?.font = CTFont.systemFont(ofSize: 22, weight: .Medium)
		monthLabel?.text = "January"
		monthLabel?.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(monthLabel!)
		let centerX = NSLayoutConstraint(item: monthLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: monthLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -33)
		NSLayoutConstraint.activate([centerX, bottom])
	}

	private func addWeekDayLabels() {
		let arrayOfWeekDayLabels = [getWeekLabel(withText: "S"), getWeekLabel(withText: "M"), getWeekLabel(withText: "T"), getWeekLabel(withText: "W"), getWeekLabel(withText: "T"), getWeekLabel(withText: "F"), getWeekLabel(withText: "S")]

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
		label.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = withText
		self.addSubview(label)
		return label
	}

}
