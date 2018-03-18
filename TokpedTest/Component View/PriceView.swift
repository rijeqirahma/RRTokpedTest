//
//  PriceView.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

class PriceView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let nibName = "PriceView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addBorders(edges: .bottom, color: .lightGray, thickness: 1)
    }
    
    func setTextAlignment(align: NSTextAlignment) {
        titleLabel.textAlignment = align
        priceLabel.textAlignment = align
    }
}

