//
//  AccountingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

import FSCalendar

import BetterSegmentedControl

struct SubCategory {

    let imageName: String

    let name: String

}

class AccountingVC: UIViewController, UIGestureRecognizerDelegate, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(
            target: self.calendar,
            action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var selectedSubCategoryImageView: UIImageView!
    
    @IBOutlet var keyboardToolBar: UIToolbar!

    @IBOutlet weak var incomeExpenseSegmentedC: BetterSegmentedControl!

    @IBOutlet weak var incomeExpenseCollectionView: UICollectionView! {

        didSet {

            incomeExpenseCollectionView.dataSource = self

            incomeExpenseCollectionView.delegate = self

            setUpCollectionView()

        }

    }

    func setUpCollectionView() {

        incomeExpenseCollectionView.helpRegister(cell: IncomeExpenseCVCell())

    }

    var selectedSubCategory: ExpenseCategory?

    var subCategorys: [ExpenseCategory] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }

        self.calendar.select(Date())

        self.view.addGestureRecognizer(self.scopeGesture)
//        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week

        incomeExpenseSegmentedC.segments = LabelSegment.segments(
            withTitles: ["支出", "收入", "移轉"],
            normalBackgroundColor: UIColor.white,
            normalFont: .systemFont(ofSize: 16),
            normalTextColor: UIColor.lightGray,
            selectedBackgroundColor: UIColor.mSYellow,
            selectedFont: .systemFont(ofSize: 16),
            selectedTextColor: UIColor.black)

        incomeExpenseSegmentedC.addTarget(
            self,
            action: #selector(navigationSegmentedControlValueChanged(_:)),
            for: .valueChanged)

        amountTextField.inputAccessoryView = keyboardToolBar

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        guard let subCategorys = StorageManager.shared.fetchCategory() else { return }
        
        self.subCategorys = subCategorys

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        amountTextField.becomeFirstResponder()

    }

    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {

        if incomeExpenseCollectionView.isDragging == false {

            if sender.index == 0 {

                UIView.animate(withDuration: 0.1, animations: {

                    self.incomeExpenseCollectionView.bounds.origin.x = 0

                })

            } else if sender.index == 1 {

                UIView.animate(withDuration: 0.1, animations: {

                    self.incomeExpenseCollectionView.bounds.origin.x = 386

                })

            } else if sender.index == 2 {

                UIView.animate(withDuration: 0.1, animations: {

                    self.incomeExpenseCollectionView.bounds.origin.x = 772

                })

            }

        }

    }

    @IBAction func dismissKeyboard(_ sender: UIButton) {

        amountTextField.resignFirstResponder()

    }

    @IBAction func addAccounting(_ sender: UIBarButtonItem) {
        
        guard let text = amountTextField.text, let amount = Int64(text), amount != 0 else { return }
        
        guard let selectedSubCategory = selectedSubCategory else { return }

        StorageManager.shared.saveAccounting(amount: amount,
                                             accountName: "現金",
                                             selectedSubCategory: selectedSubCategory)

    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
//        if shouldBegin {
//            let velocity = self.scopeGesture.velocity(in: self.view)
//            switch self.calendar.scope {
//            case .month:
//                return velocity.y < 0
//            case .week:
//                return velocity.y > 0
//            }
//        }
//        return shouldBegin

        return true
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height

        print("boundingRectWillChange")

        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }

    @IBAction func dismiss(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

    }

}

extension AccountingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == incomeExpenseCollectionView {

            return 3

        } else {

            return subCategorys.count

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == incomeExpenseCollectionView {

            guard let cell = incomeExpenseCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: IncomeExpenseCVCell.self),
                for: indexPath) as? IncomeExpenseCVCell else {
                    return IncomeExpenseCVCell()
            }

            cell.initSavingCVCell(dataSource: self, delegate: self)

            return cell

        } else {

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategorySelectCVCell.self),
                for: indexPath) as? CategorySelectCVCell else {
                    return CategorySelectCVCell()
            }
            
            let aSubCategory = subCategorys[indexPath.row]
            
            guard let iconName = aSubCategory.iconName,
                let name = aSubCategory.name,
                let color = aSubCategory.color else { return cell }
                
            cell.initCategorySelectCVCell(imageName: iconName, subCategoryName: name, hex: color)
            
            cell.selectSubCategory = {
                
                self.selectedSubCategory = aSubCategory
                
                self.selectedSubCategoryImageView.image = UIImage(named: iconName)
                
                self.selectedSubCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                
            }

            return cell

        }

    }

}

extension AccountingVC: UICollectionViewDelegate {

}

extension AccountingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == incomeExpenseCollectionView {

            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        } else {

            return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == incomeExpenseCollectionView {

            return CGSize(width: 374, height: 240)

        } else {

            return CGSize(width: 32, height: 76)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == incomeExpenseCollectionView {

            return 12

        } else {

            return 0

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == incomeExpenseCollectionView {

            return 0

        } else {

            return 40

        }

    }

}

extension AccountingVC {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == incomeExpenseCollectionView {

            // Simulate "Page" Function

            let pageWidth: Float = Float(386)
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

        if scrollView.isEqual(incomeExpenseCollectionView) {

            let move = incomeExpenseCollectionView.bounds.origin.x

            print((move + 193) / 386)

            if (move + 193) / 386 < 1 {

                incomeExpenseSegmentedC.setIndex(0, animated: true)

            } else if (move + 193) / 386 >= 1 && (move + 193) / 386 < 2 {

                incomeExpenseSegmentedC.setIndex(1, animated: true)

            } else if (move + 193) / 386 >= 2 {

                incomeExpenseSegmentedC.setIndex(2, animated: true)

            }

        }

    }

}
