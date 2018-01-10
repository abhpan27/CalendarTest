//
//  CTCalendarMonthViewerCellTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCalendarMonthViewerCellTableViewCell: UITableViewCell {

	@IBOutlet weak var monthNameLabel: UILabel!

	static func registerCell(inTableView:UITableView, withIdentifier:String) {
		inTableView.register(UINib(nibName: "CTCalendarMonthViewerCellTableViewCell", bundle: nil), forCellReuseIdentifier: withIdentifier)
	}

	override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
		self.monthNameLabel.font = CTFont.systemFont(ofSize: 18, weight: .Bold)
		self.monthNameLabel.textColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)
    }

}
