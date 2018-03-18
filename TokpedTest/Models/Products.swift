//
//  Products.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit


struct HomeProducts {
    
    var title: String
    var price: String
    var image: UIImage
    
    
    init(title: String, price: String, image: UIImage) {
        self.title = title
        self.price = price
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard let title = dictionary["Caption"], let price = dictionary["Comment"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }
        self.init(title: title, price: price, image: image)
    }
    
    static func allPhotos() -> [HomeProducts] {
        var photos = [HomeProducts]()

        guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return photos
        }
        for dictionary in photosFromPlist {
            if let photo = HomeProducts(dictionary: dictionary) {
                photos.append(photo)
            }
        }
        return photos

//        var products = [Products]()
//
//        if let image = UIImage(named: "tokpedIcon") {
//
//            for i in 1...10000 {
//                let item = Products(title: "title : \(i)", price: "\(i)000", image: image)
//                products.append(item)
//            }
//        }

//        return products
    }
    
}


