//
//  AccountingsCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountingsCVCell: UICollectionViewCell {

    @IBOutlet weak var accountingsCollectionView: UICollectionView! {

        didSet {

            accountingsCollectionView.dataSource = self

            accountingsCollectionView.delegate = self

            setUpCollectionView()

        }

    }

    var haveHeader = false
    
    var accountings: [Accounting] = []
    
    var goToAccountDetail: (() -> Void)?
    
    var selectedAccounting: Accounting?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountsCVCell(haveHeader: Bool, accountings: [Accounting]) {

        self.haveHeader = haveHeader
        
        self.accountings = accountings

    }

    func setUpCollectionView() {

        accountingsCollectionView.helpRegisterView(cell: AccountingDateCVCell())

        accountingsCollectionView.helpRegister(cell: AccountingCVCell())

    }

}

extension AccountingsCVCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return accountings.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: AccountingCVCell.self),
            for: indexPath) as? AccountingCVCell else { return UICollectionViewCell() }
        
        cell.initAccountCVCell(accounting: accountings[indexPath.row])

        cell.goToAccountDetail = {
            
//            self.selectedAccounting = self.accountings[indexPath.row]
            
            guard let goTo = self.goToAccountDetail else { return }
            
            goTo()
            
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: AccountingDateCVCell.self),
            for: indexPath) as? AccountingDateCVCell else {
                return AccountingCVCell()
        }
        
//        var totalAmount = 0
//        
//        for index in 0...accountings.count - 1 {
//            
//            if accountings[index].accounting.expenseCategory != nil {
//                
//                totalAmount -= Int(accountings[index].accounting.amount)
//                
//            } else if accountings[index].accounting.incomeCategory != nil {
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

        return headerView

    }
    
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

extension AccountingsCVCell: UICollectionViewDelegate {

}

extension AccountingsCVCell: UICollectionViewDelegateFlowLayout {

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
