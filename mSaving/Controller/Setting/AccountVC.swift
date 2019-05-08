//
//  AccountVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/11.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var accountAmountTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedAccount: Account?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    func setUpView() {
        
        if let account = selectedAccount {
            
            titleLabel.text = "帳戶資訊"
            
            accountTextField.text = account.name
            
            accountAmountTextField.text = "\(account.initialValue)"
            
            deleteButton.isHidden = false
            
        } else {
            
            titleLabel.text = "新增帳戶"
            
        }
        
        accountTextField.becomeFirstResponder()
        
    }

    @IBAction func dismiss(_ sender: UIButton) {
        
        accountTextField.resignFirstResponder()
        
        accountAmountTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = true
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccount()

    }
    
    func saveAccount() {
        
        guard let text = accountTextField.text, text != "" else { return }
        
        guard let amountText = accountAmountTextField.text, let amount = Int64(amountText) else { return }
        
        if let account = selectedAccount {
            
            AccountProvider().reviseAccount(account: account, name: text, initialValue: amount)
            
        } else {
            
            AccountProvider().createAccount(name: text, initalAmount: amount)
            
        }
        
        dismiss(UIButton())
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        AlertManager().showDeleteAlertWith(account: selectedAccount, viewController: self) { [weak self] in
            
            self?.dismiss(UIButton())
            
        }
        
    }
    
}
