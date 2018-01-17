//
//  CTCentralContainerViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This class is container of top bar, calendar view and agenda view.
Top bar shows current month name selected in app.
Calendar view is grid style calendar which scrolls vertically.
Agenda view is chronological list of dates which scrolls vertically.
*/
class CTCentralContainerViewController: UIViewController {

	///top bar view. shows month name and weather button.
	let topBar:CTTopBarOnCentralView

	///Calendar view controller, creates grid like dates.
	let calendarViewController:CTCalendarViewController

	///Agenda view controller, shows list on events in chronological order.
	let agendaViewController:CTAgendaViewController

	///height constraint of calendar view. It is used to expand and shrink calendar view.
	var calendarViewHeightConstraint:NSLayoutConstraint!

	init() {
		self.topBar = CTTopBarOnCentralView.loadTopBarView()
		self.calendarViewController = CTCalendarViewController()
		self.agendaViewController = CTAgendaViewController()
		super.init(nibName: "CTCentralContainerViewController", bundle: nil)
		//set delegate of each part of UI. Using these delegates agenda view, top bar and calendar view inform about some event.
		self.calendarViewController.delegate = self
		self.agendaViewController.delegate = self
		self.topBar.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.addAndLayoutViews()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	/**
	This method is responsible for adding views and adding constraints for these views.
	*/
	private func addAndLayoutViews() {
		self.addAndLayoutTopBar()
		self.addTopBarAndCalendarViewSeparator()
		self.addAndLayoutCalendarView()
		self.addCalAndAgendaViewSeparator()
		self.addAgendaView()
		self.view.layoutIfNeeded()
	}

}

//MARK:Calendar view delegate
/**
Implementation of Calendar view delegate. It handles different events from calendar view
*/
extension CTCentralContainerViewController:CTCalendarViewControllerDelegate {

	/**
	This is called when viewing mode of calendar view changes. On reciving this event, calendar view is expanded to five row height or shrinked to two row height.
	- Parameter viewingMode: Which viewing mode to use, five rows or two rows.
	*/
	func viewingModeDidChange(viewingMode:CalViewingMode) {
		self.calendarViewHeightConstraint.constant = viewingMode.totalHeightNeeded
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

	/**
	This is called when some date is selected in Calendar view. On reciving this event, agenda view and top bar view are informed about date change.
	- Parameter date: Selected date in calendar view.
	*/
	func didSelectedDate(date:Date) {
		//update other parts of app
		self.topBar.updateMonthLabel(date: date)
		self.agendaViewController.loadEventsForSelectionInCalendar(selectedDate: date)
	}
}


//MARK:Agenda view delegate
/**
Implementation of agenda view delegate.
*/
extension CTCentralContainerViewController:CTAgendaViewControllerProtocol {

	/**
	This is called when user starts dragging(scrolling) agenda view. On this event, calendar view shrinks to two row height.
	- Parameter agendaView: Agenda table view.
	*/
	func didDragAgendaView(agendaView:UITableView) {
		self.calendarViewController.viewingMode = .twoRows
	}

	/**
	This is called when agenda view scrolls to some date (when top visibile date changes).
	- Parameter date: Top visible date.
	*/
	func agendaViewScrolledToDate(date:Date) {
		self.topBar.updateMonthLabel(date: date)
		if calendarViewController.viewingMode == .twoRows {
			self.calendarViewController.selectDate(date: date, animated: false)
		}
	}
}


//MARK:Top bar view delegate
/**
Implementation of top bar view delegate.
*/
extension CTCentralContainerViewController:CTTopBarDelegate {

	/**
	This is called when user taps on weather button in top bar. On this event just present weather view controller
	*/
	func didSelectedWeatherInfoButton() {
		let weatherInfoController = CTWeatherInfoViewController()
		self.present(weatherInfoController, animated: true, completion: nil)
	}

}
