//
//  LibraryFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import UIKitUtilities
import PiedPiperCoreUI

public final class LibraryFlowController: NavigationController {
    
    public init() {
        super.init(rootViewController: LibraryViewController())
        let tabBarImage = UIImage(resource: .customPlayRectangleStackFill)
        tabBarItem = UITabBarItem(title: "Медиатека", image: tabBarImage, selectedImage: tabBarImage)
    }
}
