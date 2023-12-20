//
//  UIInputChangesContext.swift
//
//
//  Created by Ruslan Lutfullin on 14/12/23.
//

public struct UIInputChangesContext {
    
    var isPendingStateChanges = false
    
    var needsStateChanges = false
     
    var isPendingConfigurationChanges = false
    
    var needsConfigurationChanges = false
    
    public var isDeferred = true
    
    public var isAnimated = false
}
