//
//  CTFont.swift
//  CalendarTest
//
//  Created by Abhishek on 09/01/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

internal class CTFont
{
	internal enum Weight: Int
	{
		case Regular
		case Medium
		case Bold
		case Light
		case SemiBold
		case Italic

		fileprivate var uiFontWeight: UIFont.Weight
		{
			switch self {
			case .Regular:
				return UIFont.Weight.regular
			case .Bold:
				return UIFont.Weight.bold
			case .Medium:
				return UIFont.Weight.medium
			case .Light:
				return UIFont.Weight.light
			case .SemiBold:
				return UIFont.Weight.semibold
			case .Italic:
				return UIFont.Weight(CGFloat(UIFontDescriptorSymbolicTraits.traitItalic.rawValue))
			}
		}
	}

	internal static func systemFont(ofSize: CGFloat, weight: Weight) -> UIFont
	{
			return UIFont.systemFont(ofSize: ofSize, weight: weight.uiFontWeight)
	}
}
