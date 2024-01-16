//
//  LoginViewController.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 16/01/24.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    private var viewModel = LoginViewModel()
    
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
       // MARK: - Actions
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty,
                  let password = txtPassword.text, !password.isEmpty else {
                showAlert(title: "Error", message: "Please enter both email and password.")
                return
            }
            configuration()
        }
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
    }
}

extension LoginViewController {
    
    func configuration(){
        initViewModel()
        observeEvent()
    }
    
    func initViewModel() {
            guard let email = txtEmail.text, let password = txtPassword.text else {
                print("Invalid email or password")
                return
            }

        viewModel.loginUser(email: email, password: password, viewController: self)
        }
    
    // Data Binding event observe will make the communication happen
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard self != nil else { return }
            
            switch event {
            case .loading : break
            case .stopLoading : break
            case .dataLoaded : break
            case .error(let error):
                print(error as Any)
            }
        }
    }

    func handleHTTPStatusCode(_ error: Error?) {
            if let afError = error as? AFError, let statusCode = afError.responseCode {
                switch statusCode {
                case 401:
                    showAlert(title: "Unauthorized", message: "You are not registered. Please create an account.")
                case 500:
                    showAlert(title: "Internal Server Error", message: "Something went wrong on the server. Please try again later.")
                default:
                    showAlert(title: "Error", message: "An unexpected error occurred. Please try again.")
                }
            } else {
                showAlert(title: "Error", message: "An unexpected error occurred. Please try again.")
            }
        }

        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
