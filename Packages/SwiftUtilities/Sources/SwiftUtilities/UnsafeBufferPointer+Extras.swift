//
//  UnsafeBufferPointer+Extras.swift
//
//
//  Created by Ruslan Lutfullin on 13/07/23.
//

extension UnsafeBufferPointer {
    
    @inlinable
    @inline(__always)
    public func pointer(at index: Int) -> UnsafePointer<Element> {
        assert(indices ~= index)
        return baseAddress.unsafelyUnwrapped + index
    }
}
