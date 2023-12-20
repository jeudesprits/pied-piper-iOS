//
//  UIView+Animation.swift
//
//
//  Created by Ruslan Lutfullin on 15/04/23.
//

import UIKit
import TimingFunctions

extension UIViewPropertyAnimator {
	
	public convenience init(animation: Animation, animations: @escaping () -> Void, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
		switch animation.animationType {
		case let .easeAnimation(duration, cubicTimingParameters):
			self.init(duration: duration, timingParameters: cubicTimingParameters)
		case let .springAnimation(settlingDuration, springTimingParameters):
			self.init(duration: settlingDuration, timingParameters: springTimingParameters)
		}
		addAnimations(animations)
		if let completion {
			addCompletion(completion)
		}
	}
	
	@discardableResult
	public static func runningPropertyAnimator(delay: TimeInterval = 0.0, animation: Animation, animations: @escaping () -> Void, completion: ((UIViewAnimatingPosition) -> Void)? = nil) -> Self {
		let `self` = UIViewPropertyAnimator(animation: animation, animations: animations, completion: completion)
		if delay == 0.0 {
			`self`.startAnimation()
		} else {
			`self`.startAnimation(afterDelay: delay)
		}
		return `self` as! Self
	}
}

///
extension UIViewPropertyAnimator {
	
	public struct Animation {
		
		public let animationType: AnimationType
		
		internal init(_ animationType: AnimationType) {
			self.animationType = animationType
		}
	}
}

extension UIViewPropertyAnimator.Animation {
	
	public enum AnimationType {
		
		case easeAnimation(duration: Double, cubicTimingParameters: UICubicTimingParameters)
		
		case springAnimation(settlingDuration: Double, springTimingParameters: UISpringTimingParameters)
	}
}

extension UIViewPropertyAnimator.Animation: EaseAnimation {
	
	public static func defaultEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init()))
	}
	
	public static func linearEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(animationCurve: .linear)))
	}
	
	public static func quadraticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.11, y: 0.00), controlPoint2: CGPoint(x: 0.50, y: 0.00))
		case .out:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.50, y: 1.00), controlPoint2: CGPoint(x: 0.89, y: 1.00))
		case .inout:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.45, y: 0.00), controlPoint2: CGPoint(x: 0.55, y: 1.00))
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
	
	public static func cubicEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(animationCurve: .easeIn)
		case .out:
			cubicTimingParameters = .init(animationCurve: .easeOut)
		case .inout:
			cubicTimingParameters = .init(animationCurve: .easeInOut)
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
	
	public static func cubicBezierEase(duration: Double, controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: x1, y: y1), controlPoint2: CGPoint(x: x2, y: y2))))
	}
	
	public static func quarticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.50, y: 0.00), controlPoint2: CGPoint(x: 0.75, y: 0.00))
		case .out:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.25, y: 1.00), controlPoint2: CGPoint(x: 0.50, y: 1.00))
		case .inout:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.76, y: 0.00), controlPoint2: CGPoint(x: 0.24, y: 1.00))
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
	
	public static func quinticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.64, y: 0.00), controlPoint2: CGPoint(x: 0.78, y: 0.00))
		case .out:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.22, y: 1.00), controlPoint2: CGPoint(x: 0.36, y: 1.00))
		case .inout:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.83, y: 0.00), controlPoint2: CGPoint(x: 0.17, y: 1.00))
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
	
	public static func sineEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.12, y: 0.00), controlPoint2: CGPoint(x: 0.39, y: 0.00))
		case .out:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.61, y: 1.00), controlPoint2: CGPoint(x: 0.88, y: 1.00))
		case .inout:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.37, y: 0.00), controlPoint2: CGPoint(x: 0.63, y: 1.00))
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
	
	public static func circularEase(duration: Double, mode: EaseAnimationMode) -> Self {
		let cubicTimingParameters: UICubicTimingParameters
		switch mode {
		case .in:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.55, y: 0.00), controlPoint2: CGPoint(x: 1.00, y: 0.45))
		case .out:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.00, y: 0.55), controlPoint2: CGPoint(x: 0.45, y: 1.00))
		case .inout:
			cubicTimingParameters = .init(controlPoint1: CGPoint(x: 0.85, y: 0.00), controlPoint2: CGPoint(x: 0.15, y: 1.00))
		}
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: cubicTimingParameters))
	}
}

extension UIViewPropertyAnimator.Animation: MaterialEaseAnimation {
	
	public static func standardEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.200, y: 0.000), controlPoint2: CGPoint(x: 0.000, y: 1.000))))
	}
	
	public static func standardAccelerateEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.300, y: 0.000), controlPoint2: CGPoint(x: 1.000, y: 1.000))))
	}
	
	public static func standardDecelerateEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.000, y: 0.000), controlPoint2: CGPoint(x: 0.000, y: 1.000))))
	}
	
	public static func emphasizedEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.200, y: 0.000), controlPoint2: CGPoint(x: 0.000, y: 1.000))))
	}
	
	public static func emphasizedAccelerateEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.300, y: 0.000), controlPoint2: CGPoint(x: 0.800, y: 0.150))))
	}
	
	public static func emphasizedDecelerateEase(duration: Double) -> Self {
		return .init(.easeAnimation(duration: duration, cubicTimingParameters: .init(controlPoint1: CGPoint(x: 0.050, y: 0.700), controlPoint2: CGPoint(x: 0.100, y: 1.000))))
	}
}

extension UIViewPropertyAnimator.Animation: SpringAnimation {
	
	public static func spring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: Double = 0.0) -> Self {
		_spring(Spring(mass: mass, stiffness: stiffness, damping: damping), initialVelocity: initialVelocity)
	}
	
	public static func spring(mass: Double = 1.0, dampingRatio: Double, frequencyResponse: Double, initialVelocity: Double = 0.0) -> Self {
		_spring(Spring(mass: mass, dampingRatio: dampingRatio, frequencyResponse: frequencyResponse), initialVelocity: initialVelocity)
	}
	
	private static func _spring(_ spring: Spring, initialVelocity: Double) -> Self {
		let springTimingFunction: any SpringTimingFunction
		switch spring.springType {
		case .underDamped:
			springTimingFunction = TimingFunctions.Springs.UnderDamped(spring: spring, initialVelocity: initialVelocity)
		case .ciriticallyDamped:
			springTimingFunction = TimingFunctions.Springs.CriticallyDamped(spring: spring, initialVelocity: initialVelocity)
		case .overDamped:
			springTimingFunction = TimingFunctions.Springs.OverDamped(spring: spring, initialVelocity: initialVelocity)
		}
		let settlingDuration = springTimingFunction.settlingDuration
		let timingParameters = UISpringTimingParameters(mass: spring.mass, stiffness: spring.stiffness, damping: spring.damping, initialVelocity: CGVector(dx: initialVelocity, dy: initialVelocity))
		return .init(.springAnimation(settlingDuration: settlingDuration, springTimingParameters: timingParameters))
	}
}

extension UIViewPropertyAnimator.Animation: SpringVectorAnimation {
	
	public static func spring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: CGVector) -> Self {
		_spring(Spring(mass: mass, stiffness: stiffness, damping: damping), initialVelocity: initialVelocity)
	}
	
	public static func spring(mass: Double = 1.0, dampingRatio: Double, frequencyResponse: Double, initialVelocity: CGVector) -> Self {
		_spring(Spring(mass: mass, dampingRatio: dampingRatio, frequencyResponse: frequencyResponse), initialVelocity: initialVelocity)
	}
	
	private static func _spring(_ spring: Spring, initialVelocity: CGVector) -> Self {
		let springTimingFunction: any SpringVectorTimingFunction
		switch spring.springType {
		case .underDamped:
			springTimingFunction = TimingFunctions.SpringsVector.UnderDamped(spring: spring, initialVelocity: (initialVelocity.dx, initialVelocity.dy))
		case .ciriticallyDamped:
			springTimingFunction = TimingFunctions.SpringsVector.CriticallyDamped(spring: spring, initialVelocity: (initialVelocity.dx, initialVelocity.dy))
		case .overDamped:
			springTimingFunction = TimingFunctions.SpringsVector.OverDamped(spring: spring, initialVelocity: (initialVelocity.dx, initialVelocity.dy))
		}
		let settlingDuration = springTimingFunction.settlingDuration
		let timingParameters = UISpringTimingParameters(mass: spring.mass, stiffness: spring.stiffness, damping: spring.damping, initialVelocity: initialVelocity)
		return .init(.springAnimation(settlingDuration: max(settlingDuration.0, settlingDuration.1), springTimingParameters: timingParameters))
	}
}
