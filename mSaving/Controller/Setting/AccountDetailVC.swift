//
//  AccountDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/11.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountDetailVC: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var accountAmountTextField: UITextField!
    
    weak var delegate: SettingVC?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        accountTextField.text = delegate?.selectedAccountName
        
        accountAmountTextField.text = delegate?.selectedAccountCurrentValue
        
        accountTextField.becomeFirstResponder()

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
        
        delegate?.selectedAccountCurrentValue = ""
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func saveAccount() {
        
        guard let delegate = delegate else { return }
        
        guard let text = accountTextField.text, text != "" else { return }
        
        guard let amountText = accountAmountTextField.text, let amount = Int64(amountText) else { return }
        
        if delegate.isAddingNewAccount {
            
            if let account = StorageManager.shared.fetchAccount()?.last {
                
                StorageManager.shared.createAccount(name: text, amount: amount, priority: account.priority + 1)
                
            } else {
                
                StorageManager.shared.createAccount(name: text, amount: amount, priority: 0)
                
            }

        }
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = true
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        guard let text = accountTextField.text, text != "" else { return }
        
        StorageManager.shared.deleteAccount(accountName: text)
        
        delegate?.fetchData()
        
        helpDismiss()
        
    }
    
}
