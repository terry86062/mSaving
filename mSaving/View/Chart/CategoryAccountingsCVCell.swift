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
    
    var categoriesMonthTotal: [CategoryMonthTotal] = []
    
    var isIncome = false
    
    var touchCategoryHandler: (() -> Void)?
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initCategoryAccountingsCVCell(monthTotal: [CategoryMonthTotal], isIncome: Bool) {
        
        self.categoriesMonthTotal = monthTotal
        
        self.isIncome = isIncome
        
    }
    
    func setUpCollectionView() {
        
        categoryAccountingsCollectionView.helpRegisterView(cell: AccountingDateCVCell())
        
        categoryAccountingsCollectionView.helpRegister(cell: CategoryCVCell())
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoriesMonthTotal.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryAccountingsCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategoryCVCell.self),
            for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
        
        cell.initCategoryCVCell(categoryMonthTotal: categoriesMonthTotal[indexPath.row], isIncome: isIncome)
        
        cell.touchCategoryHandler = {
            
            self.selectedCategoryMonthTotal = self.categoriesMonthTotal[indexPath.row]
            
            self.touchCategoryHandler?()
            
        }
        
        return cell
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDelegate { }

extension CategoryAccountingsCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 48)
        
    }
    
}
