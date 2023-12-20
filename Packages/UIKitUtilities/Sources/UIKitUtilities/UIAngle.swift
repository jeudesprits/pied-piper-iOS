//
//  UIAngle.swift
//
//
//  Created by Ruslan Lutfullin on 16/10/23.
//

import UIKit

public struct UIAngle {
    
    public var radians: CGFloat
    
    @inlinable
    public var degrees: CGFloat {
        get {
            radians * (180.0 / .pi)
        }
        set {
            radians = newValue * (.pi / 180.0)
        }
    }
    
    @inlinable
    public init(radians: CGFloat) {
        self.radians = radians
    }
    
    @inlinable
    public init(degrees: CGFloat) {
        radians = degrees * (.pi / 180.0)
    }
}

extension UIAngle {
    
    @inlinable
    public static var zero: Self {
        .init()
    }
    
    @inlinable
    public init() {
        self.init(radians: 0.0)
    }
}

extension UIAngle {
    
    @inlinable
    public static func radians(_ radians: consuming CGFloat) -> Self {
        .init(radians: radians)
    }
    
    @inlinable
    public static func degrees(_ degrees: consuming CGFloat) -> Self {
        .init(degrees: degrees)
    }
}

extension UIAngle {
    
    @inlinable
    public var accurateNormalized: Self {
        .init(radians: atan2(sin(radians), cos(radians)))
    }
    
    @inlinable
    public var normalized: Self {
        .init(radians: radians - .pi * floor((radians + .pi) / .pi))
    }
}

extension UIAngle: Hashable {
}

extension UIAngle: Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.radians < rhs.radians
    }
}
