//
//  UIDevice+DynamicIsland.swift
//
//
//  Created by Ruslan Lutfullin on 23/04/23.
//

import UIKit

extension UIDevice {
	
	public var hasDynamicIsland: Bool {
		guard userInterfaceIdiom == .phone else {
			return false
		}
		
		guard let keyWindow = UIApplication.shared.connectedScenes.lazy.compactMap({ $0 as? UIWindowScene}).compactMap({ $0.keyWindow }).first else {
			assertionFailure()
			return false
		}
		
		// 59.0 on non-zoomed, 51.0 on zoomed
		return keyWindow.safeAreaInsets.top >= 51.0
	}
}
