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
    
    var isIncome = false
    
    var categoriesMonthTotal: [CategoryMonthTotal] = []

    weak var delegate: AnalysisCVCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initCategoryAccountingsCVCell(isIncome: Bool, monthTotal: [CategoryMonthTotal],
                                       delegate: AnalysisCVCellDelegate?) {
        
        self.categoriesMonthTotal = monthTotal
        
        self.isIncome = isIncome
        
        self.delegate = delegate
        
        categoryAccountingsCollectionView.reloadData()
        
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
        
        cell.initCategoryCVCell(isIncome: isIncome,
                                categoryMonthTotal: categoriesMonthTotal[indexPath.row], delegate: delegate)
        
        return cell
        
    }
    
}

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
