//
//  CTGeneralExtension.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation

/**
Helper function to run some code in Main queue asynchronously

- Parameter block: Block to execute asynchronously.
*/
func mainQueueAsync(_ block : @escaping () -> ()) {
	DispatchQueue.main.async(execute: { () -> Void in
		block()
	})
}

/**
Helper function to run some code in Main queue asynchronously after some delay

- Parameter delay: Seconds after which block should be executed.
- Parameter closure: Block to execute asynchronously after some delay.
*/
func delayedRunInMainQueue(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/**
Helper function to run generate random number in given range

- Parameter inRange: Closed Range of signed integers.
- Note: It is based on arc4random
*/
func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T>) -> T {
	let length = Int64(range.upperBound - range.lowerBound + 1)
	let value = Int64(arc4random()) % length + Int64(range.lowerBound)
	return T(value)
}
