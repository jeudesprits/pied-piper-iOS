//
//  ImmediateChangesInputObjectProperty.swift
//
//
//  Created by Ruslan Lutfullin on 28/12/23.
//

import OrderedCollections
import Foundation

protocol ImmediateChangesInputObjectProperty: InputObjectProperty {
    
    typealias WillChangeHandler = () -> Void
    
    var willChangeHandler: WillChangeHandler { get set }
    
    typealias DidChangeHandler = () -> Void
    
    var didChangeHandler: DidChangeHandler  { get set }
        
    var id: UUID { get }
    
    typealias ChangesHandler = (_ previousInput: Input?) -> Void
    
    var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> { get set }
}
