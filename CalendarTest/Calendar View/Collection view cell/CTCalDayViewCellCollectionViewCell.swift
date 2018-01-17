//
//  CTCalDayViewCellCollectionViewCell.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

/**
This is UICollectionViewCell subclass used in collection view of calendar view
*/
class CTCalDayViewCellCollectionViewCell: UICollectionViewCell {

	///Circuler dot added below date label to show event availabilty on date
	@IBOutlet weak var eventAvailabiltyDot: UIView!

	///UIView added around date label to draw blue circle around date on selection of cell
	@IBOutlet weak var backgroundHighlighterView: UIView!

	///Label added in center of cell. Used to date in cell.
	@IBOutlet weak var dateLabel: UILabel!

	///UI data object, which is used to customize UI of this cell
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

	/**
	This is static method used to register cell for reusablity in collection view.
	-Parameter collectionView: collectionView view in which this cell should be registered.
	-Parameter withIdentifier: Identifier which should be used in registering this cell for reusability.
	*/
	static func registerCell(collectionView:UICollectionView, withIdentifier:String) {
		collectionView.register(UINib(nibName: "CTCalDayViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:withIdentifier)
	}

	/**
	This is method is used to customize this cell's UI based on uiData.
	-Parameter uiData: CTCalCollectionViewCellUIData object.
	*/
	final func updateCellWithUIData(uiData:CTCalCollectionViewCellUIData) {
		self.cellUIData = uiData
		self.checkSelectionStateAndSetUI()
	}

	/**
	This is method is used to check current selection state and update UI accordingly
	*/
	private func checkSelectionStateAndSetUI() {
		if self.isSelected {
			updateUIForSelectedCell()
		}else {
			updateFontAndColorForNonSelectedCell()
		}
		///common operation needs to be done irrespective of selection state
		self.setBackgroundColor()
		self.setFontForDateLabel()
		self.setEventAvailabiltyDotColor()
	}

	/**
	This is method is used to update cell's UI is cell is not selected
	*/
	private func updateFontAndColorForNonSelectedCell() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		self.backgroundHighlighterView.backgroundColor = UIColor.clear
		self.dateLabel.text = uiData.fullDateString
		self.dateLabel.textColor = UIColor(red: 67/255, green: 75/255, blue: 82/255, alpha: 1.0)
	}

	/**
	This is method is used to update cell's UI is cell is selected
	*/
	private func updateUIForSelectedCell() {
		guard let uiData = self.cellUIData
			else {
				return
		}

		self.backgroundHighlighterView.backgroundColor = UIColor(red: 41/255, green: 127/255, blue: 246/255, alpha: 1.0)
		self.dateLabel.textColor = UIColor.white
		self.dateLabel.text = uiData.dateNumberString
	}

	/**
	This is method is used to set background color of cell
	*/
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

	/**
	This is method is used to set font and color for date label
	*/
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

	/**
	This is method is used to set color of event availability dot
	*/
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
