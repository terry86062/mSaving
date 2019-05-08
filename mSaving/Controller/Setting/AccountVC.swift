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
        
        showDeleteAlertWith(title: "您確定要刪除此帳戶嗎？", message: nil)
        
    }
    
    func showDeleteAlertWith(title: String, message: String?, style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let account = self.selectedAccount else { return }
            
            AccountProvider().deleteAccount(account: account)
            
            self.dismiss(UIButton())
            
        })
        
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
