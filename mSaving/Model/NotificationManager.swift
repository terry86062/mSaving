//
//  NotificationManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class NotificationManager {
    
    var handler: (() -> Void)?
    
    // Observer
    
    func addAllNotification(changeHandler: @escaping () -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .accountingChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .savingChanged, object: nil)
        
    }
    
    func addAccountingNotification(changeHandler: @escaping () -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .accountingChanged, object: nil)
        
    }
    
    func addAccountNotification(changeHandler: @escaping () -> Void) {
        
        handler = changeHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(anyChanged(notification:)),
                                               name: .accountChanged, object: nil)
        
    }
    
    @objc func anyChanged(notification: Notification) {
        
        handler?()
        
    }
    
    // Post
    
    func postAccountingChanged() {
        
        NotificationCenter.default.post(name: .accountingChanged, object: nil)
        
    }
    
    func postSavingChanged() {
        
        NotificationCenter.default.post(name: .savingChanged, object: nil)
        
    }
    
    func postAccountChanged() {
        
        NotificationCenter.default.post(name: .accountChanged, object: nil)
        
    }
    
}
