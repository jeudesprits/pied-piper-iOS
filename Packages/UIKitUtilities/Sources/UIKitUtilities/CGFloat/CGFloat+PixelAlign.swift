//
//  CGFloat+PixelAlign.swift
//
//
//  Created by Ruslan Lutfullin on 25/03/23.
//

import UIKit

extension CGFloat {
		
	public var pixelAligned: Self {
		pixelAligned(for: .current)
	}
	
	public mutating func pixelAlign(for trait: UITraitCollection) {
		let scale = trait.displayScale
		self = (self * scale).rounded(.up) / scale
	}
	
	public func pixelAligned(for trait: UITraitCollection) -> Self {
		let scale = trait.displayScale
		return (self * scale).rounded(.up) / scale
	}
}
