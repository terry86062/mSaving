//
//  ChartVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class ChartVC: MonthVC {
    
    @IBOutlet weak var expenseIncomeButton: UIButton!
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pushChartDetailVC" {
            
            guard let chartDetailVC = segue.destination as? ChartDetailVC else { return }
            
            chartDetailVC.selectedCategoryMonthTotal = selectedCategoryMonthTotal
            
        }
        
    }
    
    @IBAction func changeExpenseIncome(_ sender: UIButton) {
        
        expenseIncomeButton.isSelected = !expenseIncomeButton.isSelected
        
        dataCollectionView.reloadData()
        
    }
    
}

extension ChartVC {

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {
            
            return super.collectionView(collectionView, cellForItemAt: indexPath)

        } else {

            guard let cell = dataCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AnalysisCVCell.self),
                for: indexPath) as? AnalysisCVCell else { return AnalysisCVCell() }

            if months != [] {
                
                cell.initAnalysisCVCell(isIncome: expenseIncomeButton.isSelected,
                                        month: months[indexPath.row], delegate: self)
                
            } else {
                
                cell.initAnalysisCVCell(isIncome: expenseIncomeButton.isSelected,
                                        month: nil, delegate: self)
                
            }
            
            cell.analysisCollectionView.reloadData()

            return cell

        }

    }

}

extension ChartVC: AnalysisCVCellDelegate {
    
    func touch(categoryMonthTotal: CategoryMonthTotal?) {
        
        selectedCategoryMonthTotal = categoryMonthTotal

        performSegue(withIdentifier: "pushChartDetailVC", sender: nil)
        
    }
    
}
