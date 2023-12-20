//
//  CGFloat+InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 16/03/23.
//

import SwiftUtilities
import UIKit

extension CGFloat: InterpolatableData {
	
	public func mixed(with other: Self, using factor: Double) -> Self {
        unclampedLinearInterpolate(to: other, using: factor)
	}
}

extension Double: InterpolatableData {
	
	public func mixed(with other: Self, using factor: Double) -> Self {
		unclampedLinearInterpolate(to: other, using: factor)
	}
}

extension Float: InterpolatableData {
	
	public func mixed(with other: Self, using factor: Double) -> Self {
		unclampedLinearInterpolate(to: other, using: Float(factor))
	}
}
