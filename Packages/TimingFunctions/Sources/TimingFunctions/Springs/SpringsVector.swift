//
//  SpringVectorTimingFunctions.swift
//
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

import Darwin

public protocol SpringVectorTimingFunction: TimingFunction {
    
    var spring: Spring { get }
    
    var amplitude: (Double, Double) { get }
    
    var settlingDuration: (Double, Double) { get }
    
    func callAsFunction(_ t: (Double, Double)) -> (Double, Double)
}

extension TimingFunctions {
    
    public enum SpringsVector {
    }
}

extension TimingFunctions.SpringsVector {
    
    public struct UnderDamped: SpringVectorTimingFunction {
        
        public let spring: Spring
        
        public let initialPosition: (Double, Double)
        
        public let initialVelocity: (Double, Double)
        
        public let epsilon: Double
        
        public var amplitude: (Double, Double) {
            let ω_d = spring.dampedNaturalFrequency
            let λ = spring.damping / spring.mass / 2.0
            let t = atan(ω_d / λ) / ω_d
            let posiiton = position((t, t), initialPosition: (0.0, 0.0))
            return (abs(posiiton.0), abs(posiiton.1))
        }
        
        public var settlingDuration: (Double, Double) {
            let ζ = spring.dampingRatio
            let ω_n = spring.undampedNaturalFrequency
            let ω = ω_n * sqrt(1.0 - ζ * ζ)
            let r = ω_n * ζ
            let A = initialPosition
            let B = (
                (initialVelocity.0 + initialPosition.0 * r) / ω,
                (initialVelocity.1 + initialPosition.1 * r) / ω
            )
            let sub_exp = (
                hypot(A.0, B.0) / epsilon,
                hypot(A.1, B.1) / epsilon
            )
            return (
                log(sub_exp.0) / r,
                log(sub_exp.1) / r
            )
        }
        
        public func callAsFunction(_ t: (Double, Double)) -> (Double, Double) {
            position(t, initialPosition: initialPosition)
        }
        
        private func position(_ t: (Double, Double), initialPosition: (Double, Double)) -> (Double, Double) {
            let ζ = spring.dampingRatio
            let ω_n = spring.undampedNaturalFrequency
            let ω = ω_n * sqrt(1.0 - ζ * ζ)
            let r = ω_n * ζ
            let A = initialPosition
            let B = (
                (initialVelocity.0 + initialPosition.0 * r) / ω,
                (initialVelocity.1 + initialPosition.1 * r) / ω
            )
            let sub_exp_1 = (
                A.0 * cos(ω * t.0),
                A.1 * cos(ω * t.1)
            )
            let sub_exp_2 = (
                B.0 * sin(ω * t.0),
                B.1 * sin(ω * t.1)
            )
            return (
                exp(-r * t.0) * (sub_exp_1.0 + sub_exp_2.0),
                exp(-r * t.1) * (sub_exp_1.1 + sub_exp_2.1)
            )
        }
        
        public init(spring: Spring, initialPosition: (Double, Double) = (1.0, 1.0), initialVelocity: (Double, Double), epsilon: Double = 1.0e-4) {
            assert(spring.springType == .underDamped)
            self.spring = spring
            self.initialPosition = initialPosition
            self.initialVelocity = initialVelocity
            self.epsilon = epsilon
        }
    }
}

extension TimingFunctions.SpringsVector {
    
    public struct CriticallyDamped: SpringVectorTimingFunction {
        
        public let spring: Spring
        
        public let initialPosition: (Double, Double)
        
        public let initialVelocity: (Double, Double)
        
        public let epsilon: Double
        
        public var amplitude: (Double, Double) {
            let recip_λ = 1.0 / (spring.damping / spring.mass / 2.0)
            let position = position((recip_λ, recip_λ), initialPosition: (0.0, 0.0))
            return (abs(position.0), abs(position.1))
        }
        
        public var settlingDuration: (Double, Double) {
            let ω_n = spring.undampedNaturalFrequency
            let X = (
                ((2.0 * .pi * initialVelocity.0) / ω_n) + initialPosition.0 * (2.0 * .pi + 1.0),
                ((2.0 * .pi * initialVelocity.1) / ω_n) + initialPosition.1 * (2.0 * .pi + 1.0)
            )
            let sub_exp_1 = (
                X.0 * log(X.0 / epsilon) - X.0 + initialPosition.0,
                X.1 * log(X.1 / epsilon) - X.1 + initialPosition.1
            )
            let sub_exp_2 = (
                X.0 * (2.0 * .pi - 1.0) + initialPosition.0,
                X.1 * (2.0 * .pi - 1.0) + initialPosition.1
            )
            return (
                (2.0 * .pi * sub_exp_1.0) / (ω_n * sub_exp_2.0),
                (2.0 * .pi * sub_exp_1.1) / (ω_n * sub_exp_2.1)
            )
        }
        
        public func callAsFunction(_ t: (Double, Double)) -> (Double, Double) {
            position(t, initialPosition: initialPosition)
        }
        
        private func position(_ t: (Double, Double), initialPosition: (Double, Double)) -> (Double, Double) {
            let ω_n = spring.undampedNaturalFrequency
            return (
                exp(-ω_n * t.0) * (initialPosition.0 + (initialVelocity.0 + initialPosition.0 * ω_n) * t.0),
                exp(-ω_n * t.1) * (initialPosition.1 + (initialVelocity.1 + initialPosition.1 * ω_n) * t.1)
            )
        }
        
        public init(spring: Spring, initialPosition: (Double, Double) = (1.0, 1.0), initialVelocity: (Double, Double), epsilon: Double = 1.0e-4) {
            assert(spring.springType == .ciriticallyDamped)
            self.spring = spring
            self.initialPosition = initialPosition
            self.initialVelocity = initialVelocity
            self.epsilon = epsilon
        }
    }
}

extension TimingFunctions.SpringsVector {
    
    public struct OverDamped: SpringVectorTimingFunction {
        
        public let spring: Spring
        
        public let initialPosition: (Double, Double)
        
        public let initialVelocity: (Double, Double)
        
        public let epsilon: Double
        
        public var amplitude: (Double, Double) {
            let λ = spring.damping / spring.mass / 2.0
            let ω_d = spring.dampedNaturalFrequency
            let t = log((λ + ω_d) / (λ - ω_d)) / (2.0 * ω_d)
            let position = position((t, t), initialPosition: (0.0, 0.0))
            return (abs(position.0), abs(position.1))
        }
        
        public var settlingDuration: (Double, Double) {
            let ζ = spring.dampingRatio
            let ω_n = spring.undampedNaturalFrequency
            let ω = ω_n * sqrt(ζ * ζ - 1.0)
            let r = ω_n * ζ
            let sub_exp_1 = (
                (initialVelocity.0 + initialPosition.0 * r) / ω,
                (initialVelocity.1 + initialPosition.1 * r) / ω
            )
            let C = (
                (initialPosition.0 + sub_exp_1.0) / 2.0,
                (initialPosition.1 + sub_exp_1.1) / 2.0
            )
            let r1 = (ζ - sqrt(ζ * ζ - 1.0)) * ω_n
            return (
                log(C.0 / epsilon) / r1,
                log(C.1 / epsilon) / r1
            )
        }
        
        public func callAsFunction(_ t: (Double, Double)) -> (Double, Double) {
            position(t, initialPosition: initialPosition)
        }
        
        private func position(_ t: (Double, Double), initialPosition: (Double, Double)) -> (Double, Double) {
            let ζ = spring.dampingRatio
            let ω_n = spring.undampedNaturalFrequency
            let ω = ω_n * sqrt(ζ * ζ - 1.0)
            let r = ω_n * ζ
            let sub_exp_1 = (
                (initialVelocity.0 + initialPosition.1 * r) / ω,
                (initialVelocity.1 + initialPosition.1 * r) / ω
            )
            let C = (
                (initialPosition.0 + sub_exp_1.0) / 2.0,
                (initialPosition.1 + sub_exp_1.1) / 2.0
            )
            let D = (
                (initialPosition.0 - sub_exp_1.0) / 2.0,
                (initialPosition.1 - sub_exp_1.1) / 2.0
            )
            let r1 = (ζ - sqrt(ζ * ζ - 1.0)) * ω_n
            let r2 = (ζ + sqrt(ζ * ζ - 1.0)) * ω_n
            return (
                C.0 * exp(-r1 * t.0) + D.0 * exp(-r2 * t.0),
                C.1 * exp(-r1 * t.1) + D.1 * exp(-r2 * t.1)
            )
        }
        
        public init(spring: Spring, initialPosition: (Double, Double) = (1.0, 1.0), initialVelocity: (Double, Double), epsilon: Double = 1.0e-4) {
            assert(spring.springType == .overDamped)
            self.spring = spring
            self.initialPosition = initialPosition
            self.initialVelocity = initialVelocity
            self.epsilon = epsilon
        }
    }
}
