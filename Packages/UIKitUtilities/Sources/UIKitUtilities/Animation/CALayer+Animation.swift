//
//  CALayer+Animation.swift
//
//
//  Created by Ruslan Lutfullin on 15/04/23.
//

import UIKit
import TimingFunctions

extension CALayer {
	
	public static func basicAnimator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CABasicAnimation {
		let animator = CABasicAnimation(keyPath: keyPath)
		animator.fromValue = from
		animator.toValue = to
		animator.byValue = by
		animator.duration = duration
		animator.timingFunction = timingFunction
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.isCumulative = cumulative
		animator.isAdditive = additive
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningBasicAnimator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CABasicAnimation {
		let animator = CALayer.basicAnimator(
			keyPath: keyPath,
			from: from,
			to: to,
			by: by,
			duration: duration,
			timingFunction: timingFunction,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			cumulative: cumulative,
			additive: additive,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? keyPath)
		return animator
	}
}

extension CALayer {
	
	public static func keyframeAnimator(
		keyPath: String,
		values: [Any],
		keyTimes: [NSNumber]? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		timingFunctions: [CAMediaTimingFunction]? = nil,
		calculationMode: CAAnimationCalculationMode = .linear,
		tensionValues: [NSNumber]? = nil,
		continuityValues: [NSNumber]? = nil,
		biasValues: [NSNumber]? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAKeyframeAnimation {
		if !(calculationMode == .cubic || calculationMode == .cubicPaced) {
			assert(
				tensionValues == nil && continuityValues == nil && biasValues == nil,
				"'tensionValues', 'continuityValues' and 'biasValues' used only with cubic calculation modes"
			)
		}
		
		let animator = CAKeyframeAnimation(keyPath: keyPath)
		animator.values = values
		animator.keyTimes = keyTimes
		animator.duration = duration
		animator.timingFunction = timingFunction
		animator.timingFunctions = timingFunctions
		animator.calculationMode = calculationMode
		animator.tensionValues = tensionValues
		animator.continuityValues = continuityValues
		animator.biasValues = biasValues
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.isCumulative = cumulative
		animator.isAdditive = additive
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	public static func keyframeAnimator(
		keyPath: String,
		path: CGPath,
		keyTimes: [NSNumber]? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		timingFunctions: [CAMediaTimingFunction]? = nil,
		calculationMode: CAAnimationCalculationMode = .linear,
		rotationMode: CAAnimationRotationMode? = nil,
		tensionValues: [NSNumber]? = nil,
		continuityValues: [NSNumber]? = nil,
		biasValues: [NSNumber]? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAKeyframeAnimation {
		if !(calculationMode == .cubic || calculationMode == .cubicPaced) {
			assert(
				tensionValues == nil && continuityValues == nil && biasValues == nil,
				"'tensionValues', 'continuityValues' and 'biasValues' used only with cubic calculation modes"
			)
		}
		
		let animator = CAKeyframeAnimation()
		animator.keyPath = keyPath
		animator.path = path
		animator.keyTimes = keyTimes
		animator.duration = duration
		animator.timingFunction = timingFunction
		animator.timingFunctions = timingFunctions
		animator.calculationMode = calculationMode
		animator.tensionValues = tensionValues
		animator.continuityValues = continuityValues
		animator.rotationMode = rotationMode
		animator.biasValues = biasValues
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.isCumulative = cumulative
		animator.isAdditive = additive
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningKeyframeAnimator(
		keyPath: String,
		values: [Any],
		keyTimes: [NSNumber]? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		timingFunctions: [CAMediaTimingFunction]? = nil,
		calculationMode: CAAnimationCalculationMode = .linear,
		tensionValues: [NSNumber]? = nil,
		continuityValues: [NSNumber]? = nil,
		biasValues: [NSNumber]? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAKeyframeAnimation {
		let animator = CALayer.keyframeAnimator(
			keyPath: keyPath,
			values: values,
			keyTimes: keyTimes,
			duration: duration,
			timingFunction: timingFunction,
			timingFunctions: timingFunctions,
			calculationMode: calculationMode,
			tensionValues: tensionValues,
			continuityValues: continuityValues,
			biasValues: biasValues,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			cumulative: cumulative,
			additive: additive,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? keyPath)
		return animator
	}
	
	@discardableResult
	public func runningKeyframeAnimator(
		keyPath: String,
		path: CGPath,
		keyTimes: [NSNumber]? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		timingFunctions: [CAMediaTimingFunction]? = nil,
		calculationMode: CAAnimationCalculationMode = .linear,
		rotationMode: CAAnimationRotationMode? = nil,
		tensionValues: [NSNumber]? = nil,
		continuityValues: [NSNumber]? = nil,
		biasValues: [NSNumber]? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAKeyframeAnimation {
		let animator = CALayer.keyframeAnimator(
			keyPath: keyPath,
			path: path,
			keyTimes: keyTimes,
			duration: duration,
			timingFunction: timingFunction,
			timingFunctions: timingFunctions,
			calculationMode: calculationMode,
			rotationMode: rotationMode,
			tensionValues: tensionValues,
			continuityValues: continuityValues,
			biasValues: biasValues,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			cumulative: cumulative,
			additive: additive,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? keyPath)
		return animator
	}
}

extension CALayer {
	
	public static func springAnimator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		damping: CGFloat = 10.0,
		initialVelocity: CGFloat = .zero,
		mass: CGFloat = 1.0,
		stiffness: CGFloat = 100.0,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CASpringAnimation {
		let animator = CASpringAnimation(keyPath: keyPath)
		animator.fromValue = from
		animator.toValue = to
		animator.byValue = by
		animator.damping = damping
		animator.initialVelocity = initialVelocity
		animator.mass = mass
		animator.stiffness = stiffness
		animator.duration = duration == .zero ? animator.settlingDuration : duration
		animator.timingFunction = timingFunction
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.isCumulative = cumulative
		animator.isAdditive = additive
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningSpringAnimator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		damping: CGFloat = 10.0,
		initialVelocity: CGFloat = .zero,
		mass: CGFloat = 1.0,
		stiffness: CGFloat = 100.0,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CASpringAnimation {
		let animator = CALayer.springAnimator(
			keyPath: keyPath,
			from: from,
			to: to,
			by: by,
			damping: damping,
			initialVelocity: initialVelocity,
			mass: mass,
			stiffness: stiffness,
			duration: duration,
			timingFunction: timingFunction,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			cumulative: cumulative,
			additive: additive,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? keyPath)
		return animator
	}
}

extension CALayer {
	
	public static func transitionAnimator(
		startProgress: Float = 0.0,
		endProgress: Float = 1.0,
		type: CATransitionType = .fade,
		subtype: CATransitionSubtype? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CATransition {
		let animator = CATransition()
		animator.startProgress = startProgress
		animator.endProgress = endProgress
		animator.type = type
		animator.subtype = subtype
		animator.duration = duration
		animator.timingFunction = timingFunction
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningTransitionAnimator(
		startProgress: Float = 0.0,
		endProgress: Float = 1.0,
		type: CATransitionType = .fade,
		subtype: CATransitionSubtype? = nil,
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CATransition {
		let animator = CALayer.transitionAnimator(
			startProgress: startProgress,
			endProgress: endProgress,
			type: type,
			subtype: subtype,
			duration: duration,
			timingFunction: timingFunction,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: "transition")
		return animator
	}
}

extension CALayer {
	
	public static func groupAnimator(
		animations: [CAAnimation],
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAAnimationGroup {
		let animator = CAAnimationGroup()
		animator.animations = animations
		animator.duration = duration
		animator.timingFunction = timingFunction
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningGroupAnimator(
		animations: [CAAnimation],
		duration: CFTimeInterval = .zero,
		timingFunction: CAMediaTimingFunction? = nil,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAAnimationGroup {
		let animator = CALayer.groupAnimator(
			animations: animations,
			duration: duration,
			timingFunction: timingFunction,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? "group")
		return animator
	}
}

extension CALayer {
	
	public static func animator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		animation: Animation,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAAnimation {
		let animator: CABasicAnimation
		switch animation.animationType {
		case let .easeAnimation(duration, timingFunction):
			let basicAnimator = CABasicAnimation(keyPath: keyPath)
			basicAnimator.timingFunction = timingFunction
			basicAnimator.duration = duration
			animator = basicAnimator
		case let .springAnimation(settlingDuration, mass, stiffness, damping, initialVelocity):
			let springAnimator = CASpringAnimation(keyPath: keyPath)
			springAnimator.mass = mass
			springAnimator.stiffness = stiffness
			springAnimator.damping = damping
			springAnimator.initialVelocity = initialVelocity
			springAnimator.duration = settlingDuration
			animator = springAnimator
		}
		animator.fromValue = from
		animator.toValue = to
		animator.byValue = by
		animator.beginTime = beginTime
		animator.timeOffset = timeOffset
		animator.repeatCount = repeatCount
		animator.repeatDuration = repeatDuration
		animator.speed = speed
		#if targetEnvironment(simulator)
		animator.speed /= slowAnimationsCoefficient()
		#endif
		animator.autoreverses = autoreverses
		animator.fillMode = fillMode
		animator.isCumulative = cumulative
		animator.isAdditive = additive
		animator.preferredFrameRateRange = preferredFrameRateRange
		animator.delegate = CALayerAnimationDelegate(animator, starting: nil, completion: completion)
		return animator
	}
	
	@discardableResult
	public func runningAnimator(
		keyPath: String,
		from: Any? = nil,
		to: Any? = nil,
		by: Any? = nil,
		animation: Animation,
		beginTime: CFTimeInterval = .zero,
		timeOffset: CFTimeInterval = .zero,
		repeatCount: Float = .zero,
		repeatDuration: CFTimeInterval = .zero,
		speed: Float = 1.0,
		autoreverses: Bool = false,
		fillMode: CAMediaTimingFillMode = .removed,
		cumulative: Bool = false,
		additive: Bool = false,
		preferredFrameRateRange: CAFrameRateRange = .high,
		removeOnCompletion: Bool = true,
		forKey key: String? = nil,
		completion: ((_ finished: Bool) -> Void)? = nil
	) -> CAAnimation {
		let animator = CALayer.animator(
			keyPath: keyPath,
			from: from,
			to: to,
			by: by,
			animation: animation,
			beginTime: beginTime,
			timeOffset: timeOffset,
			repeatCount: repeatCount,
			repeatDuration: repeatDuration,
			speed: speed,
			autoreverses: autoreverses,
			fillMode: fillMode,
			cumulative: cumulative,
			additive: additive,
			preferredFrameRateRange: preferredFrameRateRange,
			removeOnCompletion: removeOnCompletion,
			completion: completion
		)
		add(animator, forKey: key ?? keyPath)
		return animator
	}
}

extension CALayer {
	
	public struct Animation {
		
		public let animationType: AnimationType
		
		internal init(_ animationType: AnimationType) {
			self.animationType = animationType
		}
	}
}

extension CALayer.Animation {
	
	public enum AnimationType {
		
		case easeAnimation(duration: Double, timingFunction: CAMediaTimingFunction)
		
		case springAnimation(settlingDuration: Double, mass: Double, stiffness: Double, damping: Double, initialVelocity: Double)
	}
}

extension CALayer.Animation: EaseAnimation {
	
	public static func defaultEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(name: .default)))
	}
	
	public static func linearEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(name: .linear)))
	}
	
	public static func quadraticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.11, 0.00, 0.50, 0.00)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.50, 1.00, 0.89, 1.00)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.45, 0.00, 0.55, 1.00)))
		}
	}
	
	public static func cubicEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(name: .easeIn)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(name: .easeOut)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(name: .easeInEaseOut)))
		}
	}
	
	public static func cubicBezierEase(duration: Double, controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Self {
		 .init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: Float(x1), Float(y1), Float(x2), Float(y2))))
	}
	
	public static func quarticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.50, 0.00, 0.75, 0.00)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.25, 1.00, 0.50, 1.00)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.76, 0.00, 0.24, 1.00)))
		}
	}
	
	public static func quinticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.64, 0.00, 0.78, 0.00)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.22, 1.00, 0.36, 1.00)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.83, 0.00, 0.17, 1.00)))
		}
	}
	
	public static func sineEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.12, 0.00, 0.39, 0.00)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.61, 1.00, 0.88, 1.00)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.37, 0.00, 0.63, 1.00)))
		}
	}
	
	public static func circularEase(duration: Double, mode: EaseAnimationMode) -> Self {
		switch mode {
		case .in:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.55, 0.00, 1.00, 0.45)))
		case .out:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.00, 0.55, 0.45, 1.00)))
		case .inout:
				.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.85, 0.00, 0.15, 1.00)))
		}
	}
}

extension CALayer.Animation: MaterialEaseAnimation {
	
	public static func standardEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.200, 0.000, 0.000, 1.000)))
	}
	
	public static func standardAccelerateEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.300, 0.000, 1.000, 1.000)))
	}
	
	public static func standardDecelerateEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.000, 0.000, 0.000, 1.000)))
	}
	
	public static func emphasizedEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.200, 0.000, 0.000, 1.000)))
	}
	
	public static func emphasizedAccelerateEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.300, 0.000, 0.800, 0.150)))
	}
	
	public static func emphasizedDecelerateEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, timingFunction: .init(controlPoints: 0.050, 0.700, 0.100, 1.000)))
	}
}

extension CALayer.Animation: SpringAnimation {
	
	public static func spring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: Double = 0.0) -> Self {
		spring(Spring(mass: mass, stiffness: stiffness, damping: damping), initialVelocity: initialVelocity)
	}
	
	public static func spring(mass: Double = 1.0, dampingRatio: Double, frequencyResponse: Double, initialVelocity: Double = 0.0) -> Self {
		spring(Spring(mass: mass, dampingRatio: dampingRatio, frequencyResponse: frequencyResponse), initialVelocity: initialVelocity)
	}
	
    private static func spring(_ spring: Spring, initialVelocity: Double) -> Self {
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
		return .init(.springAnimation(
			settlingDuration: settlingDuration,
			mass: spring.mass,
			stiffness: spring.stiffness,
			damping: spring.damping,
			initialVelocity: initialVelocity
		))
	}
}

internal final class CALayerAnimationDelegate: NSObject, CAAnimationDelegate {
	
	internal unowned let animation: CAAnimation
	
	internal let starting: (() -> Void)?
	
	internal let completion: ((_ finished: Bool) -> Void)?
	
	internal func animationDidStart(_ animation: CAAnimation) {
		starting?()
	}
	
	internal func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
		completion?(flag)
	}
	
	internal init(_ animation: CAAnimation, starting: (() -> Void)? = nil, completion: ((_ finished: Bool) -> Void)? = nil) {
		self.animation = animation
		self.starting = starting
		self.completion = completion
		super.init()
	}
}
