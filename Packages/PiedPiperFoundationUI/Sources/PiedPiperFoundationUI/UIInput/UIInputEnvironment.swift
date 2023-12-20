//
//  UIInputEnvironment.swift
//
//
//  Created by Ruslan Lutfullin on 08/08/23.
//

public protocol UIInputEnvironment: AnyObject {
    
    func setNeedsStateChanges()
    
    func changesStateIfNeeded()
    
    func setNeedsConfigurationChanges()
    
    func changesConfigurationIfNeeded()
    
    func withAnimatedChanges(_ changes: () -> Void)
    
    func withoutAnimatedChanges(_ changes: () -> Void)
}
