//
//  InputObjectProperty.swift
//
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

import Foundation
import OrderedCollections

protocol InputObjectProperty: ObservableProperty {
    
    associatedtype Input: UIInput
    
    var id: UUID { get }
    
    typealias ChangesHandler = (_ previousInput: Input?, _ context: UIInputChangesContext) -> Void

    var registeredChangesHandlers: OrderedDictionary<UIInputChangesRegistration, ChangesHandler> { get set }
}
