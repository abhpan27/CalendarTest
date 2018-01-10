//
//  CTGeneralExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

func runInMainQueue(_ block : @escaping () -> ()){
	DispatchQueue.main.async(execute: { () -> Void in
		block()
	})
}

func delayedRun(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
	let length = Int64(range.upperBound - range.lowerBound + 1)
	let value = Int64(arc4random()) % length + Int64(range.lowerBound)
	return T(value)
}
