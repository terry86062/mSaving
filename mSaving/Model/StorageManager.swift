//
//  StorageManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

struct Category {
    
    let name: String
    
    let iconName: String
    
    let color: String
    
    let priority: Int64
    
    let subPriority: Int64
    
}

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "mSaving")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    var initCategoryArray = [
        Category(name: "食物", iconName: "cutleryForkKnife", color: "EE5142", priority: 1, subPriority: 1),
        Category(name: "飲料", iconName: "beverageMilkShake", color: "EE5142", priority: 1, subPriority: 2),
        Category(name: "交通", iconName: "car", color: "8A99AB", priority: 2, subPriority: 1),
        Category(name: "捷運", iconName: "trainSideView01", color: "8A99AB", priority: 2, subPriority: 2),
        Category(name: "家庭", iconName: "home", color: "69CAF9", priority: 3, subPriority: 1),
        Category(name: "水電", iconName: "waterTap", color: "69CAF9", priority: 3, subPriority: 2),
        Category(name: "電話", iconName: "contact", color: "69CAF9", priority: 3, subPriority: 3),
        Category(name: "寵物", iconName: "footprint", color: "69CAF9", priority: 3, subPriority: 4),
        Category(name: "娛樂", iconName: "eightNote", color: "F6B143", priority: 4, subPriority: 1),
        Category(name: "健身", iconName: "dumbbells", color: "F6B143", priority: 4, subPriority: 2),
        Category(name: "旅遊", iconName: "aeroplane", color: "F6B143", priority: 4, subPriority: 3),
        Category(name: "購物", iconName: "shoppingBag", color: "B751F8", priority: 5, subPriority: 1),
        Category(name: "衣服", iconName: "menTShirt", color: "B751F8", priority: 5, subPriority: 2),
        Category(name: "進修", iconName: "bookOpen", color: "7BDF3B", priority: 6, subPriority: 1),
        Category(name: "才藝", iconName: "color", color: "7BDF3B", priority: 6, subPriority: 2),
        Category(name: "醫療", iconName: "pill", color: "667BF7", priority: 7, subPriority: 1),
        Category(name: "人情", iconName: "gift", color: "55C4B3", priority: 7, subPriority: 1),
        Category(name: "投資", iconName: "stockExchange", color: "ED5190", priority: 8, subPriority: 1),
        Category(name: "保險", iconName: "addShield", color: "ED5190", priority: 9, subPriority: 2),
        Category(name: "薪水", iconName: "cash", color: "F9C746", priority: 1, subPriority: 1)
    ]
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                
                print("save success")
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initExpenseIncomeCategory() {
        
        for index in 0...initCategoryArray.count - 1 {
            
            if index == initCategoryArray.count - 1 {
                
                let incomeSubCategory = IncomeCategory(context: viewContext)
                
                let category = initCategoryArray[index]
                
                incomeSubCategory.name = category.name
                incomeSubCategory.iconName = category.iconName
                incomeSubCategory.color = category.color
                incomeSubCategory.priority = category.priority
                incomeSubCategory.subPriority = category.subPriority
                
            } else {
                
                let expenseSubCategory = ExpenseCategory(context: viewContext)
                
                let category = initCategoryArray[index]
                
                expenseSubCategory.name = category.name
                expenseSubCategory.iconName = category.iconName
                expenseSubCategory.color = category.color
                expenseSubCategory.priority = category.priority
                expenseSubCategory.subPriority = category.subPriority
                
            }
            
        }
        
        saveContext()
        
    }
    
    func createAccount(name: String, amount: Int64, priority: Int64) {
        
        let account = Account(context: viewContext)
        
        account.initialValue = amount
        
        account.currentValue = amount
        
        account.name = name
        
        account.priority = priority
        
        saveContext()
        
    }
    
    func fetchCategory() -> [ExpenseCategory]? {
        
        let request = NSFetchRequest<ExpenseCategory>(entityName: "ExpenseCategory")
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "priority", ascending: true),
            NSSortDescriptor(key: "subPriority", ascending: true)
        ]
        
        do {
            
            return try viewContext.fetch(request)
            
        } catch {
            
            print("fetch expense category fail")
            
            return nil
            
        }
        
    }
    
    func saveAccounting(date: Date, amount: Int64, accountName: String, selectedSubCategory: ExpenseCategory) {
        
        let accounting = Accounting(context: viewContext)
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let account = try viewContext.fetch(request)

            accounting.occurDate = Int64(date.timeIntervalSince1970)

            accounting.amount = amount

            accounting.accountName = account[0]
            
            accounting.expenseSubCategory = selectedSubCategory
            
        } catch {
            
            print(error)
            
        }
        
        saveContext()
        
    }
    
    func fetchAccount() -> [Account]? {
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        
        do {
            
            return try viewContext.fetch(request)
            
        } catch {
            
            print("fetch account fail")
            
            return nil
            
        }
        
    }
    
    func deleteAccount(accountName: String) {
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let account = try viewContext.fetch(request)
            
            let request = NSFetchRequest<Account>(entityName: "Account")
            
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
            
            do {
                
                let accounts = try viewContext.fetch(request)
                
                var priority = Int(account[0].priority)
                
                while priority + 1 < accounts.count {
                    
                    accounts[priority + 1].priority -= 1
                    
                    priority += 1
                    
                }
                
            } catch {
                
                print(error)
                
            }
            
            viewContext.delete(account[0])
            
        } catch {
            
            print(error)
            
        }
        
        saveContext()
        
    }
    
    func reviseAccount(accountName: String, newName: String, newInitialValue: Int64) {
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let account = try viewContext.fetch(request)
            
            account[0].name = newName
            
            account[0].currentValue = account[0].currentValue + newInitialValue - account[0].initialValue
            
            account[0].initialValue = newInitialValue
            
        } catch {
            
            print("revise account fail")
            
        }
        
        saveContext()
        
    }
    
    func fetchAccounting() -> [Accounting]? {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        request.sortDescriptors = [NSSortDescriptor(key: "occurDate", ascending: true)]
        
        do {
            
            return try viewContext.fetch(request).reversed()
            
        } catch {
            
            print("fetch accounting fail")
            
            return nil
            
        }
        
    }
    
    func reviseAccounting(date: Int64, newDate: Date, amount: Int64, accountName: String, selectedSubCategory: ExpenseCategory) {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        request.predicate = NSPredicate(format: "occurDate == \(date)")
        
        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
        
        accountRequest.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let accounting = try viewContext.fetch(request)
            
            let account = try viewContext.fetch(accountRequest)
            
            accounting[0].occurDate = Int64(newDate.timeIntervalSince1970)
            
            accounting[0].amount = amount
            
            accounting[0].accountName = account[0]
            
            accounting[0].expenseSubCategory = selectedSubCategory
            
        } catch {
            
            print("revise accounting fail")
            
        }
        
        saveContext()
        
    }
    
}
