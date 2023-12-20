//
//  UIInputEnvironmentTypeInfo.swift
//
//
//  Created by Ruslan Lutfullin on 19/12/23.
//

import SwiftUtilities

struct UIInputEnvironmentTypeInfo {
    
    let name: String
    
    let stateObjectProperties: [StateObjectPropertyInfo]
    
    let configurationObjectProperties: [ConfigurationObjectPropertyInfo]
    
    init(of environmentType: (some UIInputEnvironmentPrivate).Type) {
        name = _typeName(environmentType)
        
        var stateObjectProperties_: [StateObjectPropertyInfo] = []
        stateObjectProperties_.reserveCapacity(3)
        
        var configurationObjectProperties_: [ConfigurationObjectPropertyInfo] = []
        configurationObjectProperties_.reserveCapacity(3)
        
        _forEachField(of: environmentType, options: [.classType, .ignoreUnknown]) { _, offset, type in
            if let type = type as? any StateObjectProperty.Type {
                stateObjectProperties_.append(StateObjectPropertyInfo(offset: offset, typeName: _typeName(type), type: type))
            } else if let type = type as? any ConfigurationObjectProperty.Type {
                configurationObjectProperties_.append(ConfigurationObjectPropertyInfo(offset: offset, typeName: _typeName(type), type: type))
            }
            return true
        }
        
        stateObjectProperties = consume stateObjectProperties_
        
        configurationObjectProperties = consume configurationObjectProperties_
    }
}

struct StateObjectPropertyInfo {
    
    let offset: Int
    
    let typeName: String
    
    let type: any StateObjectProperty.Type
}

struct ConfigurationObjectPropertyInfo {
    
    let offset: Int
    
    let typeName: String
    
    let type: any ConfigurationObjectProperty.Type
}
