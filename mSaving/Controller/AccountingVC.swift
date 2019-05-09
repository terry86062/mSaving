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

class AccountingVC: PresentVC {

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

    @IBOutlet weak var incomeExpenseCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedAccountButton: UIButton!
    
    @IBOutlet weak var deleteAccountingButton: UIButton!
    
    @IBOutlet weak var incomeExpenseButton: UIButton!
    
    let categoryCVVC = CategoryCollectionViewVC()
    
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
        
        incomeExpenseCollectionView.dataSource = categoryCVVC
        
        incomeExpenseCollectionView.delegate = categoryCVVC
        
        categoryCVVC.delegate = self
        
        if categoryCVVC.expenseCategories != [] {
            
            setUpForSelected(category: .expense(categoryCVVC.expenseCategories[0]))
            
        }
        
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
        
        accounts = AccountProvider().accounts
        
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
    
    @IBAction func addAccountingToo(_ sender: UIButton) {
        
        addAccounting(UIBarButtonItem())
        
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
            
            dismiss(UIButton())
            
        } else {
            
            AccountingProvider().createAccounting(occurDate: occurDate,
                                                  createDate: Date(),
                                                  amount: amount,
                                                  account: selectedAccount,
                                                  category: selectedCategory)
            
            dismiss(UIButton())

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
        
        amountTextField.resignFirstResponder()

        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        AlertManager().showAlertWith(accounts: accounts, viewController: self) { [weak self] account in
            
            self?.selectedAccountButton.setTitle(account.name, for: .normal)
            
            self?.selectedAccount = account
            
        }
        
        Analytics.logEvent("accounting_page_change_account_button", parameters: nil)
        
    }
    
    @IBAction func deleteAccounting(_ sender: UIButton) {
        
        AlertManager().showDeleteAlertWith(accounting: selectedAccounting, viewController: self) { [weak self] in
            
            self?.dismiss(UIButton())
            
        }
        
    }
    
    @IBAction func changeIncomeExpense(_ sender: UIButton) {
        
        incomeExpenseButton.isSelected = !incomeExpenseButton.isSelected
        
        categoryCVVC.showExpense = !incomeExpenseButton.isSelected
        
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

extension AccountingVC: CategorySelectCVCellDelegate {
    
    func touchCategory(expense: ExpenseCategory?, income: IncomeCategory?) {
        
        if let expense = expense {
            
            selectedCategory = .expense(expense)
            
            guard let iconName = expense.iconName, let color = expense.color else { return }
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        } else if let income = income {
            
            selectedCategory = .income(income)
            
            guard let iconName = income.iconName, let color = income.color else { return }
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        }
        
    }
    
}
