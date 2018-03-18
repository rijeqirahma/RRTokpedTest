//
//  FooterView.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 18/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

class FooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 235/255)
    }

}
