//
//  ChartDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class ChartDetailVC: UIViewController {

    @IBOutlet weak var categoryAccountingsCollectionView: UICollectionView! {

        didSet {

            categoryAccountingsCollectionView.dataSource = self

            categoryAccountingsCollectionView.delegate = self

        }

    }
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        categoryNameLabel.text = selectedCategoryMonthTotal?.accountings[0][0].expenseCategory?.name

    }

    func setUpCollectionView() {

        categoryAccountingsCollectionView.helpRegister(cell: CategoryAccountingsTotalCVCell())

        categoryAccountingsCollectionView.helpRegister(cell: AccountingsCVCell())

    }

    @IBAction func pop(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)

    }

}

extension ChartDetailVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let selectedCategoryMonthTotal = selectedCategoryMonthTotal else { return 0 }
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return selectedCategoryMonthTotal.accountings.count
            
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {

            guard let cell = categoryAccountingsCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategoryAccountingsTotalCVCell.self),
                for: indexPath) as? CategoryAccountingsTotalCVCell else {
                    return UICollectionViewCell()
            }
            
            guard let selectedCategoryMonthTotal = selectedCategoryMonthTotal else { return cell }
            
            var flatMapArray = selectedCategoryMonthTotal.accountings.flatMap({ $0 })
            
            var highestSpend: Int64 = 0
            
            for index in 0...flatMapArray.count - 1 where flatMapArray[index].amount > highestSpend {
                
                highestSpend = flatMapArray[index].amount
                
            }

            cell.initCategoryAccountingsTotalCVCell(totalSpend: selectedCategoryMonthTotal.amount,
                                                    highestSpend: highestSpend)
            
            return cell

        } else {

            guard let cell = categoryAccountingsCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AccountingsCVCell.self),
                for: indexPath) as? AccountingsCVCell else {
                    return UICollectionViewCell()
            }
            
            guard let selectedCategoryMonthTotal = selectedCategoryMonthTotal else { return cell }

            cell.initAccountingsCVCell(haveHeader: true,
                                    accountings: selectedCategoryMonthTotal.accountings[indexPath.row],
                                    delegate: nil)

            return cell

        }

    }

}

extension ChartDetailVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let selectedCategoryMonthTotal = selectedCategoryMonthTotal else {
            
            return CGSize(width: 0, height: 0)
            
        }
        
        if indexPath.section == 0 {

            return CGSize(width: Int(UIScreen.main.bounds.width - 32), height: 68)

        } else {
            
            return CGSize(width: Int(UIScreen.main.bounds.width - 32),
                          height: 48 * (selectedCategoryMonthTotal.accountings[indexPath.row].count) + 53)

        }

    }

}
