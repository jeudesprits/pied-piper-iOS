//
//  CollectionViewLayout+LayoutSize.swift
//  
//
//  Created by Ruslan Lutfullin on 04/09/22.
//

import UIKit

extension CollectionViewLayout {
  
  public struct LayoutSize {
    public var old: CGSize = .zero
    public var current: CGSize = .zero
    
    public mutating func reset() {
      old = current
      current = .zero
    }
  }
}
