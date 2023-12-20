//
//  TextView.swift
//  
//
//  Created by Ruslan Lutfullin on 06/05/22.
//

import UIKit

///
//open class TextView: UITextView, ViewProtocolInternal {
//	
//	// MARK: -
//	
//	public final let id: UUID
//	
//	// MARK: -
//	
//	internal final let typeInfo: TypeInfo
//	
//	internal final var stateConfigurationContext: StateConfigurationContext = .init()
//	
//	internal final var stateConfigurationFlags: StateConfigurationFlags = []
//	
//	public final var hasUncommittedStateUpdates: Bool { stateConfigurationFlags.contains(.hasUncommittedStateUpdates) }
//	
//	public final var hasUncommittedConfigurationUpdates: Bool { stateConfigurationFlags.contains(.hasUncommittedConfigurationUpdates) }
//	
//	// MARK: -
//	
//	public final func setNeedsUpdateState() {
//		_setNeedsUpdateState()
//	}
//	
//	public final func updateStateIfNeeded() {
//		_updateStateIfNeeded()
//	}
//	
//	open func didUpdateState(_ state: UIState) {
//		_didUpdateState(state)
//	}
//	
//	// MARK: -
//	
//	open func shouldAutomaticallyUpdateConfiguration(_ configuration: UIConfiguration) -> Bool {
//		return true
//	}
//	
//	open func updateConfiguration(_ configuration: UIConfiguration, using state: UIState) {
//		_updateConfiguration(configuration, using: state)
//	}
//	
//	public typealias UpdateConfigurationHandler = (_ configuration: UIConfiguration, _ state: UIState) -> Void
//	
//	public final var updateConfigurationHandler: UpdateConfigurationHandler? {
//		didSet {
//			guard updateConfigurationHandler != nil else { return }
//			_setNeedsUpdateState()
//		}
//	}
//	
//	// MARK: -
//	
//	public final func setNeedsUpdateConfiguration() {
//		_setNeedsUpdateConfiguration()
//	}
//	
//	public final func updateConfigurationIfNeeded() {
//		_updateConfigurationIfNeeded()
//	}
//	
//	open func didUpdateConfiguration(_ configuration: UIConfiguration) {
//		_didUpdateConfiguration(configuration)
//	}
//	
//	// MARK: -
//	
//	internal final var setupFlags: SetupFlags = []
//	
//	open func setupCommon() {
//	}
//	
//	open func setupConstraints() {
//	}
//	
//	open func setupAfterLayoutSubviews() {
//	}
//	
//	// MARK: -
//	
//	public final override class var requiresConstraintBasedLayout: Bool { true }
//	
//	open override func updateConstraints() {
//		_updateConstraints()
//		super.updateConstraints()
//	}
//	
//	open func updatingConstraints() {
//	}
//	
//	open override func layoutSubviews() {
//		super.layoutSubviews()
//		_layoutSubviews()
//	}
//	
//	// MARK: -
//	public override init(frame: CGRect, textContainer: NSTextContainer?) {
//		id = .init()
//		typeInfo = .init(Self.self)
//		super.init(frame: frame, textContainer: textContainer)
//		setupCommon()
//		setupStateConfigurationObjects()
//	}
//	
//	@available(*, unavailable, message: "use 'init(frame:textContainer:)' instead")
//	public required init?(coder: NSCoder) {
//		fatalError()
//	}
//}
