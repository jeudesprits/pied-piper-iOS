//
//  Scope.swift
//
//
//  Created by Ruslan Lutfullin on 18/09/22.
//

@inlinable
@discardableResult
public func with<T>(_ receiver: consuming T, _ apply: (inout T) throws -> Void) rethrows -> T {
    try apply(&receiver)
    return receiver
}

@inlinable
@discardableResult
public func with<T, V>(_ receiver: consuming T, _ apply: (inout T) throws -> V) rethrows -> V {
    return try apply(&receiver)
}

@inlinable
@discardableResult
public func with<T>(_ apply: () throws -> T) rethrows -> T {
    try apply()
}
