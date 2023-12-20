//
//  RoundNearest.swift
//
//
//  Created by Ruslan Lutfullin on 25/07/23.
//

extension BinaryFloatingPoint {
    
    mutating public func round(nearestTo nearest: Self) {
        self = (self / nearest).rounded() * nearest
    }
    
    public func rounded(nearestTo nearest: Self) -> Self {
        (self / nearest).rounded() * nearest
    }
}
