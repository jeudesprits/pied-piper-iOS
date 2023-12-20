//
//  RunLoopTransaction.swift
//
//
//  Created by Ruslan Lutfullin on 18/12/23.
//

public protocol RunLoopTransaction: Identifiable, Hashable {
    
    func commit()
    
    var isCommitted: Bool { get }
    
    var isCancelled: Bool { get }
}
