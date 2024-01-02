//
//  ViewProtocol.swift
//
//
//  Created by Ruslan Lutfullin on 04/01/23.
//

import UIKit

public protocol ViewProtocol: UIView {
	
	// MARK: -
	
	func updatingConstraints()
	
	// MARK: -
	
	func setupCommon()
	
	func setupConstraints()
	
	func setupAfterLayoutSubviews()
}
