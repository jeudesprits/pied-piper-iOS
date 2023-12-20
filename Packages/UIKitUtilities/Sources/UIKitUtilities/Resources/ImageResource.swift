//
//  ImageResource.swift
//
//
//  Created by Ruslan Lutfullin on 17/07/23.
//

import UIKit

extension UIImage {
	
	public convenience init(resource: ImageResource) {
		self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
	}
}

///
public struct ImageResource: Hashable {
	
	fileprivate let name: String
	
	fileprivate let bundle: Bundle
	
	public init(name: String, bundle: Bundle) {
		self.name = name
		self.bundle = bundle
	}
}
