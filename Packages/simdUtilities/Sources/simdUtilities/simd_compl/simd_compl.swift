//
//  simd_compl.swift
//
//
//  Created by Ruslan Lutfullin on 17/12/22.
//

import Darwin
import simd

public struct simd_compl {
	
	@usableFromInline
	internal var storage: SIMD2<Double>
	
	public var real: Double {
		@_transparent
		get { storage.x }
		@_transparent
		set { storage.x = newValue }
	}
	
	public var imag: Double {
		@_transparent
		get { storage.y }
		@_transparent
		set { storage.y = newValue }
	}
	
	@inlinable
	internal init(_ store: SIMD2<Double>) {
		self.storage = store
	}
	
	@_transparent
	public init(real: Double, imag: Double) {
		storage = SIMD2<Double>(real, imag)
	}
}

extension simd_compl {
	
	@_transparent
    public static var zero: Self {
        .init(.zero)
    }
	
	@_transparent
    public static var one: Self {
        .init(SIMD2<Double>(1.0, 0.0))
    }
	
	@_transparent
	public static var i: Self { 
        .init(SIMD2<Double>(0.0, 1.0))
    }
	
	@_transparent
	public static var infinity: Self { 
        .init(SIMD2<Double>(.infinity, 0.0))
    }
	
	@_transparent
    public var conjugate: Self { 
        .init(real: real, imag: -imag)
    }
	
	@_transparent
    public var isFinite: Bool {
        storage.x.isFinite && storage.y.isFinite
    }
	
	@_transparent
	public var isNormal: Bool { 
        isFinite && (storage.x.isNormal || storage.y.isNormal)
    }
	
	@_transparent
    public var isZero: Bool {
        storage.x == 0.0 && storage.y == 0.0
    }
	
	@_transparent
	public var magnitude: Double {
		guard isFinite else { return .infinity }
		return abs(storage).max()
	}
	
	@_transparent
	public var argument: Double {
		guard isFinite && !isZero else { return .nan }
        return atan2(storage.y, storage.x)
	}
	
	@_transparent
	public var length: Double {
		let naive = lengthSquared
		guard naive.isNormal else { return carefulLength }
		return sqrt(naive)
	}
	
	@_transparent
	public var lengthSquared: Double {
		(storage * storage).sum()
	}
	
	public var polar: (argument: Double, length: Double) { 
        (argument, length)
    }
	
	@usableFromInline
	internal var carefulLength: Double {
		guard isFinite else { return .infinity }
		return hypot(storage.x, storage.y)
	}
}

extension simd_compl {
	
	@inlinable
	public init(_ rotationMatrix: matrix_double2x2) {
		assert(rotationMatrix[0][1] == -rotationMatrix[1][0])
		let (real, imag) = (rotationMatrix[0][0], rotationMatrix[1][0])
		assert(real * real + imag * imag == 1.0)
		self.init(real: real, imag: imag)
	}
	
	@inlinable
	public init(_ rotationMatrix: matrix_double3x3) {
		assert(rotationMatrix[0][1] == -rotationMatrix[1][0])
		let (real, imag) = (rotationMatrix[0][0], rotationMatrix[1][0])
		assert(real * real + imag * imag == 1.0)
		self.init(real: real, imag: imag)
	}
}

extension simd_compl {
	
	@_transparent
	public static func + (lhs: Self, rhs: Self) -> Self {
        .init(lhs.storage + rhs.storage)
	}
	
	@_transparent
	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	
	@_transparent
	public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage - rhs.storage)
	}
	
	@_transparent
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	
	@_transparent
	prefix public static func - (rhs: Self) -> Self {
        .init(-rhs.storage)
	}
	
	@_transparent
	public static func * (lhs: Self, rhs: Self) -> Self {
        .init(SIMD2<Double>(
            lhs.storage.x * rhs.storage.x - lhs.storage.y * rhs.storage.y,
            rhs.storage.y * lhs.storage.x + lhs.storage.y * rhs.storage.y
        ))
	}
	
	@_transparent
	public static func * (lhs: Double, rhs: Self) -> Self {
        .init(lhs * rhs.storage)
	}
	
	@_transparent
	public static func * (lhs: Self, rhs: Double) -> Self {
        .init(lhs.storage * rhs)
	}
	
	@_transparent
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	
	@_transparent
	public static func *= (lhs: inout Self, rhs: Double) {
		lhs = lhs * rhs
	}
	
	@_transparent
	public static func / (lhs: Self, rhs: Self) -> Self {
		let lenSq = rhs.lengthSquared
		guard lenSq.isNormal else { return rescaledDivide(lhs: lhs, rhs: rhs) }
		return lhs * (rhs.conjugate / lenSq)
	}
	
	@_transparent
	public static func / (lhs: Self, rhs: Double) -> Self {
        .init(lhs.storage / rhs)
	}
	
	@_transparent
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
	
	@_transparent
	public static func /= (lhs: inout Self, rhs: Double) {
		lhs = lhs / rhs
	}
	
	@inlinable
	public var normalized: Self? {
		if length.isNormal { return self / length }
		if isZero || !isFinite { return nil }
		return (self / magnitude).normalized
	}
	
	@usableFromInline
	@_alwaysEmitIntoClient
	@inline(never)
	internal static func rescaledDivide(lhs: Self, rhs: Self) -> Self {
		if rhs.isZero { return .infinity }
		if lhs.isZero || !rhs.isFinite { return .zero }
		let zScale = lhs.magnitude
		let wScale = rhs.magnitude
		let zNorm = lhs / zScale
		let wNorm = rhs / wScale
		let r = (zNorm * wNorm.conjugate) / wNorm.lengthSquared
		if (zScale / wScale).isNormal { return r * (zScale / wScale) }
		if (r.magnitude * zScale).isNormal { return (r * zScale) / wScale }
		return (r / wScale) * zScale
	}
}
