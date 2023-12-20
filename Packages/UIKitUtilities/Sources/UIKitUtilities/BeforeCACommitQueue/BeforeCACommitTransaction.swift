//
//  BeforeCACommitTransaction.swift
//
//
//  Created by Ruslan Lutfullin on 15/05/23.
//

import UIKit

///
public struct BeforeCACommitTransaction: Identifiable {
	
	internal let _transaction: BeforeCACommitQueue.Transaction
	
	public let id: UUID
	
	@discardableResult
	public init(
		action: @escaping () -> Void,
		onCancel cancelHandler: @escaping () -> Void = {}
	) {
		_transaction = .init(action: action, onCancel: cancelHandler)
		id = _transaction.id
		BeforeCACommitQueue.shared.enqueue(_transaction)
	}
}

extension BeforeCACommitTransaction {
	
	public var isCommitted: Bool { _transaction.isCommitted }
	
	public func commitSynchronously() {
		BeforeCACommitQueue.shared.dequeue(_transaction)
	}
	
	public static func commitSynchronously<S>(of transactions: S) where S: Sequence<Self> {
		BeforeCACommitQueue.shared.dequeue(of: transactions.lazy.map { $0._transaction })
	}
}

extension BeforeCACommitTransaction {
	
	public var isCancelled: Bool { _transaction.isCancelled }
	
	public func cancel() {
		BeforeCACommitQueue.shared.dequeue(_transaction, asCancellation: true)
	}
}

extension BeforeCACommitTransaction: Equatable {
	
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs._transaction == rhs._transaction
	}
}

extension BeforeCACommitTransaction: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(_transaction)
	}
}
