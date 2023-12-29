//
//  DisplayLinkAnimator.swift
//
//
//  Created by Ruslan Lutfullin on 16/04/23.
//

import SwiftUtilities
import TimingFunctions
import UIKit

public final class DisplayLinkAnimator<Value: InterpolatableData>: DisplayLink {
	
	private var delay: Double
	
	private var interpolation: Interpolation
	
	private let action: (_ value: Value) -> Void
	
	private let completion: ((_ position: UIViewAnimatingPosition) -> Void)?
	
	private var startTime = 0.0
	
	private var deltaTime = 0.0
	
	public func start() {
        _start()
	}
	
	public func stop(withoutFinishing finishing: Bool) {
		_stop()
		if finishing {
			state = .inactive
		}
	}
	
	public func finish(at position: UIViewAnimatingPosition) {
		assert(state == .stopped)
		switch position {
		case .start:
			action(interpolation.from)
		case .end:
			action(interpolation.to)
		default:
			break
		}
		state = .inactive
		completion?(position)
	}
	
	public func pause() {
		startTime = 0.0
		_pause()
	}
    
    public var isReversed = false {
        didSet {
            interpolation.isReversed = isReversed
            //deltaTime = interpolation.duration - deltaTime
        }
    }
    
    private var fraction = 0.0
    
    public var fractionComplete: Double {
        get {
            fraction
        }
        set {
            fraction = newValue
            let (deltaTime, value) = interpolation(fraction: clamp(fraction, min: 0.0, max: 1.0))
            self.deltaTime = deltaTime
            action(value)
        }
    }
    
    public var scrubsLinearly = true {
        didSet {
            interpolation.isLinearFractioned = scrubsLinearly
        }
    }
    
	@objc
	internal override func heartbit(_ displayLink: CADisplayLink) {
		let targetTime = displayLink.targetTimestamp
		if _slowPath(startTime == 0.0) {
			startTime = targetTime - deltaTime
		}
		deltaTime = targetTime - startTime
        
        //print("deltaTime: \(deltaTime)")
        #if targetEnvironment(simulator)
            deltaTime /= Double(slowAnimationsCoefficient())
        #endif
        let (fraction, value) = interpolation(deltaTime: deltaTime)
        self.fraction = fraction
		action(value)
		
		if _slowPath(deltaTime >= interpolation.duration) {
			if value != interpolation.to {
                fractionComplete = 1.0
				action(interpolation.to)
			}
			stop(withoutFinishing: true)
			completion?(.end)
		}
	}
	
	public init(
		from: Value,
		to: Value,
		delay: Double = 0.0,
		animation: Animation = .defaultEase,
		preferredFrameRateRange: CAFrameRateRange = .high,
		onTick action: @escaping (_ value: Value) -> Void,
		completion: ((_ position: UIViewAnimatingPosition) -> Void)? = nil
	) {
		assert(delay >= 0.0)
		self.delay = delay
		self.interpolation = Interpolation(from: from, to: to, animation: animation)
		self.action = action
		self.completion = completion
		super.init(mode: .common, preferredFrameRateRange: preferredFrameRateRange)
	}
	
	@discardableResult
	public static func runningAnimator(
		from: Value,
		to: Value,
		delay: Double = 0.0,
		animation: Animation = .defaultEase,
		preferredFrameRateRange: CAFrameRateRange = .high,
		onTick action: @escaping (_ value: Value) -> Void,
		completion: ((_ position: UIViewAnimatingPosition) -> Void)? = nil
	) -> DisplayLinkAnimator {
		let animator = DisplayLinkAnimator(
			from: from,
			to: to,
			delay: delay,
			animation: animation,
			preferredFrameRateRange: preferredFrameRateRange,
			onTick: action,
			completion: completion
		)
		animator.start()
		return animator
	}
}

extension DisplayLinkAnimator {
	
	internal struct Interpolation {
		
		internal let from: Value
		
		internal let to: Value
		
		internal let duration: Double
        
        internal var isReversed = false
        
        internal var isLinearFractioned = true
        
        internal let timedInterpolate: (_ deltaTime: Double, _ isReversed: Bool) -> (fraction: Double, value: Value)
        
        internal let fractionedInterpolate: (_ fraction: Double, _ isReversed: Bool, _ isLinearFractioned: Bool) -> (deltaTime: Double, value: Value)
		
		@_transparent
		internal func callAsFunction(deltaTime: Double) -> (fraction: Double, value: Value) {
            timedInterpolate(deltaTime, isReversed)
		}
        
        @_transparent
        internal func callAsFunction(fraction: Double) -> (deltaTime:Double, value: Value) {
            fractionedInterpolate(fraction, isReversed, isLinearFractioned)
        }
		
		internal init(from: Value, to: Value, animation: borrowing Animation) {
			self.from = from
			self.to = to
            
			switch animation.animationType {
			case let .easeAnimation(duration, easeTimingFunction):
				self.duration = duration
                
                timedInterpolate = { deltaTime, isReversed in
					if _slowPath(deltaTime >= duration) {
                        return (1.0, to)
					} else {
						_onFastPath()
						var fraction = deltaTime / duration
                        fraction = easeTimingFunction(fraction)
                        if isReversed {
                            fraction = 1.0 - fraction
                        }
						return (fraction, from.mixed(with: to, using: fraction))
					}
				}
                
                fractionedInterpolate = { fraction, isReversed, isLinearFractioned in
                    var fraction = fraction
                    if _slowPath(!isLinearFractioned) {
                        fraction = easeTimingFunction(fraction)
                    }
                    if isReversed {
                        fraction = 1.0 - fraction
                    }
                    return (fraction * duration, from.mixed(with: to, using: fraction))
                }
				
			case let .stepAnimation(duration, stepTimingFunction):
				self.duration = duration
                
                timedInterpolate = { deltaTime, isReversed in
                    if _slowPath(deltaTime >= duration) {
                        return (1.0, to)
                    } else {
                        _onFastPath()
                        var fraction = deltaTime / duration
                        fraction = stepTimingFunction(fraction)
                        if isReversed { 
                            fraction = 1.0 - fraction
                        }
                        return (fraction, from.mixed(with: to, using: fraction))
                    }
                }
                
                fractionedInterpolate = { fraction, isReversed, isLinearFractioned in
                    var fraction = fraction
                    if _slowPath(!isLinearFractioned) { 
                        fraction = stepTimingFunction(fraction)
                    }
                    if isReversed { 
                        fraction = 1.0 - fraction
                    }
                    return (fraction * duration, from.mixed(with: to, using: fraction))
                }
				
			case let .springAnimation(settlingDuration, springTimingFunction):
				duration = settlingDuration
                
                timedInterpolate = { deltaTime, isReversed in
                    if _slowPath(deltaTime >= settlingDuration) {
                        return (1.0, to)
                    } else {
                        _onFastPath()
                        var fraction = 1.0 - springTimingFunction(deltaTime)
                        if isReversed {
                            fraction = 1.0 - fraction
                        }
                        return (fraction, from.mixed(with: to, using: fraction))
                    }
				}
                
                fractionedInterpolate = { fraction, isReversed, isLinearFractioned in
                    var fraction = fraction
                    if _slowPath(!isLinearFractioned) {
                        fraction = 1.0 - springTimingFunction(fraction * settlingDuration)
                    }
                    if isReversed {
                        fraction = 1.0 - fraction
                    }
                    return (fraction * settlingDuration, from.mixed(with: to, using: fraction))
                }
			}
		}
	}
}

extension DisplayLink {
	
	public struct Animation {
		
		internal let animationType: AnimationType
		
		internal init(_ animationType: AnimationType) {
			self.animationType = animationType
		}
	}
}

extension DisplayLink.Animation {
	
	internal enum AnimationType {
		
		case easeAnimation(duration: Double, easeTimingFunction: any EaseTimingFunction)
		
		case stepAnimation(duration: Double, stepTimingFunction: any StepTimingFunction)
		
		case springAnimation(settlingDuration: Double, springTimingFunction: any SpringTimingFunction)
	}
}

extension DisplayLink.Animation: ExtendedEaseAnimation {
	
	public static func defaultEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.250, 0.100, 0.250, 1.000)
	}
	
	public static func linearEase(duration: Double) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Linear()))
	}
	
	public static func quadraticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Quadratic(mode: mode.rawValue)))
	}
	
	public static func cubicEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Cubic(mode: mode.rawValue)))
	}
	
	public static func cubicBezierEase(duration: Double, controlPoints x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.CubicBezier(controlPoints: x1, y1, x2, y2)))
	}
	
	public static func quarticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Quartic(mode: mode.rawValue)))
	}
	
	public static func quinticEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Quintic(mode: mode.rawValue)))
	}
	
	public static func sineEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Sine(mode: mode.rawValue)))
	}
	
	public static func circularEase(duration: Double, mode: EaseAnimationMode) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Circle(mode: mode.rawValue)))
	}
	
	public static func exponentialEase(duration: Double, mode: EaseAnimationMode, exponent: Double = 7.0) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Exponential(mode: mode.rawValue, exponent: exponent)))
	}
	
	public static func backEase(duration: Double, mode: EaseAnimationMode, amplitude: Double = 1.70158) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Back(mode: mode.rawValue, amplitude: amplitude)))
	}
	
	public static func elasticEase(duration: Double, mode: EaseAnimationMode, oscillations: Int = 1, springiness: Double = 0.3) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Elastic(mode: mode.rawValue, oscillations: oscillations, springiness: springiness)))
	}
	
	public static func bounceEase(duration: Double, mode: EaseAnimationMode, bounces: Int = 3, bounciness: Double = 2.0) -> Self {
		.init(.easeAnimation(duration: duration, easeTimingFunction: TimingFunctions.Eases.Bounce(mode: mode.rawValue, bounces: bounces, bounciness: bounciness)))
	}
}

extension DisplayLink.Animation: MaterialEaseAnimation {
	
	public static func standardEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.200, 0.000, 0.000, 1.000)
	}
	
	public static func standardAccelerateEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.300, 0.000, 1.000, 1.000)
	}
	
	public static func standardDecelerateEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.000, 0.000, 0.000, 1.000)
	}
	
	public static func emphasizedEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.200, 0.000, 0.000, 1.000)
	}
	
	public static func emphasizedAccelerateEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.300, 0.000, 0.800, 0.150)
	}
	
	public static func emphasizedDecelerateEase(duration: Double) -> Self {
		cubicBezierEase(duration: duration, controlPoints: 0.050, 0.700, 0.100, 1.000)
	}
}

extension DisplayLink.Animation: StepAnimation {
	
	public static func smoothStep(duration: Double) -> Self {
		.init(.stepAnimation(duration: duration, stepTimingFunction: TimingFunctions.Steps.Smooth()))
	}
	
	public static func smootherStep(duration: Double) -> Self {
		.init(.stepAnimation(duration: duration, stepTimingFunction: TimingFunctions.Steps.Smoother()))
	}
}

extension DisplayLink.Animation: SpringAnimation {
	 
	public static var default1Spring: Self {
		spring(dampingRatio: 0.825, frequencyResponse: 0.550)
	}
	
	public static var default2Spring: Self {
		spring(stiffness: 170.0, damping: 26.0)
	}
	
	public static var interactiveDefaultSpring: Self {
		spring(dampingRatio: 0.860, frequencyResponse: 0.150)
	}
	
	public static var gentleSpring: Self {
		spring(stiffness: 120.0, damping: 14.0)
	}
	
	public static var wobblySpring: Self {
		spring(stiffness: 180.0, damping: 12.0)
	}
	
	public static var stiffSpring: Self {
		spring(stiffness: 210.0, damping: 20.0)
	}
	
	public static var slowSpring: Self {
		spring(stiffness: 280.0, damping: 60.0)
	}
	
	public static var molassesSpring: Self {
		spring(stiffness: 280.0, damping: 120.0)
	}
	
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
		return .init(.springAnimation(settlingDuration: springTimingFunction.settlingDuration, springTimingFunction: springTimingFunction))
	}
}
