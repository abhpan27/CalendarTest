//
//  CTCalDayViewCellCollectionViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCalDayViewCellCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var backgroundHighlighterView: UIView!
	@IBOutlet weak var dateLabel: UILabel!
	var cellUIData:CTCellUIData!

	override var isSelected: Bool {
		didSet {
			self.checkAndSetUI()
		}
	}

	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundHighlighterView.layer.cornerRadius = self.backgroundHighlighterView.frame.height/2 //rounded corners
    }

	static func registerCell(collectionView:UICollectionView, withIdentifier:String) {
		collectionView.register(UINib(nibName: "CTCalDayViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:withIdentifier)
	}

	final func updateCellWithUIData(uiData:CTCellUIData) {
		self.cellUIData = uiData
		self.checkAndSetUI()
	}

	private func checkAndSetUI() {
		if self.isSelected {
			updateUIForSelection()
		}else {
			updateFontAndColor()
		}
	}

	private func updateFontAndColor() {
		guard let uiData = self.cellUIData else {return}
		self.backgroundHighlighterView.backgroundColor = UIColor.clear
		if uiData.shouldDrawInGrey {
			self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
		}else {
			self.backgroundColor = UIColor.white
		}
		self.dateLabel.text = uiData.fullDateString
		self.dateLabel.textColor = UIColor(red: 67/255, green: 75/255, blue: 82/255, alpha: 1.0)
	}

	private func updateUIForSelection() {
		guard let uiData = self.cellUIData else { return }
		self.backgroundHighlighterView.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		self.dateLabel.textColor = UIColor.white
		self.dateLabel.text = uiData.dateNumberString
	}

}
