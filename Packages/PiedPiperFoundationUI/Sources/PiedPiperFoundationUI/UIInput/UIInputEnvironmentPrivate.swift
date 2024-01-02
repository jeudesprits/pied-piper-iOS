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
    
    @inlinable
    func _setNeedsInputsChanges() {
        inputChangesSystem.setNeedsChanges()
    }
    
    @inlinable
    func _setNeedsInputChanges<State: UIState>(of input: UIView.StateObject<State>) {
        inputChangesSystem.setNeedsChanges(of: input)
    }
    
    @inlinable
    func _setNeedsInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        inputChangesSystem.setNeedsChanges(of: input)
    }
    
    @inlinable
    func _setNeedsAnimatedInputsChanges() {
        inputChangesSystem.setNeedsAnimatedChanges()
    }
    
    @inlinable
    func _setNeedsAnimatedInputChanges<State: UIState>(of input: UIView.StateObject<State>) {
        inputChangesSystem.setNeedsAnimatedChanges(of: input)
    }
    
    @inlinable
    func _setNeedsAnimatedInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        inputChangesSystem.setNeedsAnimatedChanges(of: input)
    }
    
    @inlinable
    func _changesInputsIfNeeded() {
        inputChangesSystem.changesIfNeeded()
    }
    
    @inlinable
    func _contextForInputChanges<State: UIState>(of input: UIView.StateObject<State>) -> UIInputChangesContext? {
        inputChangesSystem.contextForChanges(of: input)
    }
    
    @inlinable
    func _contextForInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) -> UIInputChangesContext? {
        inputChangesSystem.contextForChanges(of: input)
    }
}

final class UIInputChangesSystem {
    
    private let environmentID: ObjectIdentifier
    
    private let environmentTypeInfo: UIInputEnvironmentTypeInfo
    
    private let environmentPointer: UnsafeMutableRawPointer
    
    private var currentTransaction: RunLoopPerformTransaction!
    
    private var currentContext: Context!
    
    init(for environment: some UIInputEnvironmentPrivate) {
        environmentID = ObjectIdentifier(environment)
        environmentTypeInfo = UIInputEnvironmentTypeInfo(of: type(of: environment))
        environmentPointer = Unmanaged.passUnretained(environment).toOpaque()
        prepareForChanges()
    }
}

extension UIInputChangesSystem {
    
    func setNeedsChanges() {
        startDeferringChangesIfNeeded()
        currentContext?.needsChanges = true
    }
    
    func setNeedsChanges<State: UIState>(of input: UIView.StateObject<State>) {
        startDeferringChangesIfNeeded()
        currentContext?.needsChangesIdentifiers.insert(input.id)
    }
    
    func setNeedsChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        startDeferringChangesIfNeeded()
        currentContext?.needsChangesIdentifiers.insert(input.id)
    }
    
    func setNeedsAnimatedChanges() {
        currentContext?.needsAnimatedChanges = true
    }
    
    func setNeedsAnimatedChanges<State: UIState>(of input: UIView.StateObject<State>) {
        currentContext?.needsAnimatedChangesIdentifiers.insert(input.id)
    }
    
    func setNeedsAnimatedChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        currentContext?.needsAnimatedChangesIdentifiers.insert(input.id)
    }
    
    func changesIfNeeded() {
//        currentContext?.needsDeferredChanges = false
        currentTransaction?.commit()
    }
    
    func contextForChanges<State: UIState>(of input: UIView.StateObject<State>) -> UIInputChangesContext? {
        currentContext?.pendingChangesContexts[input.id]
    }
    
    func contextForChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) -> UIInputChangesContext? {
        currentContext?.pendingChangesContexts[input.id]
    }
}

extension UIInputChangesSystem {
    
    private func prepareForChanges() {
        assert(currentTransaction == nil)
        assert(currentContext == nil)
        
        guard !(environmentTypeInfo.stateObjectProperties.isEmpty && environmentTypeInfo.configurationObjectProperties.isEmpty) else { return }
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(self.environmentID.debugDescription, privacy: .public)] \
            Preparing Input objects for deferring changes...
            """
        )
        
        func visit(stateObjectPropertyOf type: (some StateObjectProperty).Type, with propertyInfo: StateObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            
            let propertyIdentifier = propertyPointer.pointee.id
            currentContext.pendingChangesIdentifiers.insert(propertyIdentifier)
            
            propertyPointer.pointee.willChangeHandler = { [unowned(unsafe) self] in
                guard !UIView.performingWithoutInputsChanges else { return }
                
                let isPendingChangesIdentifier = currentContext?.pendingChangesIdentifiers.contains(propertyIdentifier) ?? false
                
                guard !isPendingChangesIdentifier else { return }
                
                let previousValue = propertyPointer.pointee.value.copy()
                propertyPointer.pointee.previousValue = consume previousValue
                
                startDeferringChangesIfNeeded()
                currentContext.pendingChangesIdentifiers.insert(propertyIdentifier)
                
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                    transactionID=\(self.currentTransaction.id, privacy: .public), \
                    stateObject=\(propertyInfo.typeName, privacy: .public), \
                    stateObjectID=\(propertyIdentifier, privacy: .public)] \
                    State object pending changes
                    """
                )
            }
        }
        
        func visit(configurationObjectPropertyOf type: (some ConfigurationObjectProperty).Type, with propertyInfo: ConfigurationObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            
            let propertyIdentifier = propertyPointer.pointee.id
            currentContext.pendingChangesIdentifiers.insert(propertyIdentifier)
            
            propertyPointer.pointee.willChangeHandler = { [unowned(unsafe) self] in
                guard !UIView.performingWithoutInputsChanges else { return }
                
                let isPendingChangesIdentifier = currentContext?.pendingChangesIdentifiers.contains(propertyIdentifier) ?? false
                
                guard !isPendingChangesIdentifier else { return }
                
                let previousValue = propertyPointer.pointee.value?.copy()
                propertyPointer.pointee.previousValue = consume previousValue
                
                startDeferringChangesIfNeeded()
                currentContext.pendingChangesIdentifiers.insert(propertyIdentifier)
                
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                    transactionID=\(self.currentTransaction.id, privacy: .public), \
                    configurationObject=\(propertyInfo.typeName, privacy: .public), \
                    configurationObjectID=\(propertyIdentifier, privacy: .public)] \
                    Configuration object pending changes
                    """
                )
            }
        }
        
        func visit(observedObjectPropertyOf type: (some ObservedObjectProperty).Type, with propertyInfo: ObservedObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            let propertyIdentifier = propertyPointer.pointee.id
            
            propertyPointer.pointee.willChangeHandler = {
                propertyPointer.pointee.previousValue = propertyPointer.pointee.value?.copy()
                
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                    observedObject=\(propertyInfo.typeName, privacy: .public), \
                    observedObjectID=\(propertyIdentifier, privacy: .public)] \
                    Observed object pending changes
                    """
                )
            }
            
            propertyPointer.pointee.didChangeHandler = {
                OSLogger.uiinput.debug(
                    """
                    [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                    environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                    observedObject=\(propertyInfo.typeName, privacy: .public), \
                    observedObjectID=\(propertyIdentifier, privacy: .public)] \
                    Performing Observed objects changes...
                    """
                )
                
                let previousValue = propertyPointer.pointee.previousValue
                for changesHandler in propertyPointer.pointee.registeredChangesHandlers.values {
                    changesHandler(previousValue)
                }
            }
        }
        
        startDeferringChangesIfNeeded()
        
        for propertyInfo in environmentTypeInfo.stateObjectProperties {
            let type = propertyInfo.type
            visit(stateObjectPropertyOf: type, with: propertyInfo)
        }
        
        for propertyInfo in environmentTypeInfo.configurationObjectProperties {
            let type = propertyInfo.type
            visit(configurationObjectPropertyOf: type, with: propertyInfo)
        }
        
        for propertyInfo in environmentTypeInfo.observedObjectProperties {
            let type = propertyInfo.type
            visit(observedObjectPropertyOf: type, with: propertyInfo)
        }
    }
}

extension UIInputChangesSystem {
    
    private func startDeferringChangesIfNeeded() {
        guard currentTransaction == nil else { return }
        assert(currentContext == nil)
        
        currentContext = Context()
        let maximumCapacity = environmentTypeInfo.stateObjectProperties.count + environmentTypeInfo.configurationObjectProperties.count
        currentContext.pendingChangesIdentifiers.reserveCapacity(maximumCapacity)
        currentContext.pendingChangesContexts.reserveCapacity(maximumCapacity)
        
        currentTransaction = RunLoopPerformTransaction { [weak self] in
            guard let self else { return }
            
            performDeferredChanges()
            
            OSLogger.uiinput.debug(
                """
                [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                transactionID=\(self.currentTransaction.id, privacy: .public)] \
                Input objects changes transaction committed
                """
            )
            
            currentTransaction = nil
            currentContext = nil
        }
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(self.environmentID.debugDescription, privacy: .public), \
            transactionID=\(self.currentTransaction.id, privacy: .public)] \
            Input objects changes transaction enqueued
            """
        )
    }
    
    private func performDeferredChanges() {
        assert(currentTransaction != nil)
        assert(currentContext != nil)
        
        OSLogger.uiinput.debug(
            """
            [environment=\(self.environmentTypeInfo.name, privacy: .public), \
            environmentID=\(self.environmentID.debugDescription, privacy: .public), \
            transactionID=\(self.currentTransaction.id, privacy: .public)] \
            Performing Input objects changes...
            """
        )
        
        func visit(stateObjectPropertyOf type: (some StateObjectProperty).Type, with propertyInfo: StateObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            let propertyIdentifier = propertyPointer.pointee.id
            
            let shouldPerform = if currentContext.pendingChangesIdentifiers.contains(propertyIdentifier), propertyPointer.pointee.value != propertyPointer.pointee.previousValue {
                true
            } else if currentContext.needsChanges || currentContext.needsChangesIdentifiers.contains(propertyIdentifier) {
                true
            } else {
                false
            }
            guard shouldPerform else { return }
            
            OSLogger.uiinput.debug(
                """
                [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                transactionID=\(self.currentTransaction.id, privacy: .public), \
                stateObject=\(propertyInfo.typeName, privacy: .public), \
                stateObjectID=\(propertyIdentifier, privacy: .public)] \
                Performing State object changes...
                """
            )
            
            var context = UIInputChangesContext()
            context.isAnimated = currentContext.needsAnimatedChanges || currentContext.needsAnimatedChangesIdentifiers.contains(propertyIdentifier)
            currentContext.pendingChangesContexts[propertyIdentifier] = context
            
            let previousValue = propertyPointer.pointee.previousValue
            for changesHandler in propertyPointer.pointee.registeredChangesHandlers.values {
                changesHandler(previousValue, context)
            }
        }
        
        func visit(configurationObjectPropertyOf type: (some ConfigurationObjectProperty).Type, with propertyInfo: ConfigurationObjectPropertyInfo) {
            let propertyPointer = environmentPointer.advanced(by: propertyInfo.offset).assumingMemoryBound(to: type)
            let propertyIdentifier = propertyPointer.pointee.id
            
            let shouldPerform = if currentContext.pendingChangesIdentifiers.contains(propertyIdentifier), propertyPointer.pointee.value != propertyPointer.pointee.previousValue {
                true
            } else if currentContext.needsChanges || currentContext.needsChangesIdentifiers.contains(propertyIdentifier) {
                true
            } else {
                false
            }
            guard shouldPerform else { return }
            
            OSLogger.uiinput.debug(
                """
                [environment=\(self.environmentTypeInfo.name, privacy: .public), \
                environmentID=\(self.environmentID.debugDescription, privacy: .public), \
                transactionID=\(self.currentTransaction.id, privacy: .public), \
                configurationObject=\(propertyInfo.typeName, privacy: .public), \
                configurationID=\(propertyIdentifier, privacy: .public)] \
                Performing Configuration object changes...
                """
            )
            
            var context = UIInputChangesContext()
            context.isAnimated = currentContext.needsAnimatedChanges || currentContext.needsAnimatedChangesIdentifiers.contains(propertyIdentifier)
            currentContext.pendingChangesContexts[propertyIdentifier] = context
            
            let previousValue = propertyPointer.pointee.previousValue
            for changesHandler in propertyPointer.pointee.registeredChangesHandlers.values {
                changesHandler(previousValue, context)
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
    }
}

extension UIInputChangesSystem {
    
    struct Context {
        
//        var needsDeferredChanges = true
        
        var pendingChangesIdentifiers: Set<UUID> = []
        
        var pendingChangesContexts: [UUID: UIInputChangesContext] = [:]
        
        var needsChanges = false
        
        var needsChangesIdentifiers: Set<UUID> = []
        
        var needsAnimatedChanges = false
        
        var needsAnimatedChangesIdentifiers: Set<UUID> = []
    }
}
