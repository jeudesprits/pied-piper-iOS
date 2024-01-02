//
//  ViewController.swift
//
//
//  Created by Ruslan Lutfullin on 6/30/21.
//

import UIKit

open class ViewController: UIViewController, ViewControllerProtocolPrivate {
	
	// MARK: -
	
	open override func updateViewConstraints() {
		viewWillUpdatingConstraints()
		super.updateViewConstraints()
		viewDidUpdatingConstraints()
	}
	
	open func viewWillUpdatingConstraints() {
		_viewWillUpdatingConstraints()
	}
	
	open func viewDidUpdatingConstraints() {
	}
	
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_viewDidLayoutSubviews()
	}
	
	// MARK: -
	
    final var setupFlags = SetupFlags()
	
	open func setupCommon() {
	}
	
	open func setupViewConstraints() {
	}
	
	open func setupAfterViewDidLayoutSubviews() {
	}
	
	// MARK: -
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		setupCommon()
	}
	
	@available(*, unavailable, message: "use 'init' instead")
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError()
	}
	
	@available(*, unavailable, message: "use 'init' instead")
	public required init?(coder: NSCoder) {
		fatalError()
	}
}
