//
//  ContainerControllerTransitioningDelegate.swift
//  
//
//  Created by Ruslan Lutfullin on 20/04/23.
//

import UIKit

///
public protocol ContainerControllerTransitioningDelegate: AnyObject {
  
  func animationController(
    forPresented presentedViewController: UIViewController,
    presenting presentingViewController: UIViewController,
    container containerViewController: UIViewController
  ) -> (any ContainerControllerAnimatedTransitioning)?

  func animationController(
    forDismissed dismissedViewController: UIViewController,
    container containerViewController: UIViewController
  ) -> (any ContainerControllerAnimatedTransitioning)?
}
