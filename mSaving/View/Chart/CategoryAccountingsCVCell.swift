//
//  CategoryAccountingsCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/19.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryAccountingsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryAccountingsCollectionView: UICollectionView! {
        
        didSet {
            
            categoryAccountingsCollectionView.dataSource = self
            
            categoryAccountingsCollectionView.delegate = self
            
            setUpCollectionView()
            
        }
        
    }
    
//    var goToAccountDetail: (() -> Void)?
    
    var haveHeader = false
    
    var categoryAccountingMonthTotals: [CategoryAccountingMonthTotal] = []
    
//    var selectedAccounting: AccountingWithDate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initCategoryAccountingsCVCell(haveHeader: Bool, categoryAccountingMonthTotals: [CategoryAccountingMonthTotal]) {
        
//        self.haveHeader = haveHeader
        
        self.categoryAccountingMonthTotals = categoryAccountingMonthTotals
        
    }
    
    func setUpCollectionView() {
        
        categoryAccountingsCollectionView.helpRegisterView(cell: AccountingDateCVCell())
        
        categoryAccountingsCollectionView.helpRegister(cell: CategoryCVCell())
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryAccountingMonthTotals.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryAccountingsCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategoryCVCell.self),
            for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
        
        cell.initCategoryCVCell(categoryAccountingMonthTotal: categoryAccountingMonthTotals[indexPath.row])
        
//        cell.goToAccountDetail = {
//            
//            self.selectedAccounting = self.accountings[indexPath.row]
//            
//            guard let goTo = self.goToAccountDetail else { return }
//            
//            goTo()
//            
//        }
        
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard let headerView = collectionView.dequeueReusableSupplementaryView(
//            ofKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: String(describing: AccountingDateCVCell.self),
//            for: indexPath) as? AccountingDateCVCell else {
//                return AccountingCVCell()
//        }
//
//        var totalAmount = 0
//
//        for index in 0...accountings.count - 1 {
//
//            if accountings[index].accounting.expenseSubCategory != nil {
//
//                totalAmount -= Int(accountings[index].accounting.amount)
//
//            } else if accountings[index].accounting.incomeSubCategory != nil {
//
//                totalAmount += Int(accountings[index].accounting.amount)
//
//            }
//
//        }
//
//        let dateComponents = accountings[0].dateComponents
//
//        guard let day = dateComponents.day, let weekday = dateComponents.weekday else { return headerView }
//
//        if totalAmount > 0 {
//
//            headerView.initAccountDateCVCell(
//                leadingText: "\(day), \(helpTransferWeekdayFromIntToString(weekday: weekday))",
//                trailingText: String(totalAmount),
//                trailingColor: .green,
//                havingShadow: false)
//
//        } else {
//
//            headerView.initAccountDateCVCell(
//                leadingText: "\(day), \(helpTransferWeekdayFromIntToString(weekday: weekday))",
//                trailingText: String(totalAmount),
//                trailingColor: .red,
//                havingShadow: false)
//
//        }
//
//        return headerView
//
//    }
    
    func helpTransferWeekdayFromIntToString(weekday: Int) -> String {
        
        switch weekday {
            
        case 1: return "星期日"
            
        case 2: return "星期一"
            
        case 3: return "星期二"
            
        case 4: return "星期三"
            
        case 5: return "星期四"
            
        case 6: return "星期五"
            
        case 7: return "星期六"
            
        default: return ""
            
        }
        
    }
    
}

extension CategoryAccountingsCVCell: UICollectionViewDelegate {
    
}

extension CategoryAccountingsCVCell: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if haveHeader {
            
            return CGSize(width: 0, height: 56)
            
        } else {
            
            return CGSize(width: 0, height: 0)
            
        }
        
    }
    
}

