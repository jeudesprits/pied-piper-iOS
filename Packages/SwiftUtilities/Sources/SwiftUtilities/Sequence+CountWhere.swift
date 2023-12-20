//
//  Sequence+CountWhere.swift
//
//
//  Created by Ruslan Lutfullin on 25/07/23.
//

extension Sequence {
    
    @inlinable
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }
}
