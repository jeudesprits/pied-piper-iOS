//
//  Transform3DComponents.swift
//
//
//  Created by Ruslan Lutfullin on 08/12/22.
//

import UIKit
import simd

public struct Transform3DComponents {
	
	public let uniformScaleFactor: Double
	
	public let scaleFactors: SIMD3<Double>
	
	public let shearFactors: SIMD3<Double>
	
	public let rotationQuaternion: simd_quatd
	
	public let reflectionFactors: SIMD3<Double>
	
	public let translationFactors: SIMD3<Double>
	
	public let projectionFactors: SIMD3<Double>
	
	public init(
		uniformScaleFactor: Double = 1.0,
		scaleFactors: SIMD3<Double> = .one,
		shearFactors: SIMD3<Double> = .zero,
		rotationQuaternion: simd_quatd = simd_quatd(),
		reflectionFactors: SIMD3<Double> = .one,
		translationFactors: SIMD3<Double> = .zero,
		projectionFactors: SIMD3<Double> = .zero
	) {
		self.uniformScaleFactor = uniformScaleFactor
		self.scaleFactors = scaleFactors
		self.shearFactors = shearFactors
		self.rotationQuaternion = rotationQuaternion
		self.reflectionFactors = reflectionFactors
		self.translationFactors = translationFactors
		self.projectionFactors = projectionFactors
	}
	
	public init(_ transform: Transform3D) {
		let A = transform.matrix.transpose
		let m = matrix_double3x3(
			A[0].dropLast,
			A[1].dropLast,
			A[2].dropLast
		)
		let det = m.determinant
		assert(det != 0, "uninvertable subtransformation")
		
		// Projection
		let (wx, wy, wz, ww) = (A[0][3], A[1][3], A[2][3], A[3][3])
		let stim = m.transpose.inverse
		let w = stim * SIMD3(wx, wy, wz)
		projectionFactors = SIMD3(w)
		
		// Uniform Scale
		uniformScaleFactor = ww - simd_dot(w, SIMD3(A[3][0], A[3][1], A[3][2]))
		
		// Translation
		translationFactors = A[3].dropLast
		
		// Rotation
		let mTm = m.transpose * m
		let a = det < 0 ? -sqrt(mTm[0][0]) : +sqrt(mTm[0][0])
		let d = mTm[1][0] / a
		let e = mTm[2][0] / a
		let b = det < 0 ? -sqrt(mTm[1][1] - d * d) : +sqrt(mTm[1][1] - d * d)
		let f = (mTm[2][1] - d * e) / b
		let c = det < 0 ? -sqrt(mTm[2][2] - e * e - f * f) : +sqrt(mTm[2][2] - e * e - f * f)
		let ssim = matrix_double3x3(
			.init(a, 0.0, 0.0),
			.init(d, b,   0.0),
			.init(e, f,   c)
		).inverse
		let rm = m * ssim
		rotationQuaternion = simd_quatd(rm)
		
		// Shear
		shearFactors = SIMD3(d / b, e / c, f / c)
		
		// Scale
		let s = SIMD3(a, b, c)
		scaleFactors = simd_abs(s)
		
		// Reflection
		reflectionFactors = simd_sign(s)
	}
}

extension Transform3DComponents {
	
	public var uniformScale: matrix_double4x4 {
		let s = uniformScaleFactor
		return matrix_double4x4(
			SIMD4(1.0, 0.0, 0.0, 0.0),
			SIMD4(0.0, 1.0, 0.0, 0.0),
			SIMD4(0.0, 0.0, 1.0, 0.0),
			SIMD4(0.0, 0.0, 0.0, s)
		)
	}
	
	public var scale: matrix_double4x4 {
		let (sx, sy, sz) = (scaleFactors.x, scaleFactors.y, scaleFactors.z)
		return matrix_double4x4(
            SIMD4(sx,  0.0, 0.0, 0.0),
            SIMD4(0.0, sy,  0.0, 0.0),
            SIMD4(0.0, 0.0, sz,  0.0),
            SIMD4(0.0, 0.0, 0.0, 1.0)
		)
	}
	
	public var shear: matrix_double4x4 {
		let (hx, hy, hz) = (shearFactors.x, shearFactors.y, shearFactors.z)
		return matrix_double4x4(
            SIMD4(1.0, hx,  hy,  0.0),
            SIMD4(0.0, 1.0, hz,  0.0),
            SIMD4(0.0, 0.0, 1.0, 0.0),
            SIMD4(0.0, 0.0, 0.0, 1.0)
		)
	}
	
	public var rotation: matrix_double4x4 {
        matrix_double4x4(rotationQuaternion).transpose
	}
	
	public var reflection: matrix_double4x4 {
		let (rflx, rfly, rflz) = (reflectionFactors.x, reflectionFactors.y, reflectionFactors.z)
		return matrix_double4x4(
            SIMD4(rflx, 0.0,  0.0,  0.0),
            SIMD4(0.0,  rfly, 0.0,  0.0),
            SIMD4(0.0,  0.0,  rflz, 0.0),
            SIMD4(0.0,  0.0,  0.0,  1.0)
		)
	}
	
	public var translation: matrix_double4x4 {
		let (tx, ty, tz) = (translationFactors.x, translationFactors.y, translationFactors.z)
		return matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, tx),
            SIMD4(0.0, 1.0, 0.0, ty),
            SIMD4(0.0, 0.0, 1.0, tz),
            SIMD4(0.0, 0.0, 0.0, 1.0)
		)
	}
	
	public var projection: matrix_double4x4 {
		let (px, py, pz) = (projectionFactors.x, projectionFactors.y, projectionFactors.z)
		return matrix_double4x4(
            SIMD4(1.0, 0.0, 0.0, 0.0),
            SIMD4(0.0, 1.0, 0.0, 0.0),
            SIMD4(0.0, 0.0, 1.0, 0.0),
            SIMD4(px,  py,  pz,  1.0)
		)
	}
}
