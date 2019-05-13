//
//  AccountProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

class AccountProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let notificationManager = NotificationManager()
    
    var accounts: [Account] {
        
        return coreDataManager.fetch(entityType: Account(), sort: ["priority"])
        
    }
    
    func createAccount(name: String, initalAmount: Int64) {
        
        let account = Account(context: coreDataManager.viewContext)
        
        account.name = name
        
        account.initialValue = initalAmount
        
        account.currentValue = initalAmount
        
        if let last = accounts.last {
            
            account.priority = last.priority + 1
            
        } else {
            
            account.priority = 0
            
        }
        
        coreDataManager.saveContext()
        
        notificationManager.postAccountChanged(userInfo: ["create": account])
        
    }
    
    func reviseAccount(account: Account, name: String, initialValue: Int64) {
        
        account.name = name
        
        account.currentValue -= account.initialValue
        
        account.currentValue += initialValue
        
        account.initialValue = initialValue
        
        coreDataManager.saveContext()
        
        notificationManager.postAccountChanged(userInfo: ["revise": account])
        
    }
    
    func deleteAccount(account: Account) {
        
        var priority = Int(account.priority)
        
        while priority + 1 < accounts.count {
            
            accounts[priority + 1].priority -= 1
            
            priority += 1
            
        }
        
        notificationManager.postAccountChanged(userInfo: ["delete": account])
        
        coreDataManager.viewContext.delete(account)
        
        coreDataManager.saveContext()
        
        notificationManager.postAccountChanged(userInfo: nil)
        
    }
    
}
