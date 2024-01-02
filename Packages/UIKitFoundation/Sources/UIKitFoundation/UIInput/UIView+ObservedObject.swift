//
//  UIView+ObservedObject.swift
//
//
//  Created by Ruslan Lutfullin on 28/12/23.
//

import OrderedCollections
import UIKit

extension UIView {
    
    @propertyWrapper
    public struct ObservedObject<Input: UIInput>: ObservedObjectProperty {
        
        @usableFromInline
        typealias Input = Input
        
        @usableFromInline
        let id: UUID
        
        @usableFromInline
        var previousValue: Input?
        
        @usableFromInline
        var value: Input?
        
        @usableFromInline
        typealias WillChangeHandler = () -> Void
        
        @usableFromInline
        var willChangeHandler: WillChangeHandler = {} {
            didSet {
                value?.willChangeHandler = willChangeHandler
            }
        }
        
        @usableFromInline
        typealias DidChangeHandler = () -> Void
        
        @usableFromInline
        var didChangeHandler: DidChangeHandler = {} {
            didSet {
                value?.didChangeHandler = didChangeHandler
            }
        }
        
        @usableFromInline
        typealias ChangesHandler = (_ previousInput: Input?) -> Void
        
        @usableFromInline
        var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> = [:]
        
        @available(*, unavailable, message: "'@ObservedObject' attribute is class constrained that conforms 'UIInputEnvironment' protocol. Use it with properties of that classes, not with other classes or non-class types like struct")
        public var wrappedValue: Input? {
            get {
                fatalError()
            }
            set {
                fatalError()
            }
        }
        
        @inlinable
        public static subscript<EnclosingSelf: UIInputEnvironment>(
            _enclosingInstance enclosingSelf: EnclosingSelf,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Input>,
            storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
        ) -> Input? {
            @inlinable
            get {
                enclosingSelf[keyPath: storageKeyPath].value
            }
            @inlinable
            set {
                let oldValue = enclosingSelf[keyPath: storageKeyPath].value
                oldValue?.willChangeHandler = {}
                oldValue?.didChangeHandler = {}
                
                if newValue != oldValue {
                    enclosingSelf[keyPath: storageKeyPath].willChangeHandler()
                    enclosingSelf[keyPath: storageKeyPath].value = newValue
                    enclosingSelf[keyPath: storageKeyPath].didChangeHandler()
                } else {
                    enclosingSelf[keyPath: storageKeyPath].value = newValue
                }
                
                newValue?.willChangeHandler = enclosingSelf[keyPath: storageKeyPath].willChangeHandler
                newValue?.didChangeHandler = enclosingSelf[keyPath: storageKeyPath].didChangeHandler
            }
        }
        
        @inlinable
        public var projectedValue: Self {
            @inlinable
            _read {
                yield self
            }
            @inlinable
            _modify {
                yield &self
            }
        }
        
        @inlinable
        public init(wrappedValue: Input?) {
            id = UUID()
            value = wrappedValue
        }
    }
}
