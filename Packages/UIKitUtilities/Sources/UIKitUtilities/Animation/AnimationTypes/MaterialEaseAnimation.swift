//
//  MaterialEaseAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 14/04/23.
//

///
public protocol MaterialEaseAnimation: Animation {
	
	static var standardEase: Self { get }
	
	static func standardEase(duration: Double) -> Self
	
	static var standardAccelerateEase: Self { get }
	
	static func standardAccelerateEase(duration: Double) -> Self
	
	static var standardDecelerateEase: Self { get }
	
	static func standardDecelerateEase(duration: Double) -> Self
	
	static var emphasizedEase: Self { get }
	
	static func emphasizedEase(duration: Double) -> Self
	
	static var emphasizedAccelerateEase: Self { get }
	
	static func emphasizedAccelerateEase(duration: Double) -> Self
	
	static var emphasizedDecelerateEase: Self { get }
	
	static func emphasizedDecelerateEase(duration: Double) -> Self
}

extension MaterialEaseAnimation {
	
	public static var standardEase: Self {
		.standardEase(duration: 0.3)
	}
	
	public static var standardAccelerateEase: Self {
		.standardAccelerateEase(duration: 0.2)
	}
	
	public static var standardDecelerateEase: Self {
		.standardDecelerateEase(duration: 0.25)
	}
	
	public static var emphasizedEase: Self {
		.emphasizedEase(duration: 0.5)
	}
	
	public static var emphasizedAccelerateEase: Self {
		.emphasizedAccelerateEase(duration: 0.2)
	}
	
	public static var emphasizedDecelerateEase: Self {
		.emphasizedDecelerateEase(duration: 0.4)
	}
}
