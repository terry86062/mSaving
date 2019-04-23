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
    
    @IBOutlet weak var selectedAccount: UIButton!
    
    @IBOutlet weak var deleteAccountingButton: UIButton!
    
    var selectedExpenseCategory: ExpenseCategory?
    
    var selectedIncomeCategory: IncomeCategory?
    
    var selectedExpense = true
    
    var reviseSelectedExpense = true

    var expenseCategorys: [ExpenseCategory] = []
    
    var incomeCategorys: [IncomeCategory] = []
    
    var newAccounting = true
    
    var reviseAmount: Int64 = 0
    
    var reviseOccurDate: Int64 = 0
    
    var reviseDate: Date?
    
    var reviseAccount: String?
    
    var reviseExpenseCategory: ExpenseCategory?
    
    var reviseIncomeCategory: IncomeCategory?

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
        
        guard let expenseCategorys = CategoryProvider().expenseCategory else { return }
        
        self.expenseCategorys = expenseCategorys
        
        if selectedExpense {
            
            selectedExpenseCategory = expenseCategorys[0]
            
        }
        
        guard let incomeCategorys = CategoryProvider().incomeCategory else { return }
        
        self.incomeCategorys = incomeCategorys

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let accounts = AccountProvider().accounts else { return }
        
        if accounts.count > 0 {
            
            selectedAccount.setTitle(accounts[0].name, for: .normal)
            
        }
        
        if newAccounting == false {
            
            setAccountingFromRevise()
            
            deleteAccountingButton.isHidden = false
            
        } else {
            
            amountTextField.becomeFirstResponder()
            
        }
        
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
        
        guard let selectedAccount = selectedAccount.titleLabel?.text else { return }
        
        guard let selectedDate = calendar.selectedDate else { return }
        
        if newAccounting {
            
            if selectedExpense {
                
                guard let selectedCategory = selectedExpenseCategory else { return }
                
                CoreDataManager.shared.saveAccounting(date: selectedDate,
                                                     amount: amount,
                                                     accountName: selectedAccount,
                                                     selectedExpenseCategory: selectedCategory,
                                                     selectedIncomeCategory: nil,
                                                     selectedExpense: selectedExpense)
                
            } else {
                
                guard let selectedCategory = selectedIncomeCategory else { return }
                
                CoreDataManager.shared.saveAccounting(date: selectedDate,
                                                     amount: amount,
                                                     accountName: selectedAccount,
                                                     selectedExpenseCategory: nil,
                                                     selectedIncomeCategory: selectedCategory,
                                                     selectedExpense: selectedExpense)
                
            }
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            if selectedExpense {
                
                guard let selectedCategory = selectedExpenseCategory else { return }
                
                CoreDataManager.shared.reviseAccounting(date: reviseOccurDate,
                                                       newDate: selectedDate,
                                                       amount: amount,
                                                       accountName: selectedAccount,
                                                       selectedExpenseCategory: selectedCategory,
                                                       selectedIncomeCategory: nil,
                                                       selectedExpense: selectedExpense,
                                                       reviseSelectedExpense: reviseSelectedExpense)
                
            } else {
                
                guard let selectedCategory = selectedIncomeCategory else { return }
                
                CoreDataManager.shared.reviseAccounting(date: reviseOccurDate,
                                                       newDate: selectedDate,
                                                       amount: amount,
                                                       accountName: selectedAccount,
                                                       selectedExpenseCategory: nil,
                                                       selectedIncomeCategory: selectedCategory,
                                                       selectedExpense: selectedExpense,
                                                       reviseSelectedExpense: reviseSelectedExpense)
                
            }
            
            navigationController?.popViewController(animated: true)
            
        }
        
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
        
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        showAlertWith(title: "請選擇帳戶", message: "")
        
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .actionSheet) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        guard let accounts = AccountProvider().accounts else { return }
        
        if accounts.count > 0 {
            
            for index in 0...accounts.count - 1 {
                
                guard let accountName = accounts[index].name else { return }
                
                let accountAction = UIAlertAction(title: accountName, style: .default, handler: { _ in
                    
                    self.selectedAccount.setTitle(accountName, for: .normal)
                    
                })
                
                alertController.addAction(accountAction)
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setAccountingRevise(occurDate: Int64, date: Date, amount: Int64,
                             account: String?, expenseCategory: ExpenseCategory?, incomeCategory: IncomeCategory?) {
        
        newAccounting = false
        
        reviseOccurDate = occurDate
        
        reviseDate = date
        
        reviseAmount = amount
        
        reviseAccount = account
        
        if expenseCategory != nil {
            
            reviseExpenseCategory = expenseCategory
            
            selectedExpense = true
            
            reviseSelectedExpense = true
            
        } else if incomeCategory != nil {
            
            reviseIncomeCategory = incomeCategory
            
            selectedExpense = false
            
            reviseSelectedExpense = false
            
        }
        
    }
    
    func setAccountingFromRevise() {
        
        calendar.select(reviseDate, scrollToDate: true)
        
        amountTextField.text = String(reviseAmount)
        
        selectedAccount.setTitle(reviseAccount, for: .normal)
        
        if selectedExpense == true, let category = reviseExpenseCategory, let iconName = category.iconName, let color = category.color {
            
            selectedExpenseCategory = category
            
            selectedSubCategoryImageView.image = UIImage(named: iconName)
            
            selectedSubCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        } else if selectedExpense == false, let category = reviseIncomeCategory, let iconName = category.iconName, let color = category.color {
            
            selectedIncomeCategory = category
            
            selectedSubCategoryImageView.image = UIImage(named: iconName)
            
            selectedSubCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        }
        
    }
    
    @IBAction func deleteAccounting(_ sender: UIButton) {
        
        CoreDataManager.shared.deleteAccounting(date: reviseOccurDate, reviseSelectedExpense: reviseSelectedExpense)
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension AccountingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 3

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = incomeExpenseCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: IncomeExpenseCVCell.self),
            for: indexPath) as? IncomeExpenseCVCell else {
                return IncomeExpenseCVCell()
        }
        
        if indexPath.row == 0 {
            
            cell.initSavingCVCell(expenseCategorys: expenseCategorys, incomeCategorys: [])
            
            cell.selectSubCategory = {
                
                guard let category = cell.expenseCategory, let iconName = category.iconName, let color = category.color else { return }
                
                self.selectedExpenseCategory = category
                
                self.selectedIncomeCategory = nil
                
                self.selectedExpense = true
                
                self.selectedSubCategoryImageView.image = UIImage(named: iconName)
                
                self.selectedSubCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                
            }
            
        } else {
            
            cell.initSavingCVCell(expenseCategorys: [], incomeCategorys: incomeCategorys)
            
            cell.selectSubCategory = {
                
                guard let category = cell.incomeCategory, let iconName = category.iconName, let color = category.color else { return }
                
                self.selectedIncomeCategory = category
                
                self.selectedExpenseCategory = nil
                
                self.selectedExpense = false
                
                self.selectedSubCategoryImageView.image = UIImage(named: iconName)
                
                self.selectedSubCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                
            }
            
        }
        
        return cell

    }

}

extension AccountingVC: UICollectionViewDelegate {

}

extension AccountingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 374, height: 240)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 12

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0

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
