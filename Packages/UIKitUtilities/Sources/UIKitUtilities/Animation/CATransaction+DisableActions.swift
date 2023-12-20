//
//  CATransaction+DisableActions.swift
//
//
//  Created by Ruslan Lutfullin on 13/04/23.
//

import UIKit

extension CATransaction {
	
	@inlinable
	public static func performWithoutActions(_ changesWithoutActions: () -> Void) {
		CATransaction.begin()
		defer { CATransaction.commit() }
		CATransaction.setDisableActions(true)
		return changesWithoutActions()
	}
}
