//
//  Character+Specific.swift
//  
//
//  Created by Ruslan Lutfullin on 02/12/22.
//

import Foundation

extension Character {
  
  public static var nonBreakingSpace: Self { "\u{00A0}" }
  
  public static var nonBreakingHyphen: Self { "\u{2011}" }
  
  public static var softHyphen: Self { "\u{00AD}" }
}
