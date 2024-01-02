//
//  AfterCACommitTransaction.swift
//
//
//  Created by Ruslan Lutfullin on 15/05/23.
//

import UIKit

public struct AfterCACommitTransaction: RunLoopTransaction {
    
    public let id: UUID
    
    var flags = Flags()
    
    let mode: CFRunLoopMode
    
    let actionHandler: () -> Void
    
    @discardableResult
    public init(mode: CFRunLoopMode = .commonModes, actionHandler: @escaping () -> Void) {
        id = UUID()
        self.mode = mode
        self.actionHandler = actionHandler
        AfterCACommitQueue.shared.enqueue(self)
    }
}

extension AfterCACommitTransaction {
    
    public func commit() {
        guard !(AfterCACommitQueue.shared.withMutation(of: self, {
            let wasComitted = $0.flags.isCommitted
            $0.flags.isCommitted = true
            return wasComitted
        }) ?? true) else { return }
        actionHandler()
    }
}

extension AfterCACommitTransaction {
    
    public var isCommitted: Bool {
        AfterCACommitQueue.shared.withMutation(of: self) {
            $0.flags.isCommitted
        } ?? true
    }
    
    public var isCancelled: Bool {
        AfterCACommitQueue.shared.withMutation(of: self) {
            $0.flags.isCancelled
        } ?? true
    }
}

extension AfterCACommitTransaction: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AfterCACommitTransaction: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AfterCACommitTransaction {
    
    struct Flags {
        
        var isCommitted = false
        
        var isCancelled = false
    }
}
