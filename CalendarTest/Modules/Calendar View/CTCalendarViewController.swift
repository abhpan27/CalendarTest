//
//  CTCalendarViewController.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCalendarViewController: UIViewController {

	private(set) var calUIData:[[CTCellUIData]]
	let singleRowHeight:CGFloat = 65
	@IBOutlet weak var calCollectionView: UICollectionView!
	
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
		//run in next run loop so that frame calculation for collection view is complete
		runInMainQueue {
			self.setUpBasicCalUI()
		}
    }

	private func setUpBasicCalUI() {
		let cellWidth : CGFloat = calCollectionView.frame.size.width / 7.0 
		let cellSize = CGSize(width: cellWidth , height:self.singleRowHeight)
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
