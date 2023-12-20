//
//  SpringAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

///
public protocol SpringAnimation: Animation {
	
	static var default1Spring: Self { get }
	
	static var default2Spring: Self { get }
	
	static var interactiveDefaultSpring: Self { get }
	
	static var gentleSpring: Self { get }
	
	static var wobblySpring: Self { get }
	
	static var stiffSpring: Self { get }
	
	static var slowSpring: Self { get }
	
	static var molassesSpring: Self { get }
	
	static func spring(mass: Double, stiffness: Double, damping: Double, initialVelocity: Double) -> Self
	
	static func spring(mass: Double, dampingRatio: Double, frequencyResponse: Double, initialVelocity: Double) -> Self
}

extension SpringAnimation {
	
	public static var default1Spring: Self {
		spring(mass: 1.0, dampingRatio: 0.825, frequencyResponse: 0.550, initialVelocity: 0.0)
	}
	
	public static var default2Spring: Self {
		spring(mass: 1.0, stiffness: 170.0, damping: 26.0, initialVelocity: 0.0)
	}
	
	public static var interactiveDefaultSpring: Self {
		spring(mass: 1.0, dampingRatio: 0.860, frequencyResponse: 0.150, initialVelocity: 0.0)
	}
	
	public static var gentleSpring: Self {
		spring(mass: 1.0, stiffness: 120.0, damping: 14.0, initialVelocity: 0.0)
	}
	
	public static var wobblySpring: Self {
		spring(mass: 1.0, stiffness: 180.0, damping: 12.0, initialVelocity: 0.0)
	}
	
	public static var stiffSpring: Self {
		spring(mass: 1.0, stiffness: 210.0, damping: 20.0, initialVelocity: 0.0)
	}
	
	public static var slowSpring: Self {
		spring(mass: 1.0, stiffness: 280.0, damping: 60.0, initialVelocity: 0.0)
	}
	
	public static var molassesSpring: Self {
		spring(mass: 1.0, stiffness: 280.0, damping: 120.0, initialVelocity: 0.0)
	}
}
