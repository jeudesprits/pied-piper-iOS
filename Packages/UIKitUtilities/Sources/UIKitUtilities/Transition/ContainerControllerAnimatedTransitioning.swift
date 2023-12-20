//
//  ContainerControllerAnimatedTransitioning.swift
//  
//
//  Created by Ruslan Lutfullin on 20/04/23.
//

import UIKit

///
public protocol ContainerControllerAnimatedTransitioning: AnyObject {
  
  func duration(using context: any ContainerControllerContextTransitioning) -> Double
  
  func animation(using context: any ContainerControllerContextTransitioning) -> ContainerControllerTransitioning.Animation
  
  func animate(using context: any ContainerControllerContextTransitioning)

  func complete(using context: any ContainerControllerContextTransitioning, success: Bool)
}

extension ContainerControllerAnimatedTransitioning {

  public func complete(using context: any ContainerControllerContextTransitioning, success: Bool) {
  }
}
