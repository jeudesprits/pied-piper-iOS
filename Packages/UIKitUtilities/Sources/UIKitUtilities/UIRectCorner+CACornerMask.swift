//
//  UIRectCorner+CACornerMask.swift
//
//
//  Created by Ruslan Lutfullin on 2/23/21.
//

import UIKit

extension UIRectCorner {
	
	public init(_ cornerMask: CACornerMask) {
		var rectCorner = UIRectCorner()
		if cornerMask.contains(.layerMinXMinYCorner) { rectCorner.insert(.topLeft) }
		if cornerMask.contains(.layerMinXMaxYCorner) { rectCorner.insert(.bottomLeft) }
		if cornerMask.contains(.layerMaxXMinYCorner) { rectCorner.insert(.topRight) }
		if cornerMask.contains(.layerMaxXMaxYCorner) { rectCorner.insert(.bottomRight) }
		self.init(rawValue: rectCorner.rawValue)
	}
}
