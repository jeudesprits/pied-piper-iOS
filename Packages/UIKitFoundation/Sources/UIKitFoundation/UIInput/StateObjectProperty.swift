//
//  StateObjectProperty.swift
//
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

protocol StateObjectProperty: DeferredChangesInputObjectProperty where Input: UIState {
    
    var previousValue: Input? { get set }
    
    var value: Input { get set }
}
