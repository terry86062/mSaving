//
//  SavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

struct AccountingWithDate {
    let accounting: Accounting
    let date: Date
    let dateComponents: DateComponents
}

struct SavingWithDate {
    let saving: Saving
    let date: Date
    let dateComponents: DateComponents
}

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
    
    var accountingWithDateGroupArray: [[[AccountingWithDate]]] = []
    
    var savingWithDateGroupArray: [[SavingWithDate]] = []
    
    var selectedYear = ""
    
    var selectedMonth = ""
    
    var selectedSaving: SavingWithDate?
    
    var selectedSavingDetail: SavingWithDate?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let accountingArray = CoreDataManager.shared.fetchAccounting() else { return }
        
        var accountingWithDateArray: [AccountingWithDate] = []
        
        if accountingArray.count > 0 {
            
            for index in 0...accountingArray.count - 1 {
                
                let date = Date(timeIntervalSince1970: TimeInterval(accountingArray[index].occurDate))
                
                accountingWithDateArray.append(
                    AccountingWithDate(accounting: accountingArray[index],
                                       date: date,
                                       dateComponents: Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
                    )
                )
                
            }
            
            for index in 0...accountingWithDateArray.count - 1 {
                
                if index == 0 {
                    
                    accountingWithDateGroupArray.append([[accountingWithDateArray[index]]])
                    
                } else {
                    
                    if accountingWithDateArray[index].dateComponents.month == accountingWithDateArray[index - 1].dateComponents.month &&
                        accountingWithDateArray[index].dateComponents.day == accountingWithDateArray[index - 1].dateComponents.day {
                        
                        let temp = accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1]
                        
                        accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1][temp.count - 1].append(accountingWithDateArray[index])
                        
                    } else if accountingWithDateArray[index].dateComponents.month == accountingWithDateArray[index - 1].dateComponents.month {
                        
                        accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1].append([accountingWithDateArray[index]])
                        
                    } else {
                        
                        accountingWithDateGroupArray.insert([[accountingWithDateArray[index]]], at: 0)
                        
                    }
                    
                }
                
            }
            
        }
        
        print(accountingWithDateGroupArray)
        
        guard let savingArray = SavingProvider().savings else { return }
        
        var savingWithDateArray: [SavingWithDate] = []
        
        if savingArray.count > 0 {
            
            for index in 0...savingArray.count - 1 {
                
                let date = Date(timeIntervalSince1970: TimeInterval(savingArray[index].month))
                
                savingWithDateArray.append(
                    SavingWithDate(saving: savingArray[index],
                                   date: date,
                                   dateComponents: Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
                    )
                )
                
            }
            
            for index in 0...savingWithDateArray.count - 1 {
                
                if index == 0 {
                    
                    savingWithDateGroupArray.append([savingWithDateArray[index]])
                    
                } else {
                    
                    if savingWithDateArray[index].dateComponents.month == savingWithDateArray[index - 1].dateComponents.month {
                        
                        savingWithDateGroupArray[savingWithDateGroupArray.count - 1].append(savingWithDateArray[index])
                        
                    } else {
                        
                        savingWithDateGroupArray.insert([savingWithDateArray[index]], at: 0)
                        
                    }
                    
                }
                
            }
            
        }
        
        print(savingWithDateGroupArray)
        
        print(savingWithDateGroupArray.count)
        
        if accountingWithDateGroupArray.count == 0 {
            
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
            
            guard let month = dateComponents.month, let year = dateComponents.year else { return }
            
            selectedYear = "\(year)"
            
            selectedMonth = "\(month)"
            
            if savingWithDateGroupArray.count != 0 {
                
                selectedSaving = savingWithDateGroupArray[savingWithDateGroupArray.count - 1].first
                
            }
            
        } else {
            
            guard let year = accountingWithDateGroupArray.last?.first?.first?.dateComponents.year,
                let month = accountingWithDateGroupArray.last?.first?.first?.dateComponents.month else { return }
            
            selectedYear = "\(year)"
            
            selectedMonth = "\(month)"
            
            if savingWithDateGroupArray.count != 0 {
                
                for index in 0...savingWithDateGroupArray.count - 1 {
                    
                    if savingWithDateGroupArray[index].first?.dateComponents.year == year && savingWithDateGroupArray[index].first?.dateComponents.month == month {
                        
                        selectedSaving = savingWithDateGroupArray[index].first
                        
                    }
                    
                }
                
            }
            
        }
        
        monthCollectionView.reloadData()
        
        savingCollectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: accountingWithDateGroupArray.count - 1, section: 0)
        
        savingCollectionView.scrollToItem(at: indexPath,
                                          at: [.centeredVertically, .centeredHorizontally],
                                          animated: false)
        
        guard let cell = monthCollectionView.cellForItem(at:
            indexPath) as? MonthCVCell else { return }
        
        cell.shadowView.alpha = 1
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        accountingWithDateGroupArray = []
        
        savingWithDateGroupArray = []
        
    }

    func setUpCollectionView() {

        monthCollectionView.helpRegister(cell: MonthCVCell())

        savingCollectionView.helpRegister(cell: SavingCVCell())

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSavingGoalSetVC" {
            
            guard let tabBarVC = tabBarController as? TabBarController else { return }
            
            tabBarVC.blackView.isHidden = false
            
            guard let savingGoalSetVC = segue.destination as? SavingGoalSetVC else { return }
            
            savingGoalSetVC.selectedMonth = selectedMonth
            
            savingGoalSetVC.selectedYear = selectedYear
            
            savingGoalSetVC.selectedSaving = selectedSaving
            
        } else if segue.identifier == "goToSavingDetail" {
            
            guard let tabBarVC = tabBarController as? TabBarController else { return }
            
            tabBarVC.blackView.isHidden = false
            
            guard let savingDetailAddVC = segue.destination as? SavingDetailAddVC else { return }
            
            savingDetailAddVC.selectedMonth = selectedMonth
            
            savingDetailAddVC.selectedYear = selectedYear
            
            savingDetailAddVC.selectedSavingDetail = selectedSavingDetail
            
        }
        
    }

}

extension SavingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if accountingWithDateGroupArray.count == 0 {
            
            return 1
            
        } else {
            
            return accountingWithDateGroupArray.count
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {

            guard let cell = monthCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MonthCVCell.self),
                for: indexPath) as? MonthCVCell else { return MonthCVCell() }

            if accountingWithDateGroupArray.count == 0 {
                
                let dateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
                
                guard let month = dateComponents.month, let year = dateComponents.year else { return cell }
                
                cell.initMonthCVCell(year: "\(year)", month: "\(month)")
                
            } else {
                
                guard let month = accountingWithDateGroupArray[indexPath.row].first?.first?.dateComponents.month,
                    let year = accountingWithDateGroupArray[indexPath.row].first?.first?.dateComponents.year else {
                    return cell
                }
                
                cell.initMonthCVCell(year: "\(year)", month: "\(month)")
                
            }
            
            return cell

        } else {

            guard let cell = savingCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingCVCell.self),
                for: indexPath) as? SavingCVCell else { return SavingCVCell() }
            
            if accountingWithDateGroupArray.count == 0 {
                
                if savingWithDateGroupArray.count > 0 {
                
                    cell.initSavingCVCell(accountings: [], savings: savingWithDateGroupArray[indexPath.row])
                
                } else {
                    
                    cell.initSavingCVCell(accountings: [], savings: [])
                    
                }
                
            } else {
                
                if savingWithDateGroupArray.count > 0 {
                    
                    var count = 0
                    
                    for index in 0...savingWithDateGroupArray.count - 1 {
                        
                        if savingWithDateGroupArray[index].first?.dateComponents.month == accountingWithDateGroupArray[indexPath.row].first?.first?.dateComponents.month {
                            
                            cell.initSavingCVCell(accountings: accountingWithDateGroupArray[indexPath.row], savings: savingWithDateGroupArray[index])
                            
                            break
                            
                        } else {
                            
                            count += 1
                            
                        }
                        
                    }
                    
                    if count == savingWithDateGroupArray.count {
                        
                        cell.initSavingCVCell(accountings: accountingWithDateGroupArray[indexPath.row], savings: [])
                        
                    }
                    
                } else {
                    
                    cell.initSavingCVCell(accountings: accountingWithDateGroupArray[indexPath.row], savings: [])
                    
                }
                
            }
            
            cell.showSavingDetail = {
                
                self.searchButton.isHidden = true
                
                self.editingButton.isHidden = false
                
            }
            
            cell.showAccountingBack = {
                
                self.searchButton.isHidden = false
                
                self.editingButton.isHidden = true
                
            }
            
            cell.presentSavingDetailAdd = {
                
                self.selectedSavingDetail = nil
                
                self.performSegue(withIdentifier: "goToSavingDetail", sender: nil)
                
            }
            
            cell.editSavingDetailAdd = {
                
                self.selectedSavingDetail = cell.selectedSavingDetail
                
                self.performSegue(withIdentifier: "goToSavingDetail", sender: nil)
                
            }
            
            cell.goToAccountDetail = {
                
                guard let accountingVC = UIStoryboard.accounting.instantiateInitialViewController()
                    as? AccountingVC else { return }
                
                guard let accounting = cell.selectedAccounting else { return }
                
                self.navigationController?.pushViewController(accountingVC, animated: true)
                
                accountingVC.setAccountingRevise(occurDate: accounting.accounting.occurDate,
                                                 date: accounting.date,
                                                 amount: accounting.accounting.amount,
                                                 account: accounting.accounting.accountName?.name,
                                                 expenseCategory: accounting.accounting.expenseSubCategory,
                                                 incomeCategory: accounting.accounting.incomeSubCategory)
                
            }
            
            cell.savingAccountingCollectionView.reloadData()

            return cell

        }

    }

}

extension SavingVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        if collectionView != monthCollectionView && collectionView != savingCollectionView {

            cell.alpha = 0

            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })

        }

    }

}

extension SavingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == monthCollectionView {

            return UIEdgeInsets(
                top: 0,
                left: monthCollectionView.frame.width / 3,
                bottom: 0,
                right: monthCollectionView.frame.width / 3)

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

            let pageWidth: Float = Float(monthCollectionView.frame.width/3)
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

        if scrollView.isEqual(monthCollectionView) {

            savingCollectionView.bounds.origin.x = monthCollectionView.bounds.origin.x * 3

        } else if scrollView.isEqual(savingCollectionView) {

            monthCollectionView.bounds.origin.x = savingCollectionView.bounds.origin.x / 3

            let row = Int((savingCollectionView.bounds.origin.x +
                            savingCollectionView.frame.width / 2) /
                            savingCollectionView.frame.width)

            guard let cell = monthCollectionView.cellForItem(at: IndexPath(
                    row: Int((savingCollectionView.bounds.origin.x +
                                savingCollectionView.frame.width / 2) /
                                savingCollectionView.frame.width),
                    section: 0)) as? MonthCVCell else { return }

            UIView.animate(withDuration: 0.5, animations: {

                cell.shadowView.alpha = 1

                self.selectedMonth = cell.month
                
                self.selectedYear = cell.year
                
            })

            switch row {

            case 0:

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingCollectionView.bounds.origin.x +
                                    savingCollectionView.frame.width / 2) /
                                    savingCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            case accountingWithDateGroupArray.count:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingCollectionView.bounds.origin.x +
                                    savingCollectionView.frame.width / 2) /
                                    savingCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

            default:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingCollectionView.bounds.origin.x +
                                    savingCollectionView.frame.width / 2) /
                                    savingCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingCollectionView.bounds.origin.x +
                                    savingCollectionView.frame.width / 2) /
                                    savingCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            }

        }

    }

}
