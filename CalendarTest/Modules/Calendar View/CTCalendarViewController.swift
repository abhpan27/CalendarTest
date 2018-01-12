//
//  CTCalendarViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

protocol CTCalendarViewControllerDelegate:NSObjectProtocol {
	func viewingModeDidChange(viewingMode:CalViewingMode)
	func didSelectedDate(date:Date)
}

internal enum CalViewingMode {
	case twoRows, fiveRows

	var totalHeightNeeded:CGFloat {
		let singleRowHeight = self.heightNeededForSingleRow
		switch self {
		case .twoRows:
			return 2*singleRowHeight
		case .fiveRows:
			return 5*singleRowHeight
		}
	}

	var heightNeededForSingleRow:CGFloat {
		return 55
	}
}

final class CTCalendarViewController: UIViewController {

	@IBOutlet weak var monthViewerTableView: UITableView!
	@IBOutlet weak var calCollectionView: UICollectionView!
	let calCollectionViewUIData:[[CTCalCollectionViewCellUIData]]
	let calTableViewUIData:[CTCalTableViewData]
	weak var delegate:CTCalendarViewControllerDelegate?
	var pangestureRecognizer:UIPanGestureRecognizer?
	var lastDraggedView:UIView?

	var viewingMode:CalViewingMode = .fiveRows {
		didSet {
			if oldValue != viewingMode {
				//this will reduce/increase calendar container size
				self.delegate?.viewingModeDidChange(viewingMode: viewingMode)
			}
		}
	}
	
	init() {
		self.calCollectionViewUIData = CTCalViewDataHelper().getBasicCollectionViewCalData()
		self.calTableViewUIData = CTCalViewDataHelper().getBasicTableViewCalData()
		super.init(nibName: "CTCalendarViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		CTCalDayViewCellCollectionViewCell.registerCell(collectionView: calCollectionView, withIdentifier: "CTCalDayViewCellCollectionViewCell")
		setUpBasicUI()
		//select current date after some delay so that current drawing of cells is completed
		delayedRunInMainQueue(0.1) {
			self.selectDate(date: Date(), animated: false)
		}
    }

	private func setUpBasicUI() {
		CTCalendarMonthViewerCellTableViewCell.registerCell(inTableView: self.monthViewerTableView, withIdentifier: "CTCalendarMonthViewerCellTableViewCell")
		self.monthViewerTableView.backgroundColor = UIColor.clear
		self.monthViewerTableView.layoutIfNeeded()
		self.monthViewerTableView.isHidden = true
	}

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
}

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

extension CTCalendarViewController: UIScrollViewDelegate {

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if self.viewingMode != .fiveRows {
			self.viewingMode = .fiveRows
		}
		self.lastDraggedView = scrollView
		if scrollView == self.calCollectionView && scrollView.isDragging {
			self.monthViewerTableView.contentOffset = scrollView.contentOffset
			self.hideOrShowMonthTableViewWithAnimation(shouldShow: true, animated: false)
		}
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			self.hideOrShowMonthTableViewWithAnimation(shouldShow: false, animated:true)
		}
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if scrollView == lastDraggedView! {
			self.hideOrShowMonthTableViewWithAnimation(shouldShow: false, animated: true)
			lastDraggedView = nil
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		if scrollView == self.monthViewerTableView && scrollView.isDragging {
			self.calCollectionView.contentOffset = offset
		}else if scrollView == self.calCollectionView && scrollView.isDragging {
			self.monthViewerTableView.contentOffset = offset
		}
	}
}

//mark:Collection view delegates
extension  CTCalendarViewController:UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let dateForIndexPath = self.dateForIndexPath(indexPath: indexPath)
			else {
				Swift.print("Can't find date for index path, this should not happen")
				return
		}

		self.delegate?.didSelectedDate(date: dateForIndexPath)
	}

	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return !self.calCollectionViewUIData[indexPath.section][indexPath.row].isBlankDay
	}
}

extension CTCalendarViewController:UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.calCollectionViewUIData[section].count
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.calCollectionViewUIData.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTCalDayViewCellCollectionViewCell", for: indexPath) as! CTCalDayViewCellCollectionViewCell
		cell.updateCellWithUIData(uiData: self.calCollectionViewUIData[indexPath.section][indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		(cell as! CTCalDayViewCellCollectionViewCell).updateCellWithUIData(uiData: self.calCollectionViewUIData[indexPath.section][indexPath.row])
	}
}

//mark: TableView delegates

extension CTCalendarViewController:UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.monthViewerTableView.dequeueReusableCell(withIdentifier: "CTCalendarMonthViewerCellTableViewCell") as! CTCalendarMonthViewerCellTableViewCell
		cell.monthNameLabel.text = self.calTableViewUIData[indexPath.row].monthName
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.calTableViewUIData.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.viewingMode.heightNeededForSingleRow * CGFloat(self.calTableViewUIData[indexPath.row].noOfDifferentWeeksInMonth)
	}
}

