//
//  Copyable.swift
//
//
//  Created by Ruslan Lutfullin on 2/24/22.
//

public protocol Copyable: AnyObject {
	
	func copy() -> Self
}
