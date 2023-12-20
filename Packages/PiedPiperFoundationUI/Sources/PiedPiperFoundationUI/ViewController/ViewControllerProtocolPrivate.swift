//
//  ViewControllerProtocolPrivate.swift
//
//
//  Created by Ruslan Lutfullin on 17/06/23.
//

import UIKit

internal protocol ViewControllerProtocolPrivate: ViewControllerProtocol {
    
    var setupFlags: SetupFlags { get set }
}

extension ViewControllerProtocolPrivate {
    
    func _viewWillUpdatingConstraints() {
        if !setupFlags.updateViewConstraintsVisitedOnce {
            setupFlags.updateViewConstraintsVisitedOnce = false
            setupViewConstraints()
        }
    }
    
    func _viewDidLayoutSubviews() {
        if !setupFlags.viewDidLayoutSubviewsVisitedOnce {
            setupFlags.viewDidLayoutSubviewsVisitedOnce = false
            setupAfterViewDidLayoutSubviews()
        }
    }
}
