//
//  SpringTimingFunctions.swift
//
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

import Darwin

public protocol SpringTimingFunction: TimingFunction {
    
    var spring: Spring { get }
    
    var amplitude: Double { get }
    
    var settlingDuration: Double { get }
    
    func callAsFunction(_ t: Double) -> Double
}

extension TimingFunctions {
	
	public enum Springs {
	}
}

extension TimingFunctions.Springs {
	
	public struct UnderDamped: SpringTimingFunction {
		
		public let spring: Spring
		
		public let initialPosition: Double
		
		public let initialVelocity: Double
		
		public let epsilon: Double
		
		public var amplitude: Double {
			let ω_d = spring.dampedNaturalFrequency
			let λ = spring.damping / spring.mass / 2.0
			let t = atan(ω_d / λ) / ω_d
			return abs(position(t, initialPosition: 0.0))
		}
		
		public var settlingDuration: Double {
			let ζ = spring.dampingRatio
			let ω_n = spring.undampedNaturalFrequency
			let ω = ω_n * sqrt(1.0 - ζ * ζ)
			let r = ω_n * ζ
			let A = initialPosition
			let B = (initialVelocity + initialPosition * r) / ω
			let sub_exp = hypot(A, B) / epsilon
			return log(sub_exp) / r
		}
		
		public func callAsFunction(_ t: Double) -> Double {
            position(t, initialPosition: initialPosition)
		}
		
		private func position(_ t: Double, initialPosition: Double) -> Double {
			let ζ = spring.dampingRatio
			let ω_n = spring.undampedNaturalFrequency
			let ω = ω_n * sqrt(1.0 - ζ * ζ)
			let r = ω_n * ζ
			let A = initialPosition
			let B = (initialVelocity + initialPosition * r) / ω
			let sub_exp_1 = A * cos(ω * t)
			let sub_exp_2 = B * sin(ω * t)
			return exp(-r * t) * (sub_exp_1 + sub_exp_2)
		}
		
		public init(spring: Spring, initialPosition: Double = 1.0, initialVelocity: Double = 0.0, epsilon: Double = 1.0e-4) {
			assert(spring.springType == .underDamped)
			self.spring = spring
			self.initialPosition = initialPosition
			self.initialVelocity = initialVelocity
			self.epsilon = epsilon
		}
	}
}

extension TimingFunctions.Springs {
	
	public struct CriticallyDamped: SpringTimingFunction {
		
		public let spring: Spring
		
		public let initialPosition: Double
		
		public let initialVelocity: Double
		
		public let epsilon: Double
		
		public var amplitude: Double {
			let λ = spring.damping / spring.mass / 2.0
			return abs(position(1.0 / λ, initialPosition: 0.0))
		}
		
		public var settlingDuration: Double {
			let ω_n = spring.undampedNaturalFrequency
			let X = ((2.0 * .pi * initialVelocity) / ω_n) + initialPosition * (2.0 * .pi + 1.0)
			let sub_exp_1 = X * log(X / epsilon) - X + initialPosition
			let sub_exp_2 = X * (2.0 * .pi - 1.0) + initialPosition
			return (2.0 * .pi * sub_exp_1) / (ω_n * sub_exp_2)
		}
		
		public func callAsFunction(_ t: Double) -> Double {
            position(t, initialPosition: initialPosition)
		}
		
		private func position(_ t: Double, initialPosition: Double) -> Double {
			let ω_n = spring.undampedNaturalFrequency
			return exp(-ω_n * t) * (initialPosition + (initialVelocity + initialPosition * ω_n) * t)
		}
		
		public init(spring: Spring, initialPosition: Double = 1.0, initialVelocity: Double = 0.0, epsilon: Double = 1.0e-4) {
			assert(spring.springType == .ciriticallyDamped)
			self.spring = spring
			self.initialPosition = initialPosition
			self.initialVelocity = initialVelocity
			self.epsilon = epsilon
		}
	}
}

extension TimingFunctions.Springs {
	
	public struct OverDamped: SpringTimingFunction {
		
		public let spring: Spring
		
		public let initialPosition: Double
		
		public let initialVelocity: Double
		
		public let epsilon: Double
		
		public var amplitude: Double {
			let λ = spring.damping / spring.mass / 2.0
			let ω_d = spring.dampedNaturalFrequency
			let t = log((λ + ω_d) / (λ - ω_d)) / (2.0 * ω_d)
			return abs(position(t, initialPosition: 0.0))
		}
		
		public var settlingDuration: Double {
			let ζ = spring.dampingRatio
			let ω_n = spring.undampedNaturalFrequency
			let ω = ω_n * sqrt(ζ * ζ - 1.0)
			let r = ω_n * ζ
			let sub_exp_1 = (initialVelocity + initialPosition * r) / ω
			let C = (initialPosition + sub_exp_1) / 2.0
			let r1 = (ζ - sqrt(ζ * ζ - 1.0)) * ω_n
			return log(C / epsilon) / r1
		}
		
		public func callAsFunction(_ t: Double) -> Double {
            position(t, initialPosition: initialPosition)
		}
		
		private func position(_ t: Double, initialPosition: Double) -> Double {
			let ζ = spring.dampingRatio
			let ω_n = spring.undampedNaturalFrequency
			let ω = ω_n * sqrt(ζ * ζ - 1.0)
			let r = ω_n * ζ
			let sub_exp_1 = (initialVelocity + initialPosition * r) / ω
			let C = (initialPosition + sub_exp_1) / 2.0
			let D = (initialPosition - sub_exp_1) / 2.0
			let r1 = (ζ - sqrt(ζ * ζ - 1.0)) * ω_n
			let r2 = (ζ + sqrt(ζ * ζ - 1.0)) * ω_n
			return C * exp(-r1 * t) + D * exp(-r2 * t)
		}
		
		public init(spring: Spring, initialPosition: Double = 1.0, initialVelocity: Double = 0.0, epsilon: Double = 1.0e-4) {
			assert(spring.springType == .overDamped)
			self.spring = spring
			self.initialPosition = initialPosition
			self.initialVelocity = initialVelocity
			self.epsilon = epsilon
		}
	}
}
