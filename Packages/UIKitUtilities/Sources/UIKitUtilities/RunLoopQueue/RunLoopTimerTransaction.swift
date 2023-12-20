//
//  RunLoopTimerTransaction.swift
//
//
//  Created by Ruslan Lutfullin on 30/05/23.
//

import UIKit

public struct RunLoopTimerTransaction: RunLoopTransaction {
    
    public let id: UUID
    
    var flags = Flags()
    
    let mode: CFRunLoopMode
    
    let delay: CFTimeInterval
    
    let actionHandler: () -> Void
    
    @discardableResult
    public init(mode: CFRunLoopMode = .commonModes, delay: CFTimeInterval, actionHandler: @escaping () -> Void) {
        id = UUID()
        self.mode = mode
        self.delay = delay
        self.actionHandler = actionHandler
        RunLoopQueue.main.enqueue(self)
    }
}

extension RunLoopTimerTransaction {
    
    public func commit() {
        guard !isCommitted else { return }
        actionHandler()
        RunLoopQueue.main.withMutation(of: self) {
            $0.flags.isCommitted = true
        }
    }
}

extension RunLoopTimerTransaction {
    
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

extension RunLoopTimerTransaction: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RunLoopTimerTransaction: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension RunLoopTimerTransaction {
    
    struct Flags {
        
        var isCommitted = false
        
        var isCancelled = false
    }
}
