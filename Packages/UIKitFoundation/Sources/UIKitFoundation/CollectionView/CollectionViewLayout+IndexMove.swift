//
//  CollectionViewLayout+IndexMove.swift
//  
//
//  Created by Ruslan Lutfullin on 3/23/22.
//

extension CollectionViewLayout {
  
  public struct IndexMove: Hashable {
    public let from: Int
    public let to: Int
    
    public init(from: Int, to: Int) {
      self.from = from
      self.to = to
    }
  }
}
