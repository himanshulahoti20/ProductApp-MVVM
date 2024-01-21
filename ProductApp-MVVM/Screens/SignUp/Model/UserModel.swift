//
//  UserModel.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 16/01/24.
//

import Foundation

// MARK: - SignUpModel
class SignUpModel: Codable {
    let address: Address?
    let id: Int?
    let email, username, password: String?
    let name: Name?
    let phone: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case address, id, email, username, password, name, phone
        case v = "__v"
    }

    init(address: Address?, id: Int?, email: String?, username: String?, password: String?, name: Name?, phone: String?, v: Int?) {
        self.address = address
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.name = name
        self.phone = phone
        self.v = v
    }
}

// MARK: - Address
class Address: Codable {
    let geolocation: Geolocation?
    let city, street: String?
    let number: Int?
    let zipcode: String?

    init(geolocation: Geolocation?, city: String?, street: String?, number: Int?, zipcode: String?) {
        self.geolocation = geolocation
        self.city = city
        self.street = street
        self.number = number
        self.zipcode = zipcode
    }
}

// MARK: - Geolocation
class Geolocation: Codable {
    let lat, long: String?

    init(lat: String?, long: String?) {
        self.lat = lat
        self.long = long
    }
}

// MARK: - Name
class Name: Codable {
    let firstname, lastname: String?

    init(firstname: String?, lastname: String?) {
        self.firstname = firstname
        self.lastname = lastname
    }
}

