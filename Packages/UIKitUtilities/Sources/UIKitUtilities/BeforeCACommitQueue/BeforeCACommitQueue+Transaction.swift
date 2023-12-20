//
//  BeforeCACommitQueue+Transaction.swift
//
//
//  Created by Ruslan Lutfullin on 03/06/23.
//

import UIKit

extension BeforeCACommitQueue {
	
	internal final class Transaction {
		
		internal let id: UUID
		
		internal var isCommitted = false
		
		internal var isCancelled = false
		
		internal let action: () -> Void
		
		internal let cancelHandler: () -> Void
		
		internal init(
			action: @escaping () -> Void,
			onCancel cancelHandler: @escaping () -> Void
		) {
			id = .init()
			self.action = action
			self.cancelHandler = cancelHandler
		}
	}
}

extension BeforeCACommitQueue.Transaction {
	
	internal func commit() {
		guard !isCommitted && !isCancelled else { return }
		_onFastPath()
		isCommitted = true
		action()
	}
}

extension BeforeCACommitQueue.Transaction {
	
	internal func cancel() {
		guard !isCancelled && !isCommitted else { return }
		_onFastPath()
		isCancelled = true
		cancelHandler()
	}
}

extension BeforeCACommitQueue.Transaction: Equatable {
	
	internal class func ==(lhs: BeforeCACommitQueue.Transaction, rhs: BeforeCACommitQueue.Transaction) -> Bool {
		return lhs.id == rhs.id
	}
}

extension BeforeCACommitQueue.Transaction: Hashable {
	
	internal func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
