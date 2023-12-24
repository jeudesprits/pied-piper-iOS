//
//  ConfigurationObject.swift
//
//
//  Created by Ruslan Lutfullin on 22/05/23.
//

import OrderedCollections
import UIKit

extension UIView {
    
    @propertyWrapper
    public struct ConfigurationObject<Configuration: UIConfiguration>: ConfigurationObjectProperty {
        
        @usableFromInline
        let id: UUID
        
        var previousValue: Configuration?
        
        @usableFromInline
        var value: Configuration?
        
        @usableFromInline
        typealias WillChangeHandler = () -> Void
        
        @usableFromInline
        var willChangeHandler: WillChangeHandler = {} {
            didSet {
                value?.willChangeHandler = willChangeHandler
            }
        }
        
        typealias ChangesHandler = (_ previousConfiguration: Configuration?, _ context: UIInputChangesContext) -> Void
        
        var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> = [:]
        
        @available(*, unavailable, message: "'@ConfigurationObject' attribute is class constrained that conforms 'UIInputEnvironment' protocol. Use it with properties of that classes, not with other classes or non-class types like struct")
        public var wrappedValue: Configuration? {
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
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Configuration?>,
            storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
        ) -> Configuration? {
            @inlinable
            get {
                enclosingSelf[keyPath: storageKeyPath].value
            }
            @inlinable
            set {
                let oldValue = enclosingSelf[keyPath: storageKeyPath].value
                if let oldValue {
                    oldValue.willChangeHandler = {}
                }
                if newValue != oldValue {
                    enclosingSelf[keyPath: storageKeyPath].willChangeHandler()
                }
                enclosingSelf[keyPath: storageKeyPath].value = newValue
                if let newValue {
                    newValue.willChangeHandler = enclosingSelf[keyPath: storageKeyPath].willChangeHandler
                }
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
        public init(wrappedValue: Configuration?) {
            id = UUID()
            value = wrappedValue
        }
    }
}
