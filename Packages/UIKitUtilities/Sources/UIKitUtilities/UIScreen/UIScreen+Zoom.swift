//
//  UIScreen+Zoom.swift
//
//
//  Created by Ruslan Lutfullin on 23/04/23.
//

import UIKit

extension UIScreen {
	
	public var isDisplayZoomed: Bool {
		displayCornerRadius != displayCornerRadiusIgnoringZoom
	}
}
