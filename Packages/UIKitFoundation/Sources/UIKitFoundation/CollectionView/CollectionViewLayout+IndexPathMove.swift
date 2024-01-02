//
//  CollectionViewLayout+IndexPathMove.swift
//  
//
//  Created by Ruslan Lutfullin on 3/23/22.
//

import UIKit

extension CollectionViewLayout {
  
  public struct IndexPathMove: Hashable {
    public let from: IndexPath
    public let to: IndexPath
    
    public init(from: IndexPath, to: IndexPath) {
      self.from = from
      self.to = to
    }
  }
}
