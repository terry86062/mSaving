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
            
            accountTextField.becomeFirstResponder()
            
        }
        
    }

    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccount()
        
        delegate?.fetchData()
        
        helpDismiss()

    }
    
    func helpDismiss() {
        
        delegate?.selectedAccountName = ""
        
        delegate?.selectedAccountInitialValue = ""
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
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
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        guard let text = accountTextField.text, text != "" else { return }
        
        AccountProvider().deleteAccount(accountName: text)
        
        delegate?.fetchData()
        
        helpDismiss()
        
    }
    
}
