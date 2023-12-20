//
//  SceneDelegate.swift
//
//
//  Created by Ruslan Lutfullin on 22/11/23.
//

import UIKit
import PiedPiperApplication
import PiedPiperApplicationUI

public final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    public var window: UIWindow?
    
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? Scene else { preconditionFailure() }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ApplicationFlowController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
