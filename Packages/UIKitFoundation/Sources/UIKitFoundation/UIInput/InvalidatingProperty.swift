//
//  InvalidatingProperty.swift
//
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

protocol InvalidatingProperty {
    
    associatedtype Value: Equatable
    
    var value: Value { get set }
}
