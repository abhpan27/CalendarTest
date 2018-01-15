//
//  CTAgendaViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 11/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

protocol CTAgendaViewControllerProtocol:NSObjectProtocol {
	func didDragAgendaView(agendaView:UITableView)
	func agendaViewScrolledToDate(date:Date)
}

class CTAgendaViewController: UIViewController {

	@IBOutlet weak var agendaTableView: UITableView!
	var scrollToTodayButton:UIButton!
	weak var delegate:CTAgendaViewControllerProtocol?
	let listUIHelper = CTAgendaListUIHelper()
	var isUserScrollingUP:Bool = false
	var lastContentOffSetOfAgendaView:CGFloat = 0
	var isLoadingEventsInAgendaView = false

    override func viewDidLoad() {
        super.viewDidLoad()
		listUIHelper.registerCells(inTableView: agendaTableView)
		loadEventForFirstLaunch()
    }

	private func checkScrollAndLoadMoreFutureOrPastEvents(scrollView:UIScrollView) {
		let scrollViewHeight = scrollView.frame.size.height
		let scrollContentSizeHeight = scrollView.contentSize.height
		let scrollOffset = scrollView.contentOffset.y
		let optimalGapValue = CGFloat(scrollContentSizeHeight/3)

		if (scrollOffset <= optimalGapValue && self.isUserScrollingUP) || (scrollOffset < 100) {
			//user is scrolling up and more past events needs to be loaded
			loadPastEventsInAgendaView()
		}else if (((scrollOffset+scrollViewHeight+optimalGapValue) > scrollContentSizeHeight) && !self.isUserScrollingUP) || (scrollContentSizeHeight - (scrollOffset+scrollViewHeight) < 100) {
			loadFutureEventsInAgendaView()
		}
	}

	final func scrollToDate(date:Date, animated:Bool) {
		guard let indexPathForToday = self.listUIHelper.indexPathForDate(date: date)
			else{
				return
		}

		mainQueueAsync {
			self.agendaTableView.scrollToRow(at: indexPathForToday, at: .top, animated: animated)
		}
	}

	private func loadPastEventsInAgendaView() {
		guard !isLoadingEventsInAgendaView
			else {
				return
		}

		let scrollView = self.agendaTableView!
		mainQueueAsync {
			self.isLoadingEventsInAgendaView = true
			let beforeReloadContentSize = scrollView.contentSize
			self.listUIHelper.loadPastUIData(completion: { (error) in
				guard error == nil
					else{
						self.isLoadingEventsInAgendaView = false
						return
				}

				self.agendaTableView.reloadData()
				let afterReloadContentSize = scrollView.contentSize
				let afterReloadContentOffset = self.agendaTableView.contentOffset
				let newOffset = CGPoint(x: afterReloadContentOffset.x, y: afterReloadContentOffset.y + afterReloadContentSize.height - beforeReloadContentSize.height)
				let currentDirection = self.isUserScrollingUP
				self.agendaTableView.contentOffset = newOffset
				self.isUserScrollingUP = currentDirection
				self.isLoadingEventsInAgendaView = false
			})
		}
	}

	private func loadEventForFirstLaunch() {
		listUIHelper.loadOnFirstLaunch { (error) in
			guard error == nil
				else{
					return
			}
			mainQueueAsync {
				self.agendaTableView.reloadData()
				self.scrollToDate(date:Date(), animated: false)
			}
		}
	}

	private func loadFutureEventsInAgendaView() {
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

}

//MARK: Scroll Delegate
extension CTAgendaViewController:UIScrollViewDelegate {

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.delegate?.didDragAgendaView(agendaView: self.agendaTableView)
		checkScrollAndLoadMoreFutureOrPastEvents(scrollView: scrollView)
	}

	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		checkScrollAndLoadMoreFutureOrPastEvents(scrollView: scrollView)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > self.lastContentOffSetOfAgendaView {
			isUserScrollingUP = false
		}else {
			isUserScrollingUP = true
		}
		lastContentOffSetOfAgendaView = scrollView.contentOffset.y

		mainQueueAsync {
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
