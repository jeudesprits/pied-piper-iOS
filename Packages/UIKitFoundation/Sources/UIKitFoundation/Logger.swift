//
//  Logger.swift
//
//
//  Created by Ruslan Lutfullin on 15/06/23.
//

import SwiftUtilities
import Foundation
import os
import osUtilities

extension OSLogger {
	
	fileprivate static let subsystem = "com.jeudesprits.FoundationUI"
	
	 static let uiinput: Self = 
		if ProcessInfo.processInfo.environment["\(subsystem).UIInputDebug"] == "YES" {
			.init(subsystem: subsystem, category: "UIInput")
		} else {
			.init(.disabled)
		}
}
