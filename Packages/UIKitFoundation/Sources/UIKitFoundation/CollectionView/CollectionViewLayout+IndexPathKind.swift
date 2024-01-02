//
//  CollectionViewLayout+IndexPathKind.swift
//  
//
//  Created by Ruslan Lutfullin on 3/23/22.
//

import UIKit

extension CollectionViewLayout {
  
  public struct IndexPathKind: Hashable {
    public let of: String
    public var at: IndexPath
    
    public init(of: String, at: IndexPath) {
      self.of = of
      self.at = at
    }
  }
}
