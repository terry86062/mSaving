//
//  CategorySelectCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategorySelectCVCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!

    @IBOutlet weak var categoryNameLabel: UILabel!

    var selectCategory: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initCategorySelectCVCell(imageName: String, categoryName: String, hex: String) {

        categoryImageView.image = UIImage(named: imageName)
        
        categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)

        categoryNameLabel.text = categoryName

    }

    @IBAction func selectCategory(_ sender: UIButton) {

        selectCategory?()

    }

}
