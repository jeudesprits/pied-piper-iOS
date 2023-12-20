//
//  CGVector3D.swift
//
//
//  Created by Ruslan Lutfullin on 28/11/22.
//

public struct CGVector3D {
	
	public var dx: Double
	
	public var dy: Double
	
	public var dz: Double
	
	public init(dx: Double, dy: Double, dz: Double) {
		self.dx = dx
		self.dy = dy
		self.dz = dz
	}
}

extension CGVector3D {
	
    public static var zero: Self {
        .init(dx: 0.0, dy: 0.0, dz: 0.0)
    }
}
