//
//  UIImage+AspectRatio.swift
//
//
//  Created by Ruslan Lutfullin on 17/07/23.
//

import UIKit

extension UIImage {
	
    public var aspectRatio: Double {
        size.width / size.height
    }
}
