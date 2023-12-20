//
//  Transform3D.swift
//
//
//  Created by Ruslan Lutfullin on 20/11/22.
//

import UIKit
import simd

public struct Transform3D {
    
    internal let m: matrix_double4x4
    
    internal init(_ m: matrix_double4x4) {
        self.m = m
    }
}

extension Transform3D {
    
    public var matrix: matrix_double4x4 { m }
}

extension Transform3D {
    
    public static var identity: Self {
        .init(matrix_identity_double4x4)
    }
    
    public init(uniformScale scaleFactor: Double) {
        let s = scaleFactor
        assert(s >= 0.0)
        m = matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, 0.0),
            SIMD4(0.0, 1.0, 0.0, 0.0),
            SIMD4(0.0, 0.0, 1.0, 0.0),
            SIMD4(0.0, 0.0, 0.0, s == 0.0 ? 0.0 : 1.0 / s)
        )
    }
    
    public init(scale scaleFactors: CGSize3D) {
        let (sx, sy, sz) = (scaleFactors.width, scaleFactors.height, scaleFactors.depth)
        assert(sx >= 0.0 && sy >= 0.0 && sz >= 0.0)
        m = matrix_double4x4(
            SIMD4(sx,  0.0, 0.0, 0.0),
            SIMD4(0.0, sy,  0.0, 0.0),
            SIMD4(0.0, 0.0, sz,  0.0),
            SIMD4(0.0, 0.0, 0.0, 1.0)
        )
    }
    
    public init(shear shearAxisWithFactors: ShearAxisWithFactors) {
        switch shearAxisWithFactors {
        case let .xAxis(yShearFactor, zShearFactor):
            m = matrix_double4x4(
                SIMD4(1.0, yShearFactor, zShearFactor, 0.0),
                SIMD4(0.0, 1.0,          0.0,          0.0),
                SIMD4(0.0, 0.0,          1.0,          0.0),
                SIMD4(0.0, 0.0,          0.0,          1.0)
            )
            
        case let .yAxis(xShearFactor, zShearFactor):
            m = matrix_double4x4(
                SIMD4(1.0,          0.0, 0.0,          0.0),
                SIMD4(xShearFactor, 1.0, zShearFactor, 0.0),
                SIMD4(0.0,          0.0, 1.0,          0.0),
                SIMD4(0.0,          0.0, 0.0,          1.0)
            )
            
        case let .zAxis(xShearFactor, yShearFactor):
            m = matrix_double4x4(
                SIMD4(1.0,          0.0,          0.0, 0.0),
                SIMD4(0.0,          1.0,          0.0, 0.0),
                SIMD4(xShearFactor, yShearFactor, 1.0, 0.0),
                SIMD4(0.0,          0.0,          0.0, 1.0)
            )
        }
    }
    
    public init(shear shearAxisWithAngles: ShearAxisWithAngles) {
        switch shearAxisWithAngles {
        case let .xAxis(yShearAngle, zShearAngle):
            let (yShearFactor, zShearFactor) = (tan(yShearAngle), tan(zShearAngle))
            m = matrix_double4x4(
                SIMD4(1.0, yShearFactor, zShearFactor, 0.0),
                SIMD4(0.0, 1.0,          0.0,          0.0),
                SIMD4(0.0, 0.0,          1.0,          0.0),
                SIMD4(0.0, 0.0,          0.0,          1.0)
            )
            
        case let .yAxis(xShearAngle, zShearAngle):
            let (xShearFactor, zShearFactor) = (tan(xShearAngle), tan(zShearAngle))
            m = matrix_double4x4(
                SIMD4(1.0,          0.0, 0.0,          0.0),
                SIMD4(xShearFactor, 1.0, zShearFactor, 0.0),
                SIMD4(0.0,          0.0, 1.0,          0.0),
                SIMD4(0.0,          0.0, 0.0,          1.0)
            )
            
        case let .zAxis(xShearAngle, yShearAngle):
            let (xShearFactor, yShearFactor) = (tan(xShearAngle), tan(yShearAngle))
            m = matrix_double4x4(
                SIMD4(1.0,          0.0,          0.0, 0.0),
                SIMD4(0.0,          1.0,          0.0, 0.0),
                SIMD4(xShearFactor, yShearFactor, 1.0, 0.0),
                SIMD4(0.0,          0.0,          0.0, 1.0)
            )
        }
    }
    
    public init(rotation rotationAngle: Double, rotationAxis: RotationAxis) {
        let (cosθ, sinθ) = (cos(rotationAngle), sin(rotationAngle))
        switch rotationAxis {
        case .xAxis:
            m = matrix_double4x4(
                SIMD4(1.0, 0.0,   0.0,  0.0),
                SIMD4(0.0, cosθ, -sinθ, 0.0),
                SIMD4(0.0, sinθ,  cosθ, 0.0),
                SIMD4(0.0, 0.0,   0.0,  1.0)
            )
        case .yAxis:
            m = matrix_double4x4(
                SIMD4( cosθ, 0.0, sinθ, 0.0),
                SIMD4( 0.0,  1.0, 0.0,  0.0),
                SIMD4(-sinθ, 0.0, cosθ, 0.0),
                SIMD4( 0.0,  0.0, 0.0,  1.0)
            )
        case .zAxis:
            m = matrix_double4x4(
                SIMD4(cosθ, -sinθ, 0.0, 0.0),
                SIMD4(sinθ,  cosθ, 0.0, 0.0),
                SIMD4(0.0,   0.0,  1.0, 0.0),
                SIMD4(0.0,   0.0,  0.0, 1.0)
            )
        }
    }
    
    public init(rotation rotationAngle: Double, rotationArbitraryAxis: RotationArbitraryAxis) {
        let (x0, y0, z0) = (rotationArbitraryAxis.origin.x, rotationArbitraryAxis.origin.y, rotationArbitraryAxis.origin.z)
        let (cx, cy, cz) = (rotationArbitraryAxis.direction.dx, rotationArbitraryAxis.direction.dy, rotationArbitraryAxis.direction.dz)
        let d = hypot(cy, cz)
        
        let tm = matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, -x0),
            SIMD4(0.0, 1.0, 0.0, -y0),
            SIMD4(0.0, 0.0, 1.0, -z0),
            SIMD4(0.0, 0.0, 0.0,  1.0)
        )
        let rxm = matrix_double4x4(
            SIMD4(1.0, 0.0,     0.0,    0.0),
            SIMD4(0.0, cz / d, -cy / d, 0.0),
            SIMD4(0.0, cy / d,  cz / d, 0.0),
            SIMD4(0.0, 0.0,     0.0,    1.0)
        )
        let rym = matrix_double4x4(
            SIMD4(d,   0.0, -cx,  0.0),
            SIMD4(0.0, 1.0,  0.0, 0.0),
            SIMD4(cx,  0.0,  d,   0.0),
            SIMD4(0.0, 0.0,  0.0, 1.0)
        )
        
        let (cosδ, sinδ) = (cos(rotationAngle), sin(rotationAngle))
        let rzm = matrix_double4x4(
            SIMD4(-cosδ, -sinδ, 0.0, 0.0),
            SIMD4( sinδ,  cosδ, 0.0, 0.0),
            SIMD4( 0.0,   0.0,  1.0, 0.0),
            SIMD4( 0.0,   0.0,  0.0, 1.0)
        )
        
        m = tm * rxm * rym * rzm * rym.inverse * rxm.inverse * tm.inverse
    }
    
    public init(reflection reflectionAxisPlane: ReflectionAxisPlane) {
        switch reflectionAxisPlane {
        case .xyPlane:
            m = matrix_double4x4(
                SIMD4(1.0, 0.0,  0.0, 0.0),
                SIMD4(0.0, 1.0,  0.0, 0.0),
                SIMD4(0.0, 0.0, -1.0, 0.0),
                SIMD4(0.0, 0.0,  0.0, 1.0)
            )
        case .yzPlane:
            m = matrix_double4x4(
                SIMD4(-1.0, 0.0, 0.0, 0.0),
                SIMD4( 0.0, 1.0, 0.0, 0.0),
                SIMD4( 0.0, 0.0, 1.0, 0.0),
                SIMD4( 0.0, 0.0, 0.0, 1.0)
            )
        case .xzPlane:
            m = matrix_double4x4(
                SIMD4(1.0,  0.0, 0.0, 0.0),
                SIMD4(0.0, -1.0, 0.0, 0.0),
                SIMD4(0.0,  0.0, 1.0, 0.0),
                SIMD4(0.0,  0.0, 0.0, 1.0)
            )
        }
    }
    
    public init(reflection reflectionArbitraryAxisPlane: ReflectionArbitraryAxisPlane) {
        let (x0, y0, z0) = (reflectionArbitraryAxisPlane.origin.x, reflectionArbitraryAxisPlane.origin.y, reflectionArbitraryAxisPlane.origin.z)
        let (cx, cy, cz) = (reflectionArbitraryAxisPlane.normal.dx, reflectionArbitraryAxisPlane.normal.dy, reflectionArbitraryAxisPlane.normal.dz)
        let d = hypot(cy, cz)
        
        let tm = matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, -x0),
            SIMD4(0.0, 1.0, 0.0, -y0),
            SIMD4(0.0, 0.0, 1.0, -z0),
            SIMD4(0.0, 0.0, 0.0,  1.0)
        )
        let rxm = matrix_double4x4(
            SIMD4(1.0, 0.0,     0.0,    0.0),
            SIMD4(0.0, cz / d, -cy / d, 0.0),
            SIMD4(0.0, cy / d,  cz / d, 0.0),
            SIMD4(0.0, 0.0,     0.0,    1.0)
        )
        let rym = matrix_double4x4(
            SIMD4(d,   0.0, -cx,  0.0),
            SIMD4(0.0, 1.0,  0.0, 0.0),
            SIMD4(cx,  0.0,  d,   0.0),
            SIMD4(0.0, 0.0,  0.0, 1.0)
        )
        let rflzm = matrix_double4x4(
            SIMD4(1.0, 0.0,  0.0, 0.0),
            SIMD4(0.0, 1.0,  0.0, 0.0),
            SIMD4(0.0, 0.0, -1.0, 0.0),
            SIMD4(0.0, 0.0,  0.0, 1.0)
        )
        
        m = tm * rxm * rym * rflzm * rym.inverse * rxm.inverse * tm.inverse
    }
    
    public init(translation translationFactors: CGVector3D) {
        let (tx, ty, tz) = (translationFactors.dx, translationFactors.dy, translationFactors.dz)
        m = matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, tx),
            SIMD4(0.0, 1.0, 0.0, ty),
            SIMD4(0.0, 0.0, 1.0, tz),
            SIMD4(0.0, 0.0, 0.0, 1.0)
        )
    }
}

extension Transform3D {
    
    public func uniformScaled(by scaleFactor: Double) -> Self {
        concatenating(with: .init(uniformScale: scaleFactor))
    }
    
    public func scaled(by scaleFactors: CGSize3D) -> Self {
        concatenating(with: .init(scale: scaleFactors))
    }
    
    public func sheared(along shearAxisWithFactors: ShearAxisWithFactors) -> Self {
        concatenating(with: .init(shear: shearAxisWithFactors))
    }
    
    public func sheared(along shearAxisWithAngles: ShearAxisWithAngles) -> Self {
        concatenating(with: .init(shear: shearAxisWithAngles))
    }
    
    public func rotated(byAngle angle: Double, about rotationAxis: RotationAxis) -> Self {
        concatenating(with: .init(rotation: angle, rotationAxis: rotationAxis))
    }
    
    public func rotated(byAngle angle: Double, about rotationArbitraryAxis: RotationArbitraryAxis) -> Self {
        concatenating(with: .init(rotation: angle, rotationArbitraryAxis: rotationArbitraryAxis))
    }
    
    public func reflected(through reflectionAxisPlane: ReflectionAxisPlane) -> Self {
        concatenating(with: .init(reflection: reflectionAxisPlane))
    }
    
    public func reflected(through reflectionArbitraryAxisPlane: ReflectionArbitraryAxisPlane) -> Self {
        concatenating(with: .init(reflection: reflectionArbitraryAxisPlane))
    }
    
    public func translated(by translationFactors: CGVector3D) -> Self {
        concatenating(with: .init(translation: translationFactors))
    }
    
    public func inverted() -> Self {
        .init(m.inverse)
    }
    
    public func concatenating(with transform: Self) -> Self {
        .init(transform.m * m)
    }
    
    public func applyingPerspective(eyeDistance distance: Double) -> Self {
        assert(distance >= 0.0)
        guard distance != 0.0 else { return self }
        var m = m
        m[3][2] = -1.0 / distance
        return .init(m)
    }
}

extension Transform3D {
    
    public init(_ caTransform3D: CATransform3D) {
        m = .init(
            SIMD4(caTransform3D.m11, caTransform3D.m21, caTransform3D.m31, caTransform3D.m41),
            SIMD4(caTransform3D.m12, caTransform3D.m22, caTransform3D.m32, caTransform3D.m42),
            SIMD4(caTransform3D.m13, caTransform3D.m23, caTransform3D.m33, caTransform3D.m43),
            SIMD4(caTransform3D.m14, caTransform3D.m24, caTransform3D.m34, caTransform3D.m44)
        )
    }
    
    public var caTransform3D: CATransform3D {
        .init(
            m11: m[0][0], m12: m[1][0], m13: m[2][0], m14: m[3][0],
            m21: m[0][1], m22: m[1][1], m23: m[2][1], m24: m[3][1],
            m31: m[0][2], m32: m[1][2], m33: m[2][2], m34: m[3][2],
            m41: m[0][3], m42: m[1][3], m43: m[2][3], m44: m[3][3]
        )
    }
}

extension Transform3D {
    
    public var components: Transform3DComponents { .init(self) }
    
    public init(components: Transform3DComponents) {
        let pm = components.projection
        let usm = components.uniformScale
        let tm = components.translation
        let rm = components.rotation
        let hs = components.shear
        let sm = components.scale
        let rflm = components.reflection
        m = rflm * sm * hs * rm * tm * usm * pm
    }
}

extension Transform3D {
    
    public enum ShearAxisWithFactors {
        case xAxis(yShearFactor: Double, zShearFactor: Double)
        case yAxis(xShearFactor: Double, zShearFactor: Double)
        case zAxis(xShearFactor: Double, yShearFactor: Double)
    }
    
    public enum ShearAxisWithAngles {
        case xAxis(yShearAngle: Double, zShearAngle: Double)
        case yAxis(xShearAngle: Double, zShearAngle: Double)
        case zAxis(xShearAngle: Double, yShearAngle: Double)
    }
}

extension Transform3D {
    
    public enum RotationAxis {
        case xAxis
        case yAxis
        case zAxis
    }
}

extension Transform3D {
    
    public enum ReflectionAxisPlane {
        case xyPlane
        case yzPlane
        case xzPlane
    }
}

extension Transform3D {
    
    public struct RotationArbitraryAxis  {
        public let origin: CGPoint3D
        public let direction: CGVector3D
        
        public init(origin: CGPoint3D, direction: CGVector3D) {
            self.origin = origin
            self.direction = direction
        }
    }
}

extension Transform3D {
    
    public struct ReflectionArbitraryAxisPlane {
        public var origin: CGPoint3D
        public var normal: CGVector3D
        
        public init(origin: CGPoint3D, normal: CGVector3D) {
            self.origin = origin
            self.normal = normal
        }
    }
}
