//
//  matrix+DropLast.swift
//
//
//  Created by Ruslan Lutfullin on 17/12/22.
//

import simd

extension matrix_double3x3 {
	
	@inlinable
    public var dropLast: matrix_double2x2 {
        .init(self[0].dropLast, self[1].dropLast)
    }
}

extension matrix_double4x4 {
	
	@inlinable
    public var dropLast: matrix_double3x3 {
        .init(self[0].dropLast, self[1].dropLast, self[2].dropLast)
    }
}
