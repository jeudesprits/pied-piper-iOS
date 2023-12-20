//
//  UIDevice+Identifier.swift
//
//
//  Created by Ruslan Lutfullin on 12/3/21.
//

import UIKit

extension UIDevice {
	
	public var modelIdentifier: String {
#if targetEnvironment(simulator)
		return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
#else
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		return machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return "\(identifier)\(UnicodeScalar(UInt8(value)))"
		}
#endif
	}
}
