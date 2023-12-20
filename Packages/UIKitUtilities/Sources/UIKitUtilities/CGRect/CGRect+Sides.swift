//
//  CGRect+Sides.swift
//
//
//  Created by Ruslan Lutfullin on 28/11/22.
//

import UIKit

extension CGRect {
	
	public var topLeft: CGPoint { origin }
	
	public var topRight: CGPoint { .init(x: maxX, y: minY) }
	
	public var bottomLeft: CGPoint { .init(x: minX, y: maxY) }
	
	public var bottomRight: CGPoint { .init(x: maxX, y: maxY) }
	
	public var center: CGPoint { .init(x: midX, y: midY) }
}
