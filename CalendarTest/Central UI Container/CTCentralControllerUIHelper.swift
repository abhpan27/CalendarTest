//
//  CTCentralControllerUIHelper.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is an extension of CTCentralContainerViewController. View layout related code is added here.
Complete struture (vertically)
	|Top bar view|
		|
	|1px Separator|
		|
	|Calendar View|
		|
	|1px Seprator|
		|
	|Agenda View|
*/
extension CTCentralContainerViewController {

	/**
	This method adds top bar. Top bar holds month name and weather button.
	*/
	func addAndLayoutTopBar() {
		self.view.addSubview(topBar)
		topBar.translatesAutoresizingMaskIntoConstraints = false

		/*
		left and right and top align to central container.
		height = status bar frame height + 65 -- status bar frame height will ensure that it will not clip in iPhone X.
		*/
		let left = NSLayoutConstraint(item: topBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: topBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: topBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: topBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height + 65)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	/**
	This methods adds 1px separator line between top bar and calendar view.
	*/
	func addTopBarAndCalendarViewSeparator() {
		let separator = UIView()
		self.view.addSubview(separator)
		separator.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 242/255, alpha: 1.0)
		separator.translatesAutoresizingMaskIntoConstraints = false

		/*
		left and right align to central container.
		top align to bottom of top bar view.
		height = 1pt
		*/
		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.topBar, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	/**
	This methods adds Calendar view below top bar.
	*/
	func addAndLayoutCalendarView() {
		self.addChildViewController(self.calendarViewController)
		self.view.addSubview(self.calendarViewController.view)
		self.calendarViewController.didMove(toParentViewController: self)
		self.calendarViewController.view.translatesAutoresizingMaskIntoConstraints = false

		/*
		left and right align to central container.

		topbar View
			|
		 1Pt gap
			|
		Calendar view

		height is kept according to viewing mode of calendar, ie for two row mode 2*row height and for five row mode 5*row height
		*/
		let left = NSLayoutConstraint(item: self.calendarViewController.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: self.calendarViewController.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: self.calendarViewController.view, attribute: .top, relatedBy: .equal, toItem: self.topBar, attribute: .bottom, multiplier: 1.0, constant: 1)
		let height = NSLayoutConstraint(item: self.calendarViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.calendarViewController.viewingMode.totalHeightNeeded)

		NSLayoutConstraint.activate([left, right, top, height])
		//also keep reference to height constraint. It will be used to change viweing mode from five rows to two rows and vice versa
		self.calendarViewHeightConstraint = height
	}


	/**
	This methods adds separator line between calendar view and agenda view.
	*/
	func addCalAndAgendaViewSeparator() {
		let separator = UIView()
		self.view.addSubview(separator)
		separator.backgroundColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.5)
		separator.translatesAutoresizingMaskIntoConstraints = false

		/*
		left and right and top align to central container.
		top align to bottom of calendar view.
		height = 1pt
		*/
		let left = NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self.calendarViewController.view, attribute: .bottom, multiplier: 1.0, constant: 0)
		let height = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)

		NSLayoutConstraint.activate([left, right, top, height])
	}

	/**
	This methods adds agenda view below calendar view
	*/
	func addAgendaView() {
		self.addChildViewController(self.agendaViewController)
		self.view.addSubview(self.agendaViewController.view)
		self.agendaViewController.didMove(toParentViewController: self)
		self.agendaViewController.view.translatesAutoresizingMaskIntoConstraints = false

		/*
		left, right and bottom align to central container.

		Calendar View
			|
		1Pt gap
			|
		Agenda view
		*/
		let left = NSLayoutConstraint(item: self.agendaViewController.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
		let right = NSLayoutConstraint(item: self.agendaViewController.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
		let top = NSLayoutConstraint(item: self.agendaViewController.view, attribute: .top, relatedBy: .equal, toItem: self.calendarViewController.view, attribute: .bottom, multiplier: 1.0, constant: 1)
		let bottom = NSLayoutConstraint(item: self.agendaViewController.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)

		NSLayoutConstraint.activate([left, right, top, bottom])
	}
}
