//
//  CTBundleExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
Bundle extension having convenient method for operation on app bundle.
*/
extension Bundle {

	/**
	This is a static method to load UIView class from Nib.

	- Parameter fromNib: Xib name from which UIView needs to be loaded..
	- Parameter withType: Class type of UIVIew.
	- Returns: First View in XIB with class type as withType. If no view found with type then returns nil
	*/
	static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
		if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
			return view
		}

		fatalError("Could not load view with type " + String(describing: type))
	}
}
