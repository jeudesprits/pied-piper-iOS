//
//  File.swift
//  
//
//  Created by Ruslan Lutfullin on 20/04/23.
//

import UIKit

///
public protocol ContainerControllerContextTransitioning {
  
  var containerView: UIView { get }
  
  var isAnimated: Bool { get }
  
  func viewController<K>(forKey _: K.Type) -> UIViewController? where K: ContainerControllerViewKeyTransitioning
  
  func view(forKey key: ContainerControllerTransitioning.ViewKey) -> UIView?
  
  func initialFrame(forKey key: ContainerControllerTransitioning.FrameKey) -> CGRect
  
  func finalFrame(forKey key: ContainerControllerTransitioning.FrameKey) -> CGRect
  
  func complete(_ success: Bool)
}
