//
//  CTWeatherInfoTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 13/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTWeatherInfoTableViewCell: UITableViewCell {

	var dateTextLabel:UILabel?
	var weatherInfoLabel:UILabel?

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTWeatherInfoTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		addDateLabel()
		addWeatherInfoLabel()
		self.selectionStyle = .none
    }

	func updateUI(withData:CTWeatherInfo) {
		self.dateTextLabel?.text = withData.dateText
		self.weatherInfoLabel?.text = withData.weatherConditionText + " (\(withData.lowestTemperature)°F / \(withData.highestTemperature)°F)"
	}

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
