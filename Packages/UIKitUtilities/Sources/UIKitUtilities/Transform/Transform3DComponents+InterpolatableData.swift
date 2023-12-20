//
//  Transform3DComponents+InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 13/04/23.
//

import SwiftUtilities
import simd

extension Transform3DComponents: InterpolatableData {
    
    public func mixed(with other: Self, using factor: Double) -> Self {
        .init(
            uniformScaleFactor: uniformScaleFactor.unclampedLinearInterpolate(to: other.uniformScaleFactor, using: factor),
            scaleFactors: mix(scaleFactors, other.scaleFactors, t: factor),
            shearFactors: mix(shearFactors, other.shearFactors, t: factor),
            rotationQuaternion: simd_slerp(rotationQuaternion, other.rotationQuaternion, factor),
            reflectionFactors: mix(reflectionFactors, other.reflectionFactors, t: factor),
            translationFactors: mix(translationFactors, other.translationFactors, t: factor),
            projectionFactors: mix(projectionFactors, other.projectionFactors, t: factor)
        )
    }
}
