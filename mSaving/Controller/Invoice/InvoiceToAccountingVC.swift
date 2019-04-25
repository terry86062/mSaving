//
//  InvoiceToAccountingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class InvoiceToAccountingVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var invoiceAccountingTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet weak var selectedAccount: UIButton!
    
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
    
    var selectedExpenseCategory: ExpenseCategory?
    
    var expenseCategorys: [ExpenseCategory] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        dateLabel.text = invoiceYear + "年" + invoiceMonth + "月" + invoiceDay + "日"
        
        invoiceAccountingTextField.text = "\(invoiceAmount)"
        
        let expenseCategorys = CategoryProvider().expenseCategories
        
        self.expenseCategorys = expenseCategorys
        
    }
    
    func setUpCollectionView() {
        
        accountingCategoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccounting()
        
        helpDismiss()
        
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
        
        tabBarVC.blackView.isHidden = true
        
    }
    
    func saveAccounting() {
        
        guard let text = invoiceAccountingTextField.text, let amount = Int64(text), amount != 0 else { return }
        
        guard let selectedAccount = selectedAccount.titleLabel?.text else { return }
        
        var components = DateComponents()
        
        components.year = Int(invoiceYear)
        components.month = Int(invoiceMonth)
        components.day = Int(invoiceDay)
        
        guard let date = Calendar.current.date(from: components) else { return }
        
        guard let selectedCategory = selectedExpenseCategory else { return }
        
//        AccountingProvider().saveAccounting(date: date,
//                                             amount: amount,
//                                             accountName: selectedAccount,
//                                             selectedExpenseCategory: selectedCategory,
//                                             selectedIncomeCategory: nil,
//                                             selectedExpense: true)
        
    }
    
}

extension InvoiceToAccountingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseCategorys.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = accountingCategoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        let expenseCategory = expenseCategorys[indexPath.row]
        
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

extension InvoiceToAccountingVC: UICollectionViewDelegate {
    
}

extension InvoiceToAccountingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 57, height: 76)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
