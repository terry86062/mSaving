//
//  MonthVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/8.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MonthVC: UIViewController {

    @IBOutlet weak var monthCollectionView: UICollectionView! {
        
        didSet {
            
            monthCollectionView.dataSource = self
            
            monthCollectionView.delegate = self
            
        }
        
    }
    
    @IBOutlet weak var dataCollectionView: UICollectionView! {
        
        didSet {
            
            dataCollectionView.dataSource = self
            
            dataCollectionView.delegate = self
            
        }
        
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    
    let notificationManager = NotificationManager()
    
    var firstAppear = true
    
    var months: [Month] = []
    
    var selectedMonth: Month?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        fetchData()
        
        setUpNotification()
        
    }
    
    func setUpCollectionView() {
        
        monthCollectionView.helpRegister(cell: MonthCVCell())
        
        dataCollectionView.helpRegister(cell: SavingCVCell())
        
        dataCollectionView.helpRegister(cell: AnalysisCVCell())
        
    }
    
    func fetchData() {
        
        months = MonthProvider().months
        
    }
    
    func setUpNotification() {
        
        notificationManager.addAccountingNotification(changeHandler: { [weak self] _ in
            
            self?.fetchData()
            
            self?.monthCollectionView.reloadData()
            
            self?.dataCollectionView.reloadData()
            
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
            
            yearLabel.text = "\(TimeManager().todayYear)"
            
        } else {
            
            let indexPath = IndexPath(item: months.count - 1, section: 0)
            
            dataCollectionView.scrollToItem(at: indexPath,
                                            at: [.centeredVertically, .centeredHorizontally],
                                            animated: false)
            
        }
        
    }
    
}

extension MonthVC: UICollectionViewDataSource {
    
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
            
            if findShowRow() == indexPath.row {
                
                cell.shadowView.alpha = 1
                
            } else {
                
                cell.shadowView.alpha = 0
                
            }
            
            guard months != [] else { return cell }
            
            cell.initMonthCVCell(month: months[indexPath.row])
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
}

extension MonthVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == monthCollectionView {
            
            return UIEdgeInsets(top: 0, left: monthCollectionView.frame.width / 3,
                                bottom: 0, right: monthCollectionView.frame.width / 3)
            
        } else {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == monthCollectionView {
            
            return CGSize(width: monthCollectionView.frame.width / 3, height: 32)
            
        } else {
            
            return CGSize(width: dataCollectionView.frame.width, height: dataCollectionView.frame.height)
            
        }
        
    }
    
}

extension MonthVC {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == monthCollectionView {
            
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
        
        monthCollectionView.bounds.origin.x = dataCollectionView.bounds.origin.x / 3
        
        let row = findShowRow()
        
        helpSetShadowAlpha(row: row, show: true)
        
        setUpSelectedMonth(row: row)
        
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
    
    func findShowRow() -> Int {
        
        let originX = dataCollectionView.bounds.origin.x
        
        let width = dataCollectionView.frame.width
        
        return Int(originX / width + 0.5)
        
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
    
}
