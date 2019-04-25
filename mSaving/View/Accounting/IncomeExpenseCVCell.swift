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
    
    var expenseCategories: [ExpenseCategory] = []
    
    var incomeCategories: [IncomeCategory] = []
    
    var selectCategory: (() -> Void)?
    
    var selectedCategory: CategoryCase?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initIncomeExpenseCVCell(expenseCategories: [ExpenseCategory], incomeCategories: [IncomeCategory]) {

        self.expenseCategories = expenseCategories
        
        self.incomeCategories = incomeCategories

    }

    func setUpCollectionView() {

        categoryCollectionView.helpRegister(cell: CategorySelectCVCell())

    }

}

extension IncomeExpenseCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if expenseCategories != [] {
            
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
        
        if expenseCategories != [] {
            
            let expenseCategory = expenseCategories[indexPath.row]
            
            guard let iconName = expenseCategory.iconName,
                let name = expenseCategory.name,
                let color = expenseCategory.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
            
            cell.selectCategory = {
                
                self.selectedCategory = .expense(expenseCategory)
                
                self.selectCategory?()
                
            }
            
        } else {
            
            let incomeCategory = incomeCategories[indexPath.row]
            
            guard let iconName = incomeCategory.iconName,
                let name = incomeCategory.name,
                let color = incomeCategory.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
            
            cell.selectCategory = {
                
                self.selectedCategory = .income(incomeCategory)
                
                self.selectCategory?()
                
            }
            
        }
        
        return cell
        
    }
    
}

extension IncomeExpenseCVCell: UICollectionViewDelegate { }

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
