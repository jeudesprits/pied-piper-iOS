//
//  SIMD+DropLast.swift
//
//
//  Created by Ruslan Lutfullin on 17/12/22.
//

import simd

extension SIMD3<Double> {
    
    @inlinable
    public var dropLast: SIMD2<Double> {
        .init(x, y)
    }
}

extension SIMD4<Double> {
    
    @inlinable
    public var dropLast: SIMD3<Double> {
        .init(x, y, z)
    }
}
