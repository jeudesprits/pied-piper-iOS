//
//  CACornerMask+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 3/2/22.
//

import UIKit

extension CACornerMask: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}
