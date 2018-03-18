//
//  ProductsViewController.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCell"

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    private var loadMoreData = false
    private var startPos = 10
    private var filteredRequest : RequestProductItem?
    private var isFilteredUrl = false
    var products : [Product] = []

    // ==============================================
    // MARK: - Life Cycle
    // ==============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // default first request
        beginLoadProduct(request: firstRequestProduct()) {
            self.collectionView.reloadData()
        }

        view.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        filterButton.addTarget(self, action: #selector(self.goToFilter), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.title = "Products"
        
        if isFilteredUrl == true {
            collectionView.scrollsToTop = true
            collectionView.reloadData()
        }
    }
    
    // ==============================================
    // MARK: - Request Management
    // ==============================================
    
    // default first request when app first launc
    func firstRequestProduct() -> RequestProductItem {
        let priceRange = PriceRange(pMin: "100", pMax: "10000000")
        let position = ProductPosition(startPosition: "0", rows: "10")
        return RequestProductItem(priceRange: priceRange, productPos: position, wholeSale: true, official: true)
    }
    
    // default request for each 10 rows scrolled
    func customRequestProduct(start: String) -> RequestProductItem {
        let priceRange = PriceRange(pMin: "100", pMax: "10000000")
        let position = ProductPosition(startPosition: start, rows: "10")
        return RequestProductItem(priceRange: priceRange, productPos: position, wholeSale: true, official: true)
    }
    
    // base request product for custom request parameter
    func beginLoadProduct(request: RequestProductItem, completed: @escaping () -> ()) {
        print("\n \(request.configuredURL()) \n")
        Product.loadProduct(request: request) { (results: [Product]) in
            for result in results {
                self.products.append(result)
            }
            DispatchQueue.main.async {
                completed()
            }
        }
    }

    // ==============================================
    // MARK: - Actions
    // ==============================================
    @objc func goToFilter() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FILTER_VC") as? FilterViewController {
            if let navigator = navigationController {
                vc.filterDelegate = self
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
}

// ==============================================
// MARK: - Collection View Data Source
// ==============================================
extension ProductsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let productCell = cell as? ProductViewCell {
            productCell.products = self.products[indexPath.item]
        }
        return cell
    }
}

// ==============================================
// MARK: - Flow Layout Delegate
// ==============================================
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // set the column to 2
        return CGSize(width: (view.bounds.width / 2) - 20, height: 200)
    }
}

// ==============================================
// MARK: - Collection View Delegate
// ==============================================
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == products.count - 1 {
            print("\n\n begin load more data at start index : \(startPos) \n")
            if isFilteredUrl == false {
                beginLoadProduct(request: customRequestProduct(start: "\(startPos)"), completed: {
                    self.collectionView.reloadData()
                })
            }
            else if isFilteredUrl == true {
                if let notNilFilteredRequest = filteredRequest {
                    notNilFilteredRequest.productPos.startPosition = "\(startPos)"
                    beginLoadProduct(request: notNilFilteredRequest, completed: {
                        self.collectionView.reloadData()
                    })
                }
            }
            startPos = startPos + 10
        }
    }
}

// ==============================================
// MARK: - Filter Product Delegate
// ==============================================
extension ProductsViewController: FilterProductDelegate {
    func getFilterParameterRequest(request: RequestProductItem, products: [Product]) {
        filteredRequest = request
        isFilteredUrl = true
        self.products.removeAll()
        self.products = products
        startPos = 0
    }
}
















