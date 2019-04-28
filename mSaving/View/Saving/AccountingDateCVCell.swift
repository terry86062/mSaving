//
//  AccountingDateCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountingDateCVCell: UICollectionViewCell {

    @IBOutlet weak var leadingLabel: UILabel!
    
    @IBOutlet weak var subLeadingLabel: UILabel!
    
    @IBOutlet weak var trailingLabel: UILabel!

    var goToDetialPage: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountDateCVCell(leadingText: String, subLeadingText: String = "", trailingText: String, trailingColor: UIColor, havingShadow: Bool) {

        leadingLabel.text = leadingText
        
        subLeadingLabel.text = subLeadingText
        
        trailingLabel.text = trailingText
        
        trailingLabel.textColor = trailingColor
        
        setShadow(bool: havingShadow)

    }

    func setShadow(bool: Bool) {

        if bool {
            
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.layer.shadowOpacity = 0.8
            
            self.layer.shadowRadius = 5
            
            self.layer.shadowColor = UIColor.gray.cgColor
            
        } else {
            
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            self.layer.shadowOpacity = 0
            
            self.layer.shadowRadius = 0
            
            self.layer.shadowColor = UIColor.clear.cgColor
            
        }
        
    }

    @IBAction func goToDetail(_ sender: UIButton) {

        guard let goTo = goToDetialPage else { return }

        goTo()

    }

}
