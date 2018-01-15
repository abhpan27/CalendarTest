//
//  CTCalDateCalculationUtils.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

extension CTCalendarViewController {

	final func selectDate(date:Date, animated:Bool) {
		guard let indexPathForDate = self.calendarViewUIDataHelper.indexPathForDate(date: date)
			else {
				Swift.print("Date \(date.logDate) is not in calendar")
				return
		}

		self.stopScrolling()

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

	final func reloadCollectionViewKeepingSelection() {
		mainQueueAsync {
			//reload
			let selectedIndexPath = self.calCollectionView.indexPathsForSelectedItems?.first
			self.calCollectionView.reloadData()
			mainQueueAsync {
				self.calCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
			}
		}
	}
}
