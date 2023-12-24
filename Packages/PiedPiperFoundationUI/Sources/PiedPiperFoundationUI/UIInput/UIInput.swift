//
//  UIInput.swift
//
//
//  Created by Ruslan Lutfullin on 07/08/23.
//

import SwiftUtilities

open class UIInput: Copyable, ObservableProperty {
    
    final let typeInfo: UIInputTypeInfo
    
    @usableFromInline
    typealias WillChangeHandler = () -> Void
    
    @usableFromInline
    final var willChangeHandler: WillChangeHandler = {}
    
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
