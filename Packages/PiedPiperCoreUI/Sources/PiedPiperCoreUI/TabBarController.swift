//
//  TabBarController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import SwiftUtilities
import UIKit
import UIKit.UIGestureRecognizerSubclass
import UIKitUtilities
import PiedPiperFoundationUI

open class TabBarController: UITabBarController {
    
    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let items = tabBar.value(forKey: "_items") as! [NSObject]
        for item in items {
            let button = item.value(forKey: "_view") as! UIControl
            button.addGestureRecognizer(HighlightTabBarButtonGestureRecognizer())
        }
    }
    
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    @available(*, unavailable, message: "use 'init(viewControllers:)' instead")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable, message: "use 'init(viewControllers:)' instead")
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

fileprivate final class HighlightTabBarButtonGestureRecognizer: UIGestureRecognizer {
    
    private var imageView: UIImageView? {
        view?.value(forKey: "_imageView") as? UIImageView
    }
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        cancelsTouchesInView = false
        delaysTouchesBegan = false
        delaysTouchesEnded = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        imageView?.layer.runningAnimator(keyPath: "transform", animation: .default2Spring)
        imageView?.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 0.8)
        imageView?.removeSymbolEffect(ofType: .bounce, animated: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        imageView?.layer.runningAnimator(keyPath: "transform", animation: .default2Spring)
        imageView?.layer.transform = CATransform3DIdentity
        imageView?.addSymbolEffect(.bounce)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        imageView?.layer.runningAnimator(keyPath: "transform", animation: .default2Spring)
        imageView?.layer.transform = CATransform3DIdentity
        imageView?.addSymbolEffect(.bounce)
    }
}
