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
    
    weak var delegate: SavingCVCCellDelegate?
    
    var selectedAccounting: Accounting?
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountCVCell(accounting: Accounting, delegate: SavingCVCCellDelegate?) {
        
        if let category = accounting.expenseCategory,
            let iconName = category.iconName,
            let color = category.color {
            
            accountingCategoryImageView.image = UIImage(named: iconName)
            
            accountingCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            accountingCategoryNameLabel.text = category.name
            
            accountingAccountNameLabel.text = accounting.accountName?.name
            
            accountingAmountLabel.text = "-$\(Int(accounting.amount).formattedWithSeparator)"
            
        } else if let category = accounting.incomeCategory,
            let iconName = category.iconName,
            let color = category.color {
            
            accountingCategoryImageView.image = UIImage(named: iconName)
            
            accountingCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            accountingCategoryNameLabel.text = category.name
            
            accountingAccountNameLabel.text = accounting.accountName?.name
            
            accountingAmountLabel.text = "$\(Int(accounting.amount).formattedWithSeparator)"
            
        }
        
        selectedAccounting = accounting
        
        self.delegate = delegate
        
    }

    @IBAction func goToAccountDetail(_ sender: UIButton) {
        
        delegate?.touch?(accounting: selectedAccounting)

    }

}
