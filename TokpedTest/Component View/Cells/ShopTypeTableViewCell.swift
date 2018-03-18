//
//  ShopTypeTableViewCell.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 18/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

class ShopTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var item : ViewShopTypeItem? {
        didSet {
            titleLabel.text = item?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
