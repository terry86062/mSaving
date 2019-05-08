//
//  AccountDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/11.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var accountAmountTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var stringForTitle: String = ""
    
    var originalAccountName = ""
    
    weak var delegate: SettingVC?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        accountTextField.text = delegate?.selectedAccountName
        
        originalAccountName = delegate?.selectedAccountName ?? ""
        
        accountAmountTextField.text = delegate?.selectedAccountInitialValue
        
        titleLabel.text = stringForTitle
        
        if let delegate = delegate, delegate.isAddingNewAccount == true {
            
//            accountTextField.becomeFirstResponder()
            
            deleteButton.isHidden = true
            
        }
        
    }

    @IBAction func dismiss(_ sender: UIButton) {
        
        delegate?.selectedAccountName = ""
        
        delegate?.selectedAccountInitialValue = ""
        
        accountTextField.resignFirstResponder()
        
        accountAmountTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccount()

    }
    
    func saveAccount() {
        
        guard let delegate = delegate else { return }
        
        guard let text = accountTextField.text, text != "" else { return }
        
        guard let amountText = accountAmountTextField.text, let amount = Int64(amountText) else { return }
        
        if delegate.isAddingNewAccount {
            
            if let account = AccountProvider().accounts.last {
                
                AccountProvider().createAccount(name: text, initalAmount: amount, priority: account.priority + 1)
                
            } else {
                
                AccountProvider().createAccount(name: text, initalAmount: amount, priority: 0)
                
            }

        } else {
            
            AccountProvider().reviseAccount(accountName: originalAccountName, newName: text, newInitialValue: amount)
            
        }
        
        delegate.fetchData()
        
        dismiss(UIButton())
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        showDeleteAlertWith(title: "您確定要刪除此帳戶嗎？", message: nil)
        
    }
    
    func showDeleteAlertWith(title: String, message: String?, style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let text = self.accountTextField.text, text != "" else { return }
            
            AccountProvider().deleteAccount(accountName: text)
            
            self.delegate?.fetchData()
            
            self.dismiss(UIButton())
            
        })
        
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
