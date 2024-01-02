//
//  HomeCollectionViewController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import SwiftUtilities
import UIKit
import UIKitUtilities
import UIKitFoundation

final class HomeCollectionViewController: ViewController {
    
    private lazy var collectionWrapperView = HomeCollectionWrapperView(frame: .zero)
    
    var collectionView: HomeCollectionView { collectionWrapperView.collectionView }
    
    private lazy var collectionViewDataSource = makeCollectionViewDataSoruce()
    
    override func loadView() {
        view = collectionWrapperView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .inline
        navigationItem.title = "Смотреть"
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(Array(0..<4))
        collectionViewDataSource.applySnapshotUsingReloadData(snapshot)
    }
}

extension HomeCollectionViewController {
    
    private func makeCollectionViewDataSoruce() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = makeCollectionViewCellRegistration()
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func makeCollectionViewCellRegistration() -> UICollectionView.CellRegistration<HomeCollectionViewCell, Item> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
        }
    }
}

extension HomeCollectionViewController {
    
    private enum Section: CaseIterable { case main }
    
    private typealias Item = Int
}

final class HomeCollectionWrapperView: View {
    
    private var segmentedControl: CategorySegmentedControl = with(CategorySegmentedControl(
        frame: .zero,
        configuration: CategorySegmentedControl.Configuration(items: [
            .init(iconImage: UIImage(resource: .icons8OneRing), title: "Фильмы"),
            .init(iconImage: UIImage(resource: .icons8WalterWhite), title: "Сериалы"),
            .init(iconImage: UIImage(resource: .icons8PatrickStar), title: "Мультфильмы"),
            .init(iconImage: UIImage(resource: .icons8MyMelody), title: "Аниме"),
        ])
    )) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.state.selectedIndex = 0
    }
    
    let collectionView: HomeCollectionView = with(HomeCollectionView(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        segmentedControl.configuration?.contentInset = UIEdgeInsets(top: 0.0, left: directionalLayoutMargins.leading, bottom: 0.0, right: directionalLayoutMargins.trailing)
    }
    
    override func setupCommon() {
        super.setupCommon()
        collectionView.pagingDelegate = self
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            self.segmentedControl.state.selectedIndex = 1
//            self.segmentedControl.setNeedsAnimatedInputsChanges()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            self.segmentedControl.state.selectedIndex = 2
//            self.segmentedControl.setNeedsAnimatedInputsChanges()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7)) {
//            self.segmentedControl.state.selectedIndex = 0
//            self.segmentedControl.setNeedsAnimatedInputsChanges()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(9)) {
//            self.segmentedControl.state.selectedIndex = 3
//           // self.segmentedControl.setNeedsAnimatedInputsChanges()
//        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        addSubview(collectionView)
        addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 0.5),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])
    }
}

extension HomeCollectionWrapperView: HomeCollectionViewPagingDelegate {
    
    func collectionViewDidBeginPaging(_ collectionView: HomeCollectionView, from fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        segmentedControl.startInteractiveTransition(toSelectedIndex: toIndexPath.item)
    }
    
    func collectionViewDidEndPaging(_ collectionView: HomeCollectionView, at indexPath: IndexPath) {
        if segmentedControl.state.selectedIndex == indexPath.item {
            segmentedControl.finishInteractiveTransition()
        } else {
            segmentedControl.cancelInteractiveTransition()
        }
    }
    
    func collectionViewDidPaging(_ collectionView: HomeCollectionView, withProgress progress: CGFloat) {
        segmentedControl.updateInteractiveTransition(progress)
    }
}

final class HomeCollectionView: CollectionView {
    
    @_nonoverride 
    let collectionViewLayout: UICollectionViewCompositionalLayout = with {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        configuration.contentInsetsReference = .none
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
    
    private var lastPagingIndexPath: IndexPath?
    
    private var pagingState: PagingState?
    
    fileprivate var hasActivePaging: Bool { pagingState != nil }
    
    fileprivate weak var pagingDelegate: (any HomeCollectionViewPagingDelegate)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let startContentOffsetX = startContentOffset.x
        let endContentOffsetX = endContentOffset.x
        let contentOffsetX = clamp(contentOffset.x, min: startContentOffsetX, max: endContentOffsetX)
        if let pagingState {
            let fromContentOffsetX = bounds.width * CGFloat(pagingState.fromIndexPath.item)
            let toContentOffsetX = bounds.width * CGFloat(pagingState.toIndexPath.item)
            let progress = (contentOffsetX - fromContentOffsetX) / (toContentOffsetX - fromContentOffsetX)
            self.pagingState!.progress = progress
            pagingDelegate?.collectionViewDidPaging(self, withProgress: progress)
            if progress == 0.0 {
                let fromIndexPath = pagingState.fromIndexPath
                self.pagingState = nil
                pagingDelegate?.collectionViewDidEndPaging(self, at: fromIndexPath)
            } else if progress == 1.0 {
                let toIndexPath = pagingState.toIndexPath
                lastPagingIndexPath = pagingState.toIndexPath
                self.pagingState = nil
                pagingDelegate?.collectionViewDidEndPaging(self, at: toIndexPath)
            }
        } else {
            guard numberOfItems(inSection: 0) > 0 else {
                lastPagingIndexPath = nil
                return
            }
            if lastPagingIndexPath == nil {
                lastPagingIndexPath = IndexPath(item: 0, section: 0)
            }
            let lastPagingIndexPath = lastPagingIndexPath!
            let pagingOffsetX = bounds.width * CGFloat(lastPagingIndexPath.item)
            if contentOffsetX > pagingOffsetX {
                let fromIndexPath = lastPagingIndexPath
                let toIndexPath = IndexPath(item: lastPagingIndexPath.item + 1, section: lastPagingIndexPath.section)
                pagingState = PagingState(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath, progress: 0.0)
                pagingDelegate?.collectionViewDidBeginPaging(self, from: fromIndexPath, to: toIndexPath)
            } else if contentOffsetX < pagingOffsetX {
                let fromIndexPath = lastPagingIndexPath
                let toIndexPath = IndexPath(item: lastPagingIndexPath.item - 1, section: lastPagingIndexPath.section)
                pagingState = PagingState(fromIndexPath: lastPagingIndexPath, toIndexPath: IndexPath(item: lastPagingIndexPath.item - 1, section: lastPagingIndexPath.section), progress: 0.0)
                pagingDelegate?.collectionViewDidBeginPaging(self, from: fromIndexPath, to: toIndexPath)
            }
        }
    }
    
    override func setupCommon() {
        super.setupCommon()
        backgroundColor = .secondarySystemBackground
        alwaysBounceVertical = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
    }
}

extension HomeCollectionView {
    
    private struct PagingState {
        
        var fromIndexPath: IndexPath
        
        var toIndexPath: IndexPath
        
        var progress: CGFloat
    }
}

fileprivate protocol HomeCollectionViewPagingDelegate: AnyObject {
    
    func collectionViewDidBeginPaging(_ collectionView: HomeCollectionView, from fromIndexPath: IndexPath, to toIndexPath: IndexPath)
    
    func collectionViewDidEndPaging(_ collectionView: HomeCollectionView, at indexPath: IndexPath)
    
    func collectionViewDidPaging(_ collectionView: HomeCollectionView, withProgress progress: CGFloat)
}

final class HomeCollectionViewCell: CollectionViewCell {
    
    private let gradientLayer: CAGradientLayer = with(CAGradientLayer()) {
        $0.startPoint = CGPoint(x: 0.0, y: 0.5)
        $0.endPoint = CGPoint(x: 1.0, y: 0.5)
        $0.type = .axial
        $0.colors = [UIColor.systemBackground.cgColor, UIColor.secondarySystemBackground.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.addSublayer(gradientLayer)
    }
}
