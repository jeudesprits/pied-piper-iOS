//
//  UIViewControllerRepresentation.swift
//  
//
//  Created by Ruslan Lutfullin on 06/11/23.
//

#if DEBUG
import UIKit
import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct UIViewControllerRepresentation<UIViewControllerType: UIViewController>: UIViewControllerRepresentable {
    
    private let layout: UIViewRepresentationLayout
    
    private let viewController: ((Context) -> UIViewControllerType)?
    
    private let viewControllerWithoutContext: (() -> UIViewControllerType)?
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        if let viewController {
            viewController(context)
        } else if let viewControllerWithoutContext {
            viewControllerWithoutContext()
        } else {
            preconditionFailure()
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIViewControllerType, context: Context) -> CGSize? {
        let size: CGSize
        switch layout {
        case .auto:
            size = uiViewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
        case .inherited:
            size = CGSize(width: proposal.width!, height: proposal.height!)
            
        case .inheritedWidth:
            let height = uiViewController.view.systemLayoutSizeFitting(
                CGSize(width: proposal.width!, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            size = CGSize(width: proposal.width!, height: max(1.0, height))
            
        case .inheritedHeight:
            let width = uiViewController.view.systemLayoutSizeFitting(
                CGSize(width: UIView.layoutFittingCompressedSize.width, height: proposal.height!),
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            ).width
            size = CGSize(width: max(1.0, width), height: proposal.height!)
            
        case .fixed(let width, let height):
            size = CGSize(width: width, height: height)
            
        case .fixedWidth(let width):
            let width = uiViewController.view.systemLayoutSizeFitting(
                CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).width
            size = CGSize(width: max(1.0, width), height: proposal.height!)
            
        case .fixedHeight(let height):
            let height = uiViewController.view.systemLayoutSizeFitting(
                CGSize(width: UIView.layoutFittingCompressedSize.width, height: height),
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            ).height
            size = CGSize(width: proposal.width!, height: max(1.0, height))
        }
        return size
    }
    
    @_disfavoredOverload
    public init(layout: UIViewRepresentationLayout = .inherited, _ viewController: @escaping (_ context: Context) -> UIViewControllerType) {
        self.layout = layout
        self.viewController = viewController
        self.viewControllerWithoutContext = nil
    }
    
    public init(layout: UIViewRepresentationLayout = .inherited, _ viewController: @escaping () -> UIViewControllerType) {
        self.layout = layout
        self.viewController = nil
        self.viewControllerWithoutContext = viewController
    }
}
#endif
