//
//  Clamp.swift
//
//
//  Created by Ruslan Lutfullin on 06/07/23.
//

@inlinable
public func clamp<T: BinaryInteger>(_ x: T, min: T, max: T) -> T {
    x < min ? min : x > max ? max : x
}

@inlinable
public func clamp<T: BinaryFloatingPoint>(_ x: T, min: T, max: T) -> T {
    x < min ? min : x > max ? max : x
}
