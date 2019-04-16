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
    
    func createAccount(name: String, initalAmount: Int64, priority: Int64, currentAmount: Int64 = 0) {
        
        let account = Account(context: viewContext)
        
        account.initialValue = initalAmount
        
        if currentAmount == 0 {
            
            account.currentValue = initalAmount
            
        } else {
            
            account.currentValue = currentAmount
            
        }
        
        account.name = name
        
        account.priority = priority
        
        saveContext()
        
    }
    
    func fetchExpenseCategory() -> [ExpenseCategory]? {
        
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
    
    func fetchIncomeCategory() -> [IncomeCategory]? {
        
        let request = NSFetchRequest<IncomeCategory>(entityName: "IncomeCategory")
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "priority", ascending: true),
            NSSortDescriptor(key: "subPriority", ascending: true)
        ]
        
        do {
            
            return try viewContext.fetch(request)
            
        } catch {
            
            print("fetch income category fail")
            
            return nil
            
        }
        
    }
    
    func saveAccounting(date: Date, amount: Int64, accountName: String, selectedExpenseCategory: ExpenseCategory?, selectedIncomeCategory: IncomeCategory?, selectedExpense: Bool) {
        
        let accounting = Accounting(context: viewContext)
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        let time = Int64(date.timeIntervalSince1970)
        
        print("time \(time)")
        
        let beginDate = time - time % 86400 + 57600
        
        print("beginDate \(beginDate)")
        
        let finishDate = beginDate + 86400 - 1
        
        print("finishDate \(finishDate)")
        
        request.predicate = NSPredicate(format: "occurDate BETWEEN { \(beginDate) , \(finishDate) }")
        
        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
        
        accountRequest.predicate = NSPredicate(format: "name = %@", accountName)
        
        do {
            
            let accountings = try viewContext.fetch(request)
            
            var isRepeat = false
            
            if accountings.count > 0 {
                
                for index in 0...accountings.count - 1 {
                    
                    if time == accountings[index].occurDate {
                        
                        isRepeat = true
                        
                        break
                        
                    }
                    
                }
                
            }
            
            if isRepeat {
                
                for newTime in beginDate...finishDate {
                    
                    if accounting.occurDate == 0 {
                        
                        var count = 0
                        
                        for index in 0...accountings.count - 1 {
                            
                            if newTime == accountings[index].occurDate {
                                
                                break
                                
                            } else {
                                
                                count += 1
                                
                            }
                            
                            if count == accountings.count {
                                
                                accounting.occurDate = newTime
                                
                            }
                            
                        }
                        
                    } else {
                        
                        break
                        
                    }
                    
                }
                
            } else {
                
                accounting.occurDate = Int64(date.timeIntervalSince1970)
                
            }
            
            let account = try viewContext.fetch(accountRequest)

            accounting.amount = amount

            if account.count > 0 {
                
                accounting.accountName = account[0]
                
            }
            
            if selectedExpense {
                
                accounting.expenseSubCategory = selectedExpenseCategory
                
                if account.count > 0 {
                    
                    account[0].currentValue -= amount
                    
                } else {
                    
                    let account = Account(context: viewContext)
                    
                    account.initialValue = 0
                    
                    account.currentValue = -amount
                    
                    account.name = "現金"
                    
                    account.priority = 0
                    
                    accounting.accountName = account
                    
                }
                
            } else {
                
                accounting.incomeSubCategory = selectedIncomeCategory
                
                if account.count > 0 {
                    
                    account[0].currentValue += amount
                    
                } else {
                    
                    let account = Account(context: viewContext)
                    
                    account.initialValue = 0
                    
                    account.currentValue = amount
                    
                    account.name = "現金"
                    
                    account.priority = 0
                    
                    accounting.accountName = account
                    
                }
                
            }
            
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
    
    // swiftlint:disable function_parameter_count
    func reviseAccounting(date: Int64,
                          newDate: Date,
                          amount: Int64,
                          accountName: String,
                          selectedExpenseCategory: ExpenseCategory?,
                          selectedIncomeCategory: IncomeCategory?,
                          selectedExpense: Bool,
                          reviseSelectedExpense: Bool) {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        request.predicate = NSPredicate(format: "occurDate == \(date)")
        
        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
        
        accountRequest.predicate = NSPredicate(format: "name = %@", accountName)
        
        let requests = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        let time = Int64(newDate.timeIntervalSince1970)
        
        print("time \(time)")
        
        let beginDate = time - time % 86400 + 57600
        
        print("beginDate \(beginDate)")
        
        let finishDate = beginDate + 86400 - 1
        
        print("finishDate \(finishDate)")
        
        requests.predicate = NSPredicate(format: "occurDate BETWEEN { \(beginDate) , \(finishDate) }")
        
        do {
            
            let accounting = try viewContext.fetch(request)
            
            let accountings = try viewContext.fetch(requests)
            
            var isRepeat = false
            
            if accountings.count > 0 {
                
                for index in 0...accountings.count - 1 {
                    
                    if time == accountings[index].occurDate {
                        
                        isRepeat = true
                        
                        break
                        
                    }
                    
                }
                
            }
            
            if isRepeat {
                
                for newTime in beginDate...finishDate {
                    
                    if accounting[0].occurDate == date {
                        
                        var count = 0
                        
                        for index in 0...accountings.count - 1 {
                            
                            if newTime == accountings[index].occurDate {
                                
                                break
                                
                            } else {
                                
                                count += 1
                                
                            }
                            
                            if count == accountings.count {
                                
                                accounting[0].occurDate = newTime
                                
                            }
                            
                        }
                        
                    } else {
                        
                        break
                        
                    }
                    
                }
                
            } else {
                
                accounting[0].occurDate = Int64(newDate.timeIntervalSince1970)
                
            }
            
            let account = try viewContext.fetch(accountRequest)
            
            if reviseSelectedExpense {
                
                if selectedExpense {
                    
                    accounting[0].accountName?.currentValue += accounting[0].amount
                    
                    account[0].currentValue -= amount
                    
                } else {
                    
                    accounting[0].accountName?.currentValue += accounting[0].amount
                    
                    account[0].currentValue += amount
                    
                }
                
            } else {
                
                if selectedExpense {
                    
                    accounting[0].accountName?.currentValue -= accounting[0].amount
                    
                    account[0].currentValue -= amount
                    
                } else {
                    
                    accounting[0].accountName?.currentValue -= accounting[0].amount
                    
                    account[0].currentValue += amount
                    
                }
                
            }
            
            accounting[0].amount = amount
            
            accounting[0].accountName = account[0]
            
            if selectedExpense {
                
                accounting[0].expenseSubCategory = selectedExpenseCategory
                
                accounting[0].incomeSubCategory = nil
                
            } else {
                
                accounting[0].expenseSubCategory = nil
                
                accounting[0].incomeSubCategory = selectedIncomeCategory
                
            }
            
        } catch {
            
            print("revise accounting fail")
            
        }
        
        saveContext()
        
    }
    // swiftlint:enable function_parameter_count
    
    func deleteAccounting(date: Int64, reviseSelectedExpense: Bool) {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        request.predicate = NSPredicate(format: "occurDate == \(date)")
        
        do {
            
            let accounting = try viewContext.fetch(request)
            
            if reviseSelectedExpense {
                
                accounting[0].accountName?.currentValue += accounting[0].amount
                
            } else {
                
                accounting[0].accountName?.currentValue -= accounting[0].amount
                
            }
            
            viewContext.delete(accounting[0])
            
        } catch {
            
            print(error)
            
        }
        
        saveContext()
        
    }
    
}
