//
//  CTAgendaViewNoEventCellTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTAgendaViewNoEventTableViewCell: UITableViewCell {

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTAgendaViewNoEventTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
        addNoEventLabel()
    }

	private func addNoEventLabel() {
		let label = UILabel()
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(red: 119/255, green: 128/255, blue: 136/255, alpha: 1.0)
		label.font = CTFont.systemFont(ofSize: 13, weight: .Regular)
		label.text = "No Event"

		let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
		let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12)
		NSLayoutConstraint.activate([left, top])
	}

}
