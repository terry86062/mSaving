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
        
        accountTextField.becomeFirstResponder()

    }

    @IBAction func dismiss(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveAccount()
        
        dismiss(animated: true, completion: nil)
        
        delegate?.settingCollectionView?.collectionViewLayout.invalidateLayout()
        
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
    
}
