//
//  SpringVectorAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 15/04/23.
//

import UIKit

///
public protocol SpringVectorAnimation: Animation {
	
	static func spring(mass: Double, stiffness: Double, damping: Double, initialVelocity: CGVector) -> Self
	
	static func spring(mass: Double, dampingRatio: Double, frequencyResponse: Double, initialVelocity: CGVector) -> Self
}
