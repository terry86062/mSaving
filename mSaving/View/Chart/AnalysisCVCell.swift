//
//  AnalysisCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AnalysisCVCell: UICollectionViewCell {

    @IBOutlet weak var analysisCollectionView: UICollectionView! {

        didSet {

            analysisCollectionView.dataSource = self
            
            analysisCollectionView.delegate = self
            
            setUpCollectionView()

        }

    }
    
    var accountingProvider = AccountingProvider()
    
    var categoriesMonthTotal: [CategoryMonthTotal] = []
    
//    var accountingWithDateArray: [[AccountingWithDate]] = []
    
    var isIncome = false
    
    var touchCategoryHandler: (() -> Void)?
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?
    
//    var numberOfRow: Int {
//
//        var tempArray: [CategoryMonthTotal] = []
//
//        guard categoryAccountingMonthTotals.count > 0 else { return 0 }
//
//        for index in 0...categoryAccountingMonthTotals.count - 1 {
//
//            if isIncome {
//
//                if categoryAccountingMonthTotals[index].incomeCategory != nil {
//
//                    tempArray.append(categoryAccountingMonthTotals[index])
//
//                }
//
//            } else {
//
//                if categoryAccountingMonthTotals[index].expenseCategory != nil {
//
//                    tempArray.append(categoryAccountingMonthTotals[index])
//
//                }
//
//            }
//
//        }
//
//        return tempArray.count
//
//    }

    override func awakeFromNib() {

        super.awakeFromNib()

    }

//    func initAnalysisCVCell(categoryAccountingMonthTotals: [CategoryMonthTotal],
//                            accountingWithDateArray: [[AccountingWithDate]],
//                            isIncome: Bool) {
//
//        self.categoryAccountingMonthTotals = categoryAccountingMonthTotals
//
//        self.accountingWithDateArray = accountingWithDateArray
//
//        self.isIncome = isIncome
//
//    }
    
    func initAnalysisCVCell(month: Month, isIncome: Bool) {
        
        categoriesMonthTotal = accountingProvider.fetchAccountingCategory(month: month)
        
        self.isIncome = isIncome
        
    }

    func setUpCollectionView() {

        analysisCollectionView.helpRegister(cell: PieChartCVCell())

        analysisCollectionView.helpRegister(cell: BarChartCVCell())

        analysisCollectionView.helpRegister(cell: CategoryAccountingsCVCell())

    }

}

extension AnalysisCVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PieChartCVCell.self),
                for: indexPath) as? PieChartCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.pieChartUpdate(categoriesMonthTotal: categoriesMonthTotal, isIncome: isIncome)
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategoryAccountingsCVCell.self),
                for: indexPath) as? CategoryAccountingsCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.initCategoryAccountingsCVCell(categoriesMonthTotal: categoriesMonthTotal, isIncome: isIncome)
            
            cell.touchCategoryHandler = {

                self.selectedCategoryMonthTotal = cell.selectedCategoryMonthTotal
                
                self.touchCategoryHandler?()

            }
            
            cell.categoryAccountingsCollectionView.reloadData()
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: BarChartCVCell.self),
                for: indexPath) as? BarChartCVCell else {
                    return UICollectionViewCell()
            }
            
//            cell.barChartUpdate(accountingWithDateArray: accountingWithDateArray)
            
            return cell
            
        }
        
    }
    
}

extension AnalysisCVCell: UICollectionViewDelegate { }

extension AnalysisCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            
        } else if section == 1 {
            
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 64, left: 0, bottom: 32, right: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSize(width: 320, height: 320)
            
        } else if indexPath.section == 1 {
            
            return CGSize(width: 382, height: 56 * 5)//* numberOfRow)
            
        } else {
            
            return CGSize(width: 360, height: 360)
            
        }
        
    }
    
}
