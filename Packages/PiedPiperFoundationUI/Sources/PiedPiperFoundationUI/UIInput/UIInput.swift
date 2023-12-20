//
//  UIInput.swift
//
//
//  Created by Ruslan Lutfullin on 07/08/23.
//

import SwiftUtilities

open class UIInput: Copyable {
    
    final let typeInfo: UIInputTypeInfo
    
    @usableFromInline
    final var willChangeHandler: () -> Void = { }
    
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
