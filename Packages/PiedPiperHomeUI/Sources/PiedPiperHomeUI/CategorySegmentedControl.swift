//
//  CategorySegmentedControl.swift
//
//
//  Created by Ruslan Lutfullin on 05/12/23.
//

import SwiftUtilities
import Algorithms
import UIKit
import UIKitFoundation
import UIKitUtilities

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
        guard !hasActiveInteractiveTransition else { return }
        hasActiveInteractiveTransition = true
        state.selectedIndex = selectedIndex
        setNeedsAnimatedInputsChanges()
        changesInputsIfNeeded()
        currentAnimator?.pauseAnimation()
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        currentAnimator?.fractionComplete = percentComplete
    }
    
    func pauseInteractiveTransition() {
        currentAnimator?.pauseAnimation()
    }
    
    func finishInteractiveTransition() {
        hasActiveInteractiveTransition = false
        currentAnimator?.startAnimation()
    }
    
    func cancelInteractiveTransition() {
        hasActiveInteractiveTransition = false
        currentAnimator?.isReversed = true
        currentAnimator?.startAnimation()
    }
    
    private var segmentsBottomConstraint: [NSLayoutConstraint] = []
    
    override func updatingConstraints() {
        super.updatingConstraints()
        
        if flags.updatingConstraintsAsPartOfApplyConfiguration {
            flags.updatingConstraintsAsPartOfApplyConfiguration = false
            
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
        }
        
        if flags.updatingConstraintsAsPartOfApplyState {
            flags.updatingConstraintsAsPartOfApplyState = false
            
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
        }
    }
        
    override func setupCommon() {
        super.setupCommon()
        addSubview(scrollView)
        
        registerForStateChanges(in: &$state) { [unowned self] previousState, context in
            applyState(previousState, with: context)
        }
        registerForConfigurationChanges(in: &$configuration) { [unowned self] previousConfiguration, context in
            applyConfiguration(previousConfiguration, with: context)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
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
        if context.isAnimated {
            for (index, segmentView) in segmentsView.indexed() {
                segmentView.state.isSelected = index == state.selectedIndex
                segmentView.setNeedsAnimatedInputsChanges()
            }
            
            flags.updatingConstraintsAsPartOfApplyState = true
            setNeedsUpdateConstraints()
            
            setNeedsLayout()
            
            currentAnimator = UIViewPropertyAnimator.runningPropertyAnimator(animation: .default1Spring) { [unowned self] in
                for segmentView in segmentsView {
                    segmentView.setNeedsAnimatedInputsChanges()
                    segmentView.changesInputsIfNeeded()
                }
                
                layoutIfNeeded()
                
                let contentOffsetX = if let selectedIndex = state.selectedIndex {
                    scrollView.startContentOffset.x + ((scrollView.endContentOffset.x -  scrollView.startContentOffset.x) / CGFloat(segmentsView.count - 1)) * CGFloat(selectedIndex)
                } else {
                    scrollView.startContentOffset.x
                }
                scrollView.contentOffset = CGPoint(x: contentOffsetX, y: 0.0)
            } completion: { [unowned self] in
                currentAnimator = nil
                guard $0 == .start, let previousState else { return }
                state = previousState
                changesInputsIfNeeded()
            }
        } else {
            for (index, segmentView) in segmentsView.indexed() {
                segmentView.state.isSelected = index == state.selectedIndex
            }
            
            flags.updatingConstraintsAsPartOfApplyState = true
            setNeedsUpdateConstraints()
            
            setNeedsLayout()
            
            AfterCACommitTransaction { [self] in
                let contentOffsetX = if let selectedIndex = state.selectedIndex {
                    scrollView.startContentOffset.x + ((scrollView.endContentOffset.x -  scrollView.startContentOffset.x) / CGFloat(segmentsView.count - 1)) * CGFloat(selectedIndex)
                } else {
                    scrollView.startContentOffset.x
                }
                CATransaction.performWithoutActions {
                    scrollView.contentOffset = CGPoint(x: contentOffsetX, y: 0.0)
                }
            }
        }
    }
}

extension CategorySegmentedControl {
    
    private func applyConfiguration(_ previousConfiguration: Configuration?, with context: UIInputChangesContext) {
        if configuration?.contentInset != previousConfiguration?.contentInset {
            scrollView.contentInset = configuration?.contentInset ?? .zero
        }
        
        if configuration?.items != previousConfiguration?.items {
            for segmentView in segmentsView {
                segmentView.removeFromSuperview()
            }
            segmentsView.removeAll()
            segmentsBottomConstraint.removeAll()
            scrollView.contentSize = .zero
            scrollView.contentOffset = scrollView.startContentOffset
            
            if let items = configuration?.items {
                segmentsView.reserveCapacity(items.count)
                for (index, item) in items.indexed() {
                    let segmentView = CategorySegmentView(frame: .zero, configuration: CategorySegmentView.Configuration(iconImage: item.iconImage, title: item.title))
                    segmentView.translatesAutoresizingMaskIntoConstraints = false
                    segmentView.state.isSelected = index == state.selectedIndex
                    scrollView.addSubview(segmentView)
                    segmentsView.append(segmentView)
                }
            }
            
            flags.updatingConstraintsAsPartOfApplyConfiguration = true
            setNeedsUpdateConstraints()
        }
    }
}

extension CategorySegmentedControl {
    
    private struct Flags {
        
        var updatingConstraintsAsPartOfApplyState = false
        
        var updatingConstraintsAsPartOfApplyConfiguration = false
    }
}

extension CategorySegmentedControl {
    
    final class State: UIState {
        
        @Invalidating var selectedIndex: Int?
        
        override init() {
            super.init()
        }
        
        override func copy() -> Self {
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
    
    private var currentAnimator: UIViewPropertyAnimator?
    
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
        if flags.updatingConstraintAsPartOfSelectChange {
            flags.updatingConstraintAsPartOfSelectChange = false
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
        if flags.layoutSubviewsAsPartOfSelectChange || flags.layoutSubviewsAsPartOfApplyConfiguration {
            flags.layoutSubviewsAsPartOfSelectChange = false
            flags.layoutSubviewsAsPartOfApplyConfiguration = false
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
        addSubview(iconImageView)
        addSubview(selectedIconImageView)
        addSubview(titleLabel)
        addSubview(selectedTitleLabel)
        
        registerForStateChanges(in: &$state) { [unowned self] previousState, context in
            applyState(previousState, with: context)
        }
        registerForConfigurationChanges(in: &$configuration) { [unowned self] previousConfiguration, context in
            applyConfiguration(previousConfiguration, with: context)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
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
            
            flags.updatingConstraintAsPartOfSelectChange = true
            setNeedsUpdateConstraints()
            
            flags.layoutSubviewsAsPartOfSelectChange = true
            setNeedsLayout()
            
            currentAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.0, delay: 0.0) { [unowned self] in
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
                
                layoutIfNeeded()
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
            
            flags.updatingConstraintAsPartOfSelectChange = true
            setNeedsUpdateConstraints()
            
            flags.layoutSubviewsAsPartOfSelectChange = true
            setNeedsLayout()
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
        
        flags.layoutSubviewsAsPartOfApplyConfiguration = true
        setNeedsLayout()
    }
}

extension CategorySegmentView {
    
    private struct Flags {
        
        var updatingConstraintAsPartOfSelectChange = false
        
        var layoutSubviewsAsPartOfSelectChange = false
        
        var layoutSubviewsAsPartOfApplyConfiguration = false
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
