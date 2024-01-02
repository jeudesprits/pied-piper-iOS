//
//  EaseAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

import TimingFunctions

public protocol EaseAnimation: Animation {
	
	static var defaultEase: Self { get }
	
	static func defaultEase(duration: Double) -> Self
	
	static func linearEase(duration: Double) -> Self
	
	static func quadraticEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func cubicEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func cubicBezierEase(duration: Double, controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Self
	
	static func quarticEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func quinticEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func sineEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func circularEase(duration: Double, mode: EaseAnimationMode) -> Self
	
	static func swingEase(duration: Double) -> Self
}

extension EaseAnimation {
	
	public static var defaultEase: Self {
		.defaultEase(duration: 0.25)
	}
	
	public static func swingEase(duration: Double) -> Self {
		return quadraticEase(duration: duration, mode: .out)
	}
}

public enum EaseAnimationMode {
	case `in`
	case out
	case `inout`
}

extension EaseAnimationMode {
	
	internal var rawValue: EaseMode {
		switch self {
		case .in:
			return .in
		case .out:
			return .out
		case .inout:
			return .inout
		}
	}
}

extension EaseAnimationMode {
}
