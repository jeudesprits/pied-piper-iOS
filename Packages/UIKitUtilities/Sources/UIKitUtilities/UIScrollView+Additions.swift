//
//  UIScrollView+Additions.swift
//
//
//  Created by Ruslan Lutfullin on 1/26/22.
//

import UIKit

extension UIScrollView {
    
    public var effectiveBounds: CGRect {
        let size = CGSize(
            width: bounds.width - (adjustedContentInset.left + adjustedContentInset.right),
            height: bounds.height - (adjustedContentInset.top + adjustedContentInset.bottom)
        ) 
        return CGRect(origin: bounds.origin, size: size)
    }
    
    public var startContentOffset: CGPoint {
        CGPoint(x: -adjustedContentInset.left, y: -adjustedContentInset.top)
    }
    
    public var endContentOffset: CGPoint {
        let effectiveBounds = effectiveBounds
        return CGPoint(
            x: -adjustedContentInset.left + (contentSize.width - effectiveBounds.width),
            y: -adjustedContentInset.top + (contentSize.height - effectiveBounds.height)
        )
    }
}
