//
//  ProductCell.swift
//  ProductApp-MVVM
//
//  Created by Himanshu Lahoti on 14/01/24.
//

import UIKit

class ProductCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    
    var product : Product? {
        didSet{  //PRODUCT OBSERVER
            productDetailConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.clipsToBounds = false
        cellView.layer.cornerRadius = 15
        productImage.layer.cornerRadius = 10
        self.cellView.backgroundColor = .systemGray6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func productDetailConfiguration() {
        guard let product else { return }
        productName.text = product.title
        productCategory.text = product.category
        productDescription.text = product.description
        priceLabel.text = "$\(product.price)"
        rateButton.setTitle("\(product.rating.rate)", for: .normal)
        productImage.setImage(with: product.image)
    }
    
}
