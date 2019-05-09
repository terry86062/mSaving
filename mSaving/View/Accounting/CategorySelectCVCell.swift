//
//  CategorySelectCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

protocol CategorySelectCVCellDelegate: AnyObject {
    
    func touchCategory(expense: ExpenseCategory?, income: IncomeCategory?)
    
}

class CategorySelectCVCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    weak var delegate: CategorySelectCVCellDelegate?
    
    var expense: ExpenseCategory?
    
    var income: IncomeCategory?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initCategorySelectCVCell(expense: ExpenseCategory?, income: IncomeCategory?, delegate: CategorySelectCVCellDelegate?) {
        
        self.delegate = delegate
        
        self.expense = expense
        
        self.income = income
        
        if expense != nil {
            
            guard let iconName = expense?.iconName, let color = expense?.color,
                let name = expense?.name else { return }
            
            categoryImageView.image = UIImage(named: iconName)
            
            categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            categoryNameLabel.text = name
            
        } else {
            
            guard let iconName = income?.iconName, let color = income?.color,
                let name = income?.name else { return }
            
            categoryImageView.image = UIImage(named: iconName)
            
            categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
            categoryNameLabel.text = name
            
        }
        
    }

    @IBAction func selectCategory(_ sender: UIButton) {
        
        delegate?.touchCategory(expense: expense, income: income)

    }

}
