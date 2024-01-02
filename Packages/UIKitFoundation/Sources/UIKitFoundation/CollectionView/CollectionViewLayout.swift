//
//  CollectionViewLayout.swift
//
//
//  Created by Ruslan Lutfullin on 6/30/21.
//

import UIKit

///
public typealias DefaultCollectionViewLayout = CollectionViewLayout<CollectionViewLayoutInvalidationContext, CollectionViewLayoutAttributes>

///
open class CollectionViewLayout<InvalidationContext: CollectionViewLayoutInvalidationContext, Attributes: CollectionViewLayoutAttributes>: UICollectionViewLayout {
	
	// MARK: -
	
	public typealias InvalidationContext = InvalidationContext
	
	public typealias Attributes = Attributes
	
	// MARK: -
	
	@available(*, unavailable)
	public override static var invalidationContextClass: AnyClass { InvalidationContext.self }
	//
	public final var isEverythingInvalid = false
	
	public final var isDataSourceCountsInvalid = false
	//
	@available(*, unavailable)
	public final override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
		invalidateLayout(with: unsafeDowncast(context, to: InvalidationContext.self))
	}
	
	open func invalidateLayout(with context: InvalidationContext) {
		super.invalidateLayout(with: context)
		if context.invalidateEverything {
			isEverythingInvalid = true
		} else if context.invalidateDataSourceCounts {
			isDataSourceCountsInvalid = true
		}
	}
	
	@available(*, unavailable)
	public final override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
		return invalidationContext(forBoundsChange: newBounds)
	}
	
	open func invalidationContext(forBoundsChange newBounds: CGRect) -> InvalidationContext {
		return unsafeDowncast(super.invalidationContext(forBoundsChange: newBounds), to: InvalidationContext.self)
	}
	
	@available(*, unavailable)
	public final override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
		return shouldInvalidateLayout(forPreferredLayoutAttributes: unsafeDowncast(preferredAttributes, to: Attributes.self), withOriginalAttributes: unsafeDowncast(originalAttributes, to: Attributes.self))
	}
	
	open func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: Attributes, withOriginalAttributes originalAttributes: Attributes) -> Bool {
		return super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
	}
	
	@available(*, unavailable)
	public final override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
		return invalidationContext(forPreferredLayoutAttributes: unsafeDowncast(preferredAttributes, to: Attributes.self), withOriginalAttributes: unsafeDowncast(originalAttributes, to: Attributes.self))
	}
	
	open func invalidationContext(forPreferredLayoutAttributes preferredAttributes: Attributes, withOriginalAttributes originalAttributes: Attributes) -> InvalidationContext {
		return unsafeDowncast(super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes), to: InvalidationContext.self)
	}
	
	@available(*, unavailable)
	public final override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
		return invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
	}
	
	open func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> InvalidationContext {
		return unsafeDowncast(super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition), to: InvalidationContext.self)
	}
	
	@available(*, unavailable)
	public final override func invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths indexPaths: [IndexPath], previousIndexPaths: [IndexPath], movementCancelled: Bool) -> UICollectionViewLayoutInvalidationContext {
		return invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths: indexPaths, previousIndexPaths: previousIndexPaths, movementCancelled: movementCancelled)
	}
	
	open func invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths indexPaths: [IndexPath], previousIndexPaths: [IndexPath], movementCancelled: Bool) -> InvalidationContext {
		return unsafeDowncast(super.invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths: indexPaths, previousIndexPaths: previousIndexPaths, movementCancelled: movementCancelled), to: InvalidationContext.self)
	}
	
	// MARK: -
	
	@available(*, unavailable)
	public override static var layoutAttributesClass: AnyClass { Attributes.self }
	//
	public final var layoutSize = LayoutSize()
	
	public final var layoutAttributes: ContiguousArray<Attributes> = []
	
	public final var mappedLayoutAttributes = MappedLayoutAttributes()
	//
	@available(*, unavailable)
	public final override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return layoutAttributesForElements(in: rect)
	}
	
	open func layoutAttributesForElements(in rect: CGRect) -> [Attributes]? {
		return layoutAttributes.filter {
			!(rect.minX > $0.frame.maxX ||
			  rect.maxX < $0.frame.minX ||
			  rect.minY > $0.frame.maxY ||
			  rect.maxY < $0.frame.minY)
		}
	}
	
	@available(*, unavailable)
	public final override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return layoutAttributesForItem(at: indexPath)
	}
	
	open func layoutAttributesForItem(at indexPath: IndexPath) -> Attributes? {
		return mappedLayoutAttributes.indexPathsToItems[indexPath]
	}
	
	@available(*, unavailable)
	public final override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
		return layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
	}
	
	open func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> Attributes {
		return unsafeDowncast(super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position), to: Attributes.self)
	}
	
	@available(*, unavailable)
	public final override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
	}
	
	open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> Attributes? {
		return mappedLayoutAttributes.indexPathKindsToSupplementaries[.init(of: elementKind, at: indexPath)]
	}
	
	@available(*, unavailable)
	public final override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
	}
	
	open func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> Attributes? {
		return mappedLayoutAttributes.indexPathKindsToSupplementaries[.init(of: elementKind, at: indexPath)]
	}
	
	// MARK: -
	
	public final var collectionViewUpdates = CollectionViewUpdates()
	
	@available(*, unavailable)
	public final override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
		super.prepare(forCollectionViewUpdates: updateItems)
		
		var updates = CollectionViewUpdates()
		
		for updateItem in updateItems {
			switch updateItem.updateAction {
			case .insert:
				guard let indexPath = updateItem.indexPathAfterUpdate else { continue }
				
				if indexPath.item == NSNotFound {
					updates.insertedSections.insert(indexPath.section)
				} else {
					updates.insertedItems.insert(indexPath)
				}
				
			case .delete:
				guard let indexPath = updateItem.indexPathBeforeUpdate else { continue }
				
				if indexPath.item == NSNotFound {
					updates.deletedSections.insert(indexPath.section)
				} else {
					updates.deletedItems.insert(indexPath)
				}
				
			case .move:
				guard let fromIndexPath = updateItem.indexPathAfterUpdate, let toIndexPath = updateItem.indexPathBeforeUpdate else { continue }
				
				if fromIndexPath.item == NSNotFound && toIndexPath.item == NSNotFound {
					updates.movedSections.insert(.init(from: fromIndexPath.section, to: toIndexPath.section))
				} else {
					updates.movedSupplementaries.insert(.init(from: fromIndexPath, to: toIndexPath))
				}
				
			case .reload:
				guard let indexPath = updateItem.indexPathAfterUpdate else { continue }
				
				if indexPath.item == NSNotFound {
					updates.reloadedSections.insert(indexPath.section)
				} else {
					updates.reloadedItems.insert(indexPath)
				}
				
			default:
				continue
			}
		}
		
		prepare(forCollectionViewUpdates: updates)
	}
	
	open func prepare(forCollectionViewUpdates updates: CollectionViewUpdates) {
		collectionViewUpdates = updates
	}
	
	// MARK: -
	
	public final override var collectionViewContentSize: CGSize { layoutSize.current }
	
	// MARK: -
	
	open override func indexPathsToInsertForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
		return .init(collectionViewUpdates.insertedSupplementaries.lazy.filter { $0.of == elementKind }.map { $0.at })
	}
	
	open override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
		return .init(collectionViewUpdates.insertedDecorations.lazy.filter { $0.of == elementKind }.map { $0.at })
	}
	
	open override func indexPathsToDeleteForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
		return .init(collectionViewUpdates.deletedSupplementaries.lazy.filter { $0.of == elementKind }.map { $0.at })
	}
	
	open override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
		return .init(collectionViewUpdates.deletedDecorations.lazy.filter { $0.of == elementKind }.map { $0.at })
	}
	
	@available(*, unavailable)
	public final override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return initialLayoutAttributesForAppearingItem(at: itemIndexPath)
	}
	
	open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> Attributes? {
		if collectionViewUpdates.insertedSections.contains(itemIndexPath.section) || collectionViewUpdates.insertedItems.contains(itemIndexPath) {
			guard let _attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
			let attributes = unsafeDowncast(_attributes, to: Attributes.self)
			attributes.alpha = 0.0
			return attributes
		} else if collectionViewUpdates.reloadedSections.contains(itemIndexPath.section) || collectionViewUpdates.reloadedItems.contains(itemIndexPath) {
			return unsafeDowncast(mappedLayoutAttributes.oldIndexPathsToItems[itemIndexPath]!, to: Attributes.self)
		} else {
			guard let _attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
			let attributes = unsafeDowncast(_attributes, to: Attributes.self)
			return attributes
		}
	}
	
	@available(*, unavailable)
	public final override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
	}
	
	open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> Attributes? {
		if collectionViewUpdates.deletedSections.contains(itemIndexPath.section) || collectionViewUpdates.deletedItems.contains(itemIndexPath) {
			guard let _attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
			let attributes = unsafeDowncast(_attributes, to: Attributes.self)
			attributes.alpha = 0.0
			return attributes
		} else if collectionViewUpdates.reloadedSections.contains(itemIndexPath.section) || collectionViewUpdates.reloadedItems.contains(itemIndexPath) {
			return unsafeDowncast(mappedLayoutAttributes.indexPathsToItems[itemIndexPath]!, to: Attributes.self)
		} else {
			guard let _attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
			let attributes = unsafeDowncast(_attributes, to: Attributes.self)
			return attributes
		}
	}
	//
	@available(*, unavailable)
	public final override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
	}
	
	open func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> Attributes? {
		let indexPathKind = IndexPathKind(of: elementKind, at: elementIndexPath)
		
		if collectionViewUpdates.insertedSupplementaries.contains(indexPathKind) {
			let attributes = mappedLayoutAttributes.indexPathKindsToSupplementaries[indexPathKind]
			attributes?.alpha = 0.0
			return attributes
		} else {
			return nil
		}
	}
	//
	@available(*, unavailable)
	public final override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
	}
	
	open func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> Attributes? {
		let indexPathKind = IndexPathKind(of: elementKind, at: elementIndexPath)
		
		if collectionViewUpdates.deletedSupplementaries.contains(indexPathKind) {
			let attributes = mappedLayoutAttributes.oldIndexPathKindsToSupplementaries[indexPathKind]
			attributes?.alpha = 0.0
			return attributes
		} else {
			return nil
		}
	}
	//
	@available(*, unavailable)
	public final override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return initialLayoutAttributesForAppearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
	}
	
	open func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> Attributes? {
		let indexPathKind = IndexPathKind(of: elementKind, at: decorationIndexPath)
		
		if collectionViewUpdates.insertedDecorations.contains(indexPathKind) {
			let attributes = mappedLayoutAttributes.indexPathKindsToDecorations[indexPathKind]
			attributes?.alpha = 0.0
			return attributes
		} else {
			return nil
		}
	}
	
	@available(*, unavailable)
	public final override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return finalLayoutAttributesForDisappearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
	}
	
	open func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> Attributes? {
		let indexPathKind = IndexPathKind(of: elementKind, at: decorationIndexPath)
		
		if collectionViewUpdates.deletedDecorations.contains(indexPathKind) {
			let attributes = mappedLayoutAttributes.oldIndexPathKindsToDecorations[indexPathKind]
			attributes?.alpha = 0.0
			return attributes
		} else {
			return nil
		}
	}
	
	// MARK: -
	
	public override init() {
		super.init()
	}
	
	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError()
	}
}
