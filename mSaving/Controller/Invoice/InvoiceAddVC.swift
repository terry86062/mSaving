//
//  InvoiceAddVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class InvoiceAddVC: PresentVC {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var invoiceAccountingTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet weak var selectedAccountButton: UIButton!
    
    @IBOutlet weak var accountingCategoryCollectionView: UICollectionView!
    
    let categoryCVVC = CategoryCollectionViewVC()
    
    var invoiceYear = ""
    
    var invoiceMonth = ""
    
    var invoiceDay = ""
    
    var invoiceAmount = 0
    
    var accounts: [Account] = []
    
    var selectedExpenseCategory: ExpenseCategory?
    
    var selectedAccount: Account?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        setUpInvoiceInfo()
        
        fetchData()
        
    }
    
    func setUpCollectionView() {
        
        accountingCategoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
        accountingCategoryCollectionView.dataSource = categoryCVVC
        
        accountingCategoryCollectionView.delegate = categoryCVVC
        
        categoryCVVC.delegate = self
        
    }
    
    func setUpInvoiceInfo() {
        
        dateLabel.text = invoiceYear + "年" + invoiceMonth + "月" + invoiceDay + "日"
        
        invoiceAccountingTextField.text = "\(invoiceAmount)"
        
    }
    
    func fetchData() {
        
        accounts = AccountProvider().accounts
        
        if accounts != [] {
            
            setUpForSelected(account: accounts[0])
            
        }
        
    }
    
    func setUpForSelected(account: Account) {
        
        selectedAccount = account
        
        selectedAccountButton.setTitle(account.name, for: .normal)
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccounting()
        
    }
    
    func saveAccounting() {
        
        guard let text = invoiceAccountingTextField.text, let amount = Int64(text), amount != 0 else { return }
        
        guard let selectedAccount = selectedAccount else { return }
        
        guard let date = TimeManager().createDate(year: Int(invoiceYear),
                                                  month: Int(invoiceMonth),
                                                  day: Int(invoiceDay)) else { return }
        
        guard let selectedCategory = selectedExpenseCategory else { return }
        
        AccountingProvider().createAccounting(occurDate: date,
                                              createDate: Date(),
                                              amount: amount,
                                              account: selectedAccount,
                                              category: .expense(selectedCategory))
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        AlertManager().showAlertWith(accounts: accounts, viewController: self) { [weak self] account in
            
            self?.selectedAccountButton.setTitle(account.name, for: .normal)
            
            self?.selectedAccount = account
            
        }
        
    }
    
}

extension InvoiceAddVC: CategorySelectCVCellDelegate {
    
    func touchCategory(expense: ExpenseCategory?, income: IncomeCategory?) {
        
        selectedExpenseCategory = expense
        
        guard let iconName = expense?.iconName, let color = expense?.color else { return }
        
        selectedCategoryImageView.image = UIImage(named: iconName)
        
        selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
    }
    
}
