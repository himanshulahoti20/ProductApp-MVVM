import Foundation
import UIKit
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {
        startListeningForNetworkReachability()
    }
    
    // Start listening for network reachability changes
    private func startListeningForNetworkReachability() {
        reachabilityManager?.startListening { status in
            switch status {
            case .reachable, .unknown:
                print("Network is reachable")
            case .notReachable:
                print("Network is not reachable")
            }
        }
    }
    
    // Function to make API request
    func fetchData(completion: @escaping ([Product]?, Error?) -> Void) {
        guard reachabilityManager?.isReachable ?? false else {
            completion(nil, NSError(domain: "No network connection", code: -1, userInfo: nil))
            return
        }

        AF.request(Constants.API.productURL, method: .get).response { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data {
                    let products = self.parseJSONData(jsonData: jsonData)
                    completion(products, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid data", code: -1, userInfo: nil))
                }
            case .failure(let error):
                self.handleAPIError(error)
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
        guard reachabilityManager?.isReachable ?? false else {
            completion(.failure(NSError(domain: "No network connection", code: -1, userInfo: nil)))
            return
        }
        
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
                    self.handleAPIError(error)
                    completion(.failure(error))
                }
            }
    }
    
    func signUpUser(parameters: [String: Any], completion: @escaping (Result<Data, AFError>) -> Void) {
        guard reachabilityManager?.isReachable ?? false else {
            completion(.failure(AFError.invalidURL(url: "")))
            return
        }
        
        AF.request(Constants.API.signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    self.handleAPIError(error)
                    completion(.failure(error))
                }
            }
    }
    
    // Handle API errors
    private func handleAPIError(_ error: Error) {
        if let afError = error as? AFError {
            switch afError {
            case .sessionTaskFailed(let sessionError):
                // Check for network-related errors
                if let urlError = sessionError as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        showAlert(title: "Network Error", message: "The internet connection appears to be offline.")
                    case .timedOut:
                        showAlert(title: "Network Error", message: "The request timed out. Please try again.")
                    default:
                        // Handle other network-related errors if needed
                        showAlert(title: "Network Error", message: "An error occurred. Please check your internet connection.")
                    }
                }
            default:
                // Handle other AFError cases if needed
                showAlert(title: "Error", message: error.localizedDescription)
            }
        } else {
            // Handle other general errors
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // Show alert function
    // Show alert function
    private func showAlert(title: String, message: String) {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
