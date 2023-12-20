//
//  CollectionExtendedDifference.swift
//
//
//  Created by Ruslan Lutfullin on 05/12/23.
//

extension RangeReplaceableCollection where Element: Hashable {
    
    public func applying(_ difference: CollectionExtendedDifference<Element>) -> Self? {
        applying(difference.difference)
    }
}

extension BidirectionalCollection where Element: Hashable {
    
    public func extendedDifference(from other: some BidirectionalCollection<Element>) -> CollectionExtendedDifference<Element> {
        .init(difference(from: other).inferringMoves())
    }
}

public struct CollectionExtendedDifference<ChangeElement: Hashable> {
    
    let difference: CollectionDifference<ChangeElement>
    
    public let insertions: [Change]
    
    public let removals: [Change]
    
    public let moves: [Change]
    
    init(_ difference: CollectionDifference<ChangeElement>) {
        self.difference = difference
        var _moves: (from: [Int], to: [Int], element: [ChangeElement]) = ([], [], [])
        _moves.from.reserveCapacity(difference.insertions.count)
        _moves.to.reserveCapacity(difference.insertions.count)
        _moves.element.reserveCapacity(difference.insertions.count)
        insertions = Array(unsafeUninitializedCapacity: difference.insertions.count) { buffer, initializedCount in
            difference.insertions.withUnsafeBufferPointer { _buffer in
                for index in _buffer.indices {
                    guard case let .insert(offset, element, associatedWith) = _buffer[index] else { continue }
                    buffer.initializeElement(at: index, to: .insert(offset: offset, element: element))
                    guard let associatedWith else { continue }
                    _moves.to.append(associatedWith)
                    _moves.element.append(element)
                }
            }
            initializedCount = buffer.count
        }
        removals = Array(unsafeUninitializedCapacity: difference.removals.count) { buffer, initializedCount in
            difference.insertions.withUnsafeBufferPointer { _buffer in
                for index in _buffer.indices {
                    guard case let .remove(offset, element, associatedWith) = _buffer[index] else { continue }
                    buffer.initializeElement(at: index, to: .remove(offset: offset, element: element))
                    guard let associatedWith else { continue }
                    _moves.from.append(associatedWith)
                }
            }
            initializedCount = buffer.count
        }
        moves = Array(unsafeUninitializedCapacity: _moves.element.count) { buffer, initializedCount in
            for index in _moves.element.indices {
                buffer.initializeElement(at: index, to: .move(fromOffset: _moves.from[index], toOffset: _moves.to[index], element: _moves.element[index]))
            }
            initializedCount = buffer.count
        }
    }
}

extension CollectionExtendedDifference: Hashable {
}

extension CollectionExtendedDifference: Collection {
    
    public typealias Element = Change
    
    public var startIndex: Index {
        Index(offset: 0)
    }
    
    public var endIndex: Index {
        Index(offset: removals.count + insertions.count + moves.count)
    }
    
    public func index(after index: Index) -> Index {
        Index(offset: index.offset + 1)
    }
    
    public func index(before index: Index) -> Index {
        Index(offset: index.offset - 1)
    }
    
    public func formIndex(_ index: inout Index, offsetBy distance: Int) {
        index = Index(offset: index.offset + distance)
    }
    
    public func distance(from start: Index, to end: Index) -> Int {
        end.offset - start.offset
    }
    
    public subscript(position: Index) -> Element {
        if position.offset < removals.count {
            removals[position.offset]
        } else if position.offset < removals.count + insertions.count {
            insertions[position.offset - removals.count]
        } else {
            moves[position.offset - (removals.count + insertions.count)]
        }
    }
}

extension CollectionExtendedDifference {
    
    public struct Index {
        
        @usableFromInline
        let offset: Int
    }
}

extension CollectionExtendedDifference.Index: Equatable {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
}

extension CollectionExtendedDifference.Index: Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset < rhs.offset
    }
}

extension CollectionExtendedDifference {
    
    public enum Change {
        
        case insert(offset: Int, element: ChangeElement)
        
        case remove(offset: Int, element: ChangeElement)
        
        case move(fromOffset: Int, toOffset: Int, element: ChangeElement)
    }
}

extension CollectionExtendedDifference.Change: Hashable {
}
