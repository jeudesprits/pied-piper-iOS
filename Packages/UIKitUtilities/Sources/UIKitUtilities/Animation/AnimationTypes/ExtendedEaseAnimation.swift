//
//  ExtendedEaseAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

///
public protocol ExtendedEaseAnimation: EaseAnimation {
	
	static func exponentialEase(duration: Double, mode: EaseAnimationMode, exponent: Double) -> Self
	
	static func backEase(duration: Double, mode: EaseAnimationMode, amplitude: Double) -> Self
	
	static func elasticEase(duration: Double, mode: EaseAnimationMode, oscillations: Int, springiness: Double) -> Self
	
	static func bounceEase(duration: Double, mode: EaseAnimationMode, bounces: Int, bounciness: Double) -> Self
}
