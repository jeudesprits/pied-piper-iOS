//
//  Transform3D+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 23/08/23.
//

extension Transform3D: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.m == rhs.m
	}
}

extension Transform3D: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		let columns = m.columns
		hasher.combine(columns.0)
		hasher.combine(columns.1)
		hasher.combine(columns.2)
		hasher.combine(columns.3)
	}
}
