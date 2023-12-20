//
//  Transform2DComponents.swift
//
//
//  Created by Ruslan Lutfullin on 08/12/22.
//

import simd
import simdUtilities

public struct Transform2DComponents {
    
    public let uniformScaleFactor: Double
    
    public let scaleFactors: SIMD2<Double>
    
    public let shearFactor: Double
    
    public let rotationComplex: simd_compl
    
    public let reflectionFactors: SIMD2<Double>
    
    public let translationFactors: SIMD2<Double>
    
    public init(
        uniformScaleFactor: Double = 1.0,
        scaleFactors: SIMD2<Double> = .one,
        shearFactor: Double = 0.0,
        rotationComplex: simd_compl = .init(real: 1.0, imag: 0.0),
        reflectionFactors: SIMD2<Double> = .one,
        translationFactors: SIMD2<Double> = .zero
    ) {
        self.uniformScaleFactor = uniformScaleFactor
        self.scaleFactors = scaleFactors
        self.shearFactor = shearFactor
        self.rotationComplex = rotationComplex
        self.reflectionFactors = reflectionFactors
        self.translationFactors = translationFactors
    }
    
    public init(_ transform: Transform2D) {
        let A = transform.matrix.transpose
        let det = A.determinant
        assert(det != 0.0, "Uninvertable transformation")
        
        // Uniform Scale
        uniformScaleFactor = A[2][2]
        
        // Translation
        translationFactors = SIMD2(A[2].dropLast)
        
        // Rotation
        let m = matrix_double2x2(
            A[0].dropLast,
            A[1].dropLast
        )
        let mTm = m.transpose * m
        let a = det < 0 ? -sqrt(mTm[0][0]) : +sqrt(mTm[0][0])
        let d = mTm[1][0] / a
        let b: Double = sqrt(mTm[1][1] - d * d)
        let ssm = matrix_double2x2(SIMD2(a, 0.0), SIMD2(d, b))
        let rm = m * ssm.inverse
        rotationComplex = simd_compl(real: rm[0][0], imag: rm[0][1])
        
        // Shear
        let k = d / b
        shearFactor = k
        
        // Scale
        let s = SIMD2(a, b)
        scaleFactors = simd_abs(s)
        
        // Reflection
        reflectionFactors = simd_sign(s)
    }
}

extension Transform2DComponents {
    
    public var uniformScale: matrix_double3x3 {
        let s = uniformScaleFactor
        return matrix_double3x3(
            SIMD3(1.0, 0.0, 0.0),
            SIMD3(0.0, 1.0, 0.0),
            SIMD3(0.0, 0.0, s)
        )
    }
    
    public var scale: matrix_double3x3 {
        let (sx, sy) = (scaleFactors.x, scaleFactors.y)
        return matrix_double3x3(
            SIMD3(sx,  0.0, 0.0),
            SIMD3(0.0, sy,  0.0),
            SIMD3(0.0, 0.0, 1.0)
        )
    }
    
    public var shear: matrix_double3x3 {
        let h = shearFactor
        return matrix_double3x3(
            SIMD3(1.0, h,   0.0),
            SIMD3(0.0, 1.0, 0.0),
            SIMD3(0.0, 0.0, 1.0)
        )
    }
    
    public var rotation: matrix_double3x3 {
        return matrix_double3x3(rotationComplex)
    }
    
    public var reflection: matrix_double3x3 {
        let (rflx, rfly) = (reflectionFactors.x, reflectionFactors.y)
        return matrix_double3x3(
            SIMD3(rflx, 0.0,  0.0),
            SIMD3(0.0,  rfly, 0.0),
            SIMD3(0.0,  0.0,  1.0)
        )
    }
    
    public var translation: matrix_double3x3 {
        let (tx, ty) = (translationFactors.x, translationFactors.y)
        return matrix_double3x3(
            SIMD3(1.0, 0.0, tx),
            SIMD3(0.0, 1.0, ty),
            SIMD3(0.0, 0.0, 1.0)
        )
    }
}
