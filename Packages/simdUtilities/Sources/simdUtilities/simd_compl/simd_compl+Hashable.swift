//
//  simd_compl+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 23/08/23.
//

extension simd_compl: Equatable {
	
	@_transparent
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.storage == rhs.storage
	}
}

extension simd_compl: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(storage)
	}
}
