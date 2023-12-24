//
//  StateObject.swift
//
//
//  Created by Ruslan Lutfullin on 20/05/23.
//

import OrderedCollections
import UIKit

extension UIView {
    
    @propertyWrapper
    public struct StateObject<State: UIState>: StateObjectProperty {
        
        @usableFromInline
        let id: UUID
        
        var previousValue: State?
        
        @usableFromInline
        var value: State
        
        @usableFromInline
        typealias WillChangeHandler = () -> Void
        
        @usableFromInline
        var willChangeHandler: WillChangeHandler = {} {
            didSet {
                value.willChangeHandler = willChangeHandler
            }
        }
        
        typealias ChangesHandler = (_ previousState: State?, _ context: UIInputChangesContext) -> Void
        
        var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> = [:]
        
        @available(*, unavailable, message: "'@StateObject' attribute is class constrained that conforms 'UIInputEnvironment' protocol. Use it with properties of that classes, not with other classes or non-class types like struct")
        public var wrappedValue: State {
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
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, State>,
            storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
        ) -> State {
            @inlinable
            get {
                enclosingSelf[keyPath: storageKeyPath].value
            }
            @inlinable
            set {
                let oldValue = enclosingSelf[keyPath: storageKeyPath].value
                
                oldValue.willChangeHandler = {}
                
                if newValue != oldValue {
                    enclosingSelf[keyPath: storageKeyPath].willChangeHandler()
                }
                enclosingSelf[keyPath: storageKeyPath].value = newValue
                
                newValue.willChangeHandler = enclosingSelf[keyPath: storageKeyPath].willChangeHandler
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
        public init(wrappedValue: State) {
            id = UUID()
            value = wrappedValue
        }
    }
}
