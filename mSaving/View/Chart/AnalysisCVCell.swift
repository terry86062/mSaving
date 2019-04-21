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
    
    var categoryAccountingMonthTotals: [CategoryAccountingMonthTotal] = []
    
    var accountingWithDateArray: [[AccountingWithDate]] = []
    
    var touchCategoryHandler: (() -> Void)?
    
    var selectedCategoryAccountingMonthTotal: CategoryAccountingMonthTotal?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAnalysisCVCell(categoryAccountingMonthTotals: [CategoryAccountingMonthTotal], accountingWithDateArray: [[AccountingWithDate]]) {

        self.categoryAccountingMonthTotals = categoryAccountingMonthTotals
        
        self.accountingWithDateArray = accountingWithDateArray
        
    }

    func setUpCollectionView() {

        analysisCollectionView.helpRegister(cell: PieChartCVCell())

        analysisCollectionView.helpRegister(cell: BarChartCVCell())

        analysisCollectionView.helpRegister(cell: CategoryAccountingsCVCell())

    }

}

extension AnalysisCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PieChartCVCell.self),
                for: indexPath) as? PieChartCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.pieChartUpdate(categoryAccountingMonthTotals: categoryAccountingMonthTotals)
            
            return cell
            
        } else if indexPath.row == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategoryAccountingsCVCell.self),
                for: indexPath) as? CategoryAccountingsCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.initCategoryAccountingsCVCell(categoryAccountingMonthTotals: categoryAccountingMonthTotals)
            
            cell.touchCategoryHandler = {

                self.selectedCategoryAccountingMonthTotal = cell.selectedCategoryAccountingMonthTotal
                
                guard let touch = self.touchCategoryHandler else { return }
                
                touch()

            }
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: BarChartCVCell.self),
                for: indexPath) as? BarChartCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.barChartUpdate(accountingWithDateArray: accountingWithDateArray)
            
            return cell
            
        }
        
    }
    
}

extension AnalysisCVCell: UICollectionViewDelegate {
    
}

extension AnalysisCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == 2 {
            
            return CGSize(width: 360, height: 360)
            
        } else {
            
            return CGSize(width: 382, height: 56 * categoryAccountingMonthTotals.count)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 32
        
    }
    
}
