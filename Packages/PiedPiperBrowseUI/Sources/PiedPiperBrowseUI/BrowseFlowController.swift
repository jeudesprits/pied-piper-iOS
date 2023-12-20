//
//  BrowseFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import PiedPiperCoreUI

public final class BrowseFlowController: NavigationController {
    
    public init() {
        super.init(rootViewController: BrowseViewController())
        let tabBarImage = UIImage(systemName: "square.grid.2x2.fill")!
        tabBarItem = UITabBarItem(title: "Обзор", image: tabBarImage, selectedImage: tabBarImage)
    }
}
