//
//  ProductListViewController.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productTableView : UITableView!
    
    private var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

extension ProductListViewController {
    
    func configuration(){
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvent()
    }
    
    func initViewModel() {
        viewModel.fetchProducts()
    }
    
    // Data Binding event observe will make the communication happen
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .loading : break
            case .stopLoading : break
            case .dataLoaded :
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                }
                print(self.viewModel.products)
            case .error(let error):
                print(error as Any)
            }
        }
    }
}

extension ProductListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
    
    
    
}
