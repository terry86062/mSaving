//
//  SavingDetailCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingDetailCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var categoryBudgetLabel: UILabel!
    
    @IBOutlet weak var categorySpendLabel: UILabel!
    
    @IBOutlet weak var categoryBudgetView: UIView!
    
    @IBOutlet weak var categorySpendView: UIView!
    
    @IBOutlet weak var categorySpendViewConstraint: NSLayoutConstraint!
    
    var showSavingDetailAdd: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initSavingDetailCVCell(budget: Int64, totalSpend: Int, imageName: String, subCategoryName: String, hex: String) {
        
        categoryImageView.image = UIImage(named: imageName)
        
        categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        categoryNameLabel.text = subCategoryName + "預算"
        
        categoryBudgetLabel.text = "$" + String(budget)
        
        categorySpendView.isHidden = false
        
        if categorySpendViewConstraint != nil {
            
            categorySpendViewConstraint.isActive = false
            
        }
        
        if budget != 0 {
            
            NSLayoutConstraint(item: categorySpendView as Any, attribute: .width, relatedBy: .equal,
                               toItem: categoryBudgetView, attribute: .width, multiplier: CGFloat(Double(totalSpend) / Double(budget)), constant: 0).isActive = true
            
        }
        
        categorySpendLabel.text = "-$" + String(totalSpend)
        
    }

    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {

        guard let show = showSavingDetailAdd else { return }

        show()

    }

}
