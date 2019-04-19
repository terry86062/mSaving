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

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAnalysisCVCell(categoryAccountingMonthTotals: [CategoryAccountingMonthTotal]) {

        self.categoryAccountingMonthTotals = categoryAccountingMonthTotals
        
    }

    func setUpCollectionView() {

        analysisCollectionView.helpRegister(cell: PieChartCVCell())

        analysisCollectionView.helpRegister(cell: BarChartCVCell())

        analysisCollectionView.helpRegister(cell: AccountingsCVCell())

        analysisCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }

}

extension AnalysisCVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PieChartCVCell.self),
                for: indexPath) as? PieChartCVCell else {
                    return UICollectionViewCell()
            }
            
            
            
            cell.pieChartUpdate(categoryAccountingMonthTotals: categoryAccountingMonthTotals)
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AccountingsCVCell.self),
                for: indexPath) as? AccountingsCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.initAccountsCVCell(haveHeader: false, accountings: [])
            
//            cell.goToAccountDetail = {
//
//                self.performSegue(withIdentifier: "goToCategoryAccountsDetailVC", sender: nil)
//
//            }
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: BarChartCVCell.self),
                for: indexPath) as? BarChartCVCell else {
                    return UICollectionViewCell()
            }
            
            cell.barChartUpdate()
            
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
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 || indexPath.section == 2 {
            
            return CGSize(width: 320, height: 320)
            
        } else {
            
            return CGSize(width: 382, height: 56 * 9)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
