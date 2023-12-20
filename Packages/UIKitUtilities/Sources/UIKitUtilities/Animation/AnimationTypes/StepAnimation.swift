//
//  StepAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

///
public protocol StepAnimation: Animation {
	
	static func smoothStep(duration: Double) -> Self
	
	static func smootherStep(duration: Double) -> Self
}
