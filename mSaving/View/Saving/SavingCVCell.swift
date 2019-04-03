//
//  SavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingCVCell: UICollectionViewCell {
    
    lazy var savingGoalView: SavingGoalView = {
        
        guard let goalView = Bundle.main.loadNibNamed(String(describing: SavingGoalView.self), owner: nil, options: nil)?[0] as? SavingGoalView else { return SavingGoalView() }
        
        goalView.frame = CGRect(x: 0, y: 0, width: savingGoalContainView.frame.width, height: savingGoalContainView.frame.height)
        
        return goalView
        
    }()
    
    @IBOutlet weak var savingGoalContainView: SavingGoalView! {
        
        didSet {
            
            savingGoalContainView.addSubview(savingGoalView)
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

}
