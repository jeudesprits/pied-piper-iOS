//
//  UIDevice+Notch.swift
//
//
//  Created by Ruslan Lutfullin on 3/19/21.
//

import UIKit

extension UIDevice {
	
	public var hasNotch: Bool {
		guard userInterfaceIdiom == .phone else {
			return false
		}
		
		guard let keyWindow = UIApplication.shared.connectedScenes.lazy.compactMap({ $0 as? UIWindowScene}).compactMap({ $0.keyWindow }).first else {
			assertionFailure()
			return false
		}
		
		// 47.0 on non-zoomed, 41.0 on zoomed
		return keyWindow.safeAreaInsets.top >= 41.0
	}
}
