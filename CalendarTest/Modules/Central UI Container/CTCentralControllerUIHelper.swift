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
		let height = NSLayoutConstraint(item: topBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height + 65)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	func addTopBarAndCalendarViewSeparator() {
		let separator = UIView()
		separator.backgroundColor =  UIColor(red: 242/255, green: 244/255, blue: 242/255, alpha: 1.0)
		separator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(separator)

		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.topBar, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	func addAndLayoutCalendarView() {
		self.addChildViewController(calendarViewController)
		self.view.addSubview(calendarViewController.view)
		calendarViewController.didMove(toParentViewController: self)

		calendarViewController.view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: calendarViewController.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: calendarViewController.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: calendarViewController.view, attribute: .top, relatedBy: .equal, toItem: self.topBar, attribute: .bottom, multiplier: 1.0, constant: 1)
		let height = NSLayoutConstraint(item: calendarViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: calendarViewController.viewingMode.totalHeightNeeded)

		NSLayoutConstraint.activate([left, right, top, height])
		self.calendarViewHeightConstraint = height
	}

	func addCalAndAgendaViewSeparator() {
		let separator = UIView()
		separator.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 242/255, alpha: 1.0)
		separator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(separator)

		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.calendarViewController.view, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	func addAgendaView() {
		self.addChildViewController(agendaViewController)
		self.view.addSubview(agendaViewController.view)
		agendaViewController.didMove(toParentViewController: self)

		agendaViewController.view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: agendaViewController.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: agendaViewController.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: agendaViewController.view, attribute: .top, relatedBy: .equal, toItem: self.calendarViewController.view, attribute: .bottom, multiplier: 1.0, constant: 1)
		let bottom = NSLayoutConstraint(item: agendaViewController.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([left, right, top, bottom])
	}
}
