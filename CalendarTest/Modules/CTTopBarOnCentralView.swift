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

	override func awakeFromNib() {

	}

	private func addMonthLabel() {
		monthLabel = UILabel()
		monthLabel?.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: monthLabel!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: monthLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 15)
		NSLayoutConstraint.activate([left, top])
	}

}
