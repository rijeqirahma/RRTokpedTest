//
//  ProductViewCell.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet fileprivate weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }
    
    var products : Product? {
        didSet {
            if let product = products {
                imageView.downloadedFrom(link: product.imageURL)
                title.text = product.name
                price.text = product.price
            }
        }
    }
}
