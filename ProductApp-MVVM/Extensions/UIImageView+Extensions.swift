//
//  UIImageView+Extensions.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 14/01/24.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
