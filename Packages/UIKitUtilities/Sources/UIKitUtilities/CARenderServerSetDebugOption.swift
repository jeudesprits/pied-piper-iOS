//
//  CARenderServerSetDebugOption.swift
//
//
//  Created by Ruslan Lutfullin on 25/03/23.
//

#if targetEnvironment(simulator)
import UIKit

public func CARenderServerSetDebugOption(_ value: Bool, for option: CARenderServerDebugOption) {
    _CARenderServerSetDebugOption(0, Int32(option.rawValue), value ? 1 : 0)
}

public enum CARenderServerDebugOption: Int {
    case colorBlendedLayers           = 0x02
    case colorHitsGreenandMissesRed   = 0x13
    case colorCopiedImages            = 0x01
    case colorLayerFormats            = 0x14
    case colorImmediately             = 0x03
    case colorMisalignedImages        = 0x0E
    case colorOffscreenRenderedYellow = 0x11
    case colorCompositingFastPathBlue = 0x12
    case flashUpdatedRegions          = 0x00
}

fileprivate let _CARenderServerSetDebugOption: @convention(c) (CInt, CInt, CInt) -> Void = {
    let handle = dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RTLD_NOW)
    defer { dlclose(handle) }
    let symbol = dlsym(handle, "CARenderServerSetDebugOption")
    let function = unsafeBitCast(symbol, to: (@convention(c) (CInt, CInt, CInt) -> Void).self)
    return function
}()
#endif
