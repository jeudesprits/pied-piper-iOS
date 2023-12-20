//
//  Control.swift
//  
//
//  Created by Ruslan Lutfullin on 6/30/21.
//

import UIKit

open class Control: UIControl, ViewProtocol, ViewProtocolPrivate, UIInputEnvironment, UIInputEnvironmentPrivate, UIInputChangesObservable {
	
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
	
	public final override class var requiresConstraintBasedLayout: Bool { true }
	
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
	
	public init(frame: CGRect, primaryAction: UIAction) {
		super.init(frame: frame)
		addAction(primaryAction, for: .primaryActionTriggered)
        inputChangesSystem = UIInputChangesSystem(for: self)
		setupCommon()
	}
	
	@available(*, unavailable, message: "use 'init(frame:primaryAction:)' instead")
	public required init?(coder: NSCoder) {
		fatalError()
	}
}
