//
//  CGPoint+PixelAlign.swift
//
//
//  Created by Ruslan Lutfullin on 25/03/23.
//

import UIKit


extension CGPoint {
	
	public var pixelAligned: Self {
		pixelAligned(for: .current)
	}
	
	public mutating func pixelAlign(for trait: UITraitCollection) {
		self = .init(x: x.pixelAligned(for: trait), y: y.pixelAligned(for: trait))
	}
	
	public func pixelAligned(for trait: UITraitCollection) -> Self {
		return .init(x: x.pixelAligned(for: trait), y: y.pixelAligned(for: trait))
	}
}
