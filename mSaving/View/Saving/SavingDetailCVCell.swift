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
    
    @IBOutlet weak var categoryBudgetView: UIView!
    
    @IBOutlet weak var categorySpendView: UIView!
    
    var showSavingDetail: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()
        
        categoryImageView.image?.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.tintColor = .darkText

    }
    
    func initSavingDetailCVCell(budget: Int64, totalSpend: Int, imageName: String, categoryName: String, hex: String) {
        
        categorySpendView.frame = CGRect(x: 0, y: 0, width: 0, height: categoryBudgetView.frame.height)
        
        categoryImageView.image = UIImage(named: imageName)
        
        categoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        categorySpendView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        categoryImageView.image?.withRenderingMode(.alwaysTemplate)
        
        categoryImageView.tintColor = .darkText
        
//        categoryBudgetView.backgroundColor = UIColor.hexStringToUIColor(hex: hex).withAlphaComponent(0.6)
        
        categoryNameLabel.text = categoryName + "預算"
        
        categoryBudgetLabel.text = "-$" + String(totalSpend.formattedWithSeparator) + "  /  " + "$" + String(Int(budget).formattedWithSeparator)
        
        if budget != 0 {
            
            if totalSpend > budget {
                
                categorySpendView.frame = CGRect(x: 0, y: 0,
                                                 width: categoryBudgetView.frame.width * 1,
                                                 height: categoryBudgetView.frame.height)
                
            } else {
                
                categorySpendView.frame = CGRect(x: 0, y: 0,
                                                 width: categoryBudgetView.frame.width * CGFloat(Double(totalSpend) / Double(budget)),
                                                 height: categoryBudgetView.frame.height)
                
            }
            
        }
        
    }

    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {

        showSavingDetail?()

    }

}
