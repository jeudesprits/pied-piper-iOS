//
//  UIView+ToolsDebug.swift
//
//
//  Created by Ruslan Lutfullin on 31/10/23.
//

import UIKit
import Tor

extension UIView {
    
    public static var isToolsDebugAlignmentRectsEnabled: Bool {
        get {
            perform(NSSelectorFromString(Tor.decode("TMHHELYzwN:VEB:GFzGMmzxML"))).takeUnretainedValue() as! Bool // _toolsDebugAlignmentRects
        }
        set {
            perform(NSSelectorFromString(Tor.decode("TzGvwEzoHHELYzwN:VEB:GFzGMmzxMLU")), with: newValue) // _enableToolsDebugAlignmentRects:
        }
    }
    
    public static var isToolsDebugColorViewBoundsEnabled: Bool {
        get {
            perform(NSSelectorFromString(Tor.decode("TMHHELYzwN:XHEHKqBzPWHNGyL"))).takeUnretainedValue() as! Bool // _toolsDebugColorViewBounds
        }
        set {
            perform(NSSelectorFromString(Tor.decode("TzGvwEzoHHELYzwN:XHEHKqBzPWHNGyLU")), with: newValue) // _enableToolsDebugColorViewBounds:
        }
    }
}
