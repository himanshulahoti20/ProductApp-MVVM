//
//  LoginViewModel.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 16/01/24.
//

import Foundation
import UIKit
import Alamofire

final class LoginViewModel {
    
    var eventHandler : ((_ event: Event) -> Void)?  // Data Binding Method
    
    func loginUser(email: String, password: String,viewController:UIViewController) {
        self.eventHandler?(.loading)
        APIManager.shared.loginUser(email: email, password: password) { result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                self.eventHandler?(.dataLoaded)
                // Handle success and parse the response data
                print("Login successful. Response data: \(String(data: data, encoding: .utf8) ?? "")")
            case .failure(let error):
                self.eventHandler?(.error(error))
                // Handle error
                if let response = error as? AFError, let statusCode = response.responseCode {
                    switch statusCode {
                    case 400...401:
                        // Unauthorized
                        self.showAlert(title: "Unauthorized", message: "Please create an account.", viewController: viewController)
                    case 500:
                        // Internal Server Error
                        self.showAlert(title: "Internal Server Error", message: "Please try again later.", viewController: viewController)
                    default:
                        // Handle other status codes if needed
                        break
                    }
                } else {
                    // Handle other general errors
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
extension LoginViewModel{
    
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    private func showAlert(title: String, message: String, viewController: UIViewController) {
        // Use UIAlertController or any other method to show an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert using the provided view controller
        viewController.present(alert, animated: true, completion: nil)
    }
}
