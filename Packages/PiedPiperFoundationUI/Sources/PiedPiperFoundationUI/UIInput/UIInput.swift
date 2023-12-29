//
//  UIInput.swift
//
//
//  Created by Ruslan Lutfullin on 07/08/23.
//

import SwiftUtilities

open class UIInput: Copyable, ObservableInputProperty {
    
    final let typeInfo: UIInputTypeInfo
    
    @usableFromInline
    typealias WillChangeHandler = () -> Void
    
    @usableFromInline
    final var willChangeHandler: WillChangeHandler = {}
    
    @usableFromInline
    typealias DidChangeHandler = () -> Void
    
    @usableFromInline
    final var didChangeHandler: DidChangeHandler = {}
    
    init() {
        typeInfo = UIInputTypeInfo(of: Self.self)
    }
    
    open func copy() -> Self {
        UIInput(copy: self) as! Self
    }
    
    public init(copy other: borrowing UIInput) {
        typeInfo = other.typeInfo
    }
}
