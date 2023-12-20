//
//  CollectionViewLayout+CollectionViewUpdates.swift
//  
//
//  Created by Ruslan Lutfullin on 04/09/22.
//

import UIKit

extension CollectionViewLayout {
  
  public struct CollectionViewUpdates {
    public var insertedSections: Set<Int> = []
    public var insertedItems: Set<IndexPath> = []
    public var insertedSupplementaries: Set<IndexPathKind> = []
    public var insertedDecorations: Set<IndexPathKind> = []
    //
    public var deletedSections: Set<Int> = []
    public var deletedItems: Set<IndexPath> = []
    public var deletedSupplementaries: Set<IndexPathKind> = []
    public var deletedDecorations: Set<IndexPathKind> = []
    //
    public var movedSections: Set<IndexMove> = []
    public var movedItems: Set<IndexPathMove> = []
    public var movedSupplementaries: Set<IndexPathMove> = []
    public var movedDecorations: Set<IndexPathMove> = []
    //
    public var reloadedSections: Set<Int> = []
    public var reloadedItems: Set<IndexPath> = []
    public var reloadedSupplementaries: Set<IndexPathKind> = []
    public var reloadedDecorations: Set<IndexPathKind> = []
  }
}
