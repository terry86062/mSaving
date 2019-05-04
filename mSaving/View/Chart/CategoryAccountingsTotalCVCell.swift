//
//  CategoryAccountingsTotalCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryAccountingsTotalCVCell: UICollectionViewCell {
    
    @IBOutlet weak var totalSpendLabel: UILabel!
    
    @IBOutlet weak var highestSpendLabel: UILabel!
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initCategoryAccountingsTotalCVCell(totalSpend: Int64, highestSpend: Int64) {
        
        totalSpendLabel.text = "-$\(Int(totalSpend).formattedWithSeparator)"
        
        highestSpendLabel.text = "-$\(Int(highestSpend).formattedWithSeparator)"
        
    }

}
