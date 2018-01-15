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
		let firstDateInfo = self.getFirstDateInfo()!
		if date.isInSameWeek(with: firstDateInfo.date) {
			let daysBetween = date.days(from: firstDateInfo.date)
			return IndexPath(row: firstDateInfo.indexPath.row + daysBetween, section: 0)
		}

		let numberOfWeeks = date.numberOfWeeks(from: firstDateInfo.date)
		let rowOfDate = date.weekDay - 1
		let sectionOfDate = date.weekDay != WeekDayNumber.saturday.rawValue ? numberOfWeeks + 1 : numberOfWeeks

		guard sectionOfDate < self.calCollectionViewUIData.count && rowOfDate < 8
			else {
				return nil
		}

		return IndexPath(row: rowOfDate, section: sectionOfDate)

//		let startOfDate = date.startOfDate.timeIntervalSince1970
//		for rowIndex in 0 ... self.calCollectionViewUIData.count - 1 {
//			let currentRow = self.calCollectionViewUIData[rowIndex]
//			if currentRow.first!.dateEpoch <= startOfDate && startOfDate <= currentRow.last!.dateEpoch {
//				for coloumnIndex in 0 ... 7 {
//					if currentRow[coloumnIndex].dateEpoch == startOfDate {
//						Swift.print("index path actual row :\(coloumnIndex), section of date :\(rowIndex)")
//						return IndexPath(row: coloumnIndex, section: rowIndex)
//					}
//				}
//			}
//		}
	}

	private func getFirstDateInfo() -> (date:Date, indexPath:IndexPath)? {
		let firstRow = self.calCollectionViewUIData[0]
		for index in 0 ... 7 {
			if firstRow[index].dateEpoch != -1 {
				let indexPath = IndexPath(row: index, section: 0)
				let date = Date(timeIntervalSince1970: firstRow[index].dateEpoch)
				return (date, indexPath)
			}
		}
		return nil
	}

	final func dateForIndexPath(indexPath:IndexPath) -> Date? {
		let row = indexPath.section
		let coloumn = indexPath.row

		if coloumn < 8 && coloumn >= 0 {
			if row >= 0 && row < self.calCollectionViewUIData.count {
				let epoch = self.calCollectionViewUIData[row][coloumn].dateEpoch
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

		self.stopScrolling()

		if indexPathForDate == self.calCollectionView.indexPathsForSelectedItems?.first {
			self.calCollectionView.scrollToItem(at: indexPathForDate, at: .top, animated: animated)
		}
		
		mainQueueAsync {
			self.calCollectionView.selectItem(at: indexPathForDate, animated: animated, scrollPosition: .top)
		}
	}
}
