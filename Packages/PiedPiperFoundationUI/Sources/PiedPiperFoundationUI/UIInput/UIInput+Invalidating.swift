//
//  UIInput+Invalidating.swift
//
//
//  Created by Ruslan Lutfullin on 19/05/23.
//

extension UIInput {
    
    @propertyWrapper
    public struct Invalidating<Value: Equatable>: InvalidatingProperty {
        
        @usableFromInline
        var value: Value
        
        @available(*, unavailable, message: "'@Invalidating' attribute is 'UIInput' class constrained. Use it with properties of that classes, not with non-class types like struct")
        public var wrappedValue: Value {
            get {
                fatalError()
            }
            set {
                fatalError()
            }
        }
        
        @inlinable
        public static subscript<EnclosingSelf: UIInput>(
            _enclosingInstance enclosingSelf: EnclosingSelf,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
            storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
        ) -> Value {
            @inlinable
            get {
                enclosingSelf[keyPath: storageKeyPath].value
            }
            @inlinable
            set {
                let oldValue = enclosingSelf[keyPath: storageKeyPath].value
                if oldValue != newValue {
                    enclosingSelf.willChangeHandler()
                }
                enclosingSelf[keyPath: storageKeyPath].value = newValue
            }
        }
        
        @inlinable
        public init(wrappedValue: Value) {
            value = wrappedValue
        }
    }
}
