//
//  simd_compl+slerp.swift
//
//
//  Created by Ruslan Lutfullin on 17/12/22.
//

import Darwin
import simd

public func simd_slerp(_ c0: simd_compl, _ c1: simd_compl, _ t: Double) -> simd_compl {
	var dot = simd_dot(c0.storage, c1.storage)
	if dot > 0.9995 {
		return (c0 + (c1 - c0) * t).normalized.unsafelyUnwrapped
	}
	dot = simd_clamp(dot, -1.0, 1.0)
	let θ = acos(dot) * t
	let c2 = (c1 - c0 * dot).normalized.unsafelyUnwrapped
	return c0 * cos(θ) + c2 * sin(θ)
}
