//
//  NotificationManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

open class NotificationManager {
    
    private var savingHandler: ((Notification) -> Void)?
    
    private var accountingHandler: ((Notification) -> Void)?
    
    private var accountHandler: ((Notification) -> Void)?
    
    // Observer
    
    func addSavingNotification(changeHandler: @escaping (Notification) -> Void) {
        
        savingHandler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(savingChanged(notification:)),
                                               name: .savingChanged, object: nil)
        
    }
    
    func addAccountingNotification(changeHandler: @escaping (Notification) -> Void) {
        
        accountingHandler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountingChanged(notification:)),
                                               name: .accountingChanged, object: nil)
        
    }
    
    func addAccountNotification(changeHandler: @escaping (Notification) -> Void) {
        
        accountHandler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountChanged(notification:)),
                                               name: .accountChanged, object: nil)
        
    }
    
    @objc private func savingChanged(notification: Notification) {
        
        savingHandler?(notification)
        
    }
    
    @objc private func accountingChanged(notification: Notification) {
        
        accountingHandler?(notification)
        
    }
    
    @objc private func accountChanged(notification: Notification) {
        
        accountHandler?(notification)
        
    }
    
    // Post
    
    func postSavingChanged(userInfo: [String: Saving]?) {
        
        NotificationCenter.default.post(name: .savingChanged, object: nil, userInfo: userInfo)
        
    }
    
    func postAccountingChanged(userInfo: [String: Accounting]?) {
        
        NotificationCenter.default.post(name: .accountingChanged, object: nil, userInfo: userInfo)
        
    }
    
    open func postAccountChanged(userInfo: [String: Account]?) {
        
        NotificationCenter.default.post(name: .accountChanged, object: nil, userInfo: userInfo)
        
    }
    
}
