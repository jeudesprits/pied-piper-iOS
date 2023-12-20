//
//  CGPoint+Hashable.swift
//
//
//  Created by Ruslan Lutfullin on 21/12/22.
//

import UIKit

extension CGPoint: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(x)
		hasher.combine(y)
	}
}
