//
// Copyright (c) 2018 Rosberry. All rights reserved.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {

    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.7 : 1.0
        }
    }

    // MARK: Subviews
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Life cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude,
                                             height: .greatestFiniteMagnitude))
    }
}
