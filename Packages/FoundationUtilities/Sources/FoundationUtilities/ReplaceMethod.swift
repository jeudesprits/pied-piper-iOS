//
//  ReplaceMethod.swift
//
//
//  Created by Ruslan Lutfullin on 02/01/23.
//

import ObjectiveC

public func replaceMethod(of type: NSObject.Type, from originalSelector: Selector, to newSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(type, originalSelector),
          let newMethod = class_getInstanceMethod(type, newSelector)
    else { 
        assertionFailure()
        return
    }
    if class_addMethod(type, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
        class_replaceMethod(type, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, newMethod)
    }
}
