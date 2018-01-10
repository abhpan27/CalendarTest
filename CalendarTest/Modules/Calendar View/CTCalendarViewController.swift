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
		return 65
	}
}

final class CTCalendarViewController: UIViewController {

	@IBOutlet weak var calCollectionView: UICollectionView!
	private(set) var calUIData:[[CTCellUIData]]
	weak var delegate:CTCalendarViewControllerDelegate?
	var pangestureRecognizer:UIPanGestureRecognizer?

	var viewingMode:CalViewingMode = .fiveRows {
		didSet {
			if oldValue != viewingMode {
				//this will reduce/increase calendar container size
				self.delegate?.viewingModeDidChange(viewingMode: viewingMode)
			}
		}
	}
	
	init() {
		self.calUIData = CTCalDataGenerator().getBasicCalData()
		super.init(nibName: "CTCalendarViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		CTCalDayViewCellCollectionViewCell.registerCell(collectionView: calCollectionView, withIdentifier: "CTCalDayViewCellCollectionViewCell")
		//select current date after some delay so that current drawing of cells is completed
		delayedRun(0.1) {
			self.selectDate(date: Date(), animated: false)
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
	}
}

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
		return !self.calUIData[indexPath.section][indexPath.row].isBlankDay
	}
}

extension CTCalendarViewController:UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.calUIData[section].count
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.calUIData.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTCalDayViewCellCollectionViewCell", for: indexPath) as! CTCalDayViewCellCollectionViewCell
		cell.updateCellWithUIData(uiData: self.calUIData[indexPath.section][indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		(cell as! CTCalDayViewCellCollectionViewCell).updateCellWithUIData(uiData: self.calUIData[indexPath.section][indexPath.row])
	}
	
}
