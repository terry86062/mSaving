//
//  AccountCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountCVCell: UICollectionViewCell {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
//        clipsToBounds = false
//        
//        layer.masksToBounds = false
        
    }
    
    func initAccountCVCell(zPosition: CGFloat) {
        
        self.layer.zPosition = zPosition
        
    }

}
