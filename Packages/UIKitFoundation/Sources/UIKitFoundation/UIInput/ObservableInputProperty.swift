//
//  ObservableInputProperty.swift
//
//
//  Created by Ruslan Lutfullin on 28/12/23.
//

protocol ObservableInputProperty: AnyObject {
    
    typealias WillChangeHandler = () -> Void
    
    var willChangeHandler: WillChangeHandler { get set }
    
    typealias DidChangeHandler = () -> Void
    
    var didChangeHandler: DidChangeHandler { get set }
}
