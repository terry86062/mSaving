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
    
    @IBOutlet weak var budgetProgressView: UIView!
    
    @IBOutlet weak var spendPercentView: UIView!
    
    var touchMainSaving: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initSavingGoalCVCell(budget: Int64, totalSpend: Int) {
        
        spendPercentView.frame = CGRect(x: 0, y: 0, width: 0, height: budgetProgressView.frame.height)
        
        budgetLabel.text = "-$" + String(totalSpend.formattedWithSeparator) + "  /  " + "$" + String(Int(budget).formattedWithSeparator)
        
        if budget != 0 {
            
            if totalSpend > budget {
                
                spendPercentView.frame = CGRect(x: 0, y: 0,
                                                width: budgetProgressView.frame.width * 1,
                                                height: budgetProgressView.frame.height)
                
            } else {
                
                spendPercentView.frame = CGRect(x: 0, y: 0,
                                                width: budgetProgressView.frame.width * CGFloat(Double(totalSpend) / Double(budget)),
                                                height: budgetProgressView.frame.height)
                
            }
            
        }
        
    }

    @IBAction func touchMainSaving(_ sender: UIButton) {

        touchMainSaving?()

    }

}
