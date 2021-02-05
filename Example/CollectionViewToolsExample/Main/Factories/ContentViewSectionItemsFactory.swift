//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import CollectionViewTools

protocol ContentViewCellItemFactoryOutput {
    func reloadCollectionView()
    func removeContentViewState(_ state: ContentViewState)
}

final class ContentViewSectionItemsFactory {

    typealias State = ContentViewState
    var output: ContentViewCellItemFactoryOutput?

    // MARK: - Factories

    // MARK: - ImageContent

    private(set) lazy var imageCellItemsFactory: CellItemFactory = {
        let factory: AssociatedCellItemFactory<ImageViewState, ImageCollectionViewCell> = makeContentCellItemsFactory(id: "image")
        let cellConfigurationHandler = factory.cellConfigurationHandler

        factory.cellConfigurationHandler = { cell, cellItem in
            cell.imageView.image = cellItem.object.imageContent.image
            cell.removeActionHandler = { [weak self] in
                self?.removeEventTriggered(state: cellItem.object)
            }
            cellConfigurationHandler?(cell, cellItem)
        }

        factory.sizeConfigurationHandler = { state, collectionView, sectionItem in
            let width = collectionView.bounds.width
            let aspectRatio = state.imageContent.image.size.width / state.imageContent.image.size.height
            return CGSize(width: width, height: width / aspectRatio)
        }
        return factory
    }()

    // MARK: - TextContent

    private(set) lazy var textCellItemsFactory: CellItemFactory = {
        let factory: AssociatedCellItemFactory<TextViewState, TextCollectionViewCell> = makeContentCellItemsFactory(id: "text")
        let cellConfigurationHandler = factory.cellConfigurationHandler

        factory.cellConfigurationHandler = { cell, cellItem in
            cell.titleLabel.text = cellItem.object.textContent.text
            cellConfigurationHandler?(cell, cellItem)
        }

        factory.sizeConfigurationHandler = { data, collectionView, sectionItem in
            CGSize(width: collectionView.bounds.width, height: 60)
        }
        return factory
    }()

    // MARK: - Spacer

    private(set) lazy var spacerCellItemsFactory: CellItemFactory = {
        let factory: AssociatedCellItemFactory<SpacerState, SpacerCell> = .init()

        factory.cellConfigurationHandler = { cell, _ in
            cell.spacerView.dividerHeight = 1
            cell.spacerView.backgroundColor = .gray
        }

        factory.sizeConfigurationHandler = {_, collectionView, sectionItem in
            .init(width: collectionView.bounds.inset(by: sectionItem.insets).width, height: 1)
        }
        return factory
    }()

    // MARK: - Content

    private(set) lazy var cellItemsFactory: CellItemFactory = imageCellItemsFactory.factory(byJoining: textCellItemsFactory)
                             .factory(byJoining: spacerCellItemsFactory)

    // MARK: - Description

    private(set) lazy var descriptionCellItemsFactory: CellItemFactory = {
        let factory = AssociatedCellItemFactory<ContentViewState, TextCollectionViewCell>()

        factory.cellItemConfigurationHandler = { cellItem in
           cellItem.itemDidSelectHandler = { [weak self] _ in
               cellItem.object.isExpanded.toggle()
               self?.updateEventTriggered()
           }
        }

        factory.cellConfigurationHandler = { cell, cellItem in
            cell.titleLabel.text = cellItem.object.content.description
        }

        factory.sizeConfigurationHandler = { data, collectionView, sectionItem in
            CGSize(width: collectionView.bounds.width, height: 60)
        }
        return factory
    }()

    func makeContentViewState(_ content: Content?) -> ContentViewState? {
        if let imageContent = content as? ImageContent {
            return ImageViewState(imageContent: imageContent)
        }
        if let textContent = content as? TextContent {
            return TextViewState(textContent: textContent)
        }
        return nil
    }

    // MARK: - Private

    private func makeContentCellItemsFactory<U: ContentViewState, T: UICollectionViewCell>(id: String) -> AssociatedCellItemFactory<U, T> {
        let factory = AssociatedCellItemFactory<U, T>()

        factory.cellItemConfigurationHandler = { cellItem in
            cellItem.itemDidSelectHandler = { [weak self] _ in
                cellItem.object.isExpanded.toggle()
                self?.updateEventTriggered()
            }
        }

        factory.initializationHandler = { [weak self] data in
           let cellItem = factory.makeUniversalCellItem(object: data)
           let separatorCellItem = SpacerCellItem()
           guard data.isExpanded,
                 let descriptionCellItem = self?.descriptionCellItemsFactory.makeCellItem(object: data) else {
               return [cellItem, separatorCellItem]
           }
           return [cellItem, descriptionCellItem, separatorCellItem]
        }

        factory.cellConfigurationHandler = { cell, cellItem in
            if cellItem.object.isExpanded {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.green.cgColor
            }
            else {
                cell.layer.borderWidth = 0
            }
        }
        return factory
    }

    // MARK: - Factory methods

    func makeSectionItems(contentViewStates: [ContentViewState]) -> [CollectionViewDiffSectionItem] {
        let cellItems = cellItemsFactory.makeCellItems(objects: contentViewStates)
        let sectionItem = GeneralCollectionViewDiffSectionItem(cellItems: cellItems)
        sectionItem.diffIdentifier = "Contents"
        return [sectionItem]
    }

    func removeEventTriggered(state: ContentViewState) {
        output?.removeContentViewState(state)
    }

    func updateEventTriggered() {
        output?.reloadCollectionView()
    }
}
