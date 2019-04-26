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
    
    var showAccounting = true
    
    var accountings: [[Accounting]] = []
    
    var savings: [Saving] = []
    
    var touchMainSaving: (() -> Void)?
    
    var goToAccountDetail: (() -> Void)?
    
    var presentSavingDetailAdd: (() -> Void)?
    
    var editSavingDetailAdd: (() -> Void)?
    
    var selectedAccounting: AccountingWithDate?
    
    var selectedSavingDetail: Saving?
    
    var totalSpend = 0
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(showAccounting: Bool, month: Month) {
        
        self.showAccounting = showAccounting
        
        accountings = AccountingProvider().fetchAccounting(month: month)
        
        savings = SavingProvider().fetchSaving(month: month)
//
//        totalSpend = 0
//
//        let accountingsFlatMaped = accountings.flatMap({ $0 })
//
//        if accountingsFlatMaped.count > 0 {
//
//            for index in 0...accountingsFlatMaped.count - 1 {
//
//                if accountingsFlatMaped[index].accounting.expenseCategory != nil {
//
//                    totalSpend += Int(accountingsFlatMaped[index].accounting.amount)
//
//                }
//
//            }
//
//        }
        
    }

    func setUpCollectionView() {

        savingAccountingCollectionView.helpRegister(cell: SavingGoalCVCell())

        savingAccountingCollectionView.helpRegister(cell: AccountingsCVCell())

        savingAccountingCollectionView.helpRegister(cell: SavingDetailCVCell())

        savingAccountingCollectionView.helpRegister(cell: AddSavingDetailCVCell())

    }

}

extension SavingCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showAccounting {

            return accountings.count + 1

        } else {

            return savings.count + 1

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
            
            cell.touchMainSaving = {
                
                self.showAccounting = !self.showAccounting
                
                self.touchMainSaving?()
                
            }
            
            return cell
            
        } else {
            
            if showAccounting {
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountingsCVCell.self),
                    for: indexPath) as? AccountingsCVCell else {
                        return AccountingsCVCell()
                }
                
                cell.initAccountsCVCell(haveHeader: true, accountings: accountings[indexPath.row - 1])
                
                cell.goToAccountDetail = {
                    
                    self.selectedAccounting = cell.selectedAccounting
                    
                    self.goToAccountDetail?()
                    
                }
                
                cell.accountingsCollectionView.reloadData()
                
                return cell
                
            } else {
                
                if indexPath.row == savings.count {
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                        for: indexPath) as? AddSavingDetailCVCell else {
                            return AddSavingDetailCVCell()
                    }
                    
                    cell.presentSavingDetailAdd = presentSavingDetailAdd
                    
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
                        
                        cell.initSavingDetailCVCell(budget: savings[indexPath.row].amount,
                                                    totalSpend: 0,
                                                    imageName: iconName,
                                                    subCategoryName: name, hex: color)
                        
                    }
                    
                    cell.showSavingDetailAdd = {
                        
                        self.selectedSavingDetail = self.savings[indexPath.row]
                        
                        self.editSavingDetailAdd?()
                        
                    }
                    
                    return cell
                    
                }
                
            }
            
        }
        
    }
    
}

extension SavingCVCell: UICollectionViewDelegate {
    
}

extension SavingCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            
            return CGSize(width: 382, height: 100)
            
        } else {
            
            if showAccounting {
                
                return CGSize(width: 382, height: 56 * (accountings[indexPath.row - 1].count + 1))
                
            } else {
                
                if indexPath.row == savings.count {
                    
                    return CGSize(width: 382, height: 56)
                    
                } else {
                    
                    return CGSize(width: 382, height: 112)
                    
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
