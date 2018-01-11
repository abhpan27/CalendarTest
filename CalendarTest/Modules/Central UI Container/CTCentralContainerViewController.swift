//
//  CTCentralContainerViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCentralContainerViewController: UIViewController {

	let topBar:CTTopBarOnCentralView
	let calendarViewController:CTCalendarViewController
	let agendaViewController:CTAgendaViewController
	var calendarViewHeightConstraint:NSLayoutConstraint!

	init() {
		self.topBar = CTTopBarOnCentralView.loadTopBarView()
		self.calendarViewController = CTCalendarViewController()
		self.agendaViewController = CTAgendaViewController()
		super.init(nibName: "CTCentralContainerViewController", bundle: nil)
		self.calendarViewController.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		addAndLayoutViews()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func addAndLayoutViews() {
		addAndLayoutTopBar()
		addTopBarAndCalendarViewSeparator()
		addAndLayoutCalendarView()
		addCalAndAgendaViewSeparator()
		addAgendaView()
		self.view.layoutIfNeeded()
	}

}

extension CTCentralContainerViewController:CTCalendarViewControllerDelegate {
	
	func viewingModeDidChange(viewingMode:CalViewingMode) {
		self.calendarViewHeightConstraint.constant = viewingMode.totalHeightNeeded
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

	func didSelectedDate(date:Date) {
		Swift.print("Date selected in calendar view :\(date.logDate)")
		//update other parts of app
		self.topBar.updateMonthLabel(date: date)
	}

}

extension CTAgendaViewController:CTAgendaViewControllerProtocol {

}
