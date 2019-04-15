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

            categoryCollectionView.dataSource = self
            
            categoryCollectionView.delegate = self
            
            setUpCollectionView()

        }

    }
    
    var selectSubCategory: (() -> Void)?
    
    var expenseCategorys: [ExpenseCategory] = []
    
    var incomeCategorys: [IncomeCategory] = []
    
    var expenseCategory: ExpenseCategory?
    
    var incomeCategory: IncomeCategory?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(expenseCategorys: [ExpenseCategory], incomeCategorys: [IncomeCategory]) {

        self.expenseCategorys = expenseCategorys
        
        self.incomeCategorys = incomeCategorys

    }

    func setUpCollectionView() {

        categoryCollectionView.helpRegister(cell: CategorySelectCVCell())

        categoryCollectionView.helpRegister(cell: AccountingsCVCell())

    }

}

extension IncomeExpenseCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if expenseCategorys != [] {
            
            return expenseCategorys.count
            
        } else {
            
            return incomeCategorys.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        if expenseCategorys != [] {
            
            expenseCategory = expenseCategorys[indexPath.row]
            
            guard let iconName = expenseCategory?.iconName,
                let name = expenseCategory?.name,
                let color = expenseCategory?.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, subCategoryName: name, hex: color)
            
            cell.selectSubCategory = selectSubCategory
            
        } else {
            
            incomeCategory = incomeCategorys[indexPath.row]
            
            guard let iconName = incomeCategory?.iconName,
                let name = incomeCategory?.name,
                let color = incomeCategory?.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, subCategoryName: name, hex: color)
            
            cell.selectSubCategory = selectSubCategory
            
        }
        
        return cell
        
    }
    
}

extension IncomeExpenseCVCell: UICollectionViewDelegate {
    
}

extension IncomeExpenseCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 32, height: 76)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 40
        
    }
    
}
