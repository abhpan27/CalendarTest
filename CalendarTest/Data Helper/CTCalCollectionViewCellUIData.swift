//
//  CTCalCollectionViewCellUIData.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

final class CTCalCollectionViewCellUIData {

	let shouldDrawInGrey:Bool
	let dateEpoch:TimeInterval //this will be -1 for blank dates
	let dateNumberString:String // only date number i.e. 1,2, 30 etc
	let fullDateString:String // for start of month

	var isBlankDay:Bool {
		return self.fullDateString.isEmpty
	}

	init(dateEpoch:TimeInterval, shouldDrawInGrey:Bool) {
		self.dateEpoch = dateEpoch
		self.shouldDrawInGrey = shouldDrawInGrey

		//getting all the UI data here so that no need to calculate it at runtime thus smooth scroll will be achived
		if  dateEpoch != -1 {
			let date = Date(timeIntervalSince1970: dateEpoch)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "d"
			dateNumberString = dateFormatter.string(from: date)

			//full date string
			if date.isFirstDateOfMonth {
				if date.isInCurrentYear {
					dateFormatter.dateFormat = "d#MMM"
				}else {
					dateFormatter.dateFormat = "MMM#d#yyyy"
				}
			}else {
				dateFormatter.dateFormat = "d"
			}
			self.fullDateString = dateFormatter.string(from: date).replacingOccurrences(of: "#", with: "\n")
		}else {
			dateNumberString = ""
			fullDateString = ""
		}
	}
}
