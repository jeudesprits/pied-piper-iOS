//
//  UIViewRepresentation.swift
//
//
//  Created by Ruslan Lutfullin on 06/11/23.
//

#if DEBUG
import UIKit
import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@freestanding(declaration) 
public macro Preview(_ name: String? = nil, traits: PreviewTrait<Preview.ViewTraits>, _ additionalTraits: PreviewTrait<Preview.ViewTraits>..., body: @escaping @MainActor () -> any View) = #externalMacro(module: "PreviewsMacros", type: "SwiftUIView")

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct UIViewRepresentation<UIViewType: UIView>: UIViewRepresentable {
    
    private let layout: UIViewRepresentationLayout
    
    private let view: ((Context) -> UIViewType)?
    
    private let viewWithoutContext: (() -> UIViewType)?
    
    public func makeUIView(context: Context) -> UIViewType {
        if let view {
            view(context)
        } else if let viewWithoutContext {
            viewWithoutContext()
        } else {
            preconditionFailure()
        }
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        let size: CGSize
        switch layout {
        case .auto:
            size = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
        case .inherited:
            size = CGSize(width: proposal.width!, height: proposal.height!)
            
        case .inheritedWidth:
            let height = uiView
                .systemLayoutSizeFitting(
                    CGSize(width: proposal.width!, height: UIView.layoutFittingCompressedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )
                .height
            size = CGSize(width: proposal.width!, height: max(1.0, height))
            
        case .inheritedHeight:
            let width = uiView
                .systemLayoutSizeFitting(
                    CGSize(width: UIView.layoutFittingCompressedSize.width, height: proposal.height!),
                    withHorizontalFittingPriority: .fittingSizeLevel,
                    verticalFittingPriority: .required
                )
                .width
            size = CGSize(width: max(1.0, width), height: proposal.height!)
            
        case .fixed(let width, let height):
            size = CGSize(width: width, height: height)
            
        case .fixedWidth(let width):
            let height = uiView
                .systemLayoutSizeFitting(
                    CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )
                .height
            size = CGSize(width: width, height: max(1.0, height))
            
        case .fixedHeight(let height):
            let width = uiView
                .systemLayoutSizeFitting(
                    CGSize(width: UIView.layoutFittingCompressedSize.width, height: height),
                    withHorizontalFittingPriority: .fittingSizeLevel,
                    verticalFittingPriority: .required
                )
                .width
            size = CGSize(width: max(1.0, width), height: height)
        }
        return size
    }
    
    @_disfavoredOverload
    public init(layout: UIViewRepresentationLayout = .auto, _ view: @escaping (_ context: Context) -> UIViewType) {
        self.layout = layout
        self.view = view
        self.viewWithoutContext = nil
    }
    
    public init(layout: UIViewRepresentationLayout = .auto, _ view: @escaping () -> UIViewType) {
        self.layout = layout
        self.view = nil
        self.viewWithoutContext = view
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum UIViewRepresentationLayout {
    
    case auto
    
    case inherited
    
    case inheritedWidth
    
    case inheritedHeight
    
    case fixed(width: CGFloat, height: CGFloat)
    
    case fixedWidth(CGFloat)
    
    case fixedHeight(CGFloat)
}
#endif
