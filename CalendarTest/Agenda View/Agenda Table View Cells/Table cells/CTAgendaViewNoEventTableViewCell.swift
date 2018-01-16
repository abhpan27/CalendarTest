//
//  CTAgendaViewNoEventCellTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This cell is used to show no event row. For some dates there may be no event then this cell will be used.
*/
class CTAgendaViewNoEventTableViewCell: UITableViewCell {

	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTAgendaViewNoEventTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
        addNoEventLabel()
    }

	/**
	Adds No event lable in cell.
	In X Direction --- (left of cell - 15pt gap - Label)
	In Y Direction --- (top of cell - 12pt gap - Label)
	*/
	private func addNoEventLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.textColor = UIColor(red: 119/255, green: 128/255, blue: 136/255, alpha: 1.0)
		label.font = CTFont.systemFont(ofSize: 13, weight: .Regular)
		label.text = "No Event"
		label.translatesAutoresizingMaskIntoConstraints = false

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12)
		NSLayoutConstraint.activate([left, top])
	}
}
