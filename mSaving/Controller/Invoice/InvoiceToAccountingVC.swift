//
//  InvoiceToAccountingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import SwiftMessages

class InvoiceToAccountingVC: UIViewController {
    
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
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccounting()
        
    }
    
    @IBAction func deleteSubSaving(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    func helpDismiss() {
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
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
        
        showAddResult(expense: selectedCategory, amount: amount)
        
        helpDismiss()
        
    }
    
    func showAddResult(expense: ExpenseCategory, amount: Int64) {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        guard let name = expense.name, let color = expense.color, let iconName = expense.iconName,
            let iconImage = UIImage(named: iconName) else { return }
        
        view.configureTheme(backgroundColor: UIColor.hexStringToUIColor(hex: color), foregroundColor: .white)
        
        view.configureContent(title: "新增成功", body: "已新增一筆\(name)交易",
            iconImage: iconImage.resizeImage())
        
        view.button?.setTitle("-$\(amount)", for: .normal)
        
        view.button?.backgroundColor = .clear
        
        view.button?.setTitleColor(.white, for: .normal)
        
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 12
        
        // Show the message.
        SwiftMessages.show(view: view)
        
    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        
        showAlertWith(title: "請選擇帳戶", message: "")
        
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
    
}

extension InvoiceToAccountingVC: UICollectionViewDataSource {
    
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

extension InvoiceToAccountingVC: UICollectionViewDelegate { }

extension InvoiceToAccountingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 36, height: 84)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 36
        
    }
    
}
