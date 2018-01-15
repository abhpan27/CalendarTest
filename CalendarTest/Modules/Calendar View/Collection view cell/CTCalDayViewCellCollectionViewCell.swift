//
//  CTCalDayViewCellCollectionViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class CTCalDayViewCellCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var eventAvailabiltyDot: UIView!
	@IBOutlet weak var backgroundHighlighterView: UIView!
	@IBOutlet weak var dateLabel: UILabel!
	var cellUIData:CTCalCollectionViewCellUIData!

	override var isSelected: Bool {
		didSet {
			self.checkSelectionStateAndSetUI()
		}
	}

	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundHighlighterView.layer.cornerRadius = self.backgroundHighlighterView.frame.height/2
		self.eventAvailabiltyDot.layer.cornerRadius = self.eventAvailabiltyDot.frame.height / 2
		self.eventAvailabiltyDot.backgroundColor = UIColor.clear
    }

	static func registerCell(collectionView:UICollectionView, withIdentifier:String) {
		collectionView.register(UINib(nibName: "CTCalDayViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:withIdentifier)
	}

	final func updateCellWithUIData(uiData:CTCalCollectionViewCellUIData) {
		self.cellUIData = uiData
		self.checkSelectionStateAndSetUI()
	}

	private func checkSelectionStateAndSetUI() {
		if self.isSelected {
			updateUIForSelectedCell()
		}else {
			updateFontAndColorForNonSelectedCell()
		}
		setBackgroundColor()
		setFontForDateLabel()
		setEventAvailabiltyDotColor()
	}

	private func updateFontAndColorForNonSelectedCell() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		self.backgroundHighlighterView.backgroundColor = UIColor.clear
		self.dateLabel.text = uiData.fullDateString
		self.dateLabel.textColor = UIColor(red: 67/255, green: 75/255, blue: 82/255, alpha: 1.0)
	}

	private func updateUIForSelectedCell() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		self.backgroundHighlighterView.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		self.dateLabel.textColor = UIColor.white
		self.dateLabel.text = uiData.dateNumberString
	}

	private func setBackgroundColor() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		if uiData.shouldDrawInGrey {
			self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
		}else {
			self.backgroundColor = UIColor.white
		}
	}

	private func setFontForDateLabel() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		if Date(timeIntervalSince1970: uiData.dateEpoch).isToday {
			self.dateLabel.font = CTFont.systemFont(ofSize: 15, weight: .Bold)
		}else {
			self.dateLabel.font = CTFont.systemFont(ofSize: 13, weight: .Regular)
		}
	}

	private func setEventAvailabiltyDotColor() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		if self.isSelected {
			self.eventAvailabiltyDot.backgroundColor = UIColor.clear
			return
		}
		self.eventAvailabiltyDot.backgroundColor = CalendarViewCellEventAvailablityColor(rawValue: uiData.eventAvailabilityColor)!.color
	}

}
