//
//  CTAgendaSectionHeader.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit


class CTAgendaSectionHeader: UITableViewHeaderFooterView {

	var customBackgroundView:UIView?
	var dateLabel:UILabel?

	static func registerHeader(tableView:UITableView, forReuseIdentifier:String) {
		tableView.register(UINib(nibName: "CTAgendaSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: forReuseIdentifier)
	}

	override func awakeFromNib() {
		addBackgroundContainer()
		addDateLabel()
	}

	private func addBackgroundContainer() {
		let customBackgroundView = UIView()
		self.backgroundView = customBackgroundView
		self.customBackgroundView = customBackgroundView
	}

	private func addDateLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.textColor = UIColor(red: 109/255, green: 107/255, blue: 115/255, alpha: 1.0)
		label.font = CTFont.systemFont(ofSize: 15, weight: .Regular)
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5)
		NSLayoutConstraint.activate([left, top])

		self.dateLabel = label
	}

}
