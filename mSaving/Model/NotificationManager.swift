//
//  NotificationManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class NotificationManager {
    
    var handler: ((Notification) -> Void)?
    
    // Observer
    
    func addSavingNotification(changeHandler: @escaping (Notification) -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .savingChanged, object: nil)
        
    }
    
    func addAccountingNotification(changeHandler: @escaping (Notification) -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .accountingChanged, object: nil)
        
    }
    
    func addAccountNotification(changeHandler: @escaping (Notification) -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .accountChanged, object: nil)
        
    }
    
    @objc func anyChanged(notification: Notification) {
        
        handler?(notification)
        
    }
    
    // Post
    
    func postSavingChanged(userInfo: [String: Saving]?) {
        
        NotificationCenter.default.post(name: .savingChanged, object: nil, userInfo: userInfo)
        
    }
    
    func postAccountingChanged(userInfo: [String: Accounting]?) {
        
        NotificationCenter.default.post(name: .accountingChanged, object: nil, userInfo: userInfo)
        
    }
    
    func postAccountChanged(userInfo: [String: Account]?) {
        
        NotificationCenter.default.post(name: .accountChanged, object: nil, userInfo: userInfo)
        
    }
    
}
