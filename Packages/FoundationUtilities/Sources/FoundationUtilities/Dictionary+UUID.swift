//
//  Dictionary+UUID.swift
//  
//
//  Created by Ruslan Lutfullin on 02/12/22.
//

import Foundation

extension Dictionary where Key == UUID {
  
  @discardableResult
  public mutating func insert(_ value: Value) -> UUID {
    let id = UUID()
    self[id] = value
    return id
  }
}
