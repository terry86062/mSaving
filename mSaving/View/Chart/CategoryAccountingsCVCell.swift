//
//  CategoryAccountingsCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/19.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryAccountingsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryAccountingsCollectionView: UICollectionView! {
        
        didSet {
            
            categoryAccountingsCollectionView.dataSource = self
            
            categoryAccountingsCollectionView.delegate = self
            
            setUpCollectionView()
            
        }
        
    }
    
    var touchCategoryHandler: (() -> Void)?
    
    var categoryAccountingMonthTotals: [CategoryMonthTotal] = []
    
    var selectedCategoryAccountingMonthTotal: CategoryMonthTotal?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initCategoryAccountingsCVCell(categoryAccountingMonthTotals: [CategoryMonthTotal]) {
        
        self.categoryAccountingMonthTotals = categoryAccountingMonthTotals
        
    }
    
    func setUpCollectionView() {
        
        categoryAccountingsCollectionView.helpRegisterView(cell: AccountingDateCVCell())
        
        categoryAccountingsCollectionView.helpRegister(cell: CategoryCVCell())
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryAccountingMonthTotals.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryAccountingsCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategoryCVCell.self),
            for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
        
        cell.initCategoryCVCell(categoryAccountingMonthTotal: categoryAccountingMonthTotals[indexPath.row])
        
        cell.touchCategoryHandler = {
            
            self.selectedCategoryAccountingMonthTotal = self.categoryAccountingMonthTotals[indexPath.row]
            
            guard let touch = self.touchCategoryHandler else { return }
            
            touch()
            
        }
        
        return cell
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDelegate {
    
}

extension CategoryAccountingsCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
