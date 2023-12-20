//
//  UIScreen+CornerRadius.swift
//
//
//  Created by Ruslan Lutfullin on 23/04/23.
//

import UIKit
import Tor

extension UIScreen {
	
	public var displayCornerRadius: CGFloat {
        guard let value = value(forKey: Tor.decode("TyBLIEvRXHKGzKmvyBNL")) as? CGFloat else {
			assertionFailure()
			return 0.0
		}
		return value
	}
	
	public var displayCornerRadiusIgnoringZoom: CGFloat {
        guard let value = value(forKey: Tor.decode("TyBLIEvRXHKGzKmvyBNLd:GHKBG:uHHF")) as? CGFloat else {
			assertionFailure()
			return 0.0
		}
		return value
	}
}
