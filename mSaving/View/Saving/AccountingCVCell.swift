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

    func initAccountCVCell(accounting: AccountingWithDate) {
        
        guard let category = accounting.accounting.expenseSubCategory,
            let iconName = category.iconName,
            let color = category.color else { return }
        
        accountingCategoryImageView.image = UIImage(named: iconName)
        
        accountingCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
        accountingCategoryNameLabel.text = category.name
        
        accountingAccountNameLabel.text = accounting.accounting.accountName?.name
        
        accountingAmountLabel.text = String(accounting.accounting.amount)
        
    }

    @IBAction func goToAccountDetail(_ sender: UIButton) {

        guard let goTo = goToAccountDetail else { return }

        goTo()

    }

}
