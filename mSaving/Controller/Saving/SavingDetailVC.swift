//
//  SavingDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingDetailVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var monthCollectionView: UICollectionView! {

        didSet {

            monthCollectionView.dataSource = self

            monthCollectionView.delegate = self

        }

    }

    @IBOutlet weak var savingDetailCollectionView: UICollectionView! {

        didSet {

            savingDetailCollectionView.dataSource = self

            savingDetailCollectionView.delegate = self

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

    var gesture: UIGestureRecognizer?

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()

        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))

        edgePan.edges = .left

        edgePan.delegate = self

        view.addGestureRecognizer(edgePan)

    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        let gestureArray: [AnyObject] = self.navigationController!.view.gestureRecognizers!

        for gesture in gestureArray {

            if gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self) {

                guard let aGesture = gesture as? UIGestureRecognizer else { return }
                self.savingDetailCollectionView.panGestureRecognizer.require(toFail: aGesture)

                break

            }

        }

    }

    func setUpCollectionView() {

        savingDetailCollectionView.helpRegister(cell: SavingCVCell())

        monthCollectionView.helpRegister(cell: MonthCVCell())

    }

    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {

        if recognizer.state == .recognized {

            self.navigationController?.popViewController(animated: true)

        }

    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return false

    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {

        return false

    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true

    }

}

extension SavingDetailVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == monthCollectionView || collectionView == savingDetailCollectionView {

            return testData.count

        } else {

            return 9

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == monthCollectionView {

            guard let cell = monthCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MonthCVCell.self),
                for: indexPath) as? MonthCVCell else { return MonthCVCell() }

            cell.initMonthCVCell(month: testData[indexPath.row].month)

            if indexPath.row == 0 {

                cell.shadowView.alpha = 0.5

            }

            return cell

        } else if collectionView == savingDetailCollectionView {

            guard let cell = savingDetailCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingCVCell.self),
                for: indexPath) as? SavingCVCell else { return SavingCVCell() }

            cell.initSavingCVCell(dataSource: self, delegate: self)

            return cell

        } else {

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SavingDetailCVCell.self),
                for: indexPath) as? SavingDetailCVCell else {
                    return SavingDetailCVCell()
            }

            cell.showSavingDetailAdd = {

                self.performSegue(withIdentifier: "showSavingDetailAddVC", sender: nil)

            }

            return cell

        }

    }

}

extension SavingDetailVC: UICollectionViewDelegate {

}

extension SavingDetailVC: UICollectionViewDelegateFlowLayout {

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

        } else if collectionView == savingDetailCollectionView {

            return CGSize(width: savingDetailCollectionView.frame.width,
                          height: savingDetailCollectionView.frame.height)

        } else {

            return CGSize(width: 382.fitScreen, height: 112.fitScreen)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == monthCollectionView || collectionView == savingDetailCollectionView {

            return 0

        } else {

            return 16

        }

    }

}

extension SavingDetailVC {

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

            savingDetailCollectionView.bounds.origin.x = monthCollectionView.bounds.origin.x * 3

        } else if scrollView.isEqual(savingDetailCollectionView) {

            monthCollectionView.bounds.origin.x = savingDetailCollectionView.bounds.origin.x / 3

            let row = Int((savingDetailCollectionView.bounds.origin.x +
                            savingDetailCollectionView.frame.width / 2) /
                            savingDetailCollectionView.frame.width)

            guard let cell = monthCollectionView.cellForItem(
                at: IndexPath(
                    row: Int((savingDetailCollectionView.bounds.origin.x +
                                savingDetailCollectionView.frame.width / 2) /
                                savingDetailCollectionView.frame.width),
                    section: 0)) as? MonthCVCell else { return }

            UIView.animate(withDuration: 0.5, animations: {

                cell.shadowView.alpha = 0.5

            })

            switch row {

            case 0:

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingDetailCollectionView.bounds.origin.x +
                                    savingDetailCollectionView.frame.width / 2) /
                                    savingDetailCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            case testData.count:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingDetailCollectionView.bounds.origin.x +
                                    savingDetailCollectionView.frame.width / 2) /
                                    savingDetailCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

            default:

                guard let cell2 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingDetailCollectionView.bounds.origin.x +
                                    savingDetailCollectionView.frame.width / 2) /
                                    savingDetailCollectionView.frame.width) - 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell2.shadowView.alpha = 0

                })

                guard let cell3 = monthCollectionView.cellForItem(
                    at: IndexPath(
                        row: Int((savingDetailCollectionView.bounds.origin.x +
                                    savingDetailCollectionView.frame.width / 2) /
                                    savingDetailCollectionView.frame.width) + 1,
                        section: 0)) as? MonthCVCell else { return }

                UIView.animate(withDuration: 0.5, animations: {

                    cell3.shadowView.alpha = 0

                })

            }

        }

    }

}
