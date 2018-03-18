//
//  FilterViewController.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

// protocol to send filtered URL and it's first response
protocol FilterProductDelegate {
    func getFilterParameterRequest(request: RequestProductItem, products: [Product])
}

class FilterViewController: UIViewController {
    // STORYBOARD ID : FILTER_VC

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var minPriceView: PriceView!
    @IBOutlet weak var maxPriceView: PriceView!
    @IBOutlet weak var priceSlider: UIView!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet weak var shopTypeButton: ButtonWithImage!
    @IBOutlet var tagListView: TaglistCollection!
    @IBOutlet var closeButton: CloseButton!
    @IBOutlet weak var applyButton: UIButton!
    

    var viewShopType = ViewShopType()
    var filterDelegate : FilterProductDelegate?
    var products : [Product] = []
    
    // request properties
    private var priceRange = PriceRange(pMin: "100", pMax: "10000000")
    private var position = ProductPosition(startPosition: "0", rows: "10")
    
    // ==============================================
    // MARK: - Life Cycle
    // ==============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.addTarget(self, action: #selector(self.dismissFilter), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        shopTypeButton.addTarget(self, action: #selector(self.toShopTypeList), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(self.validateAllFilter), for: .touchUpInside)

        minPriceView.titleLabel.text = "Minimum Price"
        minPriceView.setTextAlignment(align: .left)
        maxPriceView.titleLabel.text = "Maximum Price"
        maxPriceView.setTextAlignment(align: .right)
        
        configurePriceSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setupTaglistView()
    }
    
    // ==============================================
    // MARK: - Appearances
    // ==============================================
    private func configurePriceSlider() {
        let sliderView = NHRangeSliderView(frame: CGRect(x: 0, y: 0, width: priceSlider.frame.size.width, height: 40) )
        sliderView.delegate = self
        sliderView.titleLabel?.isHidden = true
        sliderView.lowerLabel?.isHidden = true
        sliderView.upperLabel?.isHidden = true
        sliderView.trackHighlightTintColor = UIColor(red: 119/255, green: 185/255, blue: 97/255, alpha: 1)
        sliderView.stepValue = 100000
        sliderView.lowerValue = 100
        sliderView.upperValue = 10000000
        sliderView.sizeToFit()
        sliderView.tag = 1
        priceSlider.addSubview(sliderView)
        
        minPriceView.priceLabel.text = "\(sliderView.lowerValue)".setAsAmountFormat(symbol: "Rp ")
        maxPriceView.priceLabel.text = "\(sliderView.upperValue)".setAsAmountFormat(symbol: "Rp ")
    }
    
    func setupTaglistView() {
        tagListView.setupTagCollection()
        tagListView.delegate = self
        
        if tagListView.tagNames != [] {
            tagListView.removeAllTags()
        }
        
        for item in viewShopType.items {
            if item.isSelected {
                tagListView.appendTag(tagName: item.title)
            }
        }
        tagListView.collectionView.reloadData()
        tagListView.textFont = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
    }

    // ==============================================
    // MARK: - Actions
    // ==============================================
    @objc func dismissFilter() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func reset() {
        guard let oldSlider = priceSlider.viewWithTag(1) else {
            return
        }
        oldSlider.removeFromSuperview()
        configurePriceSlider()
        wholeSaleSwitch.isOn = true
        for item in viewShopType.items {
            item.isSelected = true
        }
        priceRange.pMin = "100"
        priceRange.pMax = "10000000"
        setupTaglistView()
    }
    
    @objc func toShopTypeList() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SHOP_TYPE_VC") as? ShopTypeViewController {
            if let navigator = navigationController {
                vc.delegate = self
                vc.viewShopType = self.viewShopType
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func validateAllFilter() {
        
        var isWholeSale = false
        if wholeSaleSwitch.isOn {
            isWholeSale = true
        } else {
            isWholeSale = false
        }
        
        var isOfficialStore = false
        if tagListView.tagNames != [] {
            for category in tagListView.tagNames {
                if category == viewShopType.dataArray[1].title {
                    isOfficialStore = true
                }
            }
        }
        let request = RequestProductItem(priceRange: priceRange, productPos: position, wholeSale: isWholeSale, official: isOfficialStore)
        print("\n FILTERED URL : \n \(request.configuredURL()) \n")
        
        beginLoadProduct(request: request) {
            self.filterDelegate?.getFilterParameterRequest(request: request, products: self.products)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
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
}

// ==============================================
// MARK: - Price Slider View Delegate
// ==============================================
extension FilterViewController : NHRangeSliderViewDelegate {
    func sliderValueChanged(slider: NHRangeSlider?) {
        guard let minVal = slider?.lowerValue, let maxVal = slider?.upperValue else {
            return
        }
        priceRange.pMin = "\(Int(minVal))"
        priceRange.pMax = "\(Int(maxVal))"
        minPriceView.priceLabel.text = "\(minVal)".setAsAmountFormat(symbol: "Rp ")
        maxPriceView.priceLabel.text = "\(maxVal)".setAsAmountFormat(symbol: "Rp ")
    }
}

// ==============================================
// MARK: - Shop Type Tag View Delegate
// ==============================================
extension FilterViewController : TagViewDelegate {
    func didRemoveTag(_ indexPath: IndexPath) {
        print("RemoveIndexPath==\(indexPath)")
        viewShopType.items[indexPath.item].isSelected = false
    }
    
    func didTaponTag(_ indexPath: IndexPath) {
        print("Tag tapped: \(self.viewShopType.items[indexPath.item])")
    }
}

// ==============================================
// MARK: - ShopType Delegate
// ==============================================
extension FilterViewController : ShopTypeDelegate {
    func getShopType(_ types: ViewShopType) {
        viewShopType = types
    }
}












