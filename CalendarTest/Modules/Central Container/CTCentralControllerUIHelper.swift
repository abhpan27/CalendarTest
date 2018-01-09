//
//  CTCentralControllerUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

extension CTCentralContainerViewController {

	func addAndLayoutTopBar() {
		self.view.addSubview(topBar)
		topBar.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: topBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: topBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: topBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: topBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height + 55)
		NSLayoutConstraint.activate([left, right, top, height])
	}

	func addAndLayoutCalendarView() {
		self.addChildViewController(calendarViewController)
		self.view.addSubview(calendarViewController.view)
		calendarViewController.didMove(toParentViewController: self)

		calendarViewController.view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: calendarViewController.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: calendarViewController.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: calendarViewController.view, attribute: .top, relatedBy: .equal, toItem: self.topBar, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: calendarViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: calendarViewController.singleRowHeight * 5)
		NSLayoutConstraint.activate([left, right, top, height])
	}
}
