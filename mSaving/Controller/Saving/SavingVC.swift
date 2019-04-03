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
    
    func setUpCollectionView() {
        
        savingCollectionView.helpRegister(cell: SavingCVCell())
        
        monthCollectionView.helpRegister(cell: MonthCVCell())
        
    }
    
}

extension SavingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return testData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == monthCollectionView {
            
            guard let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthCVCell.self), for: indexPath) as? MonthCVCell else { return MonthCVCell() }
            
            cell.initMonthCVCell(month: testData[indexPath.row].month)
            
            return cell
            
        } else {
            
            guard let cell = savingCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SavingCVCell.self), for: indexPath) as? SavingCVCell else { return SavingCVCell() }
            
            return cell
            
        }
        
    }
    
}

extension SavingVC: UICollectionViewDelegate {
    
}

extension SavingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == monthCollectionView {
            
            return UIEdgeInsets(top: 0, left: monthCollectionView.frame.width / 3, bottom: 0, right: 0)
            
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == monthCollectionView {
            
            return CGSize(width: UIScreen.main.bounds.width / 3, height: 43.fitScreen)
            
        } else {
            
            return CGSize(width: savingCollectionView.frame.width, height: savingCollectionView.frame.height)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
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
        
        if scrollView.isEqual(monthCollectionView), scrollView.isDragging {
            var offset = savingCollectionView.contentOffset
            offset.x = monthCollectionView.contentOffset.x * 3
            savingCollectionView.setContentOffset(offset, animated: false)
        } else if scrollView.isEqual(savingCollectionView), scrollView.isDragging {
            var offset = monthCollectionView.contentOffset
            offset.x = savingCollectionView.contentOffset.x / 3
            monthCollectionView.setContentOffset(offset, animated: false)
        }
        
    }
    
}
