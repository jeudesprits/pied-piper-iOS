//
//  ViewProtocolInternal.swift
//
//
//  Created by Ruslan Lutfullin on 27/05/23.
//

import UIKit

protocol ViewProtocolPrivate: ViewProtocol {
    
    var setupFlags: SetupFlags { get set }
}

extension ViewProtocolPrivate {
    
    func _updateConstraints() {
        if _slowPath(!setupFlags.updateConstraintsVisitedOnce) {
            setupFlags.updateConstraintsVisitedOnce = true
            setupConstraints()
        }
        updatingConstraints()
    }
    
    func _layoutSubviews() {
        if _slowPath(!setupFlags.layoutSubviewsVisitedOnce) {
            setupFlags.layoutSubviewsVisitedOnce = true
            setupAfterLayoutSubviews()
        }
    }
}
