//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public protocol CellItemFactory {

    /// Returns only main cellItem for provided object
    ///
    /// - Parameters:
    ///
    ///    - object: an object to create a cell item for it
    ///    - index: the index of the object in the array
    func makeCellItem(object: Any, index: Int) -> CollectionViewCellItem?

    /// Returns an array of cell items
    ///
    /// - Parameters:
    ///    - array: an array of objects to create cell items for them
    func makeCellItems(array: [Any]) -> [CollectionViewCellItem]

    /// Returns a cell items for associated object
    ///
    /// - Parameters:
    ///    - object: an object associated with cell item
    ///    - index: the position of the object in the array
    func makeCellItems(object: Any, index: Int) -> [CollectionViewCellItem]

    /// Returns a default cell item for object ignoring initialization handler
    ///
    /// - Parameters:
    ///    - object: an object associated with cell item
    func makeCellItem(object: Any) -> CollectionViewCellItem?

    /// Joins different cell item factories
    ///
    /// - Parameters:
    ///    - factory: a second cell item factory the associated type of which should be united
    @discardableResult
    func factory(byJoining factory: CellItemFactory) -> CellItemFactory

    /// Defines a unique identifier associated with a specific type of factory
    var hashKey: String? { get }
}
