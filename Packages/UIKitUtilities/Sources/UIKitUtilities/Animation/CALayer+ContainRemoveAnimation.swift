//
//  CALayer+ContainRemoveAnimation.swift
//
//
//  Created by Ruslan Lutfullin on 16/04/23.
//

import UIKit

extension CALayer {
	
    public var hasAnimations: Bool {
        animationKeys()?.isEmpty == false
    }
    
	public func isContainAnimation(forKey key: String) -> Bool {
        animationKeys()?.contains(key) == true
	}
	
	public func removeAnimations(containsKey key: String) {
        let subkey = key
        guard let keys = animationKeys() else { return }
        for key in keys {
            if key.contains(subkey) {
                removeAnimation(forKey: key)
            }
        }
	}
}
