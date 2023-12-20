//
//  UIAnimationDragCoefficient.swift
//
//
//  Created by Ruslan Lutfullin on 2/25/21.
//

#if targetEnvironment(simulator)
import UIKit

public func slowAnimationsCoefficient() -> Float {
    _slowAnimationsCoefficient()
}

fileprivate let _slowAnimationsCoefficient: @convention(c) () -> Float = {
    let handle = dlopen("/System/Library/Frameworks/UIKit.framework/UIKit", RTLD_NOW)
    defer { dlclose(handle) }
    let symbol = dlsym(handle, "UIAnimationDragCoefficient")
    let function = unsafeBitCast(symbol, to: (@convention(c) () -> Float).self)
    return function
}()
#endif
