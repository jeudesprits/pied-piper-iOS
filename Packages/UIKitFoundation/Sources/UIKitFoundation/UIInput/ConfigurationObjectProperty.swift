//
//  ConfigurationObjectProperty.swift
//  
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

protocol ConfigurationObjectProperty: DeferredChangesInputObjectProperty where Input: UIConfiguration {
    
    var previousValue: Input? { get set }
    
    var value: Input? { get set }
}
