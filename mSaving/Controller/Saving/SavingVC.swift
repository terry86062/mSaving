//
//  SavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingVC: MonthVC {
    
//    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var editingButton: UIButton!
    
    var selectedSaving: Saving?
    
    var selectedSubSaving: Saving?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        setUpSelectedMonth(row: findShowRow())
        
        setUpSelectedSaving(row: findShowRow())
        
        if segue.identifier == "presentMainSavingVC" {
            
            guard let mainSavingVC = segue.destination as? MainSavingVC else { return }
            
            mainSavingVC.selectedMonth = selectedMonth
            
            mainSavingVC.selectedSaving = selectedSaving
            
        } else if segue.identifier == "presentSubSavingVC" {
            
            guard let subSavingVC = segue.destination as? SubSavingVC else { return }
            
            subSavingVC.selectedMonth = selectedMonth
            
            subSavingVC.selectedSubSaving = selectedSubSaving
            
        }
        
    }
    
    func setUpSelectedSaving(row: Int) {
        
        guard let cell = dataCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
            as? SavingCVCell else { return }
        
        guard cell.savings != [] else {
            
            selectedSaving = nil
            
            return
            
        }
        
        selectedSaving = cell.savings[0]
        
    }

}

extension SavingVC {

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == monthCollectionView {
            
            return super.collectionView(collectionView, cellForItemAt: indexPath)

        } else {

            guard let cell = dataCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingCVCell.self),
                for: indexPath) as? SavingCVCell else { return SavingCVCell() }
            
            if months != [] {

                cell.initSavingCVCell(showAccounting: editingButton.isHidden, month: months[indexPath.row],
                                      delegate: self)

            } else {
                
                cell.initSavingCVCell(showAccounting: editingButton.isHidden, month: nil,
                                      delegate: self)
                
            }

            return cell

        }

    }

}

extension SavingVC: SavingCVCCellDelegate {
    
    func touchMain() {
        
        editingButton.isHidden = !editingButton.isHidden
        
        dataCollectionView.reloadData()
        
    }
    
    func touchSub(saving: Saving?) {
        
        selectedSubSaving = saving
        
        performSegue(withIdentifier: "presentSubSavingVC", sender: nil)
        
    }
    
    func touchAddSaving() {
        
        selectedSubSaving = nil
        
        performSegue(withIdentifier: "presentSubSavingVC", sender: nil)
        
    }
    
    func touch(accounting: Accounting?) {
        
        guard let accountingVC = UIStoryboard.accounting.instantiateInitialViewController()
            as? AccountingVC else { return }
        
        accountingVC.selectedAccounting = accounting
        
        present(accountingVC, animated: true, completion: nil)
        
    }
    
}
