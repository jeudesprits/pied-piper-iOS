//
//  ObservedObjectProperty.swift
//  
//
//  Created by Ruslan Lutfullin on 28/12/23.
//

protocol ObservedObjectProperty: ImmediateChangesInputObjectProperty {
    
    var previousValue: Input? { get set }
    
    var value: Input? { get set }
}
