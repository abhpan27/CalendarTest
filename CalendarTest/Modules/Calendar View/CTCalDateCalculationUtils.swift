//
//  CTCalDateCalculationUtils.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

extension CTCalendarViewController {

	private func indexPathForDate(date:Date) -> IndexPath? {
		let startOfDate = date.startOfDate.timeIntervalSince1970
		for rowIndex in 0 ... self.calUIData.count - 1 {
			let currentRow = self.calUIData[rowIndex]
			if currentRow.first!.dateEpoch <= startOfDate && startOfDate <= currentRow.last!.dateEpoch {
				for coloumnIndex in 0 ... 7 {
					if currentRow[coloumnIndex].dateEpoch == startOfDate {
						return IndexPath(row: coloumnIndex, section: rowIndex)
					}
				}
			}
		}

		return nil
	}

	final func dateForIndexPath(indexPath:IndexPath) -> Date? {
		let row = indexPath.section
		let coloumn = indexPath.row

		if coloumn < 8 && coloumn >= 0 {
			if row >= 0 && row < self.calUIData.count {
				let epoch = self.calUIData[row][coloumn].dateEpoch
				return Date(timeIntervalSince1970: epoch).startOfDate
			}
		}

		return nil
	}

	final func selectDate(date:Date, animated:Bool) {
		guard let indexPathForDate = self.indexPathForDate(date: date)
			else {
				Swift.print("Date \(date.logDate) is not in calendar")
				return
		}
		
		runInMainQueue {
			self.calCollectionView.selectItem(at: indexPathForDate, animated: animated, scrollPosition: .centeredVertically)
		}
	}
}
