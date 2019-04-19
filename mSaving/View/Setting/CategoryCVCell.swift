//
//  CategoryCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var trailingLabel: UILabel!
    
    var goToSetCategory: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initCategoryCVCell(categoryAccountingMonthTotal: CategoryAccountingMonthTotal) {
        
        let category = categoryAccountingMonthTotal.expenseCategory
        
        guard let iconName = category.iconName, let color = category.color else { return }
            
        categoryImageView.image = UIImage(named: iconName)
        
        categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
        categoryNameLabel.text = category.name
        
        trailingLabel.text = "-\(categoryAccountingMonthTotal.amount)"
        
    }

    @IBAction func goToSetCategory(_ sender: UIButton) {

        guard let goTo = goToSetCategory else { return }

        goTo()

    }

}
