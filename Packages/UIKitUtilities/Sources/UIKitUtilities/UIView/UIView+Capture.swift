//
//  UIView+Capture.swift
//
//
//  Created by Ruslan Lutfullin on 12/14/21.
//

import UIKit

extension UIView {
    
    public func captureAsImage(afterScreenUpdates: Bool = true) -> UIImage {
        UIGraphicsImageRenderer(size: bounds.size, format: .preferred())
            .image { context in
                let cgContext = context.cgContext
                cgContext.setShouldAntialias(true)
                cgContext.setAllowsAntialiasing(true)
                cgContext.interpolationQuality = .high
                drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
            }
    }
}
