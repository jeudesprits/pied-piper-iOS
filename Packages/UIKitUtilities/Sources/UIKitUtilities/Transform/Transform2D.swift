//
//  Transform2D.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/22.
//

import UIKit
import simd

public struct Transform2D {
    
    internal let m: matrix_double3x3
    
    internal init(_ m: matrix_double3x3) {
        self.m = m
    }
}

extension Transform2D {
    
    public var matrix: matrix_double3x3 { m }
}

extension Transform2D {
    
    public func uniformScaled(by scaleFactor: Double) -> Self {
        concatenating(with: .init(uniformScale: scaleFactor))
    }
    
    public func scaled(by scaleFactors: CGSize) -> Self {
        concatenating(with: .init(scale: scaleFactors))
    }
    
    public func sheared(along shearAxisWithFactor: ShearAxisWithFactor) -> Self {
        concatenating(with: .init(shear: shearAxisWithFactor))
    }
    
    public func sheared(along shearAxisWithAngle: ShearAxisWithAngle) -> Self {
        concatenating(with: .init(shear: shearAxisWithAngle))
    }
    
    public func rotated(byAngle angle: Double) -> Self {
        concatenating(with: .init(rotation: angle))
    }
    
    public func rotated(byAngle angle: Double, about arbitraryPoint: CGPoint) -> Self {
        concatenating(with: .init(rotation: angle, arbitraryPoint: arbitraryPoint))
    }
    
    public func reflected(through reflectionAxis: ReflectionAxis) -> Self {
        concatenating(with: .init(reflection: reflectionAxis))
    }
    
    public func reflected(through reflectionArbitraryAxis: ReflectionArbitraryAxis) -> Self {
        concatenating(with: .init(reflection: reflectionArbitraryAxis))
    }
    
    public func translated(by translationFactors: CGVector) -> Self {
        concatenating(with: .init(translation: translationFactors))
    }
    
    public func concatenating(with transform: Self) -> Self {
        .init(transform.m * m)
    }
    
    public func inverted() -> Self {
        .init(m.inverse)
    }
}

extension Transform2D {
    
    public static var identity: Self {
        .init(matrix_identity_double3x3)
    }
    
    public init(uniformScale scaleFactor: CGFloat) {
        let s = scaleFactor
        assert(s >= 0.0)
        m = simd_double3x3(
            SIMD3(1.0, 0.0, 0.0),
            SIMD3(0.0, 1.0, 0.0),
            SIMD3(0.0, 0.0, s)
        )
    }
    
    public init(scale scaleFactors: CGSize) {
        let (sx, sy) = (scaleFactors.width, scaleFactors.height)
        assert(sx >= 0.0 && sy >= 0.0)
        m = matrix_double3x3(
            SIMD3(sx,  0.0, 0.0),
            SIMD3(0.0, sy,  0.0),
            SIMD3(0.0, 0.0, 1.0)
        )
    }
    
    public init(shear shearAxisWithFactor: ShearAxisWithFactor) {
        switch shearAxisWithFactor {
        case let .xAxis(factor):
            m = matrix_double3x3(
                SIMD3(1.0, factor, 0.0),
                SIMD3(0.0, 1.0,    0.0),
                SIMD3(0.0, 0.0,    1.0)
            )
            
        case let .yAxis(factor):
            m = matrix_double3x3(
                SIMD3(1.0,    0.0, 0.0),
                SIMD3(factor, 1.0, 0.0),
                SIMD3(0.0,    0.0, 1.0)
            )
        }
    }
    
    public init(shear shearAxisWithAngle: ShearAxisWithAngle) {
        switch shearAxisWithAngle {
        case let .xAxis(angle):
            let factor = tan(angle)
            m = matrix_double3x3(
                SIMD3(1.0, factor, 0.0),
                SIMD3(0.0, 1.0,    0.0),
                SIMD3(0.0, 0.0,    1.0)
            )
            
        case let .yAxis(angle):
            let factor = tan(angle)
            m = matrix_double3x3(
                SIMD3(1.0,    0.0, 0.0),
                SIMD3(factor, 1.0, 0.0),
                SIMD3(0.0,    0.0, 1.0)
            )
        }
    }
    
    public init(rotation rotationAngle: CGFloat) {
        let (cosθ, sinθ) = (cos(rotationAngle), sin(rotationAngle))
        m = matrix_double3x3(
            SIMD3(cosθ, -sinθ, 0.0),
            SIMD3(sinθ,  cosθ, 0.0),
            SIMD3(0.0,   0.0,  1.0)
        )
    }
    
    public init(rotation rotationAngle: CGFloat, arbitraryPoint: CGPoint) {
        let (x0, y0) = (arbitraryPoint.x, arbitraryPoint.y)
        let (cosθ, sinθ) = (cos(rotationAngle), sin(rotationAngle))
        m = matrix_double3x3(
            SIMD3(cosθ, -sinθ, -x0 * (cosθ - 1.0) + y0 * sinθ),
            SIMD3(sinθ,  cosθ, -y0 * (cosθ - 1.0) - x0 * sinθ),
            SIMD3(0.0,   0.0,   1.0)
        )
    }
    
    public init(reflection reflectionAxis: ReflectionAxis) {
        switch reflectionAxis {
        case .xAxis:
            m = matrix_double3x3(
                SIMD3(1.0,  0.0, 0.0),
                SIMD3(0.0, -1.0, 0.0),
                SIMD3(0.0,  0.0, 1.0)
            )
        case .yAxis:
            m = matrix_double3x3(
                SIMD3(-1.0, 0.0, 0.0),
                SIMD3( 0.0, 1.0, 0.0),
                SIMD3( 0.0, 0.0, 1.0)
            )
        }
    }
    
    public init(reflection reflectionArbitraryAxis: ReflectionArbitraryAxis) {
        let (cx, cy) = (reflectionArbitraryAxis.normal.dx, reflectionArbitraryAxis.normal.dy)
        let k = -cx / cy
        let angle = -atan(k)
        let (cosθ, sinθ) = (cos(angle), sin(angle))
        let tm = matrix_double3x3(
            SIMD3(1.0, 0.0, -cx),
            SIMD3(0.0, 1.0, -cy),
            SIMD3(0.0, 0.0, 1.0)
        )
        let rm = matrix_double3x3(
            SIMD3(cosθ, -sinθ, 0.0),
            SIMD3(sinθ,  cosθ, 0.0),
            SIMD3(0.0,   0.0,  1.0)
        )
        let rflm = matrix_double3x3(
            SIMD3(1.0,  0.0, 0.0),
            SIMD3(0.0, -1.0, 0.0),
            SIMD3(0.0,  0.0, 1.0)
        )
        m = tm * rm * rflm * rm.inverse * tm.inverse
    }
    
    public init(translation translationFactors: CGVector) {
        let (tx, ty) = (translationFactors.dx, translationFactors.dy)
        m = matrix_double3x3(
            SIMD3(1.0, 0.0, tx),
            SIMD3(0.0, 1.0, ty),
            SIMD3(0.0, 0.0, 1.0)
        )
    }
}

extension Transform2D {
    
    public init(_ cgAffineTransform: CGAffineTransform) {
        m = matrix_double3x3(
            SIMD3(cgAffineTransform.a, cgAffineTransform.c, cgAffineTransform.tx),
            SIMD3(cgAffineTransform.b, cgAffineTransform.d, cgAffineTransform.ty),
            SIMD3(0.0,                 0.0,                 1.0)
        )
    }
    
    public var cgAffineTransform: CGAffineTransform {
        .init(a: m[0][0], b: m[1][0], c: m[0][1], d: m[1][1], tx: m[0][2], ty: m[1][2])
    }
}

extension Transform2D {
    
    public var components: Transform2DComponents { .init(self) }
    
    public init(components: Transform2DComponents) {
        let usm = components.uniformScale
        let tm = components.translation
        let rm = components.rotation
        let hm = components.shear
        let sm = components.scale
        let rflm = components.reflection
        m = rflm * sm * hm * rm * tm * usm
    }
}

extension Transform2D {
    
    public enum ShearAxisWithFactor {
        case xAxis(shearFactor: CGFloat)
        case yAxis(shearFactor: CGFloat)
    }
    
    public enum ShearAxisWithAngle {
        case xAxis(shearAngle: CGFloat)
        case yAxis(shearAngle: CGFloat)
    }
}

extension Transform2D {
    
    public enum ReflectionAxis {
        case xAxis
        case yAxis
    }
}

extension Transform2D {
    
    public struct ReflectionArbitraryAxis {
        public var origin: CGPoint
        public var normal: CGVector
        
        public init(origin: CGPoint, normal: CGVector) {
            self.origin = origin
            self.normal = normal
        }
    }
}
