//
//  Transform3DComponents+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 23/08/23.
//

extension Transform3DComponents: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uniformScaleFactor == rhs.uniformScaleFactor &&
		lhs.scaleFactors == rhs.scaleFactors &&
		lhs.shearFactors == rhs.shearFactors &&
		lhs.rotationQuaternion == rhs.rotationQuaternion &&
		lhs.reflectionFactors == rhs.reflectionFactors &&
		lhs.translationFactors == rhs.translationFactors &&
		lhs.projectionFactors == rhs.projectionFactors
	}
}

extension Transform3DComponents: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(uniformScaleFactor)
		hasher.combine(scaleFactors)
		hasher.combine(shearFactors)
		if #available(iOS 17.0, *) {
			hasher.combine(rotationQuaternion)
		} else {
			hasher.combine(rotationQuaternion.vector)
		}
		hasher.combine(reflectionFactors)
		hasher.combine(translationFactors)
		hasher.combine(projectionFactors)
	}
}
