//
//  AccountingProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

enum CategoryCase {
    
    case expense(ExpenseCategory)
    
    case income(IncomeCategory)
    
}

struct AccountingWithDate {
    
    let accounting: Accounting
    
    let date: Date
    
    let dateComponents: DateComponents
    
}

struct CategoryMonthTotal {
    
    let year: Int
    
    let month: Int
    
    var amount: Int64
    
    let expenseCategory: ExpenseCategory?
    
    let incomeCategory: IncomeCategory?
    
    var accountings: [[AccountingWithDate]]
    
}

class AccountingProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let transformer = AccountingTransformer()
    
    let notificationManager = MSNotificationManager()
    
    var accountingsWithDate: [AccountingWithDate] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(), sort: ["occurDate"], predicate: "", reverse: true)
        
        return transformer.transformFrom(accountings: accountings)
        
    }
    
    var accountingsWithDateGroup: [[[AccountingWithDate]]] {
        
        return transformer.transformFrom(accountingsWithDate: accountingsWithDate)
        
    }
    
    var categoriesMonthTotalGroup: [[CategoryMonthTotal]] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(), sort: ["expenseSubCategory", "occurDate"], predicate: "", reverse: true)
        
        let accountingsWithDate = transformer.transformFrom(accountings: accountings)
        
        let categoriesMonthTotal = transformer.transformToTotal(accountingsWithDate: accountingsWithDate)
        
        return transformer.transformFrom(categoriesMonthTotal: categoriesMonthTotal)
        
    }
    
//    func saveAccounting(date: Date, amount: Int64, accountName: String, selectedExpenseCategory: ExpenseCategory?, selectedIncomeCategory: IncomeCategory?, selectedExpense: Bool) {
//        
//        let accounting = Accounting(context: coreDataManager.viewContext)
//        
//        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
//        
//        let time = Int64(date.timeIntervalSince1970)
//        
//        print("time \(time)")
//        
//        let beginDate = time - time % 86400 + 57600
//        
//        print("beginDate \(beginDate)")
//        
//        let finishDate = beginDate + 86400 - 1
//        
//        print("finishDate \(finishDate)")
//        
//        request.predicate = NSPredicate(format: "occurDate BETWEEN { \(beginDate) , \(finishDate) }")
//        
//        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
//        
//        accountRequest.predicate = NSPredicate(format: "name = %@", accountName)
//        
//        do {
//            
//            let accountings = try coreDataManager.viewContext.fetch(request)
//            
//            var isRepeat = false
//            
//            if accountings.count > 0 {
//                
//                for index in 0...accountings.count - 1 {
//                    
//                    if time == accountings[index].occurDate {
//                        
//                        isRepeat = true
//                        
//                        break
//                        
//                    }
//                    
//                }
//                
//            }
//            
//            if isRepeat {
//                
//                for newTime in beginDate...finishDate {
//                    
//                    if accounting.occurDate == 0 {
//                        
//                        var count = 0
//                        
//                        for index in 0...accountings.count - 1 {
//                            
//                            if newTime == accountings[index].occurDate {
//                                
//                                break
//                                
//                            } else {
//                                
//                                count += 1
//                                
//                            }
//                            
//                            if count == accountings.count {
//                                
//                                accounting.occurDate = newTime
//                                
//                            }
//                            
//                        }
//                        
//                    } else {
//                        
//                        break
//                        
//                    }
//                    
//                }
//                
//            } else {
//                
//                accounting.occurDate = Int64(date.timeIntervalSince1970)
//                
//            }
//            
//            let account = try coreDataManager.viewContext.fetch(accountRequest)
//            
//            accounting.amount = amount
//            
//            if account.count > 0 {
//                
//                accounting.accountName = account[0]
//                
//            }
//            
//            if selectedExpense {
//                
//                accounting.expenseCategory = selectedExpenseCategory
//                
//                if account.count > 0 {
//                    
//                    account[0].currentValue -= amount
//                    
//                } else {
//                    
//                    let account = Account(context: coreDataManager.viewContext)
//                    
//                    account.initialValue = 0
//                    
//                    account.currentValue = -amount
//                    
//                    account.name = "現金"
//                    
//                    account.priority = 0
//                    
//                    accounting.accountName = account
//                    
//                }
//                
//            } else {
//                
//                accounting.incomeCategory = selectedIncomeCategory
//                
//                if account.count > 0 {
//                    
//                    account[0].currentValue += amount
//                    
//                } else {
//                    
//                    let account = Account(context: coreDataManager.viewContext)
//                    
//                    account.initialValue = 0
//                    
//                    account.currentValue = amount
//                    
//                    account.name = "現金"
//                    
//                    account.priority = 0
//                    
//                    accounting.accountName = account
//                    
//                }
//                
//            }
//            
//        } catch {
//            
//            print(error)
//            
//        }
//        
//        coreDataManager.saveContext()
//        
//        notificationManager.postNotificationForRenew()
//        
//    }
    
    func createAccounting(occurDate: Date, createDate: Date, amount: Int64, account: Account, category: CategoryCase) {
        
        let accounting = Accounting(context: coreDataManager.viewContext)
        
        guard let month = helpSetMonth(occurDate: occurDate) else { return }
        
        accounting.month = month
        
        accounting.occurDate = Int64(occurDate.timeIntervalSince1970)
        
        accounting.createDate = Int64(createDate.timeIntervalSince1970)
        
        accounting.amount = amount
        
        accounting.accountName = account
                
        switch category {
            
        case .expense(let category):
            
            accounting.expenseCategory = category
            
            account.currentValue -= amount
            
        case .income(let category):
            
            accounting.incomeCategory = category
            
            account.currentValue += amount
            
        }
        
        coreDataManager.saveContext()
        
        notificationManager.postNotificationForRenew()
        
    }
    
    func helpSetMonth(occurDate: Date) -> Month? {
        
        let dataComponents = TimeManager().transform(date: occurDate)
        
        guard let year = dataComponents.year, let month = dataComponents.month else { return nil }
        
        let months = MonthProvider().months
        
        if months != [] {
            
            for index in 0...months.count - 1 {
                
                if months[index].year == year && months[index].month == month {
                    
                    return months[index]
                    
                }
                
            }
            
        }
        
        let aMonth = Month(context: coreDataManager.viewContext)
        
        aMonth.year = Int64(year)
        
        aMonth.month = Int64(month)
        
        return aMonth
        
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
            
            let accounting = try coreDataManager.viewContext.fetch(request)
            
            let accountings = try coreDataManager.viewContext.fetch(requests)
            
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
            
            let account = try coreDataManager.viewContext.fetch(accountRequest)
            
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
                
                accounting[0].expenseCategory = selectedExpenseCategory
                
                accounting[0].incomeCategory = nil
                
            } else {
                
                accounting[0].expenseCategory = nil
                
                accounting[0].incomeCategory = selectedIncomeCategory
                
            }
            
        } catch {
            
            print("revise accounting fail")
            
        }
        
        coreDataManager.saveContext()
        
    }
    // swiftlint:enable function_parameter_count
    
    func deleteAccounting(date: Int64, reviseSelectedExpense: Bool) {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        request.predicate = NSPredicate(format: "occurDate == \(date)")
        
        do {
            
            let accounting = try coreDataManager.viewContext.fetch(request)
            
            if reviseSelectedExpense {
                
                accounting[0].accountName?.currentValue += accounting[0].amount
                
            } else {
                
                accounting[0].accountName?.currentValue -= accounting[0].amount
                
            }
            
            coreDataManager.viewContext.delete(accounting[0])
            
        } catch {
            
            print(error)
            
        }
        
        coreDataManager.saveContext()
        
    }
    
}
