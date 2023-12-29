//
//  DeferredChangesInputObjectProperty.swift
//
//
//  Created by Ruslan Lutfullin on 21/12/23.
//

import OrderedCollections
import Foundation

protocol DeferredChangesInputObjectProperty: InputObjectProperty {
    
    typealias WillChangeHandler = () -> Void
    
    var willChangeHandler: WillChangeHandler  { get set }
        
    var id: UUID { get }
    
    typealias ChangesHandler = (_ previousInput: Input?, _ context: UIInputChangesContext) -> Void
    
    var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> { get set }
}
