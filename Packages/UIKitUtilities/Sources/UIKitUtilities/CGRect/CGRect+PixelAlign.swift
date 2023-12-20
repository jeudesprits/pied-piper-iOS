//
//  CGRect+PixelAlign.swift
//
//
//  Created by Ruslan Lutfullin on 25/03/23.
//

import UIKit

extension CGRect {
	
	public var pixelAligned: Self {
		pixelAligned(for: .current)
	}
	
	public mutating func pixelAlign(for trait: UITraitCollection) {
		self = .init(origin: origin.pixelAligned(for: trait), size: size.pixelAligned(for: trait))
	}
	
	public func pixelAligned(for trait: UITraitCollection) -> Self {
		return .init(origin: origin.pixelAligned(for: trait), size: size.pixelAligned(for: trait))
	}
}
