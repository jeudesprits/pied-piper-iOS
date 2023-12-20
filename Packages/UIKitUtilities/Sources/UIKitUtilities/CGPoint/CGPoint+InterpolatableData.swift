//
//  CGPoint+InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 16/03/23.
//

import SwiftUtilities
import UIKit

extension CGPoint: InterpolatableData {
	
	public func mixed(with other: CGPoint, using factor: Double) -> CGPoint {
		let mixed = unclampedLinearInterpolate((x, y), (other.x, other.y), using: factor)
		return CGPoint(x: mixed.0, y: mixed.1)
	}
}
