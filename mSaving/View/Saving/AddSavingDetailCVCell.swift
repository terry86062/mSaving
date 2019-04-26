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
    
    @IBOutlet weak var addLabel: UILabel!
    
    var presentSavingDetailAdd: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

        plusImageView.tintColor = .lightGray

    }
    
    func initAddSavingDetailCVCell(addText: String) {
        
        addLabel.text = addText
        
    }

    @IBAction func goToSavingDetailAdd(_ sender: UIButton) {

        presentSavingDetailAdd?()

    }

}
