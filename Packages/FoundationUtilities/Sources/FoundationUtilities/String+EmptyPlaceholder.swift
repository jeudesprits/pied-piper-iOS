//
//  String+EmptyPlaceholder.swift
//  
//
//  Created by Ruslan Lutfullin on 02/12/22.
//

import Foundation

extension String {
  
  public static func emptyPlaceholder(withNumberOfLines numberOfLines: Int) -> Self {
    assert(numberOfLines > 0)
    
    var result = Self()
    
    for i in 0..<numberOfLines {
      switch i {
      case 0:
        result.append(.nonBreakingSpace)
        
      default:
        result.append("\n")
        result.append(.nonBreakingSpace)
      }
    }
    
    return result
  }
}
