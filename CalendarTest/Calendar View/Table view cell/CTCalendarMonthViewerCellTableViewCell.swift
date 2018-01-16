//
//  CTCalendarMonthViewerCellTableViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is UITableViewCell used for Semi Transparent overlay table view above collection view
*/
class CTCalendarMonthViewerCellTableViewCell: UITableViewCell {

	///Outlet to label used to show month name
	@IBOutlet weak var monthNameLabel: UILabel!

	/**
	This is static method used to register cell for reusablity in tableview.
	-Parameter inTableView: Table view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
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
