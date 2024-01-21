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
    func fetchData(completion: @escaping ([Product]?, Error?) -> Void) {
        AF.request(Constants.API.productURL, method: .get).response { response in
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
    func parseJSONData(jsonData: Data) -> [Product]? {
        do {
            let products = try JSONDecoder().decode([Product].self, from: jsonData)
            return products
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        AF.request(Constants.API.loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func signUpUser(parameters: [String: Any], completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(Constants.API.signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
