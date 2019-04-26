//
//  SavingGoalCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingGoalCVCell: UICollectionViewCell {
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var spendLabel: UILabel!
    
    @IBOutlet weak var budgetProgressView: UIView!
    
    @IBOutlet weak var spendPercentView: UIView!
    
    @IBOutlet weak var spendPercentWidthConstraint: NSLayoutConstraint!
    
    var touchMainSaving: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initSavingGoalCVCell(budget: Int64, totalSpend: Int) {
        
        budgetLabel.text = "$" + String(budget)
        
        spendLabel.text = "-$" + String(totalSpend)
        
        if spendPercentWidthConstraint != nil {

            spendPercentWidthConstraint.isActive = false

        }
        
        if budget != 0 {
            
            NSLayoutConstraint(item: spendPercentView as Any, attribute: .width, relatedBy: .equal,
                               toItem: budgetProgressView, attribute: .width,
                               multiplier: CGFloat(Double(totalSpend) / Double(budget)), constant: 0).isActive = true
            
        }
        
    }

    @IBAction func touchMainSaving(_ sender: UIButton) {

        touchMainSaving?()

    }

}
