//
//  NSObject+Perform.swift
//  
//
//  Created by Ruslan Lutfullin on 02/12/22.
//

import Foundation

extension NSObject {
    
    public final func perform(_ selector: Selector, with argument: Any?, inModes modes: [RunLoop.Mode]) {
        perform(selector, with: argument, afterDelay: 0.0, inModes: modes)
    }
    
    public final func perform(_ selector: Selector, with argument: Any?) {
        perform(selector, with: argument, afterDelay: 0.0)
    }
    
    public final func cancelPreviousPerformRequests(_ selector: Selector, object anArgument: Any?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: anArgument)
    }
    
    public final func cancelPreviousPerformRequests() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}
