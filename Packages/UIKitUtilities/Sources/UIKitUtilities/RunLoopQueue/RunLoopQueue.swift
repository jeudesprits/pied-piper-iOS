//
//  RunLoopQueue.swift
//
//
//  Created by Ruslan Lutfullin on 30/05/23.
//

import OrderedCollections
import UIKit

final class RunLoopQueue {
    
    private var performTransactions = OrderedSet<RunLoopPerformTransaction>(minimumCapacity: 10)
    
    private var timerTransactions = OrderedSet<RunLoopTimerTransaction>(minimumCapacity: 5)
    
    private let wakeUpSource: CFRunLoopSource
    
    private var observer: CFRunLoopObserver!
    
    private init() {
        var wakeUpSourceContext = CFRunLoopSourceContext()
        wakeUpSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &wakeUpSourceContext)
        CFRunLoopAddSource(CFRunLoopGetMain(), wakeUpSource, .commonModes)
        
        observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 0xa0, true, 1_000_001) { [unowned(unsafe) self] _, _ in
            flushPerformTransactions()
        }
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
    }
    
    deinit {
        if CFRunLoopSourceIsValid(wakeUpSource) {
            CFRunLoopSourceInvalidate(wakeUpSource)
        }
        if CFRunLoopObserverIsValid(observer) {
            CFRunLoopObserverInvalidate(observer)
        }
    }
}

extension RunLoopQueue {
    
    static let main = RunLoopQueue()
}

extension RunLoopQueue {
    
    func enqueue(_ transaction: RunLoopPerformTransaction) {
        let (inserted, _) = performTransactions.append(transaction)
        guard inserted else { return }
        CFRunLoopPerformBlock(CFRunLoopGetMain(), transaction.mode.rawValue) { [unowned(unsafe) self] in
            withMutation(of: transaction) {
                guard !$0.flags.isCommitted else { return }
                $0.flags.isCommitted = true
                $0.actionHandler()
            }
        }
        if performTransactions.count == 1 {
            CFRunLoopSourceSignal(wakeUpSource)
            CFRunLoopWakeUp(CFRunLoopGetMain())
        }
    }
    
    func enqueue(_ transaction: RunLoopTimerTransaction) {
        let (inserted, _) = timerTransactions.append(transaction)
        guard inserted else { return }
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + transaction.delay, 0.0, 0, 0) { [unowned(unsafe) self] _ in
            withMutation(of: transaction) {
                guard !$0.flags.isCommitted else { return }
                $0.flags.isCommitted = true
                $0.actionHandler()
            }
            timerTransactions.remove(transaction)
        }
        precondition(CFRunLoopTimerIsValid(timer))
        CFRunLoopAddTimer(CFRunLoopGetMain(), timer, transaction.mode)
    }
}

extension RunLoopQueue {
    
    func flushPerformTransactions() {
        for index in performTransactions.indices {
            var transaction = performTransactions[index]
            guard !transaction.flags.isCommitted else { continue }
            transaction.flags.isCommitted = true
            transaction.actionHandler()
            performTransactions.update(transaction, at: index)
        }
        performTransactions.removeAll(keepingCapacity: true)
    }
}

extension RunLoopQueue {
    
    func withMutation<R>(of transaction: RunLoopPerformTransaction, _ body: (inout RunLoopPerformTransaction) throws -> R) rethrows -> R? {
        guard let index = performTransactions.firstIndex(of: transaction) else { return nil }
        var transaction = performTransactions[index]
        let result = try body(&transaction)
        performTransactions.update(transaction, at: index)
        return result
    }
    
    func withMutation<R>(of transaction: RunLoopTimerTransaction, _ body: (inout RunLoopTimerTransaction) throws -> R) rethrows -> R? {
        guard let index = timerTransactions.firstIndex(of: transaction) else { return nil }
        var transaction = timerTransactions[index]
        let result = try body(&transaction)
        timerTransactions.update(transaction, at: index)
        return result
    }
}
