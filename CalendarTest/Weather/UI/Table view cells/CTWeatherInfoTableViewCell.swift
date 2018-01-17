//
//  CTWeatherInfoTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit


/**
This is UITableViewCell used by table view in weather view controller to show weather forcast.
*/
class CTWeatherInfoTableViewCell: UITableViewCell {

	/// Label to date for which forcasting is done
	var dateTextLabel:UILabel?

	/// Label to show weather forcast, which includes min/max temperature and weather condition
	var weatherInfoLabel:UILabel?


	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTWeatherInfoTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.addDateLabel()
		self.addWeatherInfoLabel()
		self.selectionStyle = .none
    }

	/**
	This method customizes reusable cell with UI Data for this cell.
	- Parameter withData: Row UI data object, which contains UI related information for each cell.
	*/
	func updateUI(withData:CTWeatherInfo) {
		self.dateTextLabel?.text = withData.dateText
		self.weatherInfoLabel?.text = withData.weatherConditionText + " (\(withData.lowestTemperature)°F / \(withData.highestTemperature)°F)"
	}

	/**
	This method adds UILabel to show date.
	Left of this label is 15Pt right of left of this cell.
	Top Of this label is 15pt below top of this cell
	*/
	private func addDateLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])
		self.dateTextLabel = label
	}

	/**
	This method adds UILabel to show weather condition.
	Left of this label is 25Pt right of right of date label.
	Top Of this label is 15pt below top of this cell
	*/
	private func addWeatherInfoLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.font = CTFont.systemFont(ofSize: 14, weight: .Regular)
		label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: dateTextLabel!, attribute: .right, multiplier: 1.0, constant: 25)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])
		self.weatherInfoLabel = label
	}
    
}
