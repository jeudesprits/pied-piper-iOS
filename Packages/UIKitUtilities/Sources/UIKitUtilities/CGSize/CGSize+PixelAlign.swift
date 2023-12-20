//
//  CGSize+PixelAlign.swift
//
//
//  Created by Ruslan Lutfullin on 25/03/23.
//

import UIKit

extension CGSize {
	
	public var pixelAligned: Self {
		pixelAligned(for: .current)
	}
	
	public mutating func pixelAlign(for trait: UITraitCollection) {
		self = .init(width: width.pixelAligned(for: trait), height: height.pixelAligned(for: trait))
	}
	
	public func pixelAligned(for trait: UITraitCollection) -> Self {
		return .init(width: width.pixelAligned(for: trait), height: height.pixelAligned(for: trait))
	}
}
