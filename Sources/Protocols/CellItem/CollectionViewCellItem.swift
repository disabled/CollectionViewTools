//
//  CollectionViewCellItem.swift
//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit.UICollectionView
import ObjectiveC.runtime

// MARK: - CollectionViewCellItem

public protocol CollectionViewCellItem: CollectionViewConfigureCellItem,
                                        CollectionViewReuseCellItem,
                                        CollectionViewSizeCellItem,
                                        CollectionViewGeneralCellItem,
                                        CollectionViewCellItemDataSource,
                                        CollectionViewSiblingCellItem {

}

// MARK: - CollectionViewReuseCellItem

public protocol CollectionViewReuseCellItem: AnyObject {
    var reuseType: ReuseType { get }
}

// MARK: - CollectionViewSizeCellItem

public protocol CollectionViewSizeCellItem: AnyObject {
    func size() -> CGSize
}

// MARK: - CollectionViewConfigureCellItem

public protocol CollectionViewConfigureCellItem: AnyObject {
    var isReplacementAnimationEnabled: Bool { get }
    func configure(_ cell: UICollectionViewCell)
    func configure(_ cell: UICollectionViewCell, animated: Bool)
}

public extension CollectionViewConfigureCellItem {
    var isReplacementAnimationEnabled: Bool {
        return true
    }
    func configure(_ cell: UICollectionViewCell, animated: Bool) {
    }
}

// MARK: - CollectionViewSiblingCellItem

public protocol CollectionViewSiblingCellItem: AnyObject {
    var collectionView: UICollectionView? { get set }
    var indexPath: IndexPath? { get set }
    var sectionItem: CollectionViewSectionItem? { get set }
}

extension CollectionViewSiblingCellItem {
    public weak var collectionView: UICollectionView? {
        get {
            if let object = objc_getAssociatedObject(self, &AssociatedKeys.collectionView) as? UICollectionView {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.collectionView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public var indexPath: IndexPath? {
        get {
            if let object = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public weak var sectionItem: CollectionViewSectionItem? {
        get {
            if let object = objc_getAssociatedObject(self, &AssociatedKeys.sectionItem) as? CollectionViewSectionItem {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sectionItem, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public var cell: UICollectionViewCell? {
        guard let collectionView = collectionView, let indexPath = indexPath else {
            return nil
        }

        return collectionView.cellForItem(at: indexPath)
    }
}

// MARK: - CollectionViewGeneralCellItem

public typealias ActionHandler = () -> Void
public typealias ActionResolver = () -> Bool
public typealias CellActionHandler = (UICollectionViewCell) -> Void
public typealias ViewActionHandler = (UICollectionReusableView, String, UICollectionView, IndexPath) -> Void

public protocol CollectionViewGeneralCellItem: AnyObject {

    var itemShouldHighlightResolver: ActionResolver? { get set }
    var itemDidHighlightHandler: ActionHandler? { get set }
    var itemDidUnhighlightHandler: ActionHandler? { get set }

    var itemDidSelectHandler: ActionHandler? { get set }
    var itemDidDeselectHandler: ActionHandler? { get set }
    var itemShouldSelectResolver: ActionResolver? { get set }
    var itemShouldDeselectResolver: ActionResolver? { get set }

    var itemWillDisplayCellHandler: CellActionHandler? { get set }
    var itemDidEndDisplayingCellHandler: CellActionHandler? { get set }
    var itemWillDisplayViewHandler: ViewActionHandler? { get set }
    var itemDidEndDisplayingViewHandler: ViewActionHandler? { get set }

    var itemCanMoveResolver: ActionResolver? { get set }

    func shouldHighlight() -> Bool
    func didHighlight()
    func didUnhighlight()

    func shouldSelect() -> Bool
    func shouldDeselect() -> Bool
    func didSelect()
    func didDeselect()

    func willDisplay(cell: UICollectionViewCell)
    func didEndDisplaying(cell: UICollectionViewCell)

    func willDisplay(view: UICollectionReusableView, for elementKind: String, for collectionView: UICollectionView, at indexPath: IndexPath)
    func didEndDisplaying(view: UICollectionReusableView,
                          for elementKind: String,
                          for collectionView: UICollectionView,
                          at indexPath: IndexPath)

    func canMove() -> Bool
}

private enum AssociatedKeys {

    static var shouldHighlightHandler = "rsb_shouldHighlightHandler"
    static var didHighlightHandler = "rsb_didHighlightHandler"
    static var didUnhighlightHandler = "rsb_didUnhighlightHandler"
    static var didSelectHandler = "rsb_didSelectHandler"
    static var didDeselectHandler = "rsb_didDeselectHandler"
    static var shouldSelectHandler = "rsb_shouldSelectHandler"
    static var shouldDeselectHandler = "rsb_shouldDeselectHandler"
    static var willDisplayCellHandler = "rsb_willDisplayCellHandler"
    static var willDisplayViewHandler = "rsb_willDisplayViewHandler"
    static var didEndDisplayingCellHandler = "rsb_didEndDisplayingCellHandler"
    static var didEndDisplayingViewHandler = "rsb_didEndDisplayingViewHandler"
    static var canMoveHandler = "rsb_canMoveHandler"

    static var collectionView = "rsb_collectionView"
    static var indexPath = "rsb_indexPath"
    static var sectionItem = "rsb_sectionItem"
}

public extension CollectionViewGeneralCellItem {

    // MARK: - Handlers

    var itemShouldHighlightResolver: ActionResolver? {
        get {
            return ClosureWrapper<ActionResolver>.handler(for: self, key: &AssociatedKeys.shouldHighlightHandler)
        }
        set {
            ClosureWrapper<ActionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.shouldHighlightHandler)
        }
    }

    var itemDidHighlightHandler: ActionHandler? {
        get {
            return ClosureWrapper<ActionHandler>.handler(for: self, key: &AssociatedKeys.didHighlightHandler)
        }
        set {
            ClosureWrapper<ActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didHighlightHandler)
        }
    }

    var itemDidUnhighlightHandler: ActionHandler? {
        get {
            return ClosureWrapper<ActionHandler>.handler(for: self, key: &AssociatedKeys.didUnhighlightHandler)
        }
        set {
            ClosureWrapper<ActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didUnhighlightHandler)
        }
    }

    var itemDidSelectHandler: ActionHandler? {
        get {
            return ClosureWrapper<ActionHandler>.handler(for: self, key: &AssociatedKeys.didSelectHandler)
        }
        set {
            ClosureWrapper<ActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didSelectHandler)
        }
    }

    var itemDidDeselectHandler: ActionHandler? {
        get {
            return ClosureWrapper<ActionHandler>.handler(for: self, key: &AssociatedKeys.didDeselectHandler)
        }
        set {
            ClosureWrapper<ActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didDeselectHandler)
        }
    }

    var itemShouldSelectResolver: ActionResolver? {
        get {
            return ClosureWrapper<ActionResolver>.handler(for: self, key: &AssociatedKeys.shouldSelectHandler)
        }
        set {
            ClosureWrapper<ActionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.shouldSelectHandler)
        }
    }

    var itemShouldDeselectResolver: ActionResolver? {
        get {
            return ClosureWrapper<ActionResolver>.handler(for: self, key: &AssociatedKeys.shouldDeselectHandler)
        }
        set {
            ClosureWrapper<ActionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.shouldDeselectHandler)
        }
    }

    var itemWillDisplayCellHandler: CellActionHandler? {
        get {
            return ClosureWrapper<CellActionHandler>.handler(for: self, key: &AssociatedKeys.willDisplayCellHandler)
        }
        set {
            ClosureWrapper<CellActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.willDisplayCellHandler)
        }
    }

    var itemDidEndDisplayingCellHandler: CellActionHandler? {
        get {
            return ClosureWrapper<CellActionHandler>.handler(for: self, key: &AssociatedKeys.didEndDisplayingCellHandler)
        }
        set {
            ClosureWrapper<CellActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didEndDisplayingCellHandler)
        }
    }

    var itemWillDisplayViewHandler: ViewActionHandler? {
        get {
            return ClosureWrapper<ViewActionHandler>.handler(for: self, key: &AssociatedKeys.willDisplayViewHandler)
        }
        set {
            ClosureWrapper<ViewActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.willDisplayViewHandler)
        }
    }

    var itemDidEndDisplayingViewHandler: ViewActionHandler? {
        get {
            return ClosureWrapper<ViewActionHandler>.handler(for: self, key: &AssociatedKeys.didEndDisplayingViewHandler)
        }
        set {
            ClosureWrapper<ViewActionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didEndDisplayingViewHandler)
        }
    }

    var itemCanMoveResolver: ActionResolver? {
        get {
            return ClosureWrapper<ActionResolver>.handler(for: self, key: &AssociatedKeys.canMoveHandler)
        }
        set {
            ClosureWrapper<ActionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.canMoveHandler)
        }
    }

    // MARK: - Functions

    func shouldHighlight() -> Bool {
        return itemShouldHighlightResolver?() ?? true
    }

    func didHighlight() {
        itemDidHighlightHandler?()
    }

    func didUnhighlight() {
        itemDidUnhighlightHandler?()
    }

    func shouldSelect() -> Bool {
        return itemShouldSelectResolver?() ?? true
    }

    func shouldDeselect() -> Bool {
        return itemShouldDeselectResolver?() ?? true
    }

    func didSelect() {
        itemDidSelectHandler?()
    }

    func didDeselect() {
        itemDidDeselectHandler?()
    }

    func willDisplay(cell: UICollectionViewCell) {
        itemWillDisplayCellHandler?(cell)
    }

    func didEndDisplaying(cell: UICollectionViewCell) {
        itemDidEndDisplayingCellHandler?(cell)
    }

    func canMove() -> Bool {
        return itemCanMoveResolver?() ?? false
    }

    func size() -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    func willDisplay(view: UICollectionReusableView,
                     for elementKind: String,
                     for collectionView: UICollectionView,
                     at indexPath: IndexPath) {
        itemWillDisplayViewHandler?(view, elementKind, collectionView, indexPath)
    }

    func didEndDisplaying(view: UICollectionReusableView,
                          for elementKind: String,
                          for collectionView: UICollectionView,
                          at indexPath: IndexPath) {
        itemDidEndDisplayingViewHandler?(view, elementKind, collectionView, indexPath)
    }
}
