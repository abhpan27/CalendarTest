//
//  CTCalDateCalculationUtils.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
This is an extension of Calendar view controller. Some helper function are added here.
*/
extension CTCalendarViewController {

	/**
	This method is used to select date in collection view.

	- Parameter date: Date which should be selected in Calendar view.
	- Parameter animated: Bool which shows if selection scroll should be animated.
	*/
	final func selectDate(date:Date, animated:Bool) {
		guard let indexPathForDate = self.calendarViewUIDataHelper.indexPathForDate(date: date)
			else {
				return
		}

		//index path found, now if currently doing any scroll animation then kill the scoll animation
		self.stopScrolling()

		//if date already selected then just make it visible if not already visible
		if indexPathForDate == self.calCollectionView.indexPathsForSelectedItems?.first {
			if !self.calCollectionView.indexPathsForVisibleItems.contains(indexPathForDate) {
				self.calCollectionView.scrollToItem(at: indexPathForDate, at: .top, animated: false)
			}
			return
		}
		
		mainQueueAsync {
			self.calCollectionView.selectItem(at: indexPathForDate, animated: animated, scrollPosition: .top)
		}
	}

	/**
	This method is used reload collection view while keeping the old selection state intact.
	*/
	final func reloadCollectionViewKeepingSelection() {
		mainQueueAsync {
			let selectedIndexPath = self.calCollectionView.indexPathsForSelectedItems?.first
			self.calCollectionView.reloadData()
			mainQueueAsync {
				self.calCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
			}
		}
	}
}
