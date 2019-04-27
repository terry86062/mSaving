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

//struct AccountingWithDate {
//
//    let accounting: Accounting
//
//    let date: Date
//
//    let dateComponents: DateComponents
//
//}

struct CategoryMonthTotal {
    
//    let year: Int
//
//    let month: Int
    
    var amount: Int64
    
//    let expenseCategory: ExpenseCategory?
//
//    let incomeCategory: IncomeCategory?
    
    var accountings: [[Accounting]]
    
}

class AccountingProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let transformer = AccountingTransformer()
    
    let notificationManager = MSNotificationManager()
    
//    var accountingsWithDate: [AccountingWithDate] {
//        
//        let accountings = coreDataManager.fetch(entityType: Accounting(), sort: ["occurDate"], predicate: nil, reverse: true)
//        
//        return transformer.transformFrom(accountings: accountings)
//        
//    }
//    
//    var accountingsWithDateGroup: [[[AccountingWithDate]]] {
//        
//        return transformer.transformFrom(accountingsWithDate: accountingsWithDate)
//        
//    }
    
//    var categoriesMonthTotalGroup: [[CategoryMonthTotal]] {
//
//        let accountings = coreDataManager.fetch(entityType: Accounting(), sort: ["expenseCategory", "occurDate"], predicate: nil, reverse: true)
//
//        let accountingsWithDate = transformer.transformFrom(accountings: [])
//
//        let categoriesMonthTotal = transformer.transformToTotal(accountingsWithDate: accountingsWithDate)
//
//        return transformer.transformFrom(categoriesMonthTotal: categoriesMonthTotal)
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
        
        notificationManager.postAccountingChanged()
        
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
    
    func fetchAccounting(month: Month) -> [[Accounting]] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(),
                                                sort: ["occurDate", "createDate"],
                                                predicate: NSPredicate(format: "month == %@", month),
                                                reverse: true)
        
        return transformer.transToAccountingsGroup(accountings: accountings)
        
    }
    
    func fetchAccountingCategory(month: Month) -> [CategoryMonthTotal] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(),
                                                sort: ["expenseCategory", "occurDate", "createDate"],
                                                predicate: NSPredicate(format: "month == %@", month),
                                                reverse: true)
        
        let categoriesMonthTotal = transformer.transToAccountingsCategory(accountings: accountings)
        
        return transformer.sort(categoriesMonthTotal: categoriesMonthTotal)
        
    }
    
    func getTotalSpend(month: Month) -> Int {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(),
                                                sort: ["occurDate", "createDate"],
                                                predicate: NSPredicate(format: "month == %@", month),
                                                reverse: true)
        
        var totalSpend = 0
        
        guard accountings != [] else { return 0 }

        for index in 0...accountings.count - 1 where accountings[index].expenseCategory != nil {
            
            totalSpend += Int(accountings[index].amount)
            
        }
        
        return totalSpend
        
    }
    
    func reviseAccounting(accounting: Accounting, occurDate: Date, createDate: Date, amount: Int64, account: Account, category: CategoryCase) {
        
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
        
        notificationManager.postAccountingChanged()
        
    }
    
    func deleteAccounting(accounting: Accounting) {
        
        coreDataManager.viewContext.delete(accounting)
        
        coreDataManager.saveContext()
        
        notificationManager.postAccountingChanged()
        
    }
    
}
