//
//  simd_compl+matrix.swift
//
//
//  Created by Ruslan Lutfullin on 17/12/22.
//

import simd

extension matrix_double2x2 {
    
    @inlinable
    public init(_ complex: simd_compl) {
        self.init(
            SIMD2<Double>(complex.real, -complex.imag),
            SIMD2<Double>(complex.imag,  complex.real)
        )
    }
}

extension matrix_double3x3 {
    
    @inlinable
    public init(_ complex: simd_compl) {
        self.init(
            SIMD3<Double>(complex.real, -complex.imag, 0.0),
            SIMD3<Double>(complex.imag,  complex.real, 0.0),
            SIMD3<Double>(0.0,           0.0,          1.0)
        )
    }
}
