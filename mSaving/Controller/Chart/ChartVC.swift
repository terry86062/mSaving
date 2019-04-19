//
//  ChartVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Charts

import BetterSegmentedControl

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

    @IBOutlet weak var incomeExpenseSegmentedC: BetterSegmentedControl!
    
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
    
    var categoryAccountingMonthTotalArray: [[CategoryAccountingMonthTotal]] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()

        incomeExpenseSegmentedC.segments = LabelSegment.segments(
            withTitles: ["支出", "收入"],
            normalBackgroundColor: UIColor.white,
            normalFont: .systemFont(ofSize: 16),
            normalTextColor: UIColor.lightGray,
            selectedBackgroundColor: UIColor.mSYellow,
            selectedFont: .systemFont(ofSize: 16),
            selectedTextColor: UIColor.black)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        categoryAccountingMonthTotalArray = StorageManager.shared.categoryAccountingMonthTotalArray
        
    }

    func setUpCollectionView() {

        monthCollectionView.helpRegister(cell: MonthCVCell())

        analysisCollectionView.helpRegister(cell: AnalysisCVCell())

    }

}

extension ChartVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return categoryAccountingMonthTotalArray.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {

            guard let cell = monthCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MonthCVCell.self),
                for: indexPath) as? MonthCVCell else { return MonthCVCell() }
            
            if let month = categoryAccountingMonthTotalArray[indexPath.row].first?.month {
                
                cell.initMonthCVCell(year: "", month: String(month))
                
            }

//            if indexPath.row == 0 {
//
//                cell.shadowView.alpha = 1
//
//            }

            return cell

        } else {

            guard let cell = analysisCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AnalysisCVCell.self),
                for: indexPath) as? AnalysisCVCell else {
                    return AnalysisCVCell()
            }

            cell.initAnalysisCVCell(categoryAccountingMonthTotals: categoryAccountingMonthTotalArray[indexPath.row])

            return cell

        }

    }

}

extension ChartVC: UICollectionViewDelegate {

}

extension ChartVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == monthCollectionView {

            return UIEdgeInsets(top: 0,
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

            analysisCollectionView.bounds.origin.x = monthCollectionView.bounds.origin.x * 3

        } else if scrollView.isEqual(analysisCollectionView) {

            monthCollectionView.bounds.origin.x = analysisCollectionView.bounds.origin.x / 3

            let row = Int((analysisCollectionView.bounds.origin.x +
                            analysisCollectionView.frame.width / 2) /
                            analysisCollectionView.frame.width)

            guard let cell = monthCollectionView.cellForItem(
                at: IndexPath(
                    row: Int((analysisCollectionView.bounds.origin.x +
                                analysisCollectionView.frame.width / 2) /
                                analysisCollectionView.frame.width),
                    section: 0)) as? MonthCVCell else { return }

            UIView.animate(withDuration: 0.5, animations: {

                cell.shadowView.alpha = 1

            })

            switch row {

            case 0:

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((analysisCollectionView.bounds.origin.x +
                                    analysisCollectionView.frame.width / 2) /
                                    analysisCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            case testData.count:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((analysisCollectionView.bounds.origin.x +
                                    analysisCollectionView.frame.width / 2) /
                                    analysisCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

            default:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((analysisCollectionView.bounds.origin.x +
                                    analysisCollectionView.frame.width / 2) /
                                    analysisCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((analysisCollectionView.bounds.origin.x +
                                    analysisCollectionView.frame.width / 2) /
                                    analysisCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            }

        }

    }

}
