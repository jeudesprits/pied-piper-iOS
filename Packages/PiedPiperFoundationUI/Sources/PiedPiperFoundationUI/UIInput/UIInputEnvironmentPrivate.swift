//
//  UIInputEnvironmentPrivate.swift
//
//
//  Created by Ruslan Lutfullin on 15/08/23.
//

import UIKit
import UIKitUtilities
import os
import osUtilities

protocol UIInputEnvironmentPrivate: UIInputEnvironment {
    
    var inputChangesSystem: UIInputChangesSystem! { get }
}

extension UIInputEnvironmentPrivate {
    
    func _setNeedsStateChanges() {
        inputChangesSystem.setNeedsStateChanges()
    }
    
    func _changesStateIfNeeded() {
        inputChangesSystem.changesStateIfNeeded()
    }
    
    func _setNeedsConfigurationChanges() {
        inputChangesSystem.setNeedsConfigurationChanges()
    }
    
    func _changesConfigurationIfNeeded() {
        inputChangesSystem.changesConfigurationIfNeeded()
    }
    
    func _withAnimatedChanges(_ changes: () -> Void) {
        inputChangesSystem.withAnimatedChanges(changes)
    }
    
    func _withoutAnimatedChanges(_ changes: () -> Void) {
        inputChangesSystem.withoutAnimatedChanges(changes)
    }
}

final class UIInputChangesSystem {
    
    private unowned(unsafe) let environment: any UIInputEnvironmentPrivate
    
    private let environmentTypeInfo: UIInputEnvironmentTypeInfo
    
    private var currentContext: UIInputChangesContext!
    
    private var currentTransaction: RunLoopPerformTransaction!
    
    private var currentPendingChangesIdentifiers: Set<UUID> = []
    
    init(for environment: some UIInputEnvironmentPrivate) {
        self.environment = environment
        environmentTypeInfo = UIInputEnvironmentTypeInfo(of: type(of: environment))
        prepareForChanges()
    }
}

extension UIInputChangesSystem {
    
    func setNeedsStateChanges() {
        startDeferringChangesIfNeeded()
        currentContext?.needsStateChanges = true
    }
    
    func changesStateIfNeeded() {
        guard currentContext?.needsStateChanges == true || currentContext?.isPendingStateChanges == true else { return }
        currentTransaction?.commit()
    }
    
    func setNeedsConfigurationChanges() {
        startDeferringChangesIfNeeded()
        currentContext?.needsConfigurationChanges = true
    }
    
    func changesConfigurationIfNeeded() {
        guard currentContext?.needsConfigurationChanges == true || currentContext?.isPendingConfigurationChanges == true else { return }
        currentTransaction?.commit()
    }
    
    func withAnimatedChanges(_ changes: () -> Void) {
        changes()
        currentContext?.isDeferred = false
        currentContext?.isAnimated = true
        currentTransaction?.commit()
    }
    
    func withoutAnimatedChanges(_ changes: () -> Void) {
        changes()
        currentContext?.isDeferred = false
        currentContext?.isAnimated = false
        currentTransaction?.commit()
    }
}

extension UIInputChangesSystem {
    
    private func prepareForChanges() {
        guard !(environmentTypeInfo.stateObjectProperties.isEmpty && environmentTypeInfo.configurationObjectProperties.isEmpty) else { return }
        
        let environmentPointer = Unmanaged.passUnretained(environment as AnyObject).toOpaque()
        
        func visit(stateObjectPropertyOf type: (some StateObjectProperty).Type, with propertyInfo: StateObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            propertyPointer.pointee.willChangeHandler = { [unowned(unsafe) self] in
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public), \
                    stateObject=\(propertyInfo.typeName, privacy: .public), \
                    isPendingStateChanges=\(self.currentContext?.isPendingStateChanges ?? false)] \
                    State object will changed
                    """
                )
                
                let propertyIdentifier = propertyPointer.pointee.id
                guard !currentPendingChangesIdentifiers.contains(propertyIdentifier) else { return }
                
                let previousValue = propertyPointer.pointee.value.copy()
                propertyPointer.pointee.previousValue = previousValue
                
                startDeferringChangesIfNeeded()
                currentContext?.isPendingStateChanges = true
                currentPendingChangesIdentifiers.insert(propertyIdentifier)
            }
        }
        
        func visit(configurationObjectPropertyOf type: (some ConfigurationObjectProperty).Type, with propertyInfo: ConfigurationObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            propertyPointer.pointee.willChangeHandler = { [unowned(unsafe) self] in
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public), \
                    configurationObject=\(propertyInfo.typeName, privacy: .public), \
                    isPendingConfigurationChanges=\(self.currentContext?.isPendingConfigurationChanges ?? false)] \
                    Configuration object will changed
                    """
                )
                
                let propertyIdentifier = propertyPointer.pointee.id
                guard !currentPendingChangesIdentifiers.contains(propertyIdentifier) else { return }
                
                let previousValue = propertyPointer.pointee.value?.copy()
                propertyPointer.pointee.previousValue = previousValue
                
                startDeferringChangesIfNeeded()
                currentContext?.isPendingConfigurationChanges = true
                currentPendingChangesIdentifiers.insert(propertyIdentifier)
            }
        }
        
        for propertyInfo in environmentTypeInfo.stateObjectProperties {
            let type = propertyInfo.type
            visit(stateObjectPropertyOf: type, with: propertyInfo)
        }
        
        for propertyInfo in environmentTypeInfo.configurationObjectProperties {
            let type = propertyInfo.type
            visit(configurationObjectPropertyOf: type, with: propertyInfo)
        }
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public)] \
            Preparing input objects for deferring changes
            """
        )
        
        startDeferringChangesIfNeeded()
        currentContext?.isPendingStateChanges = !environmentTypeInfo.stateObjectProperties.isEmpty
        currentContext?.isPendingConfigurationChanges = !environmentTypeInfo.configurationObjectProperties.isEmpty
    }
}

extension UIInputChangesSystem {
    
    private func startDeferringChangesIfNeeded() {
        guard currentTransaction == nil else { return }
        assert(currentContext == nil)
        assert(currentPendingChangesIdentifiers.isEmpty)
        
        let context = UIInputChangesContext()
        currentContext = consume context
        
        let transaction = RunLoopPerformTransaction { [weak self] in
            guard let self else { return }
            
            OSLogger.uiinput.debug(
                """
                [environment=\(environmentTypeInfo.name, privacy: .public), \
                environmentID=\(ObjectIdentifier(environment).debugDescription, privacy: .public), \
                transactionID=\(self.currentTransaction.id, privacy: .public)] \
                Input objects changes transaction committed
                """
            )
            
            performDeferredChanges()
            
            currentTransaction = nil
            currentContext = nil
            currentPendingChangesIdentifiers.removeAll(keepingCapacity: true)
        }
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public), \
            transactionID=\(transaction.id, privacy: .public)] \
            Input objects changes transaction enqueued
            """
        )
        currentTransaction = consume transaction
    }
    
    private func performDeferredChanges() {
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public)] \
            Starting performing input objects changes
            """
        )
        
        let environmentPointer = Unmanaged.passUnretained(environment as AnyObject).toOpaque()
        
        if currentContext.needsStateChanges || currentContext.isPendingStateChanges {
            func visit(stateObjectPropertyOf type: (some StateObjectProperty).Type, with propertyInfo: StateObjectPropertyInfo) {
                let property = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type).pointee
                let state = property.value
                let previousState = property.previousValue
                if currentContext.needsStateChanges || state != previousState {
                    OSLogger.uiinput.debug(
                        """
                        [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                        environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public), \
                        stateObject=\(propertyInfo.typeName, privacy: .public)] \
                        Performing state object changes
                        """
                    )
                    for changesHandler in property.registeredChangesHandlers.values {
                        changesHandler(previousState, currentContext)
                    }
                }
            }
            
            for propertyInfo in environmentTypeInfo.stateObjectProperties {
                let type = propertyInfo.type
                visit(stateObjectPropertyOf: type, with: propertyInfo)
            }
        }
        
        if currentContext.needsConfigurationChanges || currentContext.isPendingConfigurationChanges {
            func visit(configurationObjectPropertyOf type: (some ConfigurationObjectProperty).Type, with propertyInfo: ConfigurationObjectPropertyInfo) {
                let property = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type).pointee
                let configuration = property.value
                let previousConfiguration = property.previousValue
                if currentContext.needsConfigurationChanges || configuration != previousConfiguration {
                    OSLogger.uiinput.debug(
                        """
                        [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                        environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public), \
                        configurationObject=\(propertyInfo.typeName, privacy: .public)] \
                        Performing configuration object changes
                        """
                    )
                    for changesHandler in property.registeredChangesHandlers.values {
                        changesHandler(previousConfiguration, currentContext)
                    }
                }
            }
            
            for propertyInfo in environmentTypeInfo.configurationObjectProperties {
                let type = propertyInfo.type
                visit(configurationObjectPropertyOf: type, with: propertyInfo)
            }
        }
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(ObjectIdentifier(self.environment).debugDescription, privacy: .public)] \
            Finished performing input objects changes
            """
        )
    }
}
