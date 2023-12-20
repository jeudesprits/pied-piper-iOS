//
//  UIImage+Init.swift
//
//
//  Created by Ruslan Lutfullin on 28/03/23.
//

import UIKit

extension UIImage {
	
	public convenience init?(named name: String, in bundle: Bundle?) {
		self.init(named: name, in: bundle, with: nil)
	}
}
