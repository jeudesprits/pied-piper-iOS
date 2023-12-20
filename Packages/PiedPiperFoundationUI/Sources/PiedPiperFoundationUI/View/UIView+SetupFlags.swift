//
//  UIView+SetupFlags.swift
//
//
//  Created by Ruslan Lutfullin on 28/05/23.
//

import UIKit

extension UIView {
    
    struct SetupFlags {
        
        var updateConstraintsVisitedOnce = false
        
        var layoutSubviewsVisitedOnce = false
    }
}
