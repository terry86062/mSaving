//
//  MessageViewVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MessageViewVC: UIViewController {
    
    let notificationManager = NotificationManager()
    
    let msMessageView = MSMessageView()
    
    func setUpNotification() {
        
        setUpSavingNotification()
        
        setUpAccountingNotification()
        
        setUpAccountNotification()
        
    }
    
    func setUpSavingNotification() {
        
        notificationManager.addSavingNotification { [weak self] notification in
            
            if let saving = notification.userInfo?["createSaving"] as? Saving {
                
                self?.msMessageView.show(saving: saving, type: .add)
                
            } else if let saving = notification.userInfo?["reviseSaving"] as? Saving {
                
                self?.msMessageView.show(saving: saving, type: .revise)
                
            } else if let subSaving = notification.userInfo?["createSubSaving"] as? Saving {
                
                self?.msMessageView.show(subSaving: subSaving, type: .add)
                
            } else if let subSaving = notification.userInfo?["reviseSubSaving"] as? Saving {
                
                self?.msMessageView.show(subSaving: subSaving, type: .revise)
                
            } else if let subSaving = notification.userInfo?["delete"] as? Saving {
                
                self?.msMessageView.show(subSaving: subSaving, type: .delete)
                
            }
            
        }
        
    }
    
    func setUpAccountingNotification() {
        
        notificationManager.addAccountingNotification { [weak self] notification in
            
            if let accounting = notification.userInfo?["create"] as? Accounting {
                
                self?.msMessageView.show(accounting: accounting, type: .add)
                
            } else if let accounting = notification.userInfo?["revise"] as? Accounting {
                
                self?.msMessageView.show(accounting: accounting, type: .revise)
                
            } else if let accounting = notification.userInfo?["delete"] as? Accounting {
                
                self?.msMessageView.show(accounting: accounting, type: .delete)
                
            }
            
        }
        
    }
    
    func setUpAccountNotification() {
        
        notificationManager.addAccountNotification { [weak self] notification in
            
            if let account = notification.userInfo?["create"] as? Account {
                
                self?.msMessageView.show(account: account, type: .add)
                
            } else if let account = notification.userInfo?["revise"] as? Account {
                
                self?.msMessageView.show(account: account, type: .revise)
                
            } else if let account = notification.userInfo?["delete"] as? Account {
                
                self?.msMessageView.show(account: account, type: .delete)
                
            }
            
        }
        
    }

}
