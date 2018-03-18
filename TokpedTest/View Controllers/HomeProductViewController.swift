//
//  HomeProductViewController.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 16/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCell"

class HomeProductViewController: UICollectionViewController {
    
    var products = Products.allPhotos()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.addSubview(addFilterButton())

        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        
        
        // set the product layout delegate
        if let layout = collectionView?.collectionViewLayout as? ProductLayout {
            layout.delegate = self
        }
    }
    
    // MARK: - Configure View
    func addFilterButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.bounds.size.width, height: 40)
        button.backgroundColor = UIColor.green
        button.setTitle("Filter", for: .normal)
        return button
    }
}

extension HomeProductViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let productCell = cell as? ProductViewCell {
            productCell.products = products[indexPath.item]
        }
        return cell
    }
}


//MARK: - PRODUCT LAYOUT DELEGATE
extension HomeProductViewController : ProductLayoutDelegate {
    // return the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return products[indexPath.item].image.size.height
    }
}

