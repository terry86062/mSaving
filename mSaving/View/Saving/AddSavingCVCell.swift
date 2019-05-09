//
//  AddSavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AddSavingCVCell: UICollectionViewCell {

    @IBOutlet weak var plusImageView: UIImageView!
    
    @IBOutlet weak var addLabel: UILabel!
    
    weak var delegate: SavingCVCCellDelegate?

    override func awakeFromNib() {

        super.awakeFromNib()

        plusImageView.tintColor = .lightGray

    }
    
    func initAddSavingCVCell(addText: String, delegate: SavingCVCCellDelegate?) {
        
        addLabel.text = addText
        
        self.delegate = delegate
        
    }

    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {
        
        delegate?.touchAddSaving?()

    }

}
