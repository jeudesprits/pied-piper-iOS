//
//  ContainerControllerCoordinatorContextTransitioning.swift
//  
//
//  Created by Ruslan Lutfullin on 20/04/23.
//

import UIKit

///
public protocol ContainerControllerCoordinatorContextTransitioning {

  var containerView: UIView { get }

  var isAnimated: Bool { get }

  var duration: Double { get }

  var animation: ContainerControllerTransitioning.Animation { get }

  func viewController(forKey key: ContainerControllerTransitioning.ViewKey) -> UIViewController

  func view(forKey key: ContainerControllerTransitioning.ViewKey) -> UIView
}
