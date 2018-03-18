//
//  ShopTypeModel.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 18/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import Foundation
import UIKit

struct ShopType {
    var title : String
}

class ViewShopTypeItem {
    private var item : ShopType
    var isSelected = true
    var title : String {
        return item.title
    }
    
    init(item : ShopType) {
        self.item = item
    }
}

class ViewShopType {
    var items = [ViewShopTypeItem]()
    
    var selectedItems: [ViewShopTypeItem] {
        return items.filter { return $0.isSelected }
    }
    
    init() {
        items = dataArray.map({ ViewShopTypeItem(item: $0) })
    }
    
    let dataArray = [
        ShopType(title: "Gold Merchant"),
        ShopType(title: "Official Store")]
}






