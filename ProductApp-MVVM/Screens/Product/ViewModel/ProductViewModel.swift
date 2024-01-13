//
//  ProductViewModel.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import Foundation

final class ProductViewModel {
    
    
    var products : [ProductModel] = []
    var eventHandler : ((_ event: Event) -> Void)?  // Data Binding Method
    
    
    func fetchProducts() {
        APIManager.shared.fetchData { (products, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let products = products {
                // Use the parsed data as needed
                for product in products {
                    print("Product Title: \(String(describing: product.title))")
                }
            }
        }
    }
}
extension ProductViewModel{
    
    
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
