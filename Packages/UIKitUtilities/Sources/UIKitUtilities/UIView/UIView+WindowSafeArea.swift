//
//  UIView+WindowSafeArea.swift
//
//
//  Created by Ruslan Lutfullin on 12/03/23.
//

import UIKit

extension UIView {
	
	public var windowSafeAreaInsets: UIEdgeInsets? { window?.safeAreaInsets }
	
	public var windowSafeAreaLayoutGuide: UILayoutGuide? { window?.safeAreaLayoutGuide }
}
