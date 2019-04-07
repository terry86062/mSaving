//
//  IncomeExpenseCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class IncomeExpenseCVCell: UICollectionViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        
        didSet {
            
            setUpCollectionView()
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initSavingCVCell(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        
        categoryCollectionView.dataSource = dataSource
        
        categoryCollectionView.delegate = delegate
        
    }
    
    func setUpCollectionView() {
        
        categoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
        categoryCollectionView.helpRegister(cell: AccountsCVCell())
        
    }
    
}
