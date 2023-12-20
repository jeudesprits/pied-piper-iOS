//
//  Transform2DComponents+InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 13/04/23.
//

import SwiftUtilities
import simd
import simdUtilities

extension Transform2DComponents: InterpolatableData {
    
    public func mixed(with other: Self, using factor: Double) -> Self {
        .init(
            uniformScaleFactor: uniformScaleFactor.unclampedLinearInterpolate(to: other.uniformScaleFactor, using: factor),
            scaleFactors: mix(scaleFactors, other.scaleFactors, t: factor),
            shearFactor: shearFactor.unclampedLinearInterpolate(to: other.shearFactor, using: factor),
            rotationComplex: simd_slerp(rotationComplex, other.rotationComplex, factor),
            reflectionFactors: mix(reflectionFactors, other.reflectionFactors, t: factor),
            translationFactors: mix(translationFactors, other.translationFactors, t: factor)
        )
    }
}
