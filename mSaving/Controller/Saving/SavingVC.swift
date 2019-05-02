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
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var editingButton: UIButton!
    
    let notificationManager = MSNotificationManager()
    
    let viewContext = CoreDataManager.shared.viewContext
    
    var showAccounting = true
    
    var firstAppear = true
    
    var firstSetColor = true
    
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
        
        notificationManager.addAllNotification(changeHandler: { [weak self] in
            
            self?.fetchData()
            
            self?.monthCollectionView.reloadData()
            
            self?.savingCollectionView.reloadData()
            
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
            
            let dataComponents = TimeManager().transform(date: Date())
            
            guard let year = dataComponents.year else { return }
            
            yearLabel.text = "\(year)"
            
        } else {
            
            let indexPath = IndexPath(item: months.count - 1, section: 0)
            
            savingCollectionView.scrollToItem(at: indexPath,
                                              at: [.centeredVertically, .centeredHorizontally],
                                              animated: false)
            
            helpSetShadowAlpha(row: indexPath.row, show: true)
            
            setUpSelectedSaving(row: indexPath.row)
            
            setUpSelectedMonth(row: indexPath.row)
            
            if indexPath.row == 0 {
                
                helpSetShadowAlpha(row: 0, show: true)
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let row = savingCollectionView.contentOffset.x / savingCollectionView.frame.width
        
        setUpSelectedMonth(row: Int(row))
        
        setUpSelectedSaving(row: Int(row))
        
        if segue.identifier == "goToSavingGoalSetVC" {
            
            helpHideTabBarVCBlackView()
            
            guard let savingGoalSetVC = segue.destination as? SavingGoalSetVC else { return }
            
            savingGoalSetVC.selectedMonth = selectedMonth
            
            savingGoalSetVC.selectedSaving = selectedSaving
            
        } else if segue.identifier == "goToSavingDetailNew" {
            
            helpHideTabBarVCBlackView()
            
            guard let savingDetailAddVC = segue.destination as? SavingDetailAddVC else { return }
            
            savingDetailAddVC.selectedMonth = selectedMonth
            
        } else if segue.identifier == "goToSavingDetailEdit" {
            
            helpHideTabBarVCBlackView()
            
            guard let savingDetailAddVC = segue.destination as? SavingDetailAddVC else { return }
            
            savingDetailAddVC.selectedMonth = selectedMonth
            
            savingDetailAddVC.selectedSavingDetail = selectedSavingDetail
            
        }
        
    }
    
    func helpHideTabBarVCBlackView() {
        
        guard let tabBarVC = tabBarController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = false
        
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
            
            if indexPath.row == months.count - 1 && firstSetColor {
                
                cell.shadowView.alpha = 1
                
                firstSetColor = false
                
            }
            
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
                
//                self.searchButton.isHidden = !cell.showAccounting
                
                self.editingButton.isHidden = cell.showAccounting
                
                self.savingCollectionView.reloadData()
                
            }
            
            cell.presentSavingDetailNew = {
                
                if self.months != [] {
                    
                    self.selectedMonth = self.months[indexPath.row]
                    
                }
                
                self.performSegue(withIdentifier: "goToSavingDetailNew", sender: nil)
                
            }
            
            cell.presentSavingDetailEdit = {
                
                if self.months != [] {
                    
                    self.selectedMonth = self.months[indexPath.row]
                    
                }
                
                self.selectedSavingDetail = cell.selectedSavingDetail
                
                self.performSegue(withIdentifier: "goToSavingDetailEdit", sender: nil)
                
            }
            
            cell.goToAccountDetail = {
                
                guard let accountingVC = UIStoryboard.accounting.instantiateInitialViewController()
                    as? AccountingVC else { return }
                
                self.selectedAccounting = cell.selectedAccounting
                
                accountingVC.selectedAccounting = self.selectedAccounting
                
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

            return CGSize(width: monthCollectionView.frame.width / 3, height: 32)

        } else {

            return CGSize(width: savingCollectionView.frame.width, height: savingCollectionView.frame.height)

        }

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
                
                guard let year = cell.month?.year else { return }
                
                self.yearLabel.text = "\(year)"
                
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
