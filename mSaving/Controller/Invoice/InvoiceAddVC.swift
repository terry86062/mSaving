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
    
    @IBOutlet weak var accountingCategoryCollectionView: UICollectionView! {
        
        didSet {
            
            accountingCategoryCollectionView.dataSource = self
            
            accountingCategoryCollectionView.delegate = self
            
        }
        
    }
    
    var invoiceYear = ""
    
    var invoiceMonth = ""
    
    var invoiceDay = ""
    
    var invoiceAmount = 0
    
    var expenseCategories: [ExpenseCategory] = []
    
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
        
    }
    
    func setUpInvoiceInfo() {
        
        dateLabel.text = invoiceYear + "年" + invoiceMonth + "月" + invoiceDay + "日"
        
        invoiceAccountingTextField.text = "\(invoiceAmount)"
        
    }
    
    func fetchData() {
        
        expenseCategories = CategoryProvider().expenseCategories
        
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
        
        dismiss(UIButton())
        
    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        AlertManager().showAlertWith(accounts: accounts, viewController: self) { [weak self] account in
            
            self?.selectedAccountButton.setTitle(account.name, for: .normal)
            
            self?.selectedAccount = account
            
        }
        
    }
    
}

extension InvoiceAddVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseCategories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = accountingCategoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        let expenseCategory = expenseCategories[indexPath.row]
        
        guard let iconName = expenseCategory.iconName,
            let name = expenseCategory.name,
            let color = expenseCategory.color else { return cell }
        
        cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
        
        cell.selectCategory = {
            
            self.selectedExpenseCategory = expenseCategory
            
            self.selectedCategoryImageView.image = UIImage(named: iconName)
            
            self.selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        }
        
        return cell
        
    }
    
}

extension InvoiceAddVC: UICollectionViewDelegate { }

extension InvoiceAddVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 43, bottom: 0, right: 38.2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 36, height: 84)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 38.2
        
    }
    
}
