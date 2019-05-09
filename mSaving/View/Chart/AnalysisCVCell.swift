//
//  AnalysisCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

protocol AnalysisCVCellDelegate: AnyObject {
    
    func touch(categoryMonthTotal: CategoryMonthTotal?)
    
}

class AnalysisCVCell: UICollectionViewCell {

    @IBOutlet weak var analysisCollectionView: UICollectionView! {

        didSet {

            analysisCollectionView.dataSource = self
            
            analysisCollectionView.delegate = self
            
            setUpCollectionView()

        }

    }
    
    @IBOutlet weak var noDataImageView: UIImageView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var accountingProvider = AccountingProvider()
    
    var isIncome = false
    
    var expenseMonthTotal: [CategoryMonthTotal] = []
    
    var incomeMonthTotal: [CategoryMonthTotal] = []
    
    var accountingsGroup: [[Accounting]] = []
    
    weak var delegate: AnalysisCVCellDelegate?

    override func awakeFromNib() {

        super.awakeFromNib()

    }
    
    func initAnalysisCVCell(isIncome: Bool, month: Month?, delegate: AnalysisCVCellDelegate?) {
        
        noDataLabel.isHidden = true
        
        noDataImageView.isHidden = true
        
        self.isIncome = isIncome
        
        if let month = month {
            
            let tempTuples = accountingProvider.fetchExpenseIncomeMonthTotal(month: month)
            
            expenseMonthTotal = tempTuples.expense
            
            incomeMonthTotal = tempTuples.income
            
            accountingsGroup = accountingProvider.fetchAccountingsGroup(month: month)
            
        }
        
        self.delegate = delegate
        
    }

    func setUpCollectionView() {

        analysisCollectionView.helpRegister(cell: PieChartCVCell())

        analysisCollectionView.helpRegister(cell: BarChartCVCell())

        analysisCollectionView.helpRegister(cell: CategoryAccountingsCVCell())

    }

}

extension AnalysisCVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isIncome {
            
            if incomeMonthTotal.count > 0 {
                
                return 1
                
            } else {
                
                noDataLabel.isHidden = false
                
                noDataImageView.isHidden = false
                
                return 0
                
            }
            
        } else {
            
            if expenseMonthTotal.count > 0 {
                
                return 1
                
            } else {
                
                noDataLabel.isHidden = false
                
                noDataImageView.isHidden = false
                
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
                
                cell.initCategoryAccountingsCVCell(isIncome: isIncome, monthTotal: incomeMonthTotal,
                                                   delegate: delegate)
                
            } else {
                
                cell.initCategoryAccountingsCVCell(isIncome: isIncome, monthTotal: expenseMonthTotal,
                                                   delegate: delegate)
                
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

extension AnalysisCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        } else if section == 1 {
            
            return UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 64, left: 0, bottom: 32, right: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSize(width: 324.fitScreen, height: 324.fitScreen)
            
        } else if indexPath.section == 1 {
            
            if isIncome {
                
                return CGSize(width: Int(UIScreen.main.bounds.width - 32),
                              height: 48 * incomeMonthTotal.count + 12)
                
            } else {
                
                return CGSize(width: Int(UIScreen.main.bounds.width - 32),
                              height: 48 * expenseMonthTotal.count + 12)
                
            }
            
        } else {
            
            return CGSize(width: 360, height: 360)
            
        }
        
    }
    
}
