//
//  SavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingCVCell: UICollectionViewCell {

    @IBOutlet weak var savingAccountingCollectionView: UICollectionView! {

        didSet {
            
            savingAccountingCollectionView.dataSource = self
            
            savingAccountingCollectionView.delegate = self
            
            setUpCollectionView()

        }

    }
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var accountingProvider = AccountingProvider()
    
    var showAccounting = true
    
    var accountingsGroup: [[Accounting]] = []
    
    var savings: [Saving] = []
    
    var expenseMonthTotal: [CategoryMonthTotal] = []
    
    var touchMainSaving: (() -> Void)?
    
    var presentSavingDetailNew: (() -> Void)?
    
    var presentSavingDetailEdit: (() -> Void)?
    
    var goToAccountDetail: (() -> Void)?
    
    var totalSpend = 0
    
    var selectedAccounting: Accounting?
    
    var selectedSavingDetail: Saving?
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(showAccounting: Bool, month: Month) {
        
        noDataLabel.isHidden = true
        
        self.showAccounting = showAccounting
        
        accountingsGroup = accountingProvider.fetchAccountingsGroup(month: month)
        
        savings = SavingProvider().fetchSaving(month: month)
        
        totalSpend = accountingProvider.getTotalSpend(month: month)
        
        let tempTuples = accountingProvider.fetchExpenseIncomeMonthTotal(month: month)
        
        expenseMonthTotal = tempTuples.expense
        
        if showAccounting && accountingsGroup.count == 0 {
            
            noDataLabel.isHidden = false
            
        }
        
    }

    func setUpCollectionView() {
        
        savingAccountingCollectionView.helpRegister(cell: AccountingsCVCell())

        savingAccountingCollectionView.helpRegister(cell: SavingGoalCVCell())

        savingAccountingCollectionView.helpRegister(cell: SavingDetailCVCell())

        savingAccountingCollectionView.helpRegister(cell: AddSavingDetailCVCell())

    }

}

extension SavingCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showAccounting {

            return accountingsGroup.count + 1

        } else {

            if savings == [] {
                
                return 2
                
            } else {
                
                return savings.count + 1
                
            }

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = savingAccountingCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingGoalCVCell.self),
                for: indexPath) as? SavingGoalCVCell else {
                    return SavingGoalCVCell()
            }
            
            if savings == [] {
                
                cell.initSavingGoalCVCell(budget: 0, totalSpend: totalSpend)
                
            } else {
                
                cell.initSavingGoalCVCell(budget: savings[0].amount, totalSpend: totalSpend)
                
            }
            
            cell.touchMainSaving = { [weak self] in
                
                guard let weakSelf = self else { return }
                
                weakSelf.showAccounting = !weakSelf.showAccounting
                
                if weakSelf.showAccounting, weakSelf.accountingsGroup == [] {
                    
                    weakSelf.noDataLabel.isHidden = false
                    
                } else {
                    
                    weakSelf.noDataLabel.isHidden = true
                    
                }
                
                weakSelf.touchMainSaving?()
                
            }
            
            return cell
            
        } else {
            
            if showAccounting {
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountingsCVCell.self),
                    for: indexPath) as? AccountingsCVCell else {
                        return AccountingsCVCell()
                }
                
                cell.initAccountsCVCell(haveHeader: true, accountings: accountingsGroup[indexPath.row - 1])
                
                cell.goToAccountDetail = {
                    
                    self.selectedAccounting = cell.selectedAccounting
                    
                    self.goToAccountDetail?()
                    
                }
                
                cell.accountingsCollectionView.reloadData()
                
                return cell
                
            } else {
                
                if savings == [] {
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                        for: indexPath) as? AddSavingDetailCVCell else {
                            return AddSavingDetailCVCell()
                    }
                    
                    cell.presentSavingDetailAdd = presentSavingDetailNew
                    
                    return cell
                    
                } else {
                    
                    if indexPath.row == savings.count {
                        
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                            for: indexPath) as? AddSavingDetailCVCell else {
                                return AddSavingDetailCVCell()
                        }
                        
                        cell.presentSavingDetailAdd = presentSavingDetailNew
                        
                        return cell
                        
                    } else {
                        
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: String(describing: SavingDetailCVCell.self),
                            for: indexPath) as? SavingDetailCVCell else {
                                return SavingDetailCVCell()
                        }
                        
                        if savings.count > 0 {
                            
                            guard let expenseCategory = savings[indexPath.row].expenseCategory,
                                let iconName = expenseCategory.iconName,
                                let name = expenseCategory.name,
                                let color = expenseCategory.color else { return cell }
                            
                            if expenseMonthTotal.count > 0 {
                                
                                var totalSpend = 0
                                
                                for index in 0...expenseMonthTotal.count - 1
                                where expenseMonthTotal[index].accountings[0][0].expenseCategory == expenseCategory {
                                        
                                        totalSpend = Int(expenseMonthTotal[index].amount)
                                        
                                }
                                
                                cell.initSavingDetailCVCell(budget: savings[indexPath.row].amount,
                                                            totalSpend: totalSpend,
                                                            imageName: iconName,
                                                            categoryName: name, hex: color)
                                
                            } else {
                                
                                cell.initSavingDetailCVCell(budget: savings[indexPath.row].amount,
                                                            totalSpend: totalSpend,
                                                            imageName: iconName,
                                                            categoryName: name, hex: color)
                                
                            }
                            
                        }
                        
                        cell.showSavingDetail = {
                            
                            self.selectedSavingDetail = self.savings[indexPath.row]
                            
                            self.presentSavingDetailEdit?()
                            
                        }
                        
                        return cell
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

//extension SavingCVCell: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//        
//        cell.alpha = 0
//        
//        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row),
//                       animations: { cell.alpha = 1 })
//        
//    }
//    
//}

extension SavingCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 72)
            
        } else {
            
            if showAccounting {
                
                return CGSize(width: Int(UIScreen.main.bounds.width - 32),
                              height: 48 * (accountingsGroup[indexPath.row - 1].count) + 53)
                
            } else {
                
                if savings == [] {
                    
                    return CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
                    
                } else {
                    
                    if indexPath.row == savings.count {
                        
                        return CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
                        
                    } else {
                        
                        return CGSize(width: UIScreen.main.bounds.width - 32, height: 72)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
        
    }
    
}
