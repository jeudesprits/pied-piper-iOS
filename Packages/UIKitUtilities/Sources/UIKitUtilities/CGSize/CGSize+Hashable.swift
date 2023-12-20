//
//  CGSize+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 3/2/22.
//

import UIKit

extension CGSize: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(width)
		hasher.combine(height)
	}
}
