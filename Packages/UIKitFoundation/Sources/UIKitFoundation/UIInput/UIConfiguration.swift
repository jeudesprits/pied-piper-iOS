//
//  ConfigurationBase.swift
//
//
//  Created by Ruslan Lutfullin on 27/12/22.
//

open class UIConfiguration: UIInput {
    
    open func update(using state: UIState) {
    }
    
    public override init() {
        super.init()
    }
    
    open override func copy() -> Self {
        UIConfiguration(copy: self) as! Self
    }
    
    public init(copy other: borrowing UIConfiguration) {
        super.init(copy: other)
    }
}
