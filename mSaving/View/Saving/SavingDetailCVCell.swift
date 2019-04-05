//
//  SavingDetailCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingDetailCVCell: UICollectionViewCell {
    
    var showSavingDetailAdd: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {
        
        guard let show = showSavingDetailAdd else { return }
        
        show()
        
    }
    
}
