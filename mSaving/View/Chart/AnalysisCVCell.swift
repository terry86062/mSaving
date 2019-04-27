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
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var accountingProvider = AccountingProvider()
    
    var month: Month?
    
    var expenseMonthTotal: [CategoryMonthTotal] = []
    
    var incomeMonthTotal: [CategoryMonthTotal] = []
    
    var accountingsGroup: [[Accounting]] = []
    
    var isIncome = false
    
    var touchCategoryHandler: (() -> Void)?
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initAnalysisCVCell(month: Month, isIncome: Bool) {
        
        noDataLabel.isHidden = true
        
        self.month = month
        
        let tempTuples = accountingProvider.fetchExpenseIncomeMonthTotal(month: month)
        
        expenseMonthTotal = tempTuples.expense
        
        incomeMonthTotal = tempTuples.income
        
        accountingsGroup = accountingProvider.fetchAccountingsGroup(month: month)
        
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
        
        if isIncome {
            
            return 2
            
        } else {
            
            return 3
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard month != nil else { return 0 }
        
        if isIncome {
            
            if incomeMonthTotal.count > 0 {
                
                return 1
                
            } else {
                
                noDataLabel.isHidden = false
                
                return 0
                
            }
            
        } else {
            
            if expenseMonthTotal.count > 0 {
                
                return 1
                
            } else {
                
                noDataLabel.isHidden = false
                
                return 0
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PieChartCVCell.self),
                for: indexPath) as? PieChartCVCell else {
                    return UICollectionViewCell()
            }
            
            if isIncome {
                
                cell.pieChartUpdate(monthTotal: incomeMonthTotal, isIncome: isIncome)
                
            } else {
                
                cell.pieChartUpdate(monthTotal: expenseMonthTotal, isIncome: isIncome)
                
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategoryAccountingsCVCell.self),
                for: indexPath) as? CategoryAccountingsCVCell else {
                    return UICollectionViewCell()
            }
            
            if isIncome {
                
                cell.initCategoryAccountingsCVCell(monthTotal: incomeMonthTotal, isIncome: isIncome)
                
            } else {
                
                cell.initCategoryAccountingsCVCell(monthTotal: expenseMonthTotal, isIncome: isIncome)
                
            }
            
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
            
            cell.barChartUpdate(accountingsGroup: accountingsGroup)
            
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
            
            if isIncome {
                
                return CGSize(width: 382, height: 56 * incomeMonthTotal.count)
                
            } else {
                
                return CGSize(width: 382, height: 56 * expenseMonthTotal.count)
                
            }
            
        } else {
            
            return CGSize(width: 360, height: 360)
            
        }
        
    }
    
}
