//
//  UILayoutPriority+Almost.swift
//
//
//  Created by Ruslan Lutfullin on 28/11/22.
//

import UIKit

extension UILayoutPriority {
	
	public static var almostRequired: UILayoutPriority { .required - 1.0 }
}
