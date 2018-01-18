//
//  CTAgendaViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
Protocol used by agenda view controller to inform about different events.
*/
protocol CTAgendaViewControllerProtocol:NSObjectProtocol {
	/**
	called when user starts dragging(scrolling) agenda list view
	- Parameter agendaView: Table view which is being dragged.
	*/
	func didDragAgendaView(agendaView:UITableView)

	/**
	Called when top visible date changes in agenda view
	- Parameter date: Date which is currently visible on top of list.
	*/
	func agendaViewScrolledToDate(date:Date)
}


/**
This is agenda view controller. It shows events in choronological order in form of list. It uses UITableView to show this chronological list. It dynamically adds more rows at top or bottom as user scrolls the list.
*/
class CTAgendaViewController: UIViewController {

	/// Outlet to UITableView object. UITableView is added as subview in CTAgendaViewController.xib with top, bottom, left and right aligned with view of this controller. Also delegate and data source of this table view is set in XIB.
	@IBOutlet weak var agendaTableView: UITableView!

	/// CTAgendaListUIHelper Object which is used to fetch more events from DB and customize cells
	let listUIHelper = CTAgendaListUIHelper()

	///Bool to detect direction of scroll. Up or down
	var isUserScrollingUP:Bool = false

	///Used to store last content offset of table view, used to update isUserScrollingUP
	var lastContentOffSetOfAgendaView:CGFloat = 0

	/// Bool to show weather currently loading more events in list. This is used to avoid multiple unnecessary loads
	var isLoadingEventsInAgendaView = false

	/// Delgate object which will receive change of events from this agenda view.
	weak var delegate:CTAgendaViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.listUIHelper.registerCells(inTableView: agendaTableView)
		self.loadEventForFirstLaunch()
    }

	/**
	This method detects whether new events should be loaded in the Table view. If user is about to reach top of list then add more days on top, or if user is about to reach bottom of list then add more days at bottom.
	*/
	private func checkScrollAndLoadMoreFutureOrPastEvents() {
		let scrollViewHeight = self.agendaTableView.frame.size.height
		let scrollContentSizeHeight = self.agendaTableView.contentSize.height
		let scrollOffset = self.agendaTableView.contentOffset.y
		let optimalGapValue = CGFloat(scrollContentSizeHeight/3)

		if (scrollOffset <= optimalGapValue && self.isUserScrollingUP) {
			//user is scrolling up and now in top 1/3rd portion of list, it is good time to add more days on top
			self.loadPastEventsInAgendaView()
		}else if (((scrollOffset+scrollViewHeight+optimalGapValue) > scrollContentSizeHeight) && !self.isUserScrollingUP) {
			///user is scrolling down and now in bottom 1/3rd part of list. It is good time to add more days below list.
			self.loadFutureEventsInAgendaView()
		}
	}

	/**
	This is a helper utility, which scrolls to section with date.
	- Parameter date: Date to which table should scroll.
	- Parameter animated: Bool to show whether scroll should be animated or not.
	*/
	final func scrollToDate(date:Date, animated:Bool) {
		guard let indexPathForToday = self.listUIHelper.indexPathForDate(date: date)
			else{
				return
		}

		mainQueueAsync {
			self.agendaTableView.scrollToRow(at: indexPathForToday, at: .top, animated: animated)
		}
	}

	/**
	This method is used to load more days above currently displayed list of days. It takes help from listUIHelper to get new data and then adjusts UI to provide seemless scroll experience.
	*/
	private func loadPastEventsInAgendaView() {
		//if already some load is in progress then just return
		guard !isLoadingEventsInAgendaView
			else {
				return
		}

		let scrollView = self.agendaTableView!
		mainQueueAsync {
			self.isLoadingEventsInAgendaView = true
			//before loading new events get scroll view content size
			let beforeReloadContentSize = scrollView.contentSize
			self.listUIHelper.loadPastUIData(completion: { (error) in
				guard error == nil
					else{
						self.isLoadingEventsInAgendaView = false
						return
				}

				self.agendaTableView.reloadData()
				//reload done now adjust content offset, to avoid jump in table view
				//new offset should be (content offset after reload + (difference in content size after reload))
				let afterReloadContentSize = scrollView.contentSize
				let afterReloadContentOffset = self.agendaTableView.contentOffset
				let differenceInContentSizeAfterReload = afterReloadContentSize.height - beforeReloadContentSize.height
				//new offset calculation
				let newOffset = CGPoint(x: afterReloadContentOffset.x, y: afterReloadContentOffset.y + differenceInContentSizeAfterReload)
				let currentDirection = self.isUserScrollingUP
				self.agendaTableView.contentOffset = newOffset
				self.isUserScrollingUP = currentDirection
				self.isLoadingEventsInAgendaView = false
			})
		}
	}


	/**
	This method is used to load days on first launch of agenda view. It takes help from listUIHelper to get data from DB.
	*/
	private func loadEventForFirstLaunch() {
		self.listUIHelper.loadOnFirstLaunch { (error) in
			guard error == nil
				else{
					return
			}
			mainQueueAsync {
				self.agendaTableView.reloadData()
				self.scrollToDate(date:Date(), animated: false)
				//start timer which will check and show first upcoming event today
				self.startTimerForUpdatingFirstUpcomingEventToday()
			}
		}
	}


	/**
	This method is used to load more days below currently displayed list of days in Table view. Note that here content offset adjustment is not needed as tableview it self manages content offset if rows are added at bottom
	*/
	private func loadFutureEventsInAgendaView() {
		//if already loading just return
		guard !isLoadingEventsInAgendaView
			else {
				return
		}

		mainQueueAsync {
			self.isLoadingEventsInAgendaView = true
			self.listUIHelper.loadFutureUIData(completion: { (error) in
				guard error == nil
					else {
						self.isLoadingEventsInAgendaView = false
						return
				}

				self.agendaTableView.reloadData()
				self.isLoadingEventsInAgendaView = false
			})
		}
	}

	/**
	This method is used to load day in table view which is selected in Calendar view. It is possible that user selects some date in calendar view which is not yet loaded in agenda view, then this method helps to load that date in agenda view.
	*/
	final func loadEventsForSelectionInCalendar(selectedDate:Date) {
		self.isLoadingEventsInAgendaView = true
		self.listUIHelper.loadDataForDateSelectionInCalendar(selectedDateInCalendar: selectedDate) {
			(error, datePassedInLastCall)
			in
			guard  datePassedInLastCall == selectedDate
				else{
					return
			}

			mainQueueAsync {
				self.scrollToDate(date: datePassedInLastCall, animated: false)
				self.agendaTableView.reloadData()
				self.isLoadingEventsInAgendaView = false
			}
		}
	}

	/**
	This method detects top visible date and informs delegate about date change. This method is triggering change of date in calendar view and change of month name on top bar
	*/
	private func checkAndUpDateTopVisibleSectionDate() {
		guard let visibleIndexPath = self.agendaTableView.indexPathsForVisibleRows, visibleIndexPath.count > 0
			else {
				return
		}

		guard let date = self.listUIHelper.dateForIndexPath(indexPath: visibleIndexPath[0])
			else{
				return
		}

		self.delegate?.agendaViewScrolledToDate(date: date)
	}


	/**
	This Method updates first upcoming event from list of events today and reloads today's section
	*/
	@objc private func checkAndShowFirstUpComingEventToday() {
		guard let todaySectionIndexPath = self.listUIHelper.indexPathForDate(date: Date())
			else{
				return
		}

		self.listUIHelper.updateFirstUpcomingEventForToday()

		//only today's date section needs to be reloaded
		self.agendaTableView.reloadRows(at: [todaySectionIndexPath], with: .none)
	}

	/**
	This Method shows arrow indicator in row for first upcoming event today. And also schedules one time to update first upcoming event row.
	*/
	private func startTimerForUpdatingFirstUpcomingEventToday() {
		//show for first time
		checkAndShowFirstUpComingEventToday()
		
		//update every 5*60 seconds, assuming that event durations are usually more than 5 mins
		Timer.scheduledTimer(timeInterval: 5*60, target: self, selector: #selector(CTAgendaViewController.checkAndShowFirstUpComingEventToday), userInfo: nil, repeats: true)
	}

}

//MARK: Scroll Delegate
extension CTAgendaViewController:UIScrollViewDelegate {

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		//inform delegate that user started dragging table view
		self.delegate?.didDragAgendaView(agendaView: self.agendaTableView)
		//also see if more events needs to loaded in list
		self.checkScrollAndLoadMoreFutureOrPastEvents()
	}

	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		self.checkScrollAndLoadMoreFutureOrPastEvents()
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > self.lastContentOffSetOfAgendaView {
			isUserScrollingUP = false
		}else {
			isUserScrollingUP = true
		}
		self.lastContentOffSetOfAgendaView = scrollView.contentOffset.y

		mainQueueAsync {
			//update date selected in calendar and in month name shown on top bar
			self.checkAndUpDateTopVisibleSectionDate()
		}

	}
}

//MARK:Table view delegates
extension CTAgendaViewController:UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.listUIHelper.numberOfSections()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.listUIHelper.numberOfRowsInSection(section: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.listUIHelper.cellForRow(indexPath: indexPath, inTableView: tableView)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.listUIHelper.heightForRow(atIndexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.listUIHelper.sectionHeaderFor(forSection: section, inTabelView: tableView)
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
}
