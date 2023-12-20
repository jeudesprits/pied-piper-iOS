//
//  InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 08/12/22.
//

public protocol InterpolatableData: Equatable {
	
	func mixed(with other: Self, using factor: Double) -> Self
	
	func mixed(with other: Self, using factor: (Double, Double)) -> Self
}

extension InterpolatableData {
	
	@inlinable
	public func mixed(with other: Self, using factor: (Double, Double)) -> Self {
		mixed(with: other, using: factor.0)
	}
}
