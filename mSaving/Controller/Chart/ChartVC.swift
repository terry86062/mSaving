//
//  ChartVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Charts

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
    
    let notificationManager = MSNotificationManager()
    
    var categoryAccountingMonthTotalArray: [[CategoryMonthTotal]] = []
    
    var accountingWithDateGroupArray: [[[AccountingWithDate]]] = []
    
    var selectedCategoryAccountingMonthTotal: CategoryMonthTotal?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        fetchData()
        
        notificationManager.addNotificationForRenew(collectionView: analysisCollectionView) { [weak self] in
            
            self?.fetchData()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: categoryAccountingMonthTotalArray.count - 1, section: 0)
        
        analysisCollectionView.scrollToItem(at: indexPath,
                                            at: [.centeredVertically, .centeredHorizontally],
                                            animated: false)
        
        guard let cell = monthCollectionView.cellForItem(at:
            indexPath) as? MonthCVCell else { return }
        
        cell.shadowView.alpha = 1
        
    }
    
    func setUpCollectionView() {

        monthCollectionView.helpRegister(cell: MonthCVCell())

        analysisCollectionView.helpRegister(cell: AnalysisCVCell())

    }
    
    func fetchData() {
        
        categoryAccountingMonthTotalArray = AccountingProvider().categoriesMonthTotalGroup
        
        accountingWithDateGroupArray = AccountingProvider().accountingsWithDateGroup
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCategoryAccountsDetailVC" {
            
            guard let categoryAccountingsDetailVC = segue.destination as? CategoryAccountingsDetailVC else { return }
            
            categoryAccountingsDetailVC.selectedCategoryAccountingMonthTotal = selectedCategoryAccountingMonthTotal
            
        }
        
    }

}

extension ChartVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard categoryAccountingMonthTotalArray.count != 0 else { return 1 }
        
        return categoryAccountingMonthTotalArray.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {

            guard let cell = monthCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MonthCVCell.self),
                for: indexPath) as? MonthCVCell else { return MonthCVCell() }
            
            if categoryAccountingMonthTotalArray.count == 0 {
                
                let dateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
                
                guard let month = dateComponents.month, let year = dateComponents.year else { return cell }
                
                cell.initMonthCVCell(year: "\(year)", month: "\(month)")
                
            } else {
                
                guard let month = categoryAccountingMonthTotalArray[indexPath.row].first?.month,
                    let year = categoryAccountingMonthTotalArray[indexPath.row].first?.year else {
                        return cell
                }
                
                cell.initMonthCVCell(year: "\(year)", month: "\(month)")
                
            }

            return cell

        } else {

            guard let cell = analysisCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AnalysisCVCell.self),
                for: indexPath) as? AnalysisCVCell else { return AnalysisCVCell() }

            cell.initAnalysisCVCell(categoryAccountingMonthTotals: categoryAccountingMonthTotalArray[indexPath.row],
                                    accountingWithDateArray: accountingWithDateGroupArray[indexPath.row])
            
            cell.touchCategoryHandler = {
                
                self.selectedCategoryAccountingMonthTotal = cell.selectedCategoryAccountingMonthTotal
                
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

            return CGSize(width: UIScreen.main.bounds.width / 3, height: 43.fitScreen)

        } else {

            return CGSize(width: 414, height: analysisCollectionView.frame.height)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

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
            
        case categoryAccountingMonthTotalArray.count - 1:
            
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
