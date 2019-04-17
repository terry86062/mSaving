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
    
    var goToAccountDetail: (() -> Void)?
    
    var showSavingDetail: (() -> Void)?
    
    var showAccountingBack: (() -> Void)?
    
    var presentSavingDetailAdd: (() -> Void)?
    
    var pushSavingDetailAdd: (() -> Void)?

    var accountings: [[AccountingWithDate]] = []
    
    var savings: [SavingWithDate] = []
    
    var selectedAccounting: AccountingWithDate?
    
    var totalSpend = 0
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(accountings: [[AccountingWithDate]], savings: [SavingWithDate]) {
        
        self.savings = []
        
        totalSpend = 0
        
        self.accountings = accountings
        
        self.savings = savings
        
        let accountingsFlatMaped = accountings.flatMap({ $0 })
        
        if accountingsFlatMaped.count > 0 {
            
            for index in 0...accountingsFlatMaped.count - 1 {
                
                if accountingsFlatMaped[index].accounting.expenseSubCategory != nil {
                    
                    totalSpend += Int(accountingsFlatMaped[index].accounting.amount)
                    
                }
                
            }
            
        }
        
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
            
            if savings.count == 0 {
                
                return 1
                
            } else {
                
                return savings.count
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = savingAccountingCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingGoalCVCell.self),
                for: indexPath) as? SavingGoalCVCell else {
                    return SavingGoalCVCell()
            }
            
            if savings.count > 0 {
                
                cell.initSavingGoalCVCell(budget: savings[indexPath.row].saving.amount, totalSpend: totalSpend)
                
            } else {
                
                cell.initSavingGoalCVCell(budget: 0, totalSpend: totalSpend)
                
            }
            
            cell.showSavingDetail = {
                
                if self.showAccounting {
                    
                    self.showAccounting = false
                    
                    guard let show = self.showSavingDetail else { return }
                    
                    show()
                    
//                    var indexPath: [IndexPath] = []
//                    
//                    for index in 1...self.accountings.count {
//                        
//                        indexPath.append(IndexPath(row: index, section: 0))
//                        
//                    }
//                    
//                    self.savingAccountingCollectionView.reloadItems(at: indexPath)
                    
                    self.savingAccountingCollectionView.reloadData()
                    
                } else {
                    
                    self.showAccounting = true
                    
                    guard let show = self.showAccountingBack else { return }
                    
                    show()
                    
//                    var indexPath: [IndexPath] = []
//                    
//                    for index in 1...self.accountings.count {
//
//                        indexPath.append(IndexPath(row: index, section: 0))
//
//                    }
//
//                    self.savingAccountingCollectionView.reloadItems(at: indexPath)
                    
                    self.savingAccountingCollectionView.reloadData()
                    
                }
                
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
                    
                    guard let goTo = self.goToAccountDetail else { return }
                    
                    goTo()
                    
                }
                
                cell.accountingsCollectionView.reloadData()
                
                return cell
                
            } else {
                
                if indexPath.row == 3 {
                    
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
                    
                    cell.pushSavingDetailAdd = pushSavingDetailAdd
                    
                    return cell
                    
                }
                
            }
            
        }
        
    }
    
}

extension SavingCVCell: UICollectionViewDelegate {
    
}

extension SavingCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            
            return CGSize(width: 382, height: 100)
            
        } else {
            
            if showAccounting {
                
                return CGSize(width: 382, height: 56 * (accountings[indexPath.row - 1].count + 1))
                
            } else {
                
                if indexPath.row == 3 {
                    
                    return CGSize(width: 382, height: 56)
                    
                } else {
                    
                    return CGSize(width: 382, height: 112)
                    
                }
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
        
    }
    
}
