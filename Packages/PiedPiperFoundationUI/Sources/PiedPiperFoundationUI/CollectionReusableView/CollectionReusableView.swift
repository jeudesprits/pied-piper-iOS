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
    
    // MARK: -
    
    final var setupFlags = SetupFlags()
    
    open func setupCommon() {
    }
    
    open func setupConstraints() {
    }
    
    open func setupAfterLayoutSubviews() {
    }
    
    // MARK: -
    
    public override static var requiresConstraintBasedLayout: Bool { true }
    
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
        changesStateIfNeeded()
        changesConfigurationIfNeeded()
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
