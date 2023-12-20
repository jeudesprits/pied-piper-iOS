//
//  UIColor+Image.swift
//
//
//  Created by Ruslan Lutfullin on 3/18/21.
//

import UIKit

extension UIColor {
	
	public func image(with size: CGSize = .init(width: 1.0, height: 1.0), isRounded: Bool = false) -> UIImage {
		let format = UIGraphicsImageRendererFormat.preferred()
		
		if isRounded {
			format.opaque = false
		} else {
			format.opaque = cgColor.components?.last == 1.0 ? true : false
		}
		
		return UIGraphicsImageRenderer(size: size, format: format).image { context in
			context.cgContext.setShouldAntialias(true)
			context.cgContext.setAllowsAntialiasing(true)
			context.cgContext.interpolationQuality = .high
			setFill()
			if isRounded {
				context.cgContext.fillEllipse(in: .init(origin: .zero, size: size))
			} else {
				context.fill(.init(origin: .zero, size: size))
			}
		}
	}
}
