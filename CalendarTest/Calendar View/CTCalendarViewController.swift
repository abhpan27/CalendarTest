//
//  CTCalendarViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
Protocol methods for Calendar view controller
*/
protocol CTCalendarViewControllerDelegate:NSObjectProtocol {

	/**
	This method is called when viewing mode of calendar view is changes.

	- Parameter viewingMode: Enum represnting current viewing mode.
	*/
	func viewingModeDidChange(viewingMode:CalViewingMode)

	/**
	This method is called when any date is selected in calendar view.

	- Parameter date: Selected date in Calendar view.
	*/
	func didSelectedDate(date:Date)
}

/**
This Enum represents number of rows used by calendar view.
*/
internal enum CalViewingMode {

	///Calendar view is drawn in two row height
	case twoRows

	///Calendar view is drawn in five row height
	case fiveRows

	///Total height that will be needed by calendar view for viewing mode
	var totalHeightNeeded:CGFloat {
		let singleRowHeight = self.heightNeededForSingleRow
		switch self {
		case .twoRows:
			return 2*singleRowHeight
		case .fiveRows:
			return 5*singleRowHeight
		}
	}

	///Height of single row of calendar view.
	var heightNeededForSingleRow:CGFloat {
		return 55
	}
}


/**
This is Calendar view controller.
It has two subviews - One collection view and one Tableview
Table view is semi transparent which becomes visible only when user is scrolling calendar view.
Collection view is top, bottom, right, left aligned with view of this controller.
Table view is also top, bottom, right, left aligned with view of this controller.
Table view is added above collection view. It's semi transparency gives overlay kind of effect.
See CTCalendarViewController.XIB
*/
final class CTCalendarViewController: UIViewController {

	///Outlet to semi transparent overlay table view above collection view.
	@IBOutlet weak var monthViewerTableView: UITableView!

	///Outlet to Collection view. Each cell represents one date. Each row is one section.
	@IBOutlet weak var calCollectionView: UICollectionView!

	///Data helper class to get Minimal UI data and also event availabilty status from core data.
	let calendarViewUIDataHelper:CTCalViewDataHelper

	///Delegate used to inform about events in calendar view
	weak var delegate:CTCalendarViewControllerDelegate?


	///viewingMode to show number of rows used by calendar view currently.
	var viewingMode:CalViewingMode = .fiveRows {
		didSet {
			if oldValue != viewingMode {
				if viewingMode == .twoRows {
					//stop scrolling animation to avoid jerk.
					self.stopScrolling()
				}
				//inform delegate about viewing mode change
				self.delegate?.viewingModeDidChange(viewingMode: viewingMode)
			}
		}
	}
	
	init() {
		self.calendarViewUIDataHelper = CTCalViewDataHelper()
		super.init(nibName: "CTCalendarViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		//load minimal UI data neede for drawing collection view and table view.
		self.calendarViewUIDataHelper.loadBaicUIdata()
		CTCalDayViewCellCollectionViewCell.registerCell(collectionView: calCollectionView, withIdentifier: "CTCalDayViewCellCollectionViewCell")
		self.setUpBasicTableUI()
		//select current date after some delay so that current drawing of cells is completed
		delayedRunInMainQueue(0.1) {
			self.selectDate(date: Date(), animated: false)
			//once basic UI is visible, it's time to query core data and load event availabilty dots of cells
			self.loadEventAvailabilityInBgThread()
		}
    }


	/**
	This method starts loading of color of dot for each cell. It takes help from calendarViewUIDataHelper
	*/
	private func loadEventAvailabilityInBgThread() {
		self.calendarViewUIDataHelper.loadEventAvailabiltyForShowingDots {
			[weak self]
			in
			guard let blockSelf = self
				else {
					return
			}
			//Event availability data loaded from core data, reload collection view to show dots in cell.
			blockSelf.reloadCollectionViewKeepingSelection()
		}
	}

	/**
	This method sets up basic UI of semi transparent overlay table view added above collection view.
	*/
	private func setUpBasicTableUI() {
		CTCalendarMonthViewerCellTableViewCell.registerCell(inTableView: self.monthViewerTableView, withIdentifier: "CTCalendarMonthViewerCellTableViewCell")
		self.monthViewerTableView.backgroundColor = UIColor.clear
		self.monthViewerTableView.layoutIfNeeded()
		self.monthViewerTableView.isHidden = true
	}

	/**
	This method is used to hide or show semi transparent overlay table view added above collection view.

	- Parameter shouldShow: Bool used to show or hide table view.
	- Parameter animated: Bool used to check if showing hiding of table view should be animated.
	*/
	fileprivate func hideOrShowMonthTableViewWithAnimation(shouldShow:Bool, animated:Bool) {
		if animated {
			UIView.animate(withDuration: 0.2, animations: {
				self.monthViewerTableView.alpha = shouldShow ? 1 : 0
			}) { (completed) in
				self.monthViewerTableView.isHidden = (self.monthViewerTableView.alpha == 0)
			}
		}else {
			self.monthViewerTableView.alpha = shouldShow ? 1 : 0
			self.monthViewerTableView.isHidden = (self.monthViewerTableView.alpha == 0)
		}
	}

	/**
	This method is used to kill scroll animation of table view and collection view.
	*/
	func stopScrolling() {
		let collectionContentOffset = self.calCollectionView.contentOffset
		//This is a trick to kill scroll animation, just set current offset without animation
		self.calCollectionView.setContentOffset(collectionContentOffset, animated: false)
		self.monthViewerTableView.setContentOffset(collectionContentOffset, animated: false)
		self.monthViewerTableView.isHidden = true
	}
}

//MARK:Flow layout delegate,
/**
width, height of cells, gap between cells and rows etc are set here
*/
extension CTCalendarViewController:UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let cellWidth = UIScreen.main.bounds.width / 7.0
		let cellSize = CGSize(width: cellWidth , height:self.viewingMode.heightNeededForSingleRow)
		return cellSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

}

//MARK:Scroll view delegate
/**
This is scroll delegate of both collection view and table view.
*/
extension CTCalendarViewController: UIScrollViewDelegate {

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		//as soon as user starts dragging, change to five row mode
		if self.viewingMode != .fiveRows {
			self.viewingMode = .fiveRows
		}
		//if user is dragging collection view then it's time to show overlay table view
		if scrollView == self.calCollectionView && scrollView.isDragging {
			self.monthViewerTableView.contentOffset = scrollView.contentOffset
			self.hideOrShowMonthTableViewWithAnimation(shouldShow: true, animated: false)
		}
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			//very short scroll, just hide overlay table view
			self.hideOrShowMonthTableViewWithAnimation(shouldShow: false, animated:true)
		}
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if self.monthViewerTableView.isDecelerating || self.calCollectionView.isDecelerating {
			return
		}
		//if both overlay table view and collection view have stopped scrolling then hide overlay table view.
		self.hideOrShowMonthTableViewWithAnimation(shouldShow: false, animated: true)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		//sync scroll of collection view and overlay tableview. This is called in same animation context of scroll so there will not be any jerk.
		let offset = scrollView.contentOffset
		if scrollView == self.monthViewerTableView && scrollView.isDragging {
			self.calCollectionView.contentOffset = offset
		}else if scrollView == self.calCollectionView && scrollView.isDragging {
			self.monthViewerTableView.contentOffset = offset
		}
	}

	func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		return false
	}
}

//MARK:Collection view delegates
extension  CTCalendarViewController:UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let dateForIndexPath = self.calendarViewUIDataHelper.dateForIndexPath(indexPath: indexPath)
			else {
				Swift.print("Can't find date for index path, this should not happen")
				return
		}
		self.delegate?.didSelectedDate(date: dateForIndexPath)
	}

	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return !self.calendarViewUIDataHelper.calCollectionViewUIData[indexPath.section][indexPath.row].isBlankDay
	}
}

//MARK:Collection view data source
extension CTCalendarViewController:UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.calendarViewUIDataHelper.calCollectionViewUIData[section].count
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.calendarViewUIDataHelper.calCollectionViewUIData.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTCalDayViewCellCollectionViewCell", for: indexPath) as! CTCalDayViewCellCollectionViewCell
		cell.updateCellWithUIData(uiData: self.calendarViewUIDataHelper.calCollectionViewUIData[indexPath.section][indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		(cell as! CTCalDayViewCellCollectionViewCell).updateCellWithUIData(uiData: self.calendarViewUIDataHelper.calCollectionViewUIData[indexPath.section][indexPath.row])
	}
}

//MARK: Table view data source and delegate
extension CTCalendarViewController:UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.monthViewerTableView.dequeueReusableCell(withIdentifier: "CTCalendarMonthViewerCellTableViewCell") as! CTCalendarMonthViewerCellTableViewCell
		cell.monthNameLabel.text = self.calendarViewUIDataHelper.calTableViewUIData[indexPath.row].monthName
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.calendarViewUIDataHelper.calTableViewUIData.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//it will be number of weeks in a month * height of single row of collection view.
		return self.viewingMode.heightNeededForSingleRow * CGFloat(self.calendarViewUIDataHelper.calTableViewUIData[indexPath.row].noOfDifferentWeeksInMonth)
	}
}
