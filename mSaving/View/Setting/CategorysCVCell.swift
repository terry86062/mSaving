//
//  CategorysCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategorysCVCell: UICollectionViewCell {

    @IBOutlet weak var categorysCollectionView: UICollectionView! {

        didSet {

            categorysCollectionView.dataSource = self

            categorysCollectionView.delegate = self

            setUpCollectionView()

        }

    }
    
    var expenseCategories: [ExpenseCategory] = []
    
    var incomeCategories: [IncomeCategory] = []

    var goToSetCategory: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initCategorysCVCell(expense: [ExpenseCategory], income: [IncomeCategory]) {
        
        expenseCategories = expense
        
        incomeCategories = income
        
    }

    func setUpCollectionView() {

        categorysCollectionView.helpRegister(cell: CategoryCVCell())

    }

}

extension CategorysCVCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if expenseCategories != [] {
            
            return expenseCategories.count
            
        } else if incomeCategories != [] {
            
            return incomeCategories.count
            
        } else {
            
            return 0
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = categorysCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategoryCVCell.self),
            for: indexPath) as? CategoryCVCell else { return CategoryCVCell() }

        if expenseCategories != [] {
            
            cell.initCategoryCVCell(expense: expenseCategories[indexPath.row],
                                    income: nil)
            
        } else if incomeCategories != [] {
            
            cell.initCategoryCVCell(expense: nil,
                                    income: incomeCategories[indexPath.row])
            
        }
        
        cell.touchCategoryHandler = goToSetCategory

        return cell

    }

}

extension CategorysCVCell: UICollectionViewDelegate { }

extension CategorysCVCell: UICollectionViewDelegateFlowLayout {

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
