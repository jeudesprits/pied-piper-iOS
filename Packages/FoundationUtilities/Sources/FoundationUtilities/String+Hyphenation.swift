//
//  String+Hyphenation.swift
//  
//
//  Created by Ruslan Lutfullin on 01/12/22.
//

import Foundation
import CoreText

extension String {
  
  public func hyphenated(locale: Locale? = nil) -> Self {
    let cfLocale = (locale ?? Locale.current) as CFLocale
    
    guard CFStringIsHyphenationAvailableForLocale(cfLocale) else { return self }
    
    let fullRange = CFRangeMake(0, utf16.count)
    var hyphenationIndices = [CFIndex]()
    
    var string = self
    
    for index in utf16.indices.reversed() {
      let hyphenationIndex = CFStringGetHyphenationLocationBeforeIndex(self as CFString, index.utf16Offset(in: string), fullRange, 0, cfLocale, nil)
      
      if hyphenationIndex < 0 { return string }
      
      if hyphenationIndices.last != hyphenationIndex {
        hyphenationIndices.append(hyphenationIndex)
        let insertHyphenationIndex = Index(utf16Offset: hyphenationIndex, in: string)
        string.insert(.softHyphen, at: insertHyphenationIndex)
      }
    }
    
    return string
  }
}
