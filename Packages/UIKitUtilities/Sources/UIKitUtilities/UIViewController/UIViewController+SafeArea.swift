//
//  UIViewController+SafeArea.swift
//
//
//  Created by Ruslan Lutfullin on 12/03/23.
//

import UIKit

extension UIViewController {
	
	public final var windowSafeAreaInsets: UIEdgeInsets? { view.window?.safeAreaInsets }
	
	public final var safeAreaInsets: UIEdgeInsets { view.safeAreaInsets }
}
