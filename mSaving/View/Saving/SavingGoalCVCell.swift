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
    
    var showSavingDetail: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initSavingGoalCVCell(budget: Int64, totalSpend: Int) {
        
        budgetLabel.text = "$" + String(budget)
        
        spendPercentView.isHidden = false
        
        if spendPercentWidthConstraint != nil {
            
            spendPercentWidthConstraint.isActive = false
            
        }
        
        if budget != 0 {
            
            NSLayoutConstraint(item: spendPercentView as Any, attribute: .width, relatedBy: .equal,
                               toItem: budgetProgressView, attribute: .width, multiplier: CGFloat(Double(totalSpend) / Double(budget)), constant: 0).isActive = true
            
        }
        
        spendLabel.text = "-$" + String(totalSpend)
        
    }

    @IBAction func showSavingDetail(_ sender: UIButton) {

        guard let show = showSavingDetail else { return }

        show()

    }

}
