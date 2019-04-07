//
//  AccountDateCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

enum AccountDateStyle {
    
    case accountDate(date: String, amount: String)
    
    case setting(leadingText: String, trailingText: String)
    
}

class AccountDateCVCell: UICollectionViewCell {
    
    @IBOutlet weak var leadingLabel: UILabel!
    
    @IBOutlet weak var trailingLabel: UILabel!
    
    var goToDetialPage: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initAccountDateCVCell(style: AccountDateStyle) {
        
        switch style {
            
        case .accountDate(let date, let amount):
            
            leadingLabel.text = date
            
            trailingLabel.text = amount
            
            setShadow(bool: false)
            
        case .setting(let leadingText, let trailingText):
            
            leadingLabel.text = leadingText
            
            trailingLabel.text = trailingText
            
            trailingLabel.textColor = .black
            
            setShadow(bool: true)
            
        }
        
    }
    
    func setShadow(bool: Bool) {
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.layer.shadowOpacity = 0.8
        
        self.layer.shadowRadius = 5
        
        self.layer.shadowColor = UIColor.gray.cgColor
        
    }
    
    @IBAction func goToDetail(_ sender: UIButton) {
        
        guard let go = goToDetialPage else { return }
        
        go()
        
    }
    
}
