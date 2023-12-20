//
//  Abstract.swift
//
//
//  Created by Ruslan Lutfullin on 2/6/22.
//

@inline(never)
public func _abstract(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    preconditionFailure("\(function) must be overridden", file: file, line: line)
}
