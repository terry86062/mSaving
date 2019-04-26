//
//  SavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingVC: UIViewController {

    @IBOutlet weak var monthCollectionView: UICollectionView! {

        didSet {

            monthCollectionView.dataSource = self

            monthCollectionView.delegate = self

        }

    }

    @IBOutlet weak var savingCollectionView: UICollectionView! {

        didSet {

            savingCollectionView.dataSource = self

            savingCollectionView.delegate = self

        }

    }

    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var editingButton: UIButton!
    
    let notificationManager = MSNotificationManager()
    
    var showAccounting = true
    
    var months: [Month] = []
    
    var selectedMonth: Month?
    
    var selectedAccounting: Accounting?
    
    var selectedSaving: Saving?
    
    var selectedSavingDetail: Saving?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        fetchData()
        
        setUpNotification()
        
    }
    
    func setUpCollectionView() {
        
        monthCollectionView.helpRegister(cell: MonthCVCell())
        
        savingCollectionView.helpRegister(cell: SavingCVCell())
        
    }
    
    func fetchData() {
        
        months = MonthProvider().months
        
    }
    
    func setUpNotification() {
        
        let collectionViews: [UICollectionView] = [monthCollectionView, savingCollectionView]
        
        notificationManager.addNotificationForRenew(collectionView: collectionViews) { [weak self] in
            
            self?.fetchData()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        showCorrectCollectionView()
        
    }
    
    func showCorrectCollectionView() {
        
        guard months != [] else { return }
        
        let indexPath = IndexPath(item: months.count - 1, section: 0)
        
        savingCollectionView.scrollToItem(at: indexPath,
                                         at: [.centeredVertically, .centeredHorizontally],
                                         animated: false)
        
        if indexPath.row == 0 {
            
            helpSetShadowAlpha(row: 0, show: true)
            
            setUpSelectedSaving(row: 0)
            
            setUpSelectedMonth(row: 0)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSavingGoalSetVC" {
            
            helpHideTabBarVCBlackView()
            
            guard let savingGoalSetVC = segue.destination as? SavingGoalSetVC else { return }
            
            savingGoalSetVC.selectedMonth = selectedMonth
            
            savingGoalSetVC.selectedSaving = selectedSaving
            
        } else if segue.identifier == "goToSavingDetailNew" {
            
            helpHideTabBarVCBlackView()
            
        } else if segue.identifier == "goToSavingDetailEdit" {
            
            helpHideTabBarVCBlackView()
            
            guard let savingDetailAddVC = segue.destination as? SavingDetailAddVC else { return }
            
            savingDetailAddVC.selectedSavingDetail = selectedSavingDetail
            
        }
        
    }
    
    func helpHideTabBarVCBlackView() {
        
        guard let tabBarVC = tabBarController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = false
        
    }

}

extension SavingVC: UICollectionViewDataSource {

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

            guard let cell = savingCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingCVCell.self),
                for: indexPath) as? SavingCVCell else { return SavingCVCell() }
            
            if months != [] {

                cell.initSavingCVCell(showAccounting: showAccounting, month: months[indexPath.row])

            }
            
            cell.touchMainSaving = {
                
                self.showAccounting = cell.showAccounting
                
                self.searchButton.isHidden = !cell.showAccounting
                
                self.editingButton.isHidden = cell.showAccounting
                
                self.savingCollectionView.reloadData()
                
            }
            
            cell.presentSavingDetailNew = {
                
                self.performSegue(withIdentifier: "goToSavingDetailNew", sender: nil)
                
            }
            
            cell.presentSavingDetailEdit = {
                
                self.selectedSavingDetail = cell.selectedSavingDetail
                
                self.performSegue(withIdentifier: "goToSavingDetailEdit", sender: nil)
                
            }
            
            cell.goToAccountDetail = {
                
                guard let accountingVC = UIStoryboard.accounting.instantiateInitialViewController()
                    as? AccountingVC else { return }
                
                guard let accounting = cell.selectedAccounting else { return }
                
//                accountingVC.setAccountingRevise(occurDate: accounting.accounting.occurDate,
//                                                 date: accounting.date,
//                                                 amount: accounting.accounting.amount,
//                                                 account: accounting.accounting.accountName?.name,
//                                                 expenseCategory: accounting.accounting.expenseSubCategory,
//                                                 incomeCategory: accounting.accounting.incomeSubCategory)
                
                self.navigationController?.pushViewController(accountingVC, animated: true)
            
            }
            
            cell.savingAccountingCollectionView.reloadData()

            return cell

        }

    }

}

extension SavingVC: UICollectionViewDelegateFlowLayout {

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

            return CGSize(width: savingCollectionView.frame.width, height: savingCollectionView.frame.height)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

}

extension SavingVC {

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
        
        monthCollectionView.bounds.origin.x = savingCollectionView.bounds.origin.x / 3
        
        let originX = savingCollectionView.bounds.origin.x
        
        let width = savingCollectionView.frame.width
        
        let row = Int(originX / width + 0.5)
        
        helpSetShadowAlpha(row: row, show: true)
        
        setUpSelectedMonth(row: row)
        
        setUpSelectedSaving(row: row)
        
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
    
    func setUpSelectedMonth(row: Int) {
        
        guard let cell = monthCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
            as? MonthCVCell else { return }
        
        selectedMonth = cell.month
        
    }
    
    func setUpSelectedSaving(row: Int) {

        guard let cell = savingCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
            as? SavingCVCell else { return }
        
        guard cell.savings != [] else {
            
            selectedSaving = nil
            
            return
            
        }
        
        selectedSaving = cell.savings[0]

    }

}
