//
//  Product.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 18/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import Foundation
import UIKit

struct Product {
    var name: String
    var price: String
    var imageURL: String

    enum SerializationError : Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else { throw
            SerializationError.missing("Product name is missing")
        }
        guard let price = json["price"] as? String else { throw
            SerializationError.missing("Product price is missing")
        }
        guard let imageURL = json["image_uri_700"] as? String else { throw
            SerializationError.missing("Product image is missing")
        }
        self.name = name
        self.price = price
        self.imageURL = imageURL
    }
    
    static func loadProduct(request: RequestProductItem, completion: @escaping ([Product]) -> ()) {
        
        let url = request.configuredURL()
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var productArray: [Product] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let productData = json["data"] as? [[String: Any]] {
                            for dataPoint in productData {
                                if let productObject = try? Product(json: dataPoint) {
                                    productArray.append(productObject)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(productArray)
            }
        }
        task.resume()
    }
}





























