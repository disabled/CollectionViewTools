//
//  CollectionViewManager.swift
//
//  Copyright © 2020 Rosberry. All rights reserved.
//

open class ArraySectionItemsProvider: SectionItemsProvider {

    public var sectionItems: [CollectionViewSectionItem] = []

    public var numberOfSections: Int {
        sectionItems.count
    }

    public var reuseTypes: [ReuseType] {
        get {
            sectionItems.flatMap { sectionItem in
                sectionItem.cellItems.map { cellItem in
                    cellItem.reuseType
                }
            }
        }
    }

    public var isEmpty: Bool {
        sectionItems.isEmpty
    }

    public subscript(index: Int) -> CollectionViewSectionItem? {
        get {
            sectionItems[safe: index]
        }
        set {
            if let value = newValue {
                sectionItems[index] = value
            }
            else {
                sectionItems.remove(at: index)
            }
        }
    }

    public subscript(indexPath: IndexPath) -> CollectionViewCellItem? {
        get {
            self[indexPath.section]?.cellItems[safe: indexPath.row]
        }
        set {
            if let value = newValue {
                self[indexPath.section]?.cellItems[indexPath.row] = value
            }
            else {
                self[indexPath.section]?.cellItems.remove(at: indexPath.row)
            }

        }
    }

    public func numberOfItems(inSection section: Int) -> Int {
        self[section]?.cellItems.count ?? 0
    }

    public func sizeForCellItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        guard let sectionItem = self[indexPath.section],
              let cellItem = sectionItem.cellItems[safe: indexPath.row] else {
                return .zero
        }
        return cellItem.size(in: collectionView, sectionItem: sectionItem)
    }

    public func insert(_ sectionItem: CollectionViewSectionItem, at index: Int) {
        sectionItems.insert(sectionItem, at: index)
    }

    public func insert(contentsOf collection: [CollectionViewSectionItem], at index: Int) {
        sectionItems.insert(contentsOf: collection, at: index)
    }

    public func remove(at index: Int) {
        sectionItems.remove(at: index)
    }

    public func remove(at indexPath: IndexPath) {
        self[indexPath.section]?.cellItems.remove(at: indexPath.row)
    }

    public func move(sectionItem: CollectionViewSectionItem?, at index: Int, to destinationIndex: Int) {
        guard let keySectionItem = sectionItem ?? self[index] else {
            return
        }
        sectionItems.remove(at: index)
        sectionItems.insert(keySectionItem, at: index)
    }

    public func move(cellItemAt indexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceSectionItem = self[indexPath.section],
              let destinationIndexPathSectionItem = self[destinationIndexPath.section] else {
            return
        }
        let cellItem = sourceSectionItem.cellItems.remove(at: indexPath.row)
        destinationIndexPathSectionItem.cellItems.insert(cellItem, at: destinationIndexPath.row)
    }

    public func firstIndex(of keySectionItem: CollectionViewSectionItem) -> Int? {
        sectionItems.firstIndex { sectionItem in
            sectionItem === keySectionItem
        }
    }

    public func forEachCellItem(actionHandler: (Int, CollectionViewCellItem) -> Void) {
        sectionItems.forEach { sectionItem in
            sectionItem.cellItems.enumerated().forEach(actionHandler)
        }
    }
}
