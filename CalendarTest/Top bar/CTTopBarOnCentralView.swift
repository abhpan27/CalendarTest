//
//  CTTopBarOnCentralView.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is protocol used by top bar view to inform about any event in top bar.
*/
protocol CTTopBarDelegate:NSObjectProtocol {

	/**
	This method is called when user taps on weather button in top bar
	*/
	func didSelectedWeatherInfoButton()
}

/**
This a UIview which is drawn above calendar view.
It is currently being used for showing current selected Month, and weather info button.
*/
class CTTopBarOnCentralView: UIView {

	///UILabel used to show month name in top bar
	var monthLabel:UILabel?

	///CTTopBarDelegate used by top bar view to inform about any event
	weak var delegate:CTTopBarDelegate?

	/**
	This is a static function which loads UIView from XIB.
	*/
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

	/**
	Action handler for weather button.
	*/
	@objc func didSelectedWeatherInfoButton(sender: UIButton!) {
		delegate?.didSelectedWeatherInfoButton()
	}

	/**
	This method is used to update month name in top bar.

	- Parameter date: date for which month name should be shown.
	*/
	final func updateMonthLabel(date:Date) {
		let dateFormatter = DateFormatter()
		if date.isInCurrentYear {
			dateFormatter.dateFormat = "MMMM"
		}else {
			dateFormatter.dateFormat = "MMMM yyyy"
		}
		self.monthLabel?.text = date.monthName
	}

	/**
	This method is adds weather info button on right of top bar view.

	In X Direction --- (Button - right of cell)
	In Y Direction --- (top of cell - Button - bottom of cell)
	width = 100
	*/
	private func addWeatherInfoButton() {
		let weatherInfoButton = UIButton()
		weatherInfoButton.setTitle("☼", for: .normal)
		weatherInfoButton.titleLabel?.font = CTFont.systemFont(ofSize: 28, weight: .Bold)
		weatherInfoButton.setTitleColor(UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0), for: .normal)
		self.addSubview(weatherInfoButton)
		weatherInfoButton.addTarget(self, action: #selector(CTTopBarOnCentralView.didSelectedWeatherInfoButton(sender:)), for: .touchUpInside)
		weatherInfoButton.translatesAutoresizingMaskIntoConstraints = false

		let right = NSLayoutConstraint(item: weatherInfoButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: weatherInfoButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: weatherInfoButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
		let width = NSLayoutConstraint(item: weatherInfoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

		NSLayoutConstraint.activate([right, top, bottom, width])
	}


	/**
	This method adds month label in top bar view.

	In X Direction --- (center align with cell)
	In Y Direction --- (bottom of label - 33pt gap - bottom of cell)
	*/
	private func addMonthLabel() {
		monthLabel = UILabel()
		self.addSubview(monthLabel!)
		monthLabel?.textColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		monthLabel?.font = CTFont.systemFont(ofSize: 22, weight: .Medium)
		monthLabel?.text = "Month Name"
		monthLabel?.translatesAutoresizingMaskIntoConstraints = false

		let centerX = NSLayoutConstraint(item: monthLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: monthLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -33)

		NSLayoutConstraint.activate([centerX, bottom])
	}

	/**
	This method adds week day label (all 7) at bottom of top bar.

	In X Direction --- (left of cell - s - m - t - w - t - f - s - right of cell)
	In Y Direction --- (each label's bottom - 3pt gap - bottom of cell)
	each label is of equal width
	*/
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


	/**
	This method returns UILabel object which will be used for adding week names.

	In X Direction --- (left of cell - s - m - t - w - t - f - s - right of cell)
	In Y Direction --- (each label's bottom - 3pt gap - bottom of cell)
	each label is of equal width
	*/
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
