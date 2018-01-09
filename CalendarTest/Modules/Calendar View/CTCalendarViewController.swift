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

	var heightNeededForViewingMode:CGFloat {
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
	
	init(minimumCalData:[[CTCellUIData]]) {
		self.calUIData = minimumCalData
		super.init(nibName: "CTCalendarViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		CTCalDayViewCellCollectionViewCell.registerCell(collectionView: calCollectionView, withIdentifier: "CTCalDayViewCellCollectionViewCell")
		//run in next run loop so that frame calculation for collection view is completed before frame usage
		runInMainQueue {
			self.setUpBasicCalUI()
		}
    }

	private func setUpBasicCalUI() {
		let cellWidth : CGFloat = calCollectionView.frame.size.width / 7.0 
		let cellSize = CGSize(width: cellWidth , height:self.viewingMode.heightNeededForSingleRow)
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = cellSize
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		calCollectionView.setCollectionViewLayout(layout, animated: false)
		calCollectionView.reloadData()
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
	
}
