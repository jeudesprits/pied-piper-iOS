//
//  ProfileFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import UIKitUtilities
import PiedPiperCoreUI

public final class ProfileFlowController: NavigationController {
    
    public init() {
        super.init(rootViewController: ProfileViewController())
        let tabBarImage = UIImage(systemName: "person.and.background.striped.horizontal")!
        tabBarItem = UITabBarItem(title: "Профиль", image: tabBarImage, selectedImage: tabBarImage)
    }
}
