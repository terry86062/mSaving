//
//  CategorySelectCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

protocol CategorySelectCVCellDelegate: AnyObject {
    
    func touchCategory(expense: ExpenseCategory?)
    
}

class CategorySelectCVCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    weak var delegate: CategorySelectCVCellDelegate?
    
    var expense: ExpenseCategory?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initCategorySelectCVCell(expense: ExpenseCategory?, delegate: CategorySelectCVCellDelegate?) {
        
        self.delegate = delegate
        
        self.expense = expense
        
        guard let iconName = expense?.iconName, let color = expense?.color,
              let name = expense?.name else { return }

        categoryImageView.image = UIImage(named: iconName)
        
        categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)

        categoryNameLabel.text = name

    }

    @IBAction func selectCategory(_ sender: UIButton) {
        
        delegate?.touchCategory(expense: expense)

    }

}
