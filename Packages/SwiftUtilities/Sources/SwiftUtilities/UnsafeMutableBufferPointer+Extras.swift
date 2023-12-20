//
//  UnsafeMutableBufferPointer+Extras.swift
//
//
//  Created by Ruslan Lutfullin on 13/07/23.
//

extension UnsafeMutableBufferPointer {
    
    @inlinable
    public func initialize(fromContentsOf source: Self) -> Index {
        guard source.count > 0 else { return 0 }
        assert(source.count <= count, "buffer cannot contain every element from source.")
        baseAddress.unsafelyUnwrapped.initialize(from: source.baseAddress.unsafelyUnwrapped, count: source.count)
        return source.count
    }
    
    @inlinable
    public func initialize(fromContentsOf source: Slice<Self>) -> Index {
        let sourceCount = source.count
        guard sourceCount > 0 else { return 0 }
        assert(sourceCount <= count, "buffer cannot contain every element from source.")
        baseAddress.unsafelyUnwrapped.initialize(from: source.base.baseAddress.unsafelyUnwrapped + source.startIndex, count: sourceCount)
        return sourceCount
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll<C: Collection>(fromContentsOf source: C) where C.Element == Element {
        let index = initialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll(fromContentsOf source: Self) {
        let index = initialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll(fromContentsOf source: Slice<Self>) {
        let index = initialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func moveInitializeAll(fromContentsOf source: Self) {
        let index = moveInitialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func moveInitializeAll(fromContentsOf source: Slice<Self>) {
        let index = moveInitialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func moveUpdateAll(fromContentsOf source: Self) {
        let index = moveUpdate(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func moveUpdateAll(fromContentsOf source: Slice<Self>) {
        let index = moveUpdate(fromContentsOf: source)
        assert(index == endIndex)
    }
}

extension Slice {
    
    @inlinable
    @inline(__always)
    public func initialize<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>) -> Index where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        let index = target.initialize(fromContentsOf: source)
        return startIndex + index
    }
    
    @inlinable
    @inline(__always)
    public func initialize<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>) -> Index where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        let index = target.initialize(fromContentsOf: source)
        return startIndex + index
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll<C: Collection>(fromContentsOf source: C) where Base == UnsafeMutableBufferPointer<C.Element> {
        let index = initialize(fromContentsOf: source)
        assert(index == endIndex)
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.initializeAll(fromContentsOf: source)
    }
    
    @inlinable
    @inline(__always)
    public func initializeAll<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.initializeAll(fromContentsOf: source)
    }
    
    @inlinable
    @inline(__always)
    public func moveInitializeAll<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.moveInitializeAll(fromContentsOf: source)
    }
    
    @inlinable
    @inline(__always)
    public func moveInitializeAll<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.moveInitializeAll(fromContentsOf: source)
    }
    
    @inlinable
    @inline(__always)
    public func moveUpdateAll<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.moveUpdateAll(fromContentsOf: source)
    }
    
    @inlinable
    @inline(__always)
    public func moveUpdateAll<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>) where Base == UnsafeMutableBufferPointer<Element> {
        let target = UnsafeMutableBufferPointer(rebasing: self)
        target.moveUpdateAll(fromContentsOf: source)
    }
}
