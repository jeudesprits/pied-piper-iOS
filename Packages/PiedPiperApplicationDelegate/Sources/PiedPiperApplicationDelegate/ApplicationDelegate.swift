//
//  ApplicationDelegate.swift
//
//
//  Created by Ruslan Lutfullin on 22/11/23.
//

import UIKit
import PiedPiperApplication

public final class ApplicationDelegate: NSObject, UIApplicationDelegate {
    
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.sceneClass = Scene.self
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
