//
//  UIDevice+HomeButton.swift
//
//
//  Created by Ruslan Lutfullin on 23/04/23.
//

import UIKit
import Tor

extension UIDevice {
	
	public var hasHomeButton: Bool {
        guard let value = UIDevice.value(forKey: Tor.decode("TAvLcHFzWNMMHG")) as? Bool else {
			assertionFailure()
			return false
		}
		return value
	}
}
