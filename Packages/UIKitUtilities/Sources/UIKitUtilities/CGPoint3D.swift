//
//  CGPoint3D.swift
//
//
//  Created by Ruslan Lutfullin on 28/11/22.
//

public struct CGPoint3D {
	
	public var x: Double
	
	public var y: Double
	
	public var z: Double
	
	public init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}
}

extension CGPoint3D {
	
	public static var zero: Self { 
        .init(x: 0.0, y: 0.0, z: 0.0)
    }
}
