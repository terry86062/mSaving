//
//  CategoryCollectionViewVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/9.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryCollectionViewVC: UIViewController {
    
    weak var delegate: CategorySelectCVCellDelegate?
    
    var showExpense = true
    
    var expenseCategories: [ExpenseCategory] = CategoryProvider().expenseCategories
    
    var incomeCategories: [IncomeCategory] = CategoryProvider().incomeCategories
    
}

extension CategoryCollectionViewVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showExpense {
            
            return expenseCategories.count
            
        } else {
            
            return incomeCategories.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        if showExpense {
            
            let expenseCategory = expenseCategories[indexPath.row]
            
            cell.initCategorySelectCVCell(expense: expenseCategory, income: nil, delegate: delegate)
            
        } else {
            
            let incomeCategory = incomeCategories[indexPath.row]
            
            cell.initCategorySelectCVCell(expense: nil, income: incomeCategory, delegate: delegate)
            
        }
        
        return cell
        
    }
    
}

extension CategoryCollectionViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 43, bottom: 0, right: 38.2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 36, height: 84)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 38.2
        
    }
    
}
