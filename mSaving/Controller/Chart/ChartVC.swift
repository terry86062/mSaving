//
//  ChartVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class ChartVC: UIViewController {

    @IBOutlet weak var monthCollectionView: UICollectionView! {

        didSet {

            monthCollectionView.dataSource = self

            monthCollectionView.delegate = self

        }

    }

    @IBOutlet weak var analysisCollectionView: UICollectionView! {

        didSet {

            analysisCollectionView.dataSource = self

            analysisCollectionView.delegate = self

        }

    }
    
    @IBOutlet weak var expenseIncomeButton: UIButton!
    
    let notificationManager = MSNotificationManager()
    
    var firstAppear = true
    
    var months: [Month] = []
    
    var selectedCategoryMonthTotal: CategoryMonthTotal?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        fetchData()
        
        setUpNotification()
        
    }
    
    func setUpCollectionView() {
        
        monthCollectionView.helpRegister(cell: MonthCVCell())
        
        analysisCollectionView.helpRegister(cell: AnalysisCVCell())
        
    }
    
    func fetchData() {

        months = MonthProvider().months
        
    }
    
    func setUpNotification() {
        
        notificationManager.addAccountingNotification(changeHandler: { [weak self] in
            
            self?.fetchData()
            
            self?.monthCollectionView.reloadData()
            
            self?.analysisCollectionView.reloadData()
            
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if firstAppear {
            
            showCorrectCollectionView()
            
            firstAppear = false
            
        }
        
    }
    
    func showCorrectCollectionView() {
        
        if months == [] {
            
            helpSetShadowAlpha(row: 0, show: true)
            
        } else {
            
            let indexPath = IndexPath(item: months.count - 1, section: 0)
            
            analysisCollectionView.scrollToItem(at: indexPath,
                                                at: [.centeredVertically, .centeredHorizontally],
                                                animated: false)
            
            helpSetShadowAlpha(row: 0, show: true)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCategoryAccountsDetailVC" {
            
            guard let categoryAccountingsDetailVC = segue.destination as? CategoryAccountingsDetailVC else { return }
            
            categoryAccountingsDetailVC.selectedCategoryMonthTotal = selectedCategoryMonthTotal
            
        }
        
    }
    
    @IBAction func changeExpenseIncome(_ sender: UIButton) {
        
        expenseIncomeButton.isSelected = !expenseIncomeButton.isSelected
        
        monthCollectionView.reloadData()
        
        analysisCollectionView.reloadData()
        
    }
    
}

extension ChartVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard months != [] else { return 1 }
        
        return months.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {

            guard let cell = monthCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MonthCVCell.self),
                for: indexPath) as? MonthCVCell else { return MonthCVCell() }
            
            guard months != [] else { return cell }
            
            cell.initMonthCVCell(month: months[indexPath.row])

            return cell

        } else {

            guard let cell = analysisCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AnalysisCVCell.self),
                for: indexPath) as? AnalysisCVCell else { return AnalysisCVCell() }

            if months != [] {
                
                cell.initAnalysisCVCell(month: months[indexPath.row], isIncome: expenseIncomeButton.isSelected)
                
            }
            
            cell.touchCategoryHandler = {
                
                self.selectedCategoryMonthTotal = cell.selectedCategoryMonthTotal
                
                self.performSegue(withIdentifier: "goToCategoryAccountsDetailVC", sender: nil)
                
            }
            
            cell.analysisCollectionView.reloadData()

            return cell

        }

    }

}

extension ChartVC: UICollectionViewDelegate { }

extension ChartVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == monthCollectionView {

            return UIEdgeInsets(top: 0, left: monthCollectionView.frame.width / 3,
                                bottom: 0, right: monthCollectionView.frame.width / 3)

        } else {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == monthCollectionView {

            return CGSize(width: monthCollectionView.frame.width / 3, height: 32)

        } else {

            return CGSize(width: analysisCollectionView.frame.width, height: analysisCollectionView.frame.height)

        }

    }

}

extension ChartVC {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == monthCollectionView {

            // Simulate "Page" Function

            let pageWidth: Float = Float(monthCollectionView.frame.width / 3)
            
            let currentOffset: Float = Float(scrollView.contentOffset.x)
            
            let targetOffset: Float = Float(targetContentOffset.pointee.x)
            
            var newTargetOffset: Float = 0
            
            if targetOffset > currentOffset {
                
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
                
            } else {
                
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
                
            }
            
            if newTargetOffset < 0 {
                
                newTargetOffset = 0
                
            } else if newTargetOffset > Float(scrollView.contentSize.width) {
                
                newTargetOffset = Float(Float(scrollView.contentSize.width))
                
            }

            targetContentOffset.pointee.x = CGFloat(currentOffset)
            
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset),
                                                y: scrollView.contentOffset.y), animated: true)

        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        monthCollectionView.bounds.origin.x = analysisCollectionView.bounds.origin.x / 3
        
        let originX = analysisCollectionView.bounds.origin.x
        
        let width = analysisCollectionView.frame.width
        
        let row = Int(originX / width + 0.5)
        
        helpSetShadowAlpha(row: row, show: true)
        
        switch row {
            
        case 0:
            
            helpSetShadowAlpha(row: row + 1, show: false)
            
        case months.count - 1:
            
            helpSetShadowAlpha(row: row - 1, show: false)
            
        default:
            
            helpSetShadowAlpha(row: row - 1, show: false)
            
            helpSetShadowAlpha(row: row + 1, show: false)
            
        }

    }
    
    func helpSetShadowAlpha(row: Int, show: Bool) {
        
        guard let cell = monthCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
            as? MonthCVCell else { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            if show {
                
                cell.shadowView.alpha = 1
                
            } else {
                
                cell.shadowView.alpha = 0
                
            }
            
        })
        
    }

}
