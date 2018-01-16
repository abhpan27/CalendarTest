//
//  CTCalCollectionViewCellUIData.swift
//  CalendarTest
//
//  Created by Abhishek on 10/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
Enum for color of dots shown in each cell of collection view in calendar view
*/
internal enum CalendarViewCellEventAvailablityColor:Int8 {
	case clear = 1, lightGrey, mediumGrey, darkGrey

	var color:UIColor {
		switch self {
		case .clear:
			return UIColor.clear
		case .mediumGrey:
			return UIColor.gray.withAlphaComponent(0.5)
		case .lightGrey:
			return UIColor.gray.withAlphaComponent(0.2)
		case .darkGrey:
			return UIColor.gray
		}
	}
}

/**
For each cell of collection view one object of this class is created.
Effort is made to reduce memory requirement for objects of this class
Even if one object is loaded for each date in 10 year range then memory requirement will be -
10(year) * 12(months) * 4(weeks) * 7(days) * ( 1 Bool + 1 Double + 2 strings with 2 characters on avarage + 1 Int8) = 10 * 12 * 4 * 7 * (1 + 64 + 82 + 8 + some overhead ~= 200 bits) = 82.031KB, which is acceptable ammount of data to keep in memory.
So on intial launch of calendar view one object of this class is created for each date shown in collection view.
*/
final class CTCalCollectionViewCellUIData {

	///used in drawing alternet months in different colors. One month white - next month grey...so on
	let shouldDrawInGrey:Bool

	///Unix epcoh for date shown in current cell
	let dateEpoch:TimeInterval

	///Date only in number, used when date is selected
	let dateNumberString:String

	///Full date string, this is same as dateNumberString except for month start date
	let fullDateString:String

	///Color for dot shown in each cell, intially it is clear, later it is changed after querying core data
	var eventAvailabilityColor:Int8 = CalendarViewCellEventAvailablityColor.clear.rawValue

	///Is current object is for blank cell
	var isBlankDay:Bool {
		return dateEpoch == -1
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
			//for blank cell both strings are empty
			dateNumberString = ""
			fullDateString = ""
		}
	}
}
