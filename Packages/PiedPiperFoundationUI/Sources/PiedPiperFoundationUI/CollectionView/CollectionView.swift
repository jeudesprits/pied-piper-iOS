//
//  BaseCollectionView.swift
//
//
//  Created by Ruslan Lutfullin on 6/30/21.
//

import UIKit

open class CollectionView: UICollectionView, ViewProtocol, ViewProtocolPrivate, UIInputEnvironment, UIInputEnvironmentPrivate, UIInputChangesObservable {
	
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
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        inputChangesSystem = UIInputChangesSystem(for: self)
        setupCommon()
    }
    
    @available(*, unavailable, message: "use 'init(frame:)' instead")
    public required init?(coder: NSCoder) {
        fatalError()
    }
}
