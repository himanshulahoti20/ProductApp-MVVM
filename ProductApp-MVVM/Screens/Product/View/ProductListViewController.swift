//
//  ProductListViewController.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import UIKit

class ProductListViewController: UIViewController {
    
    
    private var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

extension ProductListViewController {
    
    func configuration(){
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
                print(self.viewModel.products)
            case .error(let error):
                print(error)
            }
        }
    }
}
