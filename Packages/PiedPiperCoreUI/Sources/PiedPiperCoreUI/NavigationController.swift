//
//  NavigationController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit

open class NavigationController: UINavigationController {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    @available(*, unavailable, message: "use 'init(rootViewController:)' or 'init(navigationBarClass:toolbarClass:)' instead")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable, message: "use 'init(rootViewController:)' or 'init(navigationBarClass:toolbarClass:)' instead")
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
