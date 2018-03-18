//
//  ButtonWithImage.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

class ButtonWithImage: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(bounds.width / 2) + (titleLabel?.frame.width)!, bottom: 0, right: 0)
        }
    }
}
