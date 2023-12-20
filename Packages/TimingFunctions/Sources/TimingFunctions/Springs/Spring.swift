//
//  Spring.swift
//
//
//  Created by Ruslan Lutfullin on 07/04/23.
//

import Darwin

public struct Spring {
	
	public let mass: Double
	
	public let stiffness: Double
	
	public let damping: Double
	
	/// Creates a damped harmonic spring using the specified underlying physical
	/// parameters.
	///
	/// - parameter mass: The mass `m` attached to the spring, measured in
	/// kilograms.
	/// - parameter stiffness: The spring constant `k`, measured in kilograms
	/// per second squared.
	/// - parameter damping: The viscous damping coefficient `c`,
	/// measured in kilograms per second.
	public init(mass: Double = 1.0, stiffness: Double, damping: Double) {
		assert(mass > 0.0)
		assert(stiffness > 0.0)
		assert(damping >= 0.0)
		self.mass = mass
		self.stiffness = stiffness
		self.damping = damping
	}
	
	/// Creates a damped harmonic spring using the specified design-friendly
	/// parameters.
	///
	/// - parameter dampingRatio: The ratio of the actual damping coefficient to
	/// the critical damping coeffcient.
	/// - parameter frequencyResponse: The duration of one period in the
	/// undamped system, measured in seconds.
	///
	/// See https://developer.apple.com/videos/play/wwdc2018/803/ at 33:46.
	public init(mass: Double = 1.0, dampingRatio: Double, frequencyResponse: Double) {
		assert(dampingRatio >= 0.0)
		assert(frequencyResponse > 0.0)
		self.mass = mass
		let _stiffness = 2.0 * .pi / frequencyResponse
		stiffness = _stiffness * _stiffness * mass
		damping = 4.0 * .pi * dampingRatio * mass / frequencyResponse
	}
}

extension Spring {
	
	public var dampingRatio: Double {
		damping / (2.0 * sqrt(stiffness * mass))
	}
	
	public var frequencyResponse: Double {
		2 * .pi / undampedNaturalFrequency
	}
	
	public var dampedNaturalFrequency: Double {
		undampedNaturalFrequency * sqrt(abs(1.0 - dampingRatio * dampingRatio))
	}
	
	public var undampedNaturalFrequency: Double {
		sqrt(stiffness / mass)
	}
}

extension Spring {
	
	public var springType: SpringType {
		if abs(dampingRatio - 1.0) < 1.0e-6 {
			return .ciriticallyDamped
		} else if dampingRatio < 1.0 {
			return .underDamped
		} else {
			return .overDamped
		}
	}
}

extension Spring {
	
	public enum SpringType {
		case underDamped
		case overDamped
		case ciriticallyDamped
	}
}
