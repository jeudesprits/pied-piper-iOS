//
//  UIInputChangesObservable.swift
//
//
//  Created by Ruslan Lutfullin on 09/08/23.
//

import UIKit

public protocol UIInputChangesObservable: AnyObject {
    
    typealias StateChangesHandler<State: UIState> = (_ previousState: State?, _ context: UIInputChangesContext) -> Void
    
    @discardableResult
    func registerForStateChanges<State: UIState>(
        in stateObject: inout UIView.StateObject<State>,
        _ changesHandler: @escaping StateChangesHandler<State>
    ) -> UIInputChangesRegistration
    
    func unregisterForStateChanges<State: UIState>(
        _ registration: UIInputChangesRegistration,
        for stateObject: inout UIView.StateObject<State>
    )
    
    typealias ConfigurationChangesHandler<Configuration: UIConfiguration> = (_ previousConfiguration: Configuration?, _ context: UIInputChangesContext) -> Void
    
    @discardableResult
    func registerForConfigurationChanges<Configuration: UIConfiguration>(
        in configurationObject: inout UIView.ConfigurationObject<Configuration>,
        _ changesHandler: @escaping ConfigurationChangesHandler<Configuration>
    ) -> UIInputChangesRegistration
    
    func unregisterForConfigurationChanges<Configuration: UIConfiguration>(
        _ registration: UIInputChangesRegistration,
        for configurationObject: inout UIView.ConfigurationObject<Configuration>
    )
    
    typealias InputChangesHandler<Input: UIInput> = (_ previousConfiguration: UIInput?) -> Void
    
    @discardableResult
    func registerForInputChanges<Input: UIInput>(
        in observedObject: inout UIView.ObservedObject<Input>,
        _ changesHandler: @escaping InputChangesHandler<Input>
    ) -> UIInputChangesRegistration
    
    func unregisterForInputChanges<Input: UIInput>(
        _ registration: UIInputChangesRegistration,
        for observedObject: inout UIView.ObservedObject<Input>
    )
}

extension UIInputChangesObservable {
    
    @discardableResult
    public func registerForStateChanges<State: UIState>(
        in stateObject: inout UIView.StateObject<State>,
        _ changesHandler: @escaping StateChangesHandler<State>
    ) -> UIInputChangesRegistration {
        let register = UIInputChangesRegistration()
        stateObject.registeredChangesHandlers[register] = changesHandler
        return register
    }
    
    public func unregisterForStateChanges<State: UIState>(
        _ registration: UIInputChangesRegistration,
        for stateObject: inout UIView.StateObject<State>
    ) {
        stateObject.registeredChangesHandlers.removeValue(forKey: registration)
    }
    
    @discardableResult
    public func registerForConfigurationChanges<Configuration: UIConfiguration>(
        in configurationObject: inout UIView.ConfigurationObject<Configuration>,
        _ changesHandler: @escaping ConfigurationChangesHandler<Configuration>
    ) -> UIInputChangesRegistration {
        let register = UIInputChangesRegistration()
        configurationObject.registeredChangesHandlers[register] = changesHandler
        return register
    }
    
    public func unregisterForConfigurationChanges<Configuration: UIConfiguration>(
        _ registration: UIInputChangesRegistration,
        for configurationObject: inout UIView.ConfigurationObject<Configuration>
    ) {
        configurationObject.registeredChangesHandlers.removeValue(forKey: registration)
    }
    
    @discardableResult
    public func registerForInputChanges<Input: UIInput>(
        in observedObject: inout UIView.ObservedObject<Input>,
        _ changesHandler: @escaping InputChangesHandler<Input>
    ) -> UIInputChangesRegistration {
        let register = UIInputChangesRegistration()
        observedObject.registeredChangesHandlers[register] = changesHandler
        return register
    }
    
    public func unregisterForInputChanges<Input: UIInput>(
        _ registration: UIInputChangesRegistration,
        for observedObject: inout UIView.ObservedObject<Input>
    ) {
        observedObject.registeredChangesHandlers.removeValue(forKey: registration)
    }
}

public struct UIInputChangesRegistration {
    
    let id = UUID()
}

extension UIInputChangesRegistration: Hashable {
}
