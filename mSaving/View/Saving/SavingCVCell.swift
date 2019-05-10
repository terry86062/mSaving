//
//  SavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

@objc protocol SavingCVCCellDelegate: AnyObject {
    
    @objc optional func touchMain()
    
    @objc optional func touchSub(saving: Saving?)
    
    @objc optional func touchAddSaving()
    
    @objc optional func touch(accounting: Accounting?)
    
}

class SavingCVCell: UICollectionViewCell {

    @IBOutlet weak var savingAccountingCollectionView: UICollectionView! {

        didSet {
            
            savingAccountingCollectionView.dataSource = self
            
            savingAccountingCollectionView.delegate = self
            
            setUpCollectionView()

        }

    }
    
    @IBOutlet weak var noDataImageView: UIImageView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var accountingProvider = AccountingProvider()
    
    var showAccounting = true
    
    var accountingsGroup: [[Accounting]] = []
    
    var savings: [Saving] = []
    
    var expenseMonthTotal: [CategoryMonthTotal] = []
    
    weak var delegate: SavingCVCCellDelegate?
    
    var totalSpend = 0
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(showAccounting: Bool, month: Month?, delegate: SavingCVCCellDelegate?) {
        
        noDataImageView.isHidden = true
        
        noDataLabel.isHidden = true
        
        self.showAccounting = showAccounting
        
        if let month = month {
            
            accountingsGroup = accountingProvider.fetchAccountingsGroup(month: month)
            
            savings = SavingProvider().fetchSaving(month: month)
            
            totalSpend = accountingProvider.getTotalSpend(month: month)
            
            let tempTuples = accountingProvider.fetchExpenseIncomeMonthTotal(month: month)
            
            expenseMonthTotal = tempTuples.expense
            
        }
        
        if showAccounting && accountingsGroup.count == 0 {
            
            noDataLabel.isHidden = false
            
            noDataImageView.isHidden = false
            
        }
        
        self.delegate = delegate
        
        savingAccountingCollectionView.reloadData()
        
    }

    func setUpCollectionView() {
        
        savingAccountingCollectionView.helpRegister(cell: AccountingsCVCell())

        savingAccountingCollectionView.helpRegister(cell: MainSavingCVCell())

        savingAccountingCollectionView.helpRegister(cell: SubSavingCVCell())

        savingAccountingCollectionView.helpRegister(cell: AddSavingCVCell())

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
                withReuseIdentifier: String(describing: MainSavingCVCell.self),
                for: indexPath) as? MainSavingCVCell else {
                    return MainSavingCVCell()
            }
            
            if savings == [] {
                
                cell.initMainSavingCVCell(budget: 0, totalSpend: totalSpend, delegate: delegate)
                
            } else {
                
                cell.initMainSavingCVCell(budget: savings[0].amount, totalSpend: totalSpend, delegate: delegate)
                
            }
            
            return cell
            
        } else {
            
            if showAccounting {
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountingsCVCell.self),
                    for: indexPath) as? AccountingsCVCell else {
                        return AccountingsCVCell()
                }
                
                cell.initAccountingsCVCell(haveHeader: true, accountings: accountingsGroup[indexPath.row - 1],
                                           delegate: delegate)
                
                return cell
                
            } else {
                
                if savings == [] {
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: AddSavingCVCell.self),
                        for: indexPath) as? AddSavingCVCell else {
                            return AddSavingCVCell()
                    }
                    
                    cell.initAddSavingCVCell(addText: "新增子預算", delegate: delegate)
                    
                    return cell
                    
                } else {
                    
                    if indexPath.row == savings.count {
                        
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: String(describing: AddSavingCVCell.self),
                            for: indexPath) as? AddSavingCVCell else {
                                return AddSavingCVCell()
                        }
                        
                        cell.initAddSavingCVCell(addText: "新增子預算", delegate: delegate)
                        
                        return cell
                        
                    } else {
                        
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: String(describing: SubSavingCVCell.self),
                            for: indexPath) as? SubSavingCVCell else {
                                return SubSavingCVCell()
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
                                
                                cell.initSubSavingCVCell(saving: savings[indexPath.row],
                                                         budget: savings[indexPath.row].amount,
                                                         totalSpend: totalSpend,
                                                         imageName: iconName,
                                                         categoryName: name, hex: color, delegate: delegate)
                                
                            } else {
                                
                                cell.initSubSavingCVCell(saving: savings[indexPath.row],
                                                         budget: savings[indexPath.row].amount,
                                                         totalSpend: totalSpend,
                                                         imageName: iconName,
                                                         categoryName: name, hex: color, delegate: delegate)
                                
                            }
                            
                        }
                        
                        return cell
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension SavingCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        
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
    
}
