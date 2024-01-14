//
//  ProductViewModel.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import Foundation

final class ProductViewModel {
    
    
    var products : [Product] = []
    var eventHandler : ((_ event: Event) -> Void)?  // Data Binding Method
    
    
    func fetchProducts() {
        self.eventHandler?(.loading)
        APIManager.shared.fetchData { (products, error) in
            self.eventHandler?(.stopLoading)
            if let error = error {
                self.eventHandler?(.error(error))
                print("Error fetching data: \(error)")
                return
            }
            if let products = products {
                self.products = products
                self.eventHandler?(.dataLoaded)
                // Use the parsed data as needed
                for product in products {
                    print("Product Title: \(product.title)")
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
