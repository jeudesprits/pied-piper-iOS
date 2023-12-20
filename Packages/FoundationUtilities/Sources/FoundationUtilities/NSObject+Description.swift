//
//  NSObject+Description.swift
//
//
//  Created by Ruslan Lutfullin on 14/09/23.
//

import Foundation
import Tor

extension NSObject {
    
    public final class var methodDescription: String {
        perform(NSSelectorFromString(Tor.decode("TFzMAHyYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
    
    public final class var shortMethodDescription: String {
        perform(NSSelectorFromString(Tor.decode("TLAHKMhzMAHyYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
    
    public final class var propertyDescription: String {
        perform(NSSelectorFromString(Tor.decode("TIKHIzKMRYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
}

extension NSObject {
    
    public final var methodDescription: String {
        perform(NSSelectorFromString(Tor.decode("TFzMAHyYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
    
    public final var shortMethodDescription: String {
        perform(NSSelectorFromString(Tor.decode("TLAHKMhzMAHyYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
    
    public final var propertyDescription: String {
        perform(NSSelectorFromString(Tor.decode("TIKHIzKMRYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
    
    public final var ivarDescription: String {
        perform(NSSelectorFromString(Tor.decode("TBOvKYzLxKBIMBHG"))).takeUnretainedValue() as! String
    }
}
