//
//  CategoryCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    @IBOutlet private weak var categoryNameLabel: UILabel!
    
    @IBOutlet private weak var trailingLabel: UILabel!
    
    var touchCategoryHandler: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initCategoryCVCell(categoryMonthTotal: CategoryMonthTotal, isIncome: Bool) {
        
        if isIncome {
            
            let category = categoryMonthTotal.accountings[0][0].incomeCategory
            
            guard let iconName = category?.iconName, let color = category?.color else { return }
            
            categoryImageView.image = UIImage(named: iconName)
            
            categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            categoryNameLabel.text = category?.name
            
            trailingLabel.text = "\(categoryMonthTotal.amount)"
            
        } else {
            
            let category = categoryMonthTotal.accountings[0][0].expenseCategory
            
            guard let iconName = category?.iconName, let color = category?.color else { return }
            
            categoryImageView.image = UIImage(named: iconName)
            
            categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            categoryNameLabel.text = category?.name
            
            trailingLabel.text = "-\(categoryMonthTotal.amount)"
            
        }
        
    }

    @IBAction private func touchCategory(_ sender: UIButton) {

        touchCategoryHandler?()

    }

}
