//
//  Result+Success.swift
//
//
//  Created by Ruslan Lutfullin on 2/26/21.
//

extension Result where Success == Void {
	
	@inlinable
	public static var success: Result { .success(()) }
}
