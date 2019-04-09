//
//  AddSavingDetailCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AddSavingDetailCVCell: UICollectionViewCell {
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    var showSavingDetailAdd: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        plusImageView.tintColor = .lightGray
        
    }
    
    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {
        
        guard let show = showSavingDetailAdd else { return }
        
        show()
        
    }
    
}
