//
//  Transform2DComponents+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 23/08/23.
//

extension Transform2DComponents: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uniformScaleFactor == rhs.uniformScaleFactor &&
		lhs.scaleFactors == rhs.scaleFactors &&
		lhs.shearFactor == rhs.shearFactor &&
		lhs.rotationComplex == rhs.rotationComplex &&
		lhs.reflectionFactors == rhs.reflectionFactors &&
		lhs.translationFactors == rhs.translationFactors
	}
}

extension Transform2DComponents: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(uniformScaleFactor)
		hasher.combine(scaleFactors)
		hasher.combine(shearFactor)
		hasher.combine(rotationComplex)
		hasher.combine(reflectionFactors)
		hasher.combine(translationFactors)
	}
}
