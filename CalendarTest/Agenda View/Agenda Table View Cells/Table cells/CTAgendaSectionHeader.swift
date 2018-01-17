//
//  CTAgendaSectionHeader.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is section header view which is used to show dates in agenda view.
Also see CTAgendaSectionHeader.xib
*/
class CTAgendaSectionHeader: UITableViewHeaderFooterView {

	/// it is top, bottom, right, left aligned with section header. Used to set background color.
	var customBackgroundView:UIView?

	/// Used to show date for section.
	var dateLabel:UILabel?

	/**
	This is static method used to register section header for reusablity in tableview.
	 -Parameter tableView: Table view in which this section header view should be registered.
	 -Parameter forReuseIdentifier: Identifier which should be used in registering this view for reusability.
	*/
	static func registerHeader(tableView:UITableView, forReuseIdentifier:String) {
		tableView.register(UINib(nibName: "CTAgendaSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: forReuseIdentifier)
	}

	override func awakeFromNib() {
		self.addBackgroundContainer()
		self.addDateLabel()
	}

	/**
	This method changes background view to our own custom background. It will used to set background color of section header
	*/
	private func addBackgroundContainer() {
		let customBackgroundView = UIView()
		self.backgroundView = customBackgroundView
		self.customBackgroundView = customBackgroundView
	}

	/**
	Adds Date lable in section header. It will be used to set date for section.
	In X Direction --- (left of section header - 15pt gap - Label)
	In Y Direction --- (top of cell - 5pt gap - Label)
	*/
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
