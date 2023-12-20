//
//  StateObjectProperty.swift
//
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

protocol StateObjectProperty: InputObjectObservedProperty {
    
    var previousValue: Input? { get set }
    
    var value: Input { get set }
}