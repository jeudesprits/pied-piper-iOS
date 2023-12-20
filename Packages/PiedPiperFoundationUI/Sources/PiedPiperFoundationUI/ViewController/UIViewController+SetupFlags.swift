//
//  UIViewController+SetupFlags.swift
//
//
//  Created by Ruslan Lutfullin on 17/06/23.
//

import UIKit

extension UIViewController {
    
    struct SetupFlags {
        
        var updateViewConstraintsVisitedOnce = false
        
        var viewDidLayoutSubviewsVisitedOnce = false
    }
}
