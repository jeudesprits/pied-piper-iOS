//
//  CopyOnWrite.swift
//
//
//  Created by Ruslan Lutfullin on 2/24/22.
//

import os

@propertyWrapper
public struct CopyOnWrite<Value: Copyable> {
    
    public var wrappedValue: Wrapper
    
    public init(object objectGetter: @autoclosure () -> Value) {
        wrappedValue = Wrapper(storage: objectGetter())
    }
    
    public var projectedValue: Value {
        @_transparent
        mutating get {
            wrappedValue.copyIfNotUnique()
            return wrappedValue.storage
        }
        @_transparent
        set {
            wrappedValue.copyIfNotUnique()
            wrappedValue.storage = newValue
        }
    }
}

extension CopyOnWrite {
    
    @dynamicMemberLookup
    public struct Wrapper {
        @usableFromInline
        internal let lock = OSAllocatedUnfairLock()
        
        @usableFromInline
        internal var storage: Value
        
        @_transparent
        @usableFromInline
        internal mutating func copyIfNotUnique() {
            guard lock.withLockUnchecked({ isKnownUniquelyReferenced(&storage) }) else { return }
            storage = storage.copy()
        }
        
        public subscript<Member>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Member>) -> Member {
            @_transparent
            get {
                storage[keyPath: keyPath]
            }
            @_transparent
            set {
                copyIfNotUnique()
                storage[keyPath: keyPath] = newValue
            }
        }
    }
}
