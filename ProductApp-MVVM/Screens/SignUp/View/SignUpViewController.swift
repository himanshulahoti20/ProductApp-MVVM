//
//  SignUpViewController.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 16/01/24.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    private var viewModel = SignUpViewModel()
    var currentLatitude: Double?
       var currentLongitude: Double?
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtStreetNumber: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationDelegateMethods()
        setupTextFieldDelegateMethods()
    }
    
    
    // MARK: - Actions
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        guard let _ = txtFirstName.text,
              let _ = txtLastName.text,
              let _ = txtEmail.text,
              let _ = txtUserName.text,
              let _ = txtPassword.text,
              let _ = txtPhone.text,
              let _ = txtCity.text,
              let _ = txtStreet.text,
              let _ = txtStreetNumber.text,
              let _ = txtZipCode.text,
              let _ = txtCurrentLocation.text else {
            // Handle the case where any of the required text fields are empty
            showAlert(title: "Error", message: "Please enter all the required fields.")
            return
        }
        configuration()
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate{
    func setupTextFieldDelegateMethods() {
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtCity.delegate = self
        self.txtEmail.delegate = self
        self.txtPhone.delegate = self
        self.txtStreet.delegate = self
        self.txtPassword.delegate = self
        self.txtZipCode.delegate = self
        self.txtUserName.delegate = self
        self.txtStreetNumber.delegate = self
        self.txtCurrentLocation.delegate = self
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - CLLocationManagerDelegate

extension SignUpViewController: CLLocationManagerDelegate {
    
    func setupLocationDelegateMethods() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Access the user's current location here (e.g., location.coordinate)
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            currentLatitude = location.coordinate.latitude
                        currentLongitude = location.coordinate.longitude
            txtCurrentLocation.text = "\(currentLatitude ?? 0.0)" + "," + "\(currentLongitude ?? 0.0)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension SignUpViewController {
    
    func configuration(){
        initViewModel()
        observeEvent()
    }
    
    func initViewModel() {
        guard let firstName = txtFirstName.text, !firstName.isEmpty,
              let lastName = txtLastName.text, !lastName.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let userName = txtUserName.text, !userName.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let phone = txtPhone.text, !phone.isEmpty,
              let city = txtCity.text, !city.isEmpty,
              let street = txtStreet.text, !street.isEmpty,
              let streetNumber = txtStreetNumber.text, !streetNumber.isEmpty,
              let zipCode = txtZipCode.text, !zipCode.isEmpty,
              let currentLocation = txtCurrentLocation.text, !currentLocation.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all the required fields.")
            return
        }
        viewModel.signUpUser(firstName: firstName, lastName: lastName, email: email, userName: userName, password: password, phone: phone, city: city, street: street, streetNumber: streetNumber, zipCode: zipCode, currentLatitude: currentLatitude, currentLongitude: currentLongitude, viewController: self)
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
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


