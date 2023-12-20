//
//  CollectionViewLayout+MappedLayoutAttributes.swift
//  
//
//  Created by Ruslan Lutfullin on 04/09/22.
//

import UIKit

extension CollectionViewLayout {
  
  public struct MappedLayoutAttributes {
    public var oldIndexPathsToItems: [IndexPath: Attributes] = [:]
    public var oldIndexPathKindsToSupplementaries: [IndexPathKind: Attributes] = [:]
    public var oldIndexPathKindsToDecorations: [IndexPathKind: Attributes] = [:]
    //
    public var indexPathsToItems: [IndexPath: Attributes] = [:]
    public var indexPathKindsToSupplementaries: [IndexPathKind: Attributes] = [:]
    public var indexPathKindsToDecorations: [IndexPathKind: Attributes] = [:]
    
    public mutating func reset(keepingCapacity keepCapacity: Bool = false) {
      oldIndexPathsToItems = indexPathsToItems
      oldIndexPathKindsToSupplementaries = indexPathKindsToSupplementaries
      oldIndexPathKindsToDecorations = indexPathKindsToDecorations
      
      indexPathsToItems.removeAll(keepingCapacity: keepCapacity)
      indexPathKindsToSupplementaries.removeAll(keepingCapacity: keepCapacity)
      indexPathKindsToDecorations.removeAll(keepingCapacity: keepCapacity)
    }
  }
}
