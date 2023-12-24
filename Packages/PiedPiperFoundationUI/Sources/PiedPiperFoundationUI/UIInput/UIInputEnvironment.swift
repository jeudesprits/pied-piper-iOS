//
//  UIInputEnvironment.swift
//
//
//  Created by Ruslan Lutfullin on 08/08/23.
//

import UIKit

public protocol UIInputEnvironment: AnyObject {
    
    func setNeedsInputsChanges()
    
    func setNeedsInputChanges<State: UIState>(of input: UIView.StateObject<State>)
    
    func setNeedsInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>)
    
    func setNeedsAnimatedInputsChanges()
    
    func setNeedsAnimatedInputChanges<State: UIState>(of input: UIView.StateObject<State>)
    
    func setNeedsAnimatedInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>)
    
    func changesInputsIfNeeded()
    
    func contextForInputChanges<State: UIState>(of input: UIView.StateObject<State>) -> UIInputChangesContext?
    
    func contextForInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) -> UIInputChangesContext?
}
