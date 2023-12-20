//
//  NSLayoutConstraint+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 09/05/22.
//

import UIKit

extension NSLayoutConstraint {
	
	public func identifier(_ newIdentifier: String?) -> NSLayoutConstraint {
		identifier = newIdentifier
		return self
	}
	
	public func priority(_ newPriority: UILayoutPriority) -> NSLayoutConstraint {
		priority = newPriority
		return self
	}
}
