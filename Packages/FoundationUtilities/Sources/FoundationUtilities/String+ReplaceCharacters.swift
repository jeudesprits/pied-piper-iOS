//
//  String+ReplaceCharacters.swift
//
//
//  Created by Ruslan Lutfullin on 02/12/22.
//

import Foundation

extension String {
    
    public mutating func replaceSpacesWithNonBreaking() {
        replaceOccurrences(of: "\u{0020}", with: .nonBreakingSpace)
    }
    
    public func replacingSpacesWithNonBreaking() -> String {
        replacingOccurrences(of: "\u{0020}", with: .nonBreakingSpace)
    }
    
    internal mutating func replaceOccurrences(of target: Character, with replacement: Character) {
        var slice = self[...]
        
        while let replaceIndex = slice.firstIndex(of: target) {
            replaceSubrange(replaceIndex...replaceIndex, with: CollectionOfOne(replacement))
            slice = slice[slice.index(after: replaceIndex)...]
        }
    }
    
    internal func replacingOccurrences(of target: Character, with replacement: Character) -> Self {
        var copy = self
        var slice = copy[...]
        
        while let replaceIndex = slice.firstIndex(of: target) {
            copy.replaceSubrange(replaceIndex...replaceIndex, with: CollectionOfOne(replacement))
            slice = slice[slice.index(after: replaceIndex)...]
        }
        
        return copy
    }
}
