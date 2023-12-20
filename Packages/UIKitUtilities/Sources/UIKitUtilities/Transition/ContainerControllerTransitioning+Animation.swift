//
//  ContainerControllerTransitioning+Animation.swift
//  
//
//  Created by Ruslan Lutfullin on 20/04/23.
//

import UIKit

///
extension ContainerControllerTransitioning {
  
  public enum Animation {
    case viewAnimation(UIViewPropertyAnimator.Animation)
    case layerAnimation(CALayer.Animation)
    case displayLinkAnimation(DisplayLink.Animation)
    case unspecifiedAnimation
  }
}
