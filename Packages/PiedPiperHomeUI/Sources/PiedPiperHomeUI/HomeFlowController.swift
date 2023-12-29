//
//  HomeFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import PiedPiperCoreUI

public final class HomeFlowController: NavigationController {
    
    public init() {
        super.init(rootViewController: HomeCollectionViewController())
        let tabBarImage = UIImage(systemName: "play.rectangle.fill")!
        tabBarItem = UITabBarItem(title: "Смотреть", image: tabBarImage, selectedImage: tabBarImage)
        navigationBar.prefersLargeTitles = true
    }
}
