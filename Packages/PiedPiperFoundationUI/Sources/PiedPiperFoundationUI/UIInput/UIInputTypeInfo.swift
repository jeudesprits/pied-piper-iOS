//
//  UIInputTypeInfo.swift
//
//
//  Created by Ruslan Lutfullin on 19/12/23.
//

import SwiftUtilities

struct UIInputTypeInfo {
    
    let invalidatingProperties: [InvalidatingPropertyInfo]
    
    init<T: UIInput>(of type: T.Type) {
        var invalidatingProperties_: [InvalidatingPropertyInfo] = []
        invalidatingProperties_.reserveCapacity(_getRecursiveChildCount(type))
        
        _forEachField(of: type, options: [.classType, .ignoreUnknown]) { name, offset, type in
            guard let type = type as? any InvalidatingProperty.Type else { return true }
            invalidatingProperties_.append(InvalidatingPropertyInfo(name: String(cString: name), offset: offset, type: type))
            return true
        }
        
        invalidatingProperties = consume invalidatingProperties_
    }
}

struct InvalidatingPropertyInfo {
    
    let name: String
    
    let offset: Int
    
    let type: any InvalidatingProperty.Type
}
