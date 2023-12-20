//
//  CGColor+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 20/10/23.
//

import UIKit

extension CGColor {
    
    public static func makeCGColor(colorSpace: CGColorSpace, components: [CGFloat]) -> CGColor? {
        components.withUnsafeBufferPointer {
            CGColor(colorSpace: colorSpace, components: $0.baseAddress!)
        }
    }
    
    public static func makeCGColor(colorSpace: CGColorSpace, components: [Double]) -> CGColor? {
        components.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CGFloat.self) {
                CGColor(colorSpace: colorSpace, components: $0.baseAddress!)
            }
        }
    }
}
