//
//  RunLoopPerformTransaction.swift
//
//
//  Created by Ruslan Lutfullin on 30/05/23.
//

import UIKit

public struct RunLoopPerformTransaction: RunLoopTransaction {
    
    public let id: UUID
    
    var flags = Flags()
    
    let mode: CFRunLoopMode
    
    let actionHandler: () -> Void
    
    public init(mode: CFRunLoopMode = .commonModes, actionHandler: @escaping () -> Void) {
        id = UUID()
        self.mode = mode
        self.actionHandler = actionHandler
        RunLoopQueue.main.enqueue(self)
    }
}

extension RunLoopPerformTransaction {
    
    public func commit() {
        guard !isCommitted else { return }
        actionHandler()
        RunLoopQueue.main.withMutation(of: self) {
            $0.flags.isCommitted = true
        }
    }
}

extension RunLoopPerformTransaction {
    
    public var isCommitted: Bool {
        RunLoopQueue.main.withMutation(of: self) {
            $0.flags.isCommitted
        } ?? false
    }
    
    public var isCancelled: Bool {
        RunLoopQueue.main.withMutation(of: self) {
            $0.flags.isCancelled
        } ?? false
    }
}

extension RunLoopPerformTransaction: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RunLoopPerformTransaction: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension RunLoopPerformTransaction {
    
    struct Flags {
        
        var isCommitted = false
        
        var isCancelled = false
    }
}
