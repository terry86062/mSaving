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
    
    var coreDataManager = CoreDataManager.shared
    
    var accounts: [Account] {
        
        return coreDataManager.fetch(entityType: Account(), sort: ["priority"])
        
    }
    
    func createAccount(name: String, initalAmount: Int64, priority: Int64) {
        
        let account = Account(context: coreDataManager.viewContext)
        
        account.name = name
        
        account.initialValue = initalAmount
        
        account.currentValue = initalAmount
        
        account.priority = priority
        
        coreDataManager.saveContext()
        
    }
    
    func deleteAccount(accountName: String) {
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let account = try coreDataManager.viewContext.fetch(request)
            
            let request = NSFetchRequest<Account>(entityName: "Account")
            
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
            
            do {
                
                let accounts = try coreDataManager.viewContext.fetch(request)
                
                var priority = Int(account[0].priority)
                
                while priority + 1 < accounts.count {
                    
                    accounts[priority + 1].priority -= 1
                    
                    priority += 1
                    
                }
                
            } catch {
                
                print(error)
                
            }
            
            coreDataManager.viewContext.delete(account[0])
            
        } catch {
            
            print(error)
            
        }
        
        coreDataManager.saveContext()
        
    }
    
    func reviseAccount(accountName: String, newName: String, newInitialValue: Int64) {
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let account = try coreDataManager.viewContext.fetch(request)
            
            account[0].name = newName
            
            account[0].currentValue = account[0].currentValue + newInitialValue - account[0].initialValue
            
            account[0].initialValue = newInitialValue
            
        } catch {
            
            print("revise account fail")
            
        }
        
        coreDataManager.saveContext()
        
    }
    
}
