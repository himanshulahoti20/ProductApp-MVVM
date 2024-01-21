//
//  SignUpViewModel.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 16/01/24.
//

import Foundation
import UIKit
import Alamofire

final class SignUpViewModel {
    
    var eventHandler : ((_ event: Event) -> Void)?  // Data Binding Method
    
    func signUpUser(firstName: String,lastName: String,email: String,userName: String,password: String,phone: String,city: String,street: String,streetNumber: String,zipCode: String,currentLatitude: Double?, currentLongitude: Double?,viewController: UIViewController) {
        
        let parameters: [String: Any] = [
            "email": email,
            "username": userName,
            "password": password,
            "name": [
                "firstname": firstName,
                "lastname": lastName
            ],
            "address": [
                "city": city,
                "street": street,
                "number": streetNumber,
                "zipcode": zipCode,
                "geolocation": [
                    "lat": "\(currentLatitude ?? 0.0)",
                    "long": "\(currentLongitude ?? 0.0)"
                ]
            ],
            "phone": phone
        ]
        
        self.eventHandler?(.loading)
        APIManager.shared.signUpUser(parameters: parameters) { result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                self.eventHandler?(.dataLoaded)
                // Handle success and parse the response data
                print("SignUp successful. Response data: \(String(data: data, encoding: .utf8) ?? "")")
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
                    
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
extension SignUpViewModel{
    
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
