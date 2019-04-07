//
//  SavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

struct MonthData {
    
    let month: String
    
    let goal: String
    
    let spend: String
    
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
    
    var showAccount = true
    
    let testData: [MonthData] = [
        MonthData(month: "January", goal: "1000", spend: "100"),
        MonthData(month: "February", goal: "2000", spend: "200"),
        MonthData(month: "March", goal: "3000", spend: "300"),
        MonthData(month: "April", goal: "4000", spend: "400"),
        MonthData(month: "May", goal: "5000", spend: "500"),
        MonthData(month: "June", goal: "6000", spend: "600"),
        MonthData(month: "July", goal: "7000", spend: "700"),
        MonthData(month: "August", goal: "8000", spend: "800"),
        MonthData(month: "September", goal: "9000", spend: "900"),
        MonthData(month: "October", goal: "10000", spend: "1000"),
        MonthData(month: "November", goal: "11000", spend: "1100"),
        MonthData(month: "December", goal: "12000", spend: "1200")
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let indexPath = IndexPath(item: 3, section: 0)
        
        savingCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: false)
        
        guard let cell = monthCollectionView.cellForItem(at: IndexPath(row: 3, section: 0)) as? MonthCVCell else { return }
        
        cell.shadowView.alpha = 0.5
        
    }
    
    func setUpCollectionView() {
        
        monthCollectionView.helpRegister(cell: MonthCVCell())
        
        savingCollectionView.helpRegister(cell: SavingCVCell())
        
    }
    
}

extension SavingVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == monthCollectionView || collectionView == savingCollectionView {
            
            return testData.count
            
        } else {
            
            return 4
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == monthCollectionView {
            
            guard let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthCVCell.self), for: indexPath) as? MonthCVCell else { return MonthCVCell() }
            
            cell.initMonthCVCell(month: testData[indexPath.row].month)
            
//            if indexPath.row == 0 {
//                
//                cell.shadowView.alpha = 0.5
//                
//            }
            
            return cell
            
        } else if collectionView == savingCollectionView {
            
            guard let cell = savingCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SavingCVCell.self), for: indexPath) as? SavingCVCell else { return SavingCVCell() }
            
            cell.initSavingCVCell(dataSource: self, delegate: self)
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SavingGoalCVCell.self), for: indexPath) as? SavingGoalCVCell else { return SavingGoalCVCell() }
                
                cell.goToSavingGoalDetail = {
                    
                    if self.showAccount {
                        
                        self.showAccount = false
                        
                        self.searchButton.isHidden = true
                        
                        self.editingButton.isHidden = false
                        
                        var indexPath: [IndexPath] = []
                        
                        for i in 1...3 {
                            
                            indexPath.append(IndexPath(row: i, section: 0))
                            
                        }
                        
                        collectionView.reloadItems(at: indexPath)
                        
                    } else {
                        
                        self.showAccount = true
                        
                        self.searchButton.isHidden = false
                        
                        self.editingButton.isHidden = true
                        
                        var indexPath: [IndexPath] = []
                        
                        for i in 1...3 {
                            
                            indexPath.append(IndexPath(row: i, section: 0))
                            
                        }
                        
                        collectionView.reloadItems(at: indexPath)
                        
                    }
                    
                }
                
                return cell
                
            } else {
                
                if showAccount {
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountsCVCell.self), for: indexPath) as? AccountsCVCell else { return AccountsCVCell() }
                    
                    return cell
                    
                } else {
                    
                    if indexPath.row == 3 {
                        
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddSavingDetailCVCell.self), for: indexPath) as? AddSavingDetailCVCell else { return AddSavingDetailCVCell() }
                        
                        cell.showSavingDetailAdd = {
                            
                            self.performSegue(withIdentifier: "goToSavingDetailAdd", sender: nil)
                            
                        }
                        
                        return cell
                        
                    } else {
                        
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SavingDetailCVCell.self), for: indexPath) as? SavingDetailCVCell else { return SavingDetailCVCell() }
                        
                        cell.showSavingDetailAdd = {
                            
                            self.performSegue(withIdentifier: "goToSavingDetailEdit", sender: nil)
                            
                        }
                        
                        return cell
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension SavingVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == monthCollectionView {
            
            return UIEdgeInsets(top: 0, left: monthCollectionView.frame.width / 3, bottom: 0, right: monthCollectionView.frame.width / 3)
            
        } else if collectionView == savingCollectionView {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == monthCollectionView {
            
            return CGSize(width: UIScreen.main.bounds.width / 3, height: 43.fitScreen)
            
        } else if collectionView == savingCollectionView {
            
            return CGSize(width: savingCollectionView.frame.width, height: savingCollectionView.frame.height)
            
        } else {
            
            if indexPath.row == 0 {
                
                return CGSize(width: 382, height: 100)
                
            } else {
                
                if showAccount {
                    
                    return CGSize(width: 382, height: 56 * 6)
                    
                } else {
                    
                    if indexPath.row == 3 {
                        
                        return CGSize(width: 382, height: 56)
                        
                    } else {
                        
                        return CGSize(width: 382, height: 112)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == monthCollectionView || collectionView == savingCollectionView {
            
            return 0
            
        } else {
            
            return 16
            
        }
        
    }
    
}

extension SavingVC {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == monthCollectionView {
            
            // Simulate "Page" Function
            
            let pageWidth: Float = Float(monthCollectionView.frame.width/3)
            let currentOffset: Float = Float(scrollView.contentOffset.x)
            let targetOffset: Float = Float(targetContentOffset.pointee.x)
            var newTargetOffset: Float = 0
            if targetOffset > currentOffset {
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
            }
            else {
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
            }
            if newTargetOffset < 0 {
                newTargetOffset = 0
            }
            else if (newTargetOffset > Float(scrollView.contentSize.width)){
                newTargetOffset = Float(Float(scrollView.contentSize.width))
            }
            
            targetContentOffset.pointee.x = CGFloat(currentOffset)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(monthCollectionView) {
            
            savingCollectionView.bounds.origin.x = monthCollectionView.bounds.origin.x * 3
            
        } else if scrollView.isEqual(savingCollectionView) {
            
            monthCollectionView.bounds.origin.x = savingCollectionView.bounds.origin.x / 3
            
            let row = Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width)
            
            guard let cell = monthCollectionView.cellForItem(at: IndexPath(row: Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width), section: 0)) as? MonthCVCell else { return }
            
            UIView.animate(withDuration: 0.5, animations: {
                
                cell.shadowView.alpha = 0.5
                
            })
            
            switch row {
                
            case 0:
                
                guard let cell3 = monthCollectionView.cellForItem(at: IndexPath(row: Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width) + 1, section: 0)) as? MonthCVCell else { return }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    cell3.shadowView.alpha = 0
                    
                })
                
            case testData.count:
                
                guard let cell2 = monthCollectionView.cellForItem(at: IndexPath(row: Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width) - 1, section: 0)) as? MonthCVCell else { return }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    cell2.shadowView.alpha = 0
                    
                })
                
            default:
                
                guard let cell2 = monthCollectionView.cellForItem(at: IndexPath(row: Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width) - 1, section: 0)) as? MonthCVCell else { return }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    cell2.shadowView.alpha = 0
                    
                })
                
                guard let cell3 = monthCollectionView.cellForItem(at: IndexPath(row: Int((savingCollectionView.bounds.origin.x + savingCollectionView.frame.width / 2) / savingCollectionView.frame.width) + 1, section: 0)) as? MonthCVCell else { return }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    cell3.shadowView.alpha = 0
                    
                })
                
            }
            
        }
        
    }
    
}
