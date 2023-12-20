//
//  MainFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 22/11/23.
//

import UIKit
import PiedPiperCoreUI
import PiedPiperHomeUI
import PiedPiperBrowseUI
import PiedPiperLibraryUI
import PiedPiperSearchUI
import PiedPiperProfileUI

public final class MainFlowController: TabBarController {
    
    private let homeFlowController = HomeFlowController()
    
    private let browseFlowController = BrowseFlowController()
    
    private let libraryFlowController = LibraryFlowController()
    
    private let searchFlowController = SearchFlowController()
    
    private let profileFlowController = ProfileFlowController()
    
    public init() {
        super.init(viewControllers: [
            homeFlowController,
            browseFlowController,
            libraryFlowController,
            searchFlowController,
            profileFlowController,
        ])
    }
}
