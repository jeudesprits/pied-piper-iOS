//
//  CGSize3D.swift
//
//
//  Created by Ruslan Lutfullin on 28/11/22.
//

public struct CGSize3D {
	
	public var width: Double
	
	public var height: Double
	
	public var depth: Double
	
	public init(width: Double, height: Double, depth: Double) {
		self.width = width
		self.height = height
		self.depth = depth
	}
}

extension CGSize3D {
	
	public var zero: Self { 
        .init(width: 0.0, height: 0.0, depth: 0.0)
    }
}
