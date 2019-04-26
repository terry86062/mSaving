//
//  AccountingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountingCVCell: UICollectionViewCell {
    
    @IBOutlet weak var accountingCategoryImageView: UIImageView!
    
    @IBOutlet weak var accountingCategoryNameLabel: UILabel!
    
    @IBOutlet weak var accountingAccountNameLabel: UILabel!
    
    @IBOutlet weak var accountingAmountLabel: UILabel!
    
    var goToAccountDetail: (() -> Void)?
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountCVCell(accounting: Accounting) {
        
        if let category = accounting.expenseCategory,
            let iconName = category.iconName,
            let color = category.color {
            
            accountingCategoryImageView.image = UIImage(named: iconName)
            
            accountingCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            accountingCategoryNameLabel.text = category.name
            
            accountingAccountNameLabel.text = accounting.accountName?.name
            
            accountingAmountLabel.text = "-\(accounting.amount)"
            
        } else if let category = accounting.incomeCategory,
            let iconName = category.iconName,
            let color = category.color {
            
            accountingCategoryImageView.image = UIImage(named: iconName)
            
            accountingCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            accountingCategoryNameLabel.text = category.name
            
            accountingAccountNameLabel.text = accounting.accountName?.name
            
            accountingAmountLabel.text = String(accounting.amount)
            
        }
        
    }

    @IBAction func goToAccountDetail(_ sender: UIButton) {

        goToAccountDetail?()

    }

}
