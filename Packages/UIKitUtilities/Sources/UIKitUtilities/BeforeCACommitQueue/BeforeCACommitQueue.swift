//
//  BeforeCACommitQueue.swift
//
//
//  Created by Ruslan Lutfullin on 11/05/23.
//

import OrderedCollections
import UIKit

internal final class BeforeCACommitQueue {
	
	internal private(set) var transactions = OrderedSet<Transaction>(minimumCapacity: 64)
	
	internal static let shared = BeforeCACommitQueue()
	
	private init() {
		let runLoopObserver =
		CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 1_000_000) {
			[unowned(unsafe) self] _, _ in
			flush()
		}
		CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, .commonModes)
	}
}

extension BeforeCACommitQueue {
	
	internal func enqueue(_ transaction: Transaction) {
		transactions.append(transaction)
		if transactions.count == 1 {
			CFRunLoopWakeUp(CFRunLoopGetMain())
		}
	}
	
	internal func dequeue(_ transaction: Transaction, asCancellation cancellation: Bool = false) {
		guard transactions.contains(transaction) else { return }
		_onFastPath()
		cancellation ? transaction.cancel() : transaction.commit()
		CATransaction.flush()
	}
	
	internal func dequeue<S>(of transactions: S, asCancellation cancellation: Bool = false) where S: Sequence<Transaction> {
		var containsAtLeastOne = false
		for transaction in transactions {
			guard self.transactions.contains(transaction) else { continue }
			containsAtLeastOne = true
			cancellation ? transaction.cancel() : transaction.commit()
		}
		if containsAtLeastOne {
			CATransaction.flush()
		}
	}
}

extension BeforeCACommitQueue {
	
	internal func flush() {
		guard !transactions.isEmpty else { return }
		for transaction in transactions {
			transaction.commit()
		}
		//CATransaction.flush()
		transactions.removeAll(keepingCapacity: true)
	}
}
