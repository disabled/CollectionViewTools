//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

/// `CollectionViewDiffCellItem` is a composition of `CollectionViewCellItem` and `DiffItem`.
/// Use it to create new cell items or just conform `DiffItem` protocol in your existing cell items.
public typealias CollectionViewDiffCellItem = CollectionViewCellItem & DiffItem
