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
    
    @_nonoverride
    @StateObject var state: State
    
    @ConfigurationObject var configuration: Configuration?
    
    private let scrollView: ScrollView = with(ScrollView(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alwaysBounceHorizontal = true
        $0.delaysContentTouches = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private var segmentsView: [CategorySegmentView] = []
    
    private var currentAnimator: UIViewPropertyAnimator?
    
    private var currentScrollAnimator: DisplayLinkAnimator<CGFloat>?
    
    private(set) var hasActiveInteractiveTransition = false
    
    func startInteractiveTransition(toSelectedIndex selectedIndex: Int) {
        print(#function)
        guard !hasActiveInteractiveTransition else { return }
        hasActiveInteractiveTransition = true
        state.previousSelectedIndex = state.selectedIndex
        state.selectedIndex = selectedIndex
        setNeedsAnimatedInputsChanges()
        changesInputsIfNeeded()
        currentAnimator?.pauseAnimation()
        segmentsView.forEach { $0.currentAnimator?.pauseAnimation() }
        currentScrollAnimator?.pause()
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        print(#function)
        currentAnimator?.fractionComplete = percentComplete
        segmentsView.forEach { $0.currentAnimator?.fractionComplete = percentComplete }
        currentScrollAnimator?.fractionComplete = percentComplete
    }
    
    func pauseInteractiveTransition() {
        currentAnimator?.pauseAnimation()
        segmentsView.forEach { $0.currentAnimator?.pauseAnimation() }
        currentScrollAnimator?.pause()
    }
    
    func finishInteractiveTransition() {
        print(#function)
        hasActiveInteractiveTransition = false
        currentAnimator?.startAnimation()
        segmentsView.forEach { $0.currentAnimator?.startAnimation() }
        currentScrollAnimator?.start()
    }
    
    func cancelInteractiveTransition() {
        print(#function)
        hasActiveInteractiveTransition = false
        currentAnimator?.isReversed = true
        currentAnimator?.startAnimation()
        segmentsView.forEach {
            $0.currentAnimator?.isReversed = true
            $0.currentAnimator?.startAnimation()
        }
        currentScrollAnimator?.isReversed = true
        currentScrollAnimator?.start()
    }
    
    private var segmentsBottomConstraint: [NSLayoutConstraint] = []
    
    override func updatingConstraints() {
        super.updatingConstraints()
        print(#function)
        
        if flags.isPartOfApplyConfiguration {
            defer { flags.isPartOfApplyConfiguration = false }
            
            segmentsView.forEach { $0.removeFromSuperview() }
            segmentsView.removeAll()
            segmentsBottomConstraint.removeAll()
            scrollView.contentSize = .zero
            
            guard let configuration else { return }
            
            segmentsView.reserveCapacity(configuration.items.count)
            for (index, item) in configuration.items.indexed() {
                let segmentView = CategorySegmentView(frame: .zero, configuration: CategorySegmentView.Configuration(iconImage: item.iconImage, title: item.title))
                segmentView.translatesAutoresizingMaskIntoConstraints = false
                segmentView.state.isSelected = index == state.selectedIndex
                scrollView.addSubview(segmentView)
                segmentsView.append(segmentView)
            }
            
            var segmentsConstraints: [NSLayoutConstraint] = []
            segmentsConstraints.reserveCapacity(segmentsView.count * 3)
            segmentsBottomConstraint.reserveCapacity(segmentsView.count)
            let firstSegmentView = segmentsView.first
            let lastSegmentView = segmentsView.last
            let selectedSegmentView: CategorySegmentView? = if let selectedIndex = state.selectedIndex { segmentsView[selectedIndex] } else { nil }
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
            
            let contentOffsetX: CGFloat = if let selectedIndex = state.selectedIndex {
                (scrollView.endContentOffset.x / CGFloat(segmentsView.count - 1)) * CGFloat(selectedIndex)
            } else {
                0.0
            }
            if let context = contextForInputChanges(of: $state) {
                for segmentView in segmentsView {
                    if context.isAnimated {
                        segmentView.setNeedsAnimatedInputsChanges()
                        segmentView.changesInputsIfNeeded()
                    } else if !context.isDeferred {
                        segmentView.changesInputsIfNeeded()
                    }
                }
                if context.isAnimated {
                    currentScrollAnimator = DisplayLinkAnimator.runningAnimator(from: scrollView.contentOffset.x, to: contentOffsetX, animation: .default1Spring) { [unowned self] in
                        print($0)
                        scrollView.contentOffset.x = $0
                    }
                } else {
                    scrollView.contentOffset.x = contentOffsetX
                }
            } else {
                scrollView.contentOffset.x = contentOffsetX
            }
        } else if flags.isPartOfApplyState {
            defer { flags.isPartOfApplyState = false }
            
            guard !segmentsView.isEmpty else { return }
            
            for (index, segmentView) in segmentsView.indexed() {
                segmentView.state.isSelected = index == state.selectedIndex
            }
            
            let selectedSegmentView: CategorySegmentView? = if let selectedIndex = state.selectedIndex { segmentsView[selectedIndex] } else { nil }
            NSLayoutConstraint.deactivate(segmentsBottomConstraint)
            segmentsBottomConstraint.removeAll(keepingCapacity: true)
            for segmentView in segmentsView {
                let bottomConstraint = if let selectedSegmentView {
                    if segmentView === selectedSegmentView {
                        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
                    } else {
                        segmentView.firstBaselineAnchor.constraint(equalTo: selectedSegmentView.firstBaselineAnchor)
                    }
                } else {
                    scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
                }
                segmentsBottomConstraint += CollectionOfOne(bottomConstraint)
            }
            NSLayoutConstraint.activate(segmentsBottomConstraint)
            
            let contentOffsetX: CGFloat = if let selectedIndex = state.selectedIndex {
                (scrollView.endContentOffset.x / CGFloat(segmentsView.count - 1)) * CGFloat(selectedIndex)
            } else {
                0.0
            }
            if let context = contextForInputChanges(of: $state) {
                for segmentView in segmentsView {
                    if context.isAnimated {
                        segmentView.setNeedsAnimatedInputsChanges()
                        segmentView.changesInputsIfNeeded()
                    } else if !context.isDeferred {
                        segmentView.changesInputsIfNeeded()
                    }
                }
                if context.isAnimated {
                    currentScrollAnimator = DisplayLinkAnimator.runningAnimator(from: scrollView.contentOffset.x, to: contentOffsetX, animation: .default1Spring) { [unowned self] in
                        print($0)
                        scrollView.contentOffset.x = $0
                    }
                    print("------")
                } else {
                    scrollView.contentOffset.x = contentOffsetX
                }
            } else {
                scrollView.contentOffset.x = contentOffsetX
            }
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
    
    init(frame: CGRect, configuration: Configuration? = nil) {
        _state = .init(wrappedValue: State())
        _configuration = .init(wrappedValue: configuration)
        super.init(frame: frame, primaryAction: UIAction { _ in })
    }
}

extension CategorySegmentedControl {
    
    private func applyState(_ previousState: State?, with context: UIInputChangesContext) {
        print(#function, context)
        if context.isAnimated {
            currentAnimator = UIViewPropertyAnimator.runningPropertyAnimator(animation: .default1Spring) { [unowned self] in
                flags.isPartOfApplyState = true
                setNeedsUpdateConstraints()
                setNeedsLayout()
                print("*******1")
                layoutIfNeeded()
                print("*******2")
            } completion: { [unowned self] in
                currentAnimator = nil
                let previousSelectedIndex = state.previousSelectedIndex
                state.previousSelectedIndex = nil
                guard $0 == .start else { return }
                state.selectedIndex = previousSelectedIndex
                changesInputsIfNeeded()
            }
        } else {
            flags.isPartOfApplyState = true
            setNeedsUpdateConstraints()
            setNeedsLayout()
            if !context.isDeferred {
                layoutIfNeeded()
            }
        }
    }
}

extension CategorySegmentedControl {
    
    private func applyConfiguration(_ previousConfiguration: Configuration?, with context: UIInputChangesContext) {
        print(#function)
        if configuration?.contentInset != previousConfiguration?.contentInset {
            scrollView.contentInset = configuration?.contentInset ?? .zero
        }
        if configuration?.items != previousConfiguration?.items {
            flags.isPartOfApplyConfiguration = true
            setNeedsUpdateConstraints()
            setNeedsLayout()
            if context.isAnimated || !context.isDeferred {
                layoutIfNeeded()
            }
        }
    }
}

extension CategorySegmentedControl {
    
    private struct Flags {
        
        var isPartOfApplyState = false
        
        var isPartOfApplyConfiguration = false
    }
}

extension CategorySegmentedControl {
    
    final class State: UIState {
        
        fileprivate var previousSelectedIndex: Int?
        
        @Invalidating var selectedIndex: Int?
        
        override init() {
            super.init()
        }
        
        override func copy() -> Self {
            State(copy: self) as! Self
        }
        
        init(copy other: borrowing State) {
            previousSelectedIndex = other.previousSelectedIndex
            _selectedIndex = other._selectedIndex
            super.init(copy: other)
        }
    }
}

extension CategorySegmentedControl {
    
    final class Configuration: UIConfiguration {
        
        @Invalidating var items: [Item]
        
        @Invalidating var contentInset: UIEdgeInsets = .zero
        
        init(items: [Item]) {
            _items = .init(wrappedValue: items)
            super.init()
        }
        
        override func copy() -> Self {
            Configuration(copy: self) as! Self
        }
        
        init(copy other: borrowing Configuration) {
            _items = other._items
            _contentInset = other._contentInset
            super.init(copy: other)
        }
    }
}

extension CategorySegmentedControl.Configuration {
    
    struct Item: Hashable {
        
        var iconImage: UIImage
        
        var title: String
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
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .secondaryLabel
    }
    
    private let selectedIconImageView: UIImageView = with(UIImageView(image: nil)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var selectedTitleLabel: UILabel = with(UILabel(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(forTextStyle: .title1, weight: .bold)
        $0.textColor = tintColor
    }
    
    var currentAnimator: UIViewPropertyAnimator?
    
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
        state.isHighlighted = true
        setNeedsAnimatedInputsChanges()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state.isHighlighted = false
        setNeedsAnimatedInputsChanges()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state.isHighlighted = false
        setNeedsAnimatedInputsChanges()
    }
    
    override func updatingConstraints() {
        super.updatingConstraints()
        if flags.isPartOfSelectChange {
            if state.isSelected {
                NSLayoutConstraint.deactivate(nonselectedConstraints)
                NSLayoutConstraint.activate(selectedConstraints)
            } else {
                NSLayoutConstraint.deactivate(selectedConstraints)
                NSLayoutConstraint.activate(nonselectedConstraints)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if flags.isPartOfSelectChange || flags.isPartOfApplyConfiguration {
            defer {
                flags.isPartOfSelectChange = false
                flags.isPartOfApplyConfiguration = false
            }
            if state.isSelected {
                iconImageView.transform = CGAffineTransform(scaleX: selectedIconImageView.bounds.width / iconImageView.bounds.width, y: selectedIconImageView.bounds.height / iconImageView.bounds.height)
                titleLabel.transform = CGAffineTransform(scaleX: selectedTitleLabel.bounds.width / titleLabel.bounds.width, y: selectedTitleLabel.bounds.height / titleLabel.bounds.height)
            } else {
                selectedIconImageView.transform = CGAffineTransform(scaleX: iconImageView.bounds.width / selectedIconImageView.bounds.width, y: iconImageView.bounds.height / selectedIconImageView.bounds.height)
                selectedTitleLabel.transform = CGAffineTransform(scaleX: titleLabel.bounds.width / selectedTitleLabel.bounds.width, y: titleLabel.bounds.height / selectedTitleLabel.bounds.height)
            }
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
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
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
            //iconImageView.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight.rounded(.down)),
            iconImageView.heightAnchor.constraint(equalToConstant: titleLabel.font.capHeight - titleLabel.font.descender),
            selectedIconImageView.widthAnchor.constraint(equalTo: selectedIconImageView.heightAnchor),
            //selectedIconImageView.heightAnchor.constraint(equalToConstant: selectedTitleLabel.font.lineHeight.rounded(.down)),
            selectedIconImageView.heightAnchor.constraint(equalToConstant: selectedTitleLabel.font.capHeight - selectedTitleLabel.font.descender),
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
        if state.isSelected != previousState?.isSelected {
            selectedDidChange(previousState?.isSelected, with: context)
        }
        if state.isHighlighted != previousState?.isHighlighted {
            highlightedDidChange(previousState?.isHighlighted, with: context)
        }
    }
    
    private func selectedDidChange(_ previousSelected: Bool?, with context: UIInputChangesContext) {
        if context.isAnimated {
            if state.isSelected {
                selectedIconImageView.isHidden = false
                selectedTitleLabel.isHidden = false
                bringSubviewToFront(selectedIconImageView)
                bringSubviewToFront(selectedTitleLabel)
            } else {
                iconImageView.isHidden = false
                titleLabel.isHidden = false
                bringSubviewToFront(iconImageView)
                bringSubviewToFront(titleLabel)
            }
            
            currentAnimator = UIViewPropertyAnimator.runningPropertyAnimator(animation: .default1Spring) { [unowned self] in
                flags.isPartOfSelectChange = true
                setNeedsUpdateConstraints()
                setNeedsLayout()
                layoutIfNeeded()
                
                if state.isSelected {
                    selectedIconImageView.transform = .identity
                    selectedTitleLabel.transform = .identity
                    iconImageView.alpha = 0.0
                    titleLabel.alpha = 0.0
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
            } completion: { [unowned self] in
                currentAnimator = nil
                guard $0 == .end else { return }
                if state.isSelected {
                    iconImageView.isHidden = true
                    titleLabel.isHidden = true
                } else {
                    selectedIconImageView.isHidden = true
                    selectedTitleLabel.isHidden = true
                }
            }
        } else {
            flags.isPartOfSelectChange = true
            setNeedsUpdateConstraints()
            setNeedsLayout()
            if !context.isDeferred {
                layoutIfNeeded()
            }
            
            if state.isSelected {
                selectedIconImageView.isHidden = false
                selectedTitleLabel.isHidden = false
                bringSubviewToFront(selectedIconImageView)
                bringSubviewToFront(selectedTitleLabel)
                
                selectedIconImageView.transform = .identity
                selectedTitleLabel.transform = .identity
                iconImageView.alpha = 0.0
                titleLabel.alpha = 0.0
                selectedIconImageView.alpha = 1.0
                selectedTitleLabel.alpha = 1.0
                
                iconImageView.isHidden = true
                titleLabel.isHidden = true
            } else {
                iconImageView.isHidden = false
                titleLabel.isHidden = false
                bringSubviewToFront(iconImageView)
                bringSubviewToFront(titleLabel)
                
                iconImageView.transform = .identity
                titleLabel.transform = .identity
                iconImageView.alpha = 1.0
                titleLabel.alpha = 1.0
                selectedIconImageView.alpha = 0.0
                selectedTitleLabel.alpha = 0.0
                
                selectedIconImageView.isHidden = true
                selectedTitleLabel.isHidden = true
            }
        }
    }
    
    private func highlightedDidChange(_ previousHighlighted: Bool?, with context: UIInputChangesContext) {
        if context.isAnimated {
            UIViewPropertyAnimator.runningPropertyAnimator(animation: .gentleSpring) { [self] in
                if state.isHighlighted {
                    transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    alpha = 0.5
                } else {
                    transform = .identity
                    alpha = 1.0
                }
            }
        } else {
            if state.isHighlighted {
                transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                alpha = 0.5
            } else {
                transform = .identity
                alpha = 1.0
            }
        }
    }
}

extension CategorySegmentView {
    
    private func applyConfiguration(_ previousConfiguration: Configuration?, with context: UIInputChangesContext) {
        if let configuration {
            let image = configuration.iconImage.withRenderingMode(.alwaysTemplate)
            iconImageView.image = image
            selectedIconImageView.image = image
            let title = configuration.title
            titleLabel.text = title
            selectedTitleLabel.text = title
        } else {
            iconImageView.image = nil
            selectedIconImageView.image = nil
            titleLabel.text = nil
            selectedTitleLabel.text = nil
        }
        
        flags.isPartOfApplyConfiguration = true
        setNeedsLayout()
        if !context.isDeferred || context.isAnimated {
            layoutIfNeeded()
        }
    }
}

extension CategorySegmentView {
    
    private struct Flags {
        
        var isPartOfSelectChange = false
        
        var isPartOfApplyConfiguration = false
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
