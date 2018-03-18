//
//  ShopTypeViewController.swift
//  TokpedTest
//
//  Created by syukur niyadi putra on 17/03/18.
//  Copyright © 2018 Jejul. All rights reserved.
//

import UIKit

protocol ShopTypeDelegate: class {
    func getShopType(_ types: ViewShopType)
}

class ShopTypeViewController: UIViewController {
    // STORYBOARD ID : SHOP_TYPE_VC
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var shopTypeTable: UITableView!
    @IBOutlet weak var applyButton: UIButton!

    var delegate : ShopTypeDelegate?
    var viewShopType = ViewShopType()

    // ==============================================
    // MARK: - Life Cycle
    // ==============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.addTarget(self, action: #selector(self.dismissShopTypeView), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(self.execute), for: .touchUpInside)
        
        shopTypeTable.dataSource = self
        shopTypeTable.delegate = self
        shopTypeTable.allowsMultipleSelection = true
        shopTypeTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // ==============================================
    // MARK: - Actions
    // ==============================================
    @objc func dismissShopTypeView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func reset() {
        if let selectedIndex = shopTypeTable.indexPathsForSelectedRows {
            for index in selectedIndex {
                viewShopType.items[index.row].isSelected = false
                shopTypeTable.reloadData()
            }
        }
    }
    
    @objc func execute() {
        shopTypeTable.reloadData()
        delegate?.getShopType(viewShopType)
        print(viewShopType.selectedItems.map({ $0.title }))
        navigationController?.popViewController(animated: true)
    }

}

// ==============================================
// MARK: - TableView Delegate & Datasource
// ==============================================
extension ShopTypeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewShopType.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ShopTypeCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ShopTypeTableViewCell {
            cell.item =  viewShopType.items[indexPath.row]
            
            if viewShopType.items[indexPath.row].isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewShopType.items[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewShopType.items[indexPath.row].isSelected = false
    }
}

























