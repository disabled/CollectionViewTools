//
//  ColorCellItem.swift
//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import CollectionViewTools
import Foundation

final class ColorCellItem: CollectionViewDiffCellItem, CustomStringConvertible {

    typealias Cell = ColorCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private var color: UIColor
    private var title: String

    init(color: UIColor, title: String) {
        self.color = color
        self.title = title
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.contentView.backgroundColor = color
        cell.label.text = title
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        let numberOfItemsInRow: CGFloat = 5
        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
            sectionItem.minimumInteritemSpacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow
        return .init(width: width, height: width)
    }

    // MARK: - CollectionViewDiffableItem

    var diffIdentifier: String = ""

    func isEqual(to item: DiffItem) -> Bool {
        guard let item = item as? ColorCellItem else {
            return false
        }
        return color == item.color
            && title == item.title
    }

    // MARK: - CustomStringConvertible

    var description: String {
        let colorString = "\(color)".replacingOccurrences(of: "UIExtendedSRGBColorSpace ", with: "")
        return "\n cellItem id = \(diffIdentifier), color = \(colorString), title = \(title)"
    }
}
