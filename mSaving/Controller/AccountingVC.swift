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

import Firebase

class AccountingVC: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    fileprivate lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter
        
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        
        let panGesture = UIPanGestureRecognizer(target: self.calendar,
                                                action: #selector(self.calendar.handleScopeGesture(_:)))
        
        panGesture.delegate = self
        
        panGesture.minimumNumberOfTouches = 1
        
        panGesture.maximumNumberOfTouches = 2
        
        return panGesture
        
    }()

    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet var keyboardToolBar: UIToolbar!

    @IBOutlet weak var incomeExpenseCollectionView: UICollectionView! {

        didSet {

            incomeExpenseCollectionView.dataSource = self

            incomeExpenseCollectionView.delegate = self

        }

    }
    
    @IBOutlet weak var selectedAccountButton: UIButton!
    
    @IBOutlet weak var deleteAccountingButton: UIButton!
    
    @IBOutlet weak var incomeExpenseButton: UIButton!
    
    var expenseCategories: [ExpenseCategory] = []
    
    var incomeCategories: [IncomeCategory] = []
    
    var accounts: [Account] = []
    
    var selectedCategory: CategoryCase?
    
    var selectedAccount: Account?
    
    var selectedAccounting: Accounting?

    override func viewDidLoad() {

        super.viewDidLoad()
        
        amountTextField.inputAccessoryView = keyboardToolBar
        
        amountTextField.becomeFirstResponder()
        
        setUpCollectionView()
        
        setUpCalendar()
        
        fetchData()

    }
    
    func setUpCollectionView() {
        
        incomeExpenseCollectionView.helpRegister(cell: CategorySelectCVCell())
        
    }
    
    func setUpCalendar() {
        
        if UIDevice.current.model.hasPrefix("iPad") {
            
            self.calendarHeightConstraint.constant = 400
            
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(scopeGesture)
        
        self.calendar.scope = .week
        
    }
    
    func fetchData() {
        
        expenseCategories = CategoryProvider().expenseCategories
        
        incomeCategories = CategoryProvider().incomeCategories
        
        accounts = AccountProvider().accounts
        
        if expenseCategories != [] {
            
            setUpForSelected(category: .expense(expenseCategories[0]))
            
        }
        
        if accounts != [] {
            
            setUpForSelected(account: accounts[0])
            
        }
        
    }
    
    func setUpForSelected(category: CategoryCase?) {
        
        guard let category = category else { return }
        
        selectedCategory = category
        
        switch category {
        
        case .expense(let expense):
            
            guard let iconName = expense.iconName, let color = expense.color else { return }
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
        case .income(let income):
            
            guard let iconName = income.iconName, let color = income.color else { return }
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
        }
        
    }
    
    func setUpForSelected(account: Account) {
        
        selectedAccount = account
        
        selectedAccountButton.setTitle(account.name, for: .normal)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if selectedAccounting != nil {
            
            setUpView()
            
            deleteAccountingButton.isHidden = false
            
        }
        
    }
    
    func setUpView() {
        
        if selectedAccounting != nil {
            
            guard let budget = selectedAccounting?.amount else { return }
            
            amountTextField.text = String(budget)
            
            guard let occurDate = selectedAccounting?.occurDate else { return }
            
            calendar.select(Date(timeIntervalSince1970: TimeInterval(occurDate)), scrollToDate: true)
            
            selectedAccountButton.setTitle(selectedAccounting?.accountName?.name, for: .normal)
            
            selectedAccount = selectedAccounting?.accountName
            
            if let expenseCategory = selectedAccounting?.expenseCategory {
                
                setUpForSelected(category: .expense(expenseCategory))
                
            } else if let incomeCategory = selectedAccounting?.incomeCategory {
                
                setUpForSelected(category: .income(incomeCategory))
                
            }
            
        }
        
    }

    @IBAction func dismissKeyboard(_ sender: UIButton) {

        amountTextField.resignFirstResponder()

    }

    @IBAction func addAccounting(_ sender: UIBarButtonItem) {
        
        guard let text = amountTextField.text, let amount = Int64(text), amount != 0 else { return }
        
        guard let selectedAccount = selectedAccount else { return }
        
        guard let selectedDate = calendar.selectedDate else { return }
        
        guard let occurDate = createOccurDate(selectedDate: selectedDate) else { return }
        
        guard let selectedCategory = selectedCategory else { return }
        
        if let selectedAccounting = selectedAccounting {
        
            AccountingProvider().reviseAccounting(accounting: selectedAccounting,
                                                  occurDate: occurDate,
                                                  createDate: Date(),
                                                  amount: amount,
                                                  account: selectedAccount,
                                                  category: selectedCategory)
            
            navigationController?.popViewController(animated: true)
            
        } else {
            
            AccountingProvider().createAccounting(occurDate: occurDate,
                                                  createDate: Date(),
                                                  amount: amount,
                                                  account: selectedAccount,
                                                  category: selectedCategory)
            
            dismiss(animated: true, completion: nil)

        }

    }
    
    @IBAction func dismissKeyboardButton(_ sender: UIBarButtonItem) {
        
        amountTextField.resignFirstResponder()
        
    }
    
    func createOccurDate(selectedDate: Date) -> Date? {
        
        let selectedComponents = TimeManager().transform(date: selectedDate)
        
        return TimeManager().createDate(year: selectedComponents.year,
                                        month: selectedComponents.month,
                                        day: selectedComponents.day)
        
    }

    @IBAction func dismiss(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        showAlertWith(title: "請選擇帳戶", message: "")
        
        Analytics.logEvent("accounting_page_change_account_button", parameters: nil)
        
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if accounts.count > 0 {
            
            for index in 0...accounts.count - 1 {
                
                guard let accountName = accounts[index].name else { return }
                
                let accountAction = UIAlertAction(title: accountName, style: .default, handler: { _ in
                    
                    self.selectedAccountButton.setTitle(accountName, for: .normal)
                    
                    self.selectedAccount = self.accounts[index]
                    
                })
                
                alertController.addAction(accountAction)
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteAccounting(_ sender: UIButton) {
        
        guard let selectedAccounting = selectedAccounting else { return }
        
        AccountingProvider().deleteAccounting(accounting: selectedAccounting)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func changeIncomeExpense(_ sender: UIButton) {
        
        incomeExpenseButton.isSelected = !incomeExpenseButton.isSelected
        
        incomeExpenseCollectionView.reloadData()
        
    }
    
}

extension AccountingVC: FSCalendarDataSource { }

extension AccountingVC: FSCalendarDelegate {
    
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
    
}

extension AccountingVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension AccountingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if incomeExpenseButton.isSelected {
            
            return incomeCategories.count
            
        } else {
            
            return expenseCategories.count
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = incomeExpenseCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        if incomeExpenseButton.isSelected {
            
            let incomeCategory = incomeCategories[indexPath.row]
            
            guard let iconName = incomeCategory.iconName,
                let name = incomeCategory.name,
                let color = incomeCategory.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
            
            cell.selectCategory = {
                
                self.selectedCategory = .income(incomeCategory)
                
                self.selectedCategoryImageView.image = UIImage(named: iconName)
                
                self.selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                
            }
            
        } else {
            
            let expenseCategory = expenseCategories[indexPath.row]
            
            guard let iconName = expenseCategory.iconName,
                let name = expenseCategory.name,
                let color = expenseCategory.color else { return cell }
            
            cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
            
            cell.selectCategory = {
                
                self.selectedCategory = .expense(expenseCategory)
                
                self.selectedCategoryImageView.image = UIImage(named: iconName)
                
                self.selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                
            }
            
        }
        
        return cell

    }

}

extension AccountingVC: UICollectionViewDelegate { }

extension AccountingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 36, height: 84)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 30
        
    }

}
