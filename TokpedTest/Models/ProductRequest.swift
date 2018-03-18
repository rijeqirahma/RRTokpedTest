//
//  ProductRequest.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 18/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import Foundation

//example :   "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=10"
let baseURL = "https://ace.tokopedia.com/search/v2.5/product?q=samsung"

struct PriceRange {
    var pMin : String
    var pMax : String
}

struct ProductPosition {
    var startPosition : String
    var rows : String
}

class RequestProductItem {
    var priceRange : PriceRange
    var productPos : ProductPosition
    var isWholeSale = true
    var isOfficial = true
    var goldSeller = "2"
    
    var pMin : String { return "&pmin=" + priceRange.pMin }
    var pMax : String { return "&pmax=" + priceRange.pMax }
    var startPos : String { return "&start=" + productPos.startPosition }
    var rows : String { return "&rows=" + productPos.rows }
    
    init(priceRange : PriceRange, productPos: ProductPosition, wholeSale: Bool, official: Bool) {
        self.priceRange = priceRange
        self.productPos = productPos
        self.isWholeSale = wholeSale
        self.isOfficial = official
    }
    
    func configuredURL() -> String {
        var wholeSaleUrl = ""
        var officialUrl = ""
        let fShopUrl = "&fshop=" + goldSeller
        
        switch isWholeSale {
        case true : wholeSaleUrl = "&wholesale=true"
        case false : wholeSaleUrl = "&wholesale=false"
        }
        
        switch isOfficial {
        case true : officialUrl = "&official=true"
        case false : officialUrl = "&official=false"
        }
        
        return baseURL + pMin + pMax + wholeSaleUrl + officialUrl + fShopUrl + startPos + rows
    }
}























