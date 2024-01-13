//
//  APIManager.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import Foundation
import UIKit
import Alamofire

// Singelton Design Pattern


final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    
    // Function to make API request
    func fetchData(completion: @escaping ([ProductModel]?, Error?) -> Void) {
        let apiUrl = "https://fakestoreapi.com/products"
        
        AF.request(apiUrl, method: .get).response { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data {
                    // Call the parseJSONData function with the received data
                    let products = self.parseJSONData(jsonData: jsonData)
                    completion(products, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid data", code: -1, userInfo: nil))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // Function to parse JSON data
    func parseJSONData(jsonData: Data) -> [ProductModel]? {
        do {
            let products = try JSONDecoder().decode([ProductModel].self, from: jsonData)
            return products
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
