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
    
    @IBOutlet weak var accountCollectionView: UICollectionView! {
        
        didSet {
            
            setUpCollectionView()
            
        }
        
    }
    
    var showSavingDetail: (() -> ())?
    
    var showSavingGoalSet: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initSavingCVCell(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        
        accountCollectionView.dataSource = dataSource
        
        accountCollectionView.delegate = delegate
        
    }
    
    func setUpCollectionView() {
        
        accountCollectionView.helpRegister(cell: AccountCVCell())
        
        accountCollectionView.helpRegister(cell: SavingDetailCVCell())
        
        accountCollectionView.helpRegisterView(cell: AccountDateCVCell())
        
        accountCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
    }
    
    @IBAction func showSavingDetail(_ sender: UIButton) {
        
        if let show = showSavingDetail {
            
            show()
            
        } else if let show = showSavingGoalSet {
            
            show()
            
        }
        
    }
    
}

