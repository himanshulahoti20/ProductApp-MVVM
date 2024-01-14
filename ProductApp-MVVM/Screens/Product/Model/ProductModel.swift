//
//  Product.swift
//  ProductApp_MVVM
//
//  Created by Himanshu Lahoti on 13/01/24.
//

import Foundation

// MARK: - ProductModel
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rate
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}
