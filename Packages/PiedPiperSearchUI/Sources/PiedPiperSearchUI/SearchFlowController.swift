//
//  SearchFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import UIKitUtilities
import PiedPiperCoreUI

public final class SearchFlowController: NavigationController {
    
    public init() {
        super.init(rootViewController: SearchViewController())
        let tabBarImage = UIImage(systemName: "magnifyingglass.circle.fill")!
        tabBarItem = UITabBarItem(title: "Поиск", image: tabBarImage, selectedImage: tabBarImage)
    }
}
