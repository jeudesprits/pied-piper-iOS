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
    
    let observedObjectProperties: [ObservedObjectPropertyInfo]
    
    init(of environmentType: (some UIInputEnvironmentPrivate).Type) {
        name = _typeName(environmentType)
        
        var stateObjectProperties_: [StateObjectPropertyInfo] = []
        
        var configurationObjectProperties_: [ConfigurationObjectPropertyInfo] = []
        
        var observedObjectProperties_: [ObservedObjectPropertyInfo] = []
        
        _forEachField(of: environmentType, options: [.classType, .ignoreUnknown]) { _, offset, type in
            if let type = type as? any StateObjectProperty.Type {
                var typeName = _typeName(type)
                typeName.trimPrefix("(extension in UIKitFoundation):__C.UIView.")
                stateObjectProperties_.append(StateObjectPropertyInfo(offset: offset, typeName: typeName, type: type))
            } else if let type = type as? any ConfigurationObjectProperty.Type {
                var typeName = _typeName(type)
                typeName.trimPrefix("(extension in UIKitFoundation):__C.UIView.")
                configurationObjectProperties_.append(ConfigurationObjectPropertyInfo(offset: offset, typeName: typeName, type: type))
            } else if let type = type as? any ObservedObjectProperty.Type {
                var typeName = _typeName(type)
                typeName.trimPrefix("(extension in UIKitFoundation):__C.UIView.")
                observedObjectProperties_.append(ObservedObjectPropertyInfo(offset: offset, typeName: typeName, type: type))
            }
            return true
        }
        
        stateObjectProperties = consume stateObjectProperties_
        
        configurationObjectProperties = consume configurationObjectProperties_
        
        observedObjectProperties = consume observedObjectProperties_
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

struct ObservedObjectPropertyInfo {
    
    let offset: Int
    
    let typeName: String
    
    let type: any ObservedObjectProperty.Type
}
