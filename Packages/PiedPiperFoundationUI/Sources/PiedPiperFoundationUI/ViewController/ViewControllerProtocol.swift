//
//  ViewControllerProtocol.swift
//
//
//  Created by Ruslan Lutfullin on 11/03/23.
//

import UIKit

public protocol ViewControllerProtocol: UIViewController {
	
	// MARK: -
	
	func viewWillUpdatingConstraints()
	
	func viewDidUpdatingConstraints()
	
	// MARK: -
	
	func setupCommon()
	
	func setupViewConstraints()
	
	func setupAfterViewDidLayoutSubviews()
}
