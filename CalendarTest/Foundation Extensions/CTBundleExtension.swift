//
//  CTBundleExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

extension Bundle {

	static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
		if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
			return view
		}

		fatalError("Could not load view with type " + String(describing: type))
	}
}
