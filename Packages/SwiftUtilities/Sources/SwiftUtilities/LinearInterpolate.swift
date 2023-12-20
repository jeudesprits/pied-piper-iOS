//
//  LinearInterpolate.swift
//
//
//  Created by Ruslan Lutfullin on 16/03/23.
//

import Darwin

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: T, _ to: T, using factor: T) -> T {
    from.unclampedLinearInterpolate(to: to, using: factor)
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: T, _ to: T, using factor: T) -> T {
    from.unclampedLinearInterpolate(to: to, using: factor)
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T), _ to: (T, T), using factor: (T, T)) -> (T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T), _ to: (T, T), using factor: T) -> (T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T), _ to: (T, T), using factor: (T, T)) -> (T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T), _ to: (T, T), using factor: T) -> (T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T, T), _ to: (T, T, T), using factor: (T, T, T)) -> (T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor.2)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T, T), _ to: (T, T, T), using factor: T) -> (T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T, T), _ to: (T, T, T), using factor: (T, T, T)) -> (T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor.2)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T, T), _ to: (T, T, T), using factor: T) -> (T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T, T, T), _ to: (T, T, T, T), using factor: (T, T, T, T)) -> (T, T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor.2),
        from.3.unclampedLinearInterpolate(to: to.3, using: factor.3)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryInteger>(_ from: (T, T, T, T), _ to: (T, T, T, T), using factor: T) -> (T, T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor),
        from.3.unclampedLinearInterpolate(to: to.3, using: factor)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T, T, T), _ to: (T, T, T, T), using factor: (T, T, T, T)) -> (T, T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor.0),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor.1),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor.2),
        from.3.unclampedLinearInterpolate(to: to.3, using: factor.3)
    )
}

@inlinable
public func unclampedLinearInterpolate<T: BinaryFloatingPoint>(_ from: (T, T, T, T), _ to: (T, T, T, T), using factor: T) -> (T, T, T, T) {
    (
        from.0.unclampedLinearInterpolate(to: to.0, using: factor),
        from.1.unclampedLinearInterpolate(to: to.1, using: factor),
        from.2.unclampedLinearInterpolate(to: to.2, using: factor),
        from.3.unclampedLinearInterpolate(to: to.3, using: factor)
    )
}

extension BinaryInteger {
    
    @inlinable
    public func unclampedLinearInterpolate(to: Self, using factor: Self) -> Self {
        factor * (to - self) + self
    }
}

extension BinaryFloatingPoint {
    
    @inlinable
    public func unclampedLinearInterpolate(to: Self, using factor: Self) -> Self {
        fma(factor, to - self, self)
    }
}
