//
//  CACornerMask+All.swift
//
//
//  Created by Ruslan Lutfullin on 2/23/21.
//

import UIKit

extension CACornerMask {
	
	public static var all: CACornerMask = [
		.layerMinXMinYCorner,
		.layerMaxXMinYCorner,
		.layerMinXMaxYCorner,
		.layerMaxXMaxYCorner
	]
}
