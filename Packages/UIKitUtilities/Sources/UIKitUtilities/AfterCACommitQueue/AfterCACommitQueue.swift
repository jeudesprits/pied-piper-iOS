//
//  AfterCACommitQueue.swift
//
//
//  Created by Ruslan Lutfullin on 11/05/23.
//

import OrderedCollections
import UIKit

final class AfterCACommitQueue {
    
    private var transactions = OrderedSet<AfterCACommitTransaction>(minimumCapacity: 10)
    
    private let wakeUpSource: CFRunLoopSource
    
    private var observer: CFRunLoopObserver!
    
    private init() {
        var wakeUpSourceContext = CFRunLoopSourceContext()
        wakeUpSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &wakeUpSourceContext)
        CFRunLoopAddSource(CFRunLoopGetMain(), wakeUpSource, .commonModes)
        
        observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 0xa0, true, 2_001_001) { [unowned(unsafe) self] _, _ in
            flushTransactions()
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

extension AfterCACommitQueue {
    
    static let shared = AfterCACommitQueue()
}

extension AfterCACommitQueue {
    
    func enqueue(_ transaction: AfterCACommitTransaction) {
        guard !transaction.flags.isCommitted else { return }
        transactions.append(transaction)
        if transactions.count == 1 {
            CFRunLoopSourceSignal(wakeUpSource)
            CFRunLoopWakeUp(CFRunLoopGetMain())
        }
    }
}

extension AfterCACommitQueue {
    
    func flushTransactions() {
        for index in transactions.indices {
            var transaction = transactions[index]
            guard !transaction.flags.isCommitted else { continue }
            transaction.flags.isCommitted = true
            transaction.actionHandler()
            transactions.update(transaction, at: index)
        }
        transactions.removeAll(keepingCapacity: true)
    }
}

extension AfterCACommitQueue {
    
    func withMutation<R>(of transaction: AfterCACommitTransaction, _ body: (inout AfterCACommitTransaction) throws -> R) rethrows -> R? {
        guard let index = transactions.firstIndex(of: transaction) else { return nil }
        var transaction = transactions[index]
        let result = try body(&transaction)
        transactions.update(transaction, at: index)
        return result
    }
}
