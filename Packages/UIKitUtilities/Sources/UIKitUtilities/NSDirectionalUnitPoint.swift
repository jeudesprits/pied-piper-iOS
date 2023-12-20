//
//  NSDirectionalUnitPoint.swift
//
//
//  Created by Ruslan Lutfullin on 16/10/23.
//

import UIKit

public struct NSDirectionalUnitPoint {
    
    public var x: CGFloat
    
    public var y: CGFloat
    
    @inlinable
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

extension NSDirectionalUnitPoint {
    
    @inlinable
    public init() {
        self.init(x: 0.0, y: 0.0)
    }
}

extension NSDirectionalUnitPoint {
    
    public static var zero: Self {
        .init()
    }
}

extension NSDirectionalUnitPoint {
    
    public static var topLeading: Self {
        .init(x: 0.0, y: 0.0)
    }
    
    public static var top: Self {
        .init(x: 0.5, y: 0.0)
    }
    
    public static var topTrailing: Self {
        .init(x: 1.0, y: 0.0)
    }
}

extension NSDirectionalUnitPoint {
    
    public static var leading: Self {
        .init(x: 0.0, y: 0.5)
        
    }
    
    public static var center: Self {
        .init(x: 0.5, y: 0.5)
    }
    
    public static var trailing: Self {
        .init(x: 1.0, y: 0.5)
    }
}

extension NSDirectionalUnitPoint {
    
    public static var bottomLeading: Self {
        .init(x: 0.0, y: 1.0)
    }
    
    public static var bottom: Self {
        .init(x: 0.5, y: 1.0)
    }
    
    public static var bottomTrailing: Self {
        .init(x: 1.0, y: 1.0)
    }
}

extension NSDirectionalUnitPoint: Hashable {
}
