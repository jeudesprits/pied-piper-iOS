//
//  Application.swift
//
//
//  Created by Ruslan Lutfullin on 22/11/23.
//

import UIKit

public final class Application: UIApplication {
    
    public override class var shared: Application {
        unsafeDowncast(super.shared, to: Application.self)
    }
    
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
//        if let touch = event.allTouches?.first {
//            print(touch, touch.gestureRecognizers?.debugDescription as Any, touch.view as Any, separator: "\n")
//            print("\n")
//        }
    }
}
