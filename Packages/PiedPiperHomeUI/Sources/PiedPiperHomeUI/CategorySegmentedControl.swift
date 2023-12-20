//
//  CategorySegmentedControl.swift
//
//
//  Created by Ruslan Lutfullin on 05/12/23.
//

import SwiftUtilities
import Algorithms
import UIKit
import UIKitUtilities
import PiedPiperFoundationUI

final class CategorySegmentedControl: Control {
    
    private var flags = Flags()
    
    private var updatingConstraintsContext: UpdatingConstraintsContext!
    
    @_nonoverride @StateObject var state: State
    
    @ConfigurationObject var configuration: Configuration?
    
    private let scrollView: ScrollView = with(ScrollView(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alwaysBounceHorizontal = true
        $0.delaysContentTouches = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private var segmentsView: [CategorySegmentView] = []
    
    func startInteractiveTransition() {
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        
    }
    
    func pauseInteractiveTransition() {
        
    }
    
    func finishInteractiveTransition() {
        
    }
    
    func cancelInteractiveTransition() {
        
    }
    
    private var segmentsBottomConstraint: [NSLayoutConstraint] = []
    
    override func updatingConstraints() {
        super.updatingConstraints()
        
        guard let updatingConstraintsContext else { return }
        defer { self.updatingConstraintsContext = nil }
        
        if flags.needsUpdatingConstraintsOnStateChange, !flags.needsUpdatingConstraintsOnConfigurationChange {
            flags.needsUpdatingConstraintsOnStateChange = false
            
            guard let selectedIndex = state.selectedIndex else { return }
            let selectedSegmentView = segmentsView[selectedIndex]
            
            for segmentView in segmentsView {
                segmentView.withAnimatedChanges {
                    segmentView.state.isSelected = segmentView === selectedSegmentView
                }
            }
            
            NSLayoutConstraint.deactivate(segmentsBottomConstraint)
            segmentsBottomConstraint.removeAll(keepingCapacity: true)
            for segmentView in segmentsView {
                let bottomConstraint = if segmentView === selectedSegmentView {
                    scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
                } else {
                    segmentView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor, constant: 3)
                    //segmentView.firstBaselineAnchor.constraint(equalTo: selectedSegmentView.firstBaselineAnchor)
                }
                segmentsBottomConstraint += CollectionOfOne(bottomConstraint)
            }
            NSLayoutConstraint.activate(segmentsBottomConstraint)
        }
        
        if flags.needsUpdatingConstraintsOnConfigurationChange {
            flags.needsUpdatingConstraintsOnConfigurationChange = false
            
            segmentsView.forEach { $0.removeFromSuperview() }
            segmentsView.removeAll(keepingCapacity: true)
            segmentsBottomConstraint.removeAll(keepingCapacity: true)
            scrollView.contentSize = .zero
            
            guard let configuration else { return }
            
            for (index, item) in configuration.items.indexed() {
                let segmentView = CategorySegmentView(frame: .zero)
                
                let state = CategorySegmentView.State()
                state.isSelected = index == self.state.selectedIndex
                segmentView.withAnimatedChanges {
                    segmentView.state = state
                }
                
                let configuration = if let title = item.title {
                    CategorySegmentView.Configuration(iconImage: UIImage(resource: .icons8Pennywise), title: title)  // UIImage(systemName: "poweroutlet.type.k.fill")!
                } else {
                    preconditionFailure()
                }
                segmentView.withAnimatedChanges {
                    segmentView.configuration = configuration
                }
                segmentView.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(segmentView)
                segmentsView.append(segmentView)
            }
            
            var segmentsConstraints: [NSLayoutConstraint] = []
            let firstSegmentView = segmentsView.first
            let lastSegmentView = segmentsView.last
            let selectedSegmentView: CategorySegmentView? = if let selectedIndex = state.selectedIndex {
                segmentsView[selectedIndex]
            } else {
                nil
            }
            for (previousSegmentView, segmentView) in segmentsView.adjacentPairs() {
                if previousSegmentView === firstSegmentView {
                    let bottomConstraint = if previousSegmentView === selectedSegmentView || selectedSegmentView == nil {
                        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: previousSegmentView.bottomAnchor)
                    } else {
                        previousSegmentView.firstBaselineAnchor.constraint(equalTo: selectedSegmentView!.firstBaselineAnchor)
                    }
                    segmentsConstraints += [
                        previousSegmentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                        previousSegmentView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.contentLayoutGuide.topAnchor),
                        bottomConstraint,
                    ]
                    segmentsBottomConstraint += CollectionOfOne(bottomConstraint)
                }
                
                let bottomConstraint = if segmentView === selectedSegmentView || selectedSegmentView == nil {
                    scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
                } else {
                    segmentView.firstBaselineAnchor.constraint(equalTo: selectedSegmentView!.firstBaselineAnchor)
                }
                segmentsConstraints += [
                    segmentView.leadingAnchor.constraint(equalTo: previousSegmentView.trailingAnchor, constant: 24.0),
                    segmentView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.contentLayoutGuide.topAnchor),
                    bottomConstraint,
                ]
                segmentsBottomConstraint += CollectionOfOne(bottomConstraint)
                
                if segmentView === lastSegmentView {
                    segmentsConstraints += CollectionOfOne(
                        scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor)
                    )
                }
            }
            NSLayoutConstraint.activate(segmentsConstraints)
        }
    }
    
    override func setupCommon() {
        super.setupCommon()
        registerForStateChanges(in: &$state) { [unowned self] previousState, context in
            applyState(previousState, with: context)
        }
        registerForConfigurationChanges(in: &$configuration) { [unowned self] previousConfiguration, context in
            applyConfiguration(previousConfiguration, with: context)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: 0.0).priority(.defaultLow),
            scrollView.frameLayoutGuide.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
        ])
    }
    
    init(frame: CGRect, configuration: Configuration) {
        _state = .init(wrappedValue: State())
        _configuration = .init(wrappedValue: configuration)
        super.init(frame: frame, primaryAction: UIAction { _ in })
    }
}

extension CategorySegmentedControl {
    
    private func applyState(_ previousState: State?, with context: UIInputChangesContext) {
        if updatingConstraintsContext == nil { updatingConstraintsContext = UpdatingConstraintsContext() }
        updatingConstraintsContext.wasAnimatedStateApply = flags.isAnimatedStateApply
        
        flags.needsUpdatingConstraintsOnStateChange = true
        setNeedsUpdateConstraints()
        setNeedsLayout()
        
        if context.isAnimated {
            UIViewPropertyAnimator.runningPropertyAnimator(animation: .default1Spring) { [self] in
                layoutIfNeeded()
            }
        }
    }
}

extension CategorySegmentedControl {
    
    private func applyConfiguration(_ previousConfiguration: Configuration?, with context: UIInputChangesContext) {
        defer { flags.isAnimatedConfigurationApply = false }
        
        if updatingConstraintsContext == nil { updatingConstraintsContext = UpdatingConstraintsContext() }
        updatingConstraintsContext.wasAnimatedConfigurationApply = flags.isAnimatedConfigurationApply
        
        flags.needsUpdatingConstraintsOnConfigurationChange = true
        setNeedsUpdateConstraints()
        if context.isAnimated {
            updateConstraintsIfNeeded()
        }
    }
}

extension CategorySegmentedControl {
    
    private struct UpdatingConstraintsContext {
        var wasAnimatedStateApply = false
        var wasAnimatedConfigurationApply = false
    }
}

extension CategorySegmentedControl {
    
    private struct Flags {
        var isAnimatedStateApply = false
        var isAnimatedConfigurationApply = false
        var needsUpdatingConstraintsOnStateChange = false
        var needsUpdatingConstraintsOnConfigurationChange = false
    }
}

extension CategorySegmentedControl {
    
    final class State: UIState {
        
        @Invalidating
        var selectedIndex: Int?
        
        override init() {
            super.init()
        }
        
        override borrowing func copy() -> Self {
            State(copy: self) as! Self
        }
        
        init(copy other: borrowing State) {
            _selectedIndex = other._selectedIndex
            super.init(copy: other)
        }
    }
}

extension CategorySegmentedControl {
    
    final class Configuration: UIConfiguration {
        
        @Invalidating
        var items: [Item]
        
        init(items: [Item]) {
            _items = .init(wrappedValue: items)
            super.init()
        }
        
        override borrowing func copy() -> Self {
            Configuration(copy: self) as! Self
        }
        
        init(copy other: borrowing Configuration) {
            _items = other._items
            super.init(copy: other)
        }
    }
}

extension CategorySegmentedControl.Configuration {
    
    struct Item: Hashable {
        
        var title: String?
        
        var attributedTitle: AttributedString?
        
        init(title: String) {
            self.title = title
            self.attributedTitle = nil
        }
        
        init(attributedTitle: AttributedString) {
            self.title = nil
            self.attributedTitle = attributedTitle
        }
    }
}

final class CategorySegmentView: View {
    
    private var flags = Flags()
    
    @StateObject var state: State
    
    @ConfigurationObject var configuration: Configuration?
    
    private let iconImageView: UIImageView = with(UIImageView(image: nil)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .secondaryLabel
    }
    
    private let titleLabel: UILabel = with(UILabel(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = .secondaryLabel
    }
    
    private let selectedIconImageView: UIImageView = with(UIImageView(image: nil)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var selectedTitleLabel: UILabel = with(UILabel(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .preferredFont(forTextStyle: .extraLargeTitle)
        $0.textColor = tintColor
    }
    
    private var nonselectedConstraints: [NSLayoutConstraint] = []
    
    private var selectedConstraints: [NSLayoutConstraint] = []
    
    override var forLastBaselineLayout: UIView {
        if state.isSelected, selectedTitleLabel.isDescendant(of: self) {
            selectedTitleLabel
        } else if !state.isSelected, titleLabel.isDescendant(of: self) {
            titleLabel
        } else {
            super.forLastBaselineLayout
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        withAnimatedChanges {
            state.isHighlighted = true
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        withAnimatedChanges {
            state.isHighlighted = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        withAnimatedChanges {
            state.isHighlighted = false
        }
    }
    
    override func updatingConstraints() {
        super.updatingConstraints()
        
        
        
        guard flags.needsUpdatingConstraintsOnSelectedChange else { return }
        flags.needsUpdatingConstraintsOnSelectedChange = false
        if state.isSelected {
            bringSubviewToFront(iconImageView)
            bringSubviewToFront(titleLabel)
            NSLayoutConstraint.deactivate(nonselectedConstraints)
            NSLayoutConstraint.activate(selectedConstraints)
        } else {
            bringSubviewToFront(selectedIconImageView)
            bringSubviewToFront(selectedTitleLabel)
            NSLayoutConstraint.deactivate(selectedConstraints)
            NSLayoutConstraint.activate(nonselectedConstraints)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard flags.isPartOfConfigurationApply else { return }
        flags.isPartOfConfigurationApply = false
        if state.isSelected {
            iconImageView.transform = CGAffineTransform(scaleX: selectedIconImageView.bounds.width / iconImageView.bounds.width, y: selectedIconImageView.bounds.height / iconImageView.bounds.height)
            titleLabel.transform = CGAffineTransform(scaleX: selectedTitleLabel.bounds.width / titleLabel.bounds.width, y: selectedTitleLabel.bounds.height / titleLabel.bounds.height)
        } else {
            selectedIconImageView.transform = CGAffineTransform(scaleX: iconImageView.bounds.width / selectedIconImageView.bounds.width, y: iconImageView.bounds.height / selectedIconImageView.bounds.height)
            selectedTitleLabel.transform = CGAffineTransform(scaleX: titleLabel.bounds.width / selectedTitleLabel.bounds.width, y: titleLabel.bounds.height / selectedTitleLabel.bounds.height)
        }
    }
    
    override func setupCommon() {
        super.setupCommon()
        registerForStateChanges(in: &$state) { [unowned self] previousState, context in
            applyState(previousState, with: context)
        }
        registerForConfigurationChanges(in: &$configuration) { [unowned self] previousConfiguration, context in
            applyConfiguration(previousConfiguration, with: context)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        addSubview(iconImageView)
        addSubview(selectedIconImageView)
        addSubview(titleLabel)
        addSubview(selectedTitleLabel)
        
        nonselectedConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 3.0),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            selectedIconImageView.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            selectedIconImageView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            selectedTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            selectedTitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ]
        
        selectedConstraints = [
            selectedIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedIconImageView.centerYAnchor.constraint(equalTo: selectedTitleLabel.centerYAnchor),
            
            selectedTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            selectedTitleLabel.leadingAnchor.constraint(equalTo: selectedIconImageView.trailingAnchor, constant: 3.0),
            trailingAnchor.constraint(equalTo: selectedTitleLabel.trailingAnchor),
            bottomAnchor.constraint(equalTo: selectedTitleLabel.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: selectedIconImageView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: selectedIconImageView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: selectedTitleLabel.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: selectedTitleLabel.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight.rounded(.down)),
//            iconImageView.heightAnchor.constraint(equalToConstant: titleLabel.font.capHeight - titleLabel.font.descender),
            selectedIconImageView.widthAnchor.constraint(equalTo: selectedIconImageView.heightAnchor),
            selectedIconImageView.heightAnchor.constraint(equalToConstant: selectedTitleLabel.font.lineHeight.rounded(.down)),
//            selectedIconImageView.heightAnchor.constraint(equalToConstant: selectedTitleLabel.font.capHeight - selectedTitleLabel.font.descender),
        ])
    }
    
    init(frame: CGRect, configuration: Configuration? = nil) {
        _state = StateObject(wrappedValue: State())
        _configuration = ConfigurationObject(wrappedValue: configuration)
        super.init(frame: frame)
    }
}

extension CategorySegmentView {
    
    private func applyState(_ previousState: State?, with context: UIInputChangesContext) {
        selectedDidChange(previousState?.isSelected, with: context)
        highlightedDidChange(previousState?.isHighlighted, with: context)
    }
    
    private func selectedDidChange(_ previousSelected: Bool?, with context: UIInputChangesContext) {
        guard state.isSelected != previousSelected else { return }
        
        if context.isAnimated {
            flags.needsUpdatingConstraintsOnSelectedChange = true
            setNeedsUpdateConstraints()
            
            flags.needsUpdateLabelsTransformOnInputsChange = true
            setNeedsLayout()
            
            if state.isSelected {
                selectedIconImageView.isHidden = false
                selectedTitleLabel.isHidden = false
            } else {
                iconImageView.isHidden = false
                titleLabel.isHidden = false
            }
//            exchangeSubview(at: subviews.firstIndex(of: iconImageView)!, withSubviewAt: subviews.firstIndex(of: selectedIconImageView)!)
//            exchangeSubview(at: subviews.firstIndex(of: titleLabel)!, withSubviewAt: subviews.firstIndex(of: selectedTitleLabel)!)
//            
            UIViewPropertyAnimator.runningPropertyAnimator(animation: .default2Spring) { [self] in
                layoutIfNeeded()
                
                if state.isSelected {
                    iconImageView.alpha = 0.0
                    titleLabel.alpha = 0.0
                    
                    selectedIconImageView.transform = .identity
                    selectedTitleLabel.transform = .identity
                    selectedIconImageView.alpha = 1.0
                    selectedTitleLabel.alpha = 1.0
                } else {
                    iconImageView.transform = .identity
                    titleLabel.transform = .identity
                    iconImageView.alpha = 1.0
                    titleLabel.alpha = 1.0
                    
                    selectedIconImageView.alpha = 0.0
                    selectedTitleLabel.alpha = 0.0
                }
            } completion: { [self] _ in
                if state.isSelected {
                    iconImageView.isHidden = true
                    titleLabel.isHidden = true
                } else {
                    selectedIconImageView.isHidden = true
                    selectedTitleLabel.isHidden = true
                }
            }
        } else {
            flags.needsUpdatingConstraintsOnSelectedChange = true
            setNeedsUpdateConstraints()
            
            flags.needsUpdateLabelsTransformOnInputsChange = true
            setNeedsLayout()
            
            if state.isSelected {
                iconImageView.alpha = 0.0
                iconImageView.isHidden = true
                titleLabel.alpha = 0.0
                titleLabel.isHidden = true
                
                selectedIconImageView.transform = .identity
                selectedIconImageView.alpha = 1.0
                selectedIconImageView.isHidden = false
                selectedTitleLabel.transform = .identity
                selectedTitleLabel.alpha = 1.0
                selectedTitleLabel.isHidden = false
            } else {
                iconImageView.transform = .identity
                iconImageView.alpha = 1.0
                iconImageView.isHidden = false
                titleLabel.transform = .identity
                titleLabel.alpha = 1.0
                titleLabel.isHidden = false
                
                selectedIconImageView.alpha = 0.0
                selectedIconImageView.isHidden = true
                selectedTitleLabel.alpha = 0.0
                selectedTitleLabel.isHidden = true
            }
        }
    }
    
    private func highlightedDidChange(_ previousHighlighted: Bool?, with context: UIInputChangesContext) {
        guard state.isHighlighted != previousHighlighted else { return }
        
        let action = { [self] in
            if state.isHighlighted {
                transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                alpha = 0.5
            } else {
                transform = .identity
                alpha = 1.0
            }
        }
        if context.isAnimated {
            UIViewPropertyAnimator.runningPropertyAnimator(animation: .gentleSpring) {
                action()
            }
        } else {
            action()
        }
    }
}

extension CategorySegmentView {
    
    private func applyConfiguration(_ previousConfiguration: Configuration?, with context: UIInputChangesContext) {
        if let configuration {
            let image = configuration.iconImage.withRenderingMode(.alwaysTemplate)
            iconImageView.image = image
            selectedIconImageView.image = image
            titleLabel.text = configuration.title
            selectedTitleLabel.text = configuration.title
        } else {
            iconImageView.image = nil
            selectedIconImageView.image = nil
            titleLabel.text = nil
            selectedTitleLabel.text = nil
        }
        
        flags.isPartOfConfigurationApply = true
        setNeedsLayout()
        
        if !context.isDeferred {
            layoutIfNeeded()
        }
    }
}

extension CategorySegmentView {
    
    private struct Flags {
        
        var needsUpdatingConstraintsOnSelectedChange = false
        
        var needsUpdateLabelsTransformOnInputsChange = false
        
        var isPartOfSelectedChange = false
        
        var isPartOfAnimatedSelectedChange = false
        
        var isPartOfConfigurationApply = false
    }
}

extension CategorySegmentView {
    
    final class State: UIState {
        
        @Invalidating var isSelected = false
        
        @Invalidating var isHighlighted = false
        
        override init() {
            super.init()
        }
        
        override func copy() -> Self {
            State(copy: self) as! Self
        }
        
        init(copy other: borrowing State) {
            _isSelected = other._isSelected
            _isHighlighted = other._isHighlighted
            super.init(copy: other)
        }
    }
}

extension CategorySegmentView {
    
    final class Configuration: UIConfiguration {
        
        @Invalidating var iconImage: UIImage
        
        @Invalidating var title: String
        
        init(iconImage: UIImage, title: String) {
            _iconImage = Invalidating(wrappedValue: iconImage)
            _title = Invalidating(wrappedValue: title)
            super.init()
        }
        
        override func copy() -> Self {
            Configuration(copy: self) as! Self
        }
        
        init(copy other: borrowing Configuration) {
            _iconImage = other._iconImage
            _title = other._title
            super.init(copy: other)
        }
    }
}

#if DEBUG

//#Preview("CategorySegmentedControl", traits: .sizeThatFitsLayout) {
//    UIViewRepresentation(layout: .inheritedWidth) {
//        let configuration = CategorySegmentedControl.Configuration(items: [
//            .init(title: "Фильмы"),
//            .init(title: "Сериалы"),
//            .init(title: "Мультфильмы"),
//            .init(title: "Аниме"),
//            .init(title: "Телеперадачи и Шоу"),
//        ])
//        return CategorySegmentedControl(frame: .zero, configuration: configuration)
//    }
//}

#Preview("CategorySegmentView", traits: .sizeThatFitsLayout) {
    let view = CategorySegmentView(
        frame: .zero,
        configuration: CategorySegmentView.Configuration(iconImage: UIImage(resource: .icons8BabyYoda), title: "Сериалы")
    )
//    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//        view.updateState(animated: true) { $0.isSelected = true }
//    }
//    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//        view.updateState(animated: true) { $0.isSelected = false }
//    }
    return view
}

#endif