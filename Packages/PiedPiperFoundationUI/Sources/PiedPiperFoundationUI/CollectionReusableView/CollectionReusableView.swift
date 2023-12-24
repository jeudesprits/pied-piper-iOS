//
//  CollectionReusableView.swift
//
//
//  Created by Ruslan Lutfullin on 6/30/21.
//

import UIKit

open class CollectionReusableView: UICollectionReusableView, ViewProtocol, ViewProtocolPrivate, UIInputEnvironment, UIInputEnvironmentPrivate, UIInputChangesObservable {
    
    // MARK: -
    
    final var inputChangesSystem: UIInputChangesSystem!
    
    public final func setNeedsInputsChanges() {
        _setNeedsInputsChanges()
    }
    
    public final func setNeedsInputChanges<State: UIState>(of input: UIView.StateObject<State>) {
        _setNeedsInputChanges(of: input)
    }
    
    public final func setNeedsInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        _setNeedsInputChanges(of: input)
    }
    
    public final func setNeedsAnimatedInputsChanges() {
        _setNeedsAnimatedInputsChanges()
    }
    
    public final func setNeedsAnimatedInputChanges<State: UIState>(of input: UIView.StateObject<State>) {
        _setNeedsAnimatedInputChanges(of: input)
    }
    
    public final func setNeedsAnimatedInputChanges<Configuration: UIConfiguration>(of input: UIView.ConfigurationObject<Configuration>) {
        _setNeedsAnimatedInputChanges(of: input)
    }
    
    public final func changesInputsIfNeeded() {
        _changesInputsIfNeeded()
    }
    
    // MARK: -
    
    final var setupFlags = SetupFlags()
    
    open func setupCommon() {
    }
    
    open func setupConstraints() {
    }
    
    open func setupAfterLayoutSubviews() {
    }
    
    // MARK: -
    
    public override final class var requiresConstraintBasedLayout: Bool { true }
    
    open override func updateConstraints() {
        _updateConstraints()
        super.updateConstraints()
    }
    
    open func updatingConstraints() {
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        _layoutSubviews()
    }
    
    // MARK: -
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        changesInputsIfNeeded()
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
    // MARK: -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        inputChangesSystem = UIInputChangesSystem(for: self)
        setupCommon()
    }
    
    @available(*, unavailable, message: "use 'init(frame:)' instead")
    public required init?(coder: NSCoder) {
        fatalError()
    }
}
