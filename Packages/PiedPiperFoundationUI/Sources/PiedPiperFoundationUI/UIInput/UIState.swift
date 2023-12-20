//
//  UIState.swift
//
//
//  Created by Ruslan Lutfullin on 26/12/22.
//

open class UIState: UIInput {
    
    public override init() {
        super.init()
    }
    
    open override func copy() -> Self {
        UIState(copy: self) as! Self
    }
    
    public init(copy other: borrowing UIState) {
        super.init(copy: other)
    }
}
