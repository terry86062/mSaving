//
//  AccountDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/11.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import SwiftMessages

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
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccount()

    }
    
    func helpDismiss() {
        
        delegate?.selectedAccountName = ""
        
        delegate?.selectedAccountInitialValue = ""
        
        accountTextField.resignFirstResponder()
        
        accountAmountTextField.resignFirstResponder()
        
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
            
            showAddResult(selected: false, name: text, amount: amount)

        } else {
            
            AccountProvider().reviseAccount(accountName: originalAccountName, newName: text, newInitialValue: amount)
            
            showAddResult(selected: true, name: text, amount: amount)
            
        }
        
        delegate.fetchData()
        
        helpDismiss()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        showDeleteAlertWith(title: "您確定要刪除此帳戶嗎？", message: nil)
        
    }
    
    func showDeleteAlertWith(title: String, message: String?, style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let text = self.accountTextField.text, text != "" else { return }
            
            if let amountText = self.delegate?.selectedAccountInitialValue, let amount = Int64(amountText) {
                
                self.showAddResult(selected: true, name: text, amount: amount, delete: true)
                
            }
            
            AccountProvider().deleteAccount(accountName: text)
            
            self.delegate?.fetchData()
            
            self.helpDismiss()
            
        })
        
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showAddResult(selected: Bool, name: String, amount: Int64, delete: Bool = false) {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        if delete {
            
            view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
            
            view.configureContent(title: "刪除成功", body: "已刪除\(name)帳戶", iconText: "\(name)")
            
            view.button?.setTitle("$\(amount)", for: .normal)
            
        } else {
            
            if selected {
                
                view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
                
                view.configureContent(title: "修改成功", body: "已修改\(name)帳戶初始金額", iconText: "\(name)")
                
                view.button?.setTitle("$\(amount)", for: .normal)
                
            } else {
                
                view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
                
                view.configureContent(title: "新增成功", body: "已新增\(name)帳戶", iconText: "\(name)")
                
                view.button?.setTitle("$\(amount)", for: .normal)
                
            }
            
        }
        
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
    
}
