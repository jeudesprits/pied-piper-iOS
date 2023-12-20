//
//  UIUnitPoint.swift
//
//
//  Created by Ruslan Lutfullin on 16/10/23.
//

import SwiftUtilities
import UIKit

public struct UIUnitPoint {
    
    public var x: CGFloat
    
    public var y: CGFloat
    
    @inlinable
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

extension UIUnitPoint {
    
    @inlinable
    public init() {
        self.init(x: 0.0, y: 0.0)
    }
}

extension UIUnitPoint {
    
    @inlinable
    public init(angle: UIAngle) {
        // Inspired by https://math.stackexchange.com/a/4041510/399217
        // Also see https://www.desmos.com/calculator/k13553cbgk
        let (s, c) = (sin(angle.radians), cos(angle.radians))
        let clamp: (CGFloat, CGFloat) = (clamp(c / s, min: -1.0, max: 1.0), clamp(s / c, min: -1.0, max: 1.0))
        self.init(x: clamp.0 * copysign(1.0, s) * 0.5 + 0.5, y: clamp.1 * copysign(1.0, c) * 0.5 + 0.5)
    }
}

extension UIUnitPoint {
    
    @inlinable
    public static var zero: Self {
        .init()
    }
}

extension UIUnitPoint {
    
    @inlinable
    public static var topLeft: Self {
        .init(x: 0.0, y: 0.0)
    }
    
    @inlinable
    public static var top: Self {
        .init(x: 0.5, y: 0.0)
    }
    
    @inlinable
    public static var topRight: Self {
        .init(x: 1.0, y: 0.0)
    }
}

extension UIUnitPoint {
    
    @inlinable
    public static var left: Self {
        .init(x: 0.0, y: 0.5)
        
    }
    
    @inlinable
    public static var center: Self {
        .init(x: 0.5, y: 0.5)
    }
    
    @inlinable
    public static var right: Self {
        .init(x: 1.0, y: 0.5)
    }
}

extension UIUnitPoint {
    
    @inlinable
    public static var bottomLeft: Self {
        .init(x: 0.0, y: 1.0)
    }
    
    @inlinable
    public static var bottom: Self {
        .init(x: 0.5, y: 1.0)
    }
    
    @inlinable
    public static var bottomRight: Self {
        .init(x: 1.0, y: 1.0)
    }
}

extension UIUnitPoint: Hashable {
}
