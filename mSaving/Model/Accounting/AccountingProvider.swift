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

struct CategoryMonthTotal {
    
    var amount: Int64
    
    var accountings: [[Accounting]]
    
}

class AccountingProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let transformer = AccountingTransformer()
    
    let notificationManager = MSNotificationManager()
    
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
    
    func fetchAccountingsGroup(month: Month) -> [[Accounting]] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(),
                                                sort: ["occurDate", "createDate"],
                                                predicate: NSPredicate(format: "month == %@", month),
                                                reverse: true)
        
        return transformer.transToAccountingsGroup(accountings: accountings)
        
    }
    
    func fetchCategoriesMonthTotal(month: Month) -> [CategoryMonthTotal] {
        
        let accountings = coreDataManager.fetch(entityType: Accounting(),
                                                sort: ["expenseCategory", "occurDate", "createDate"],
                                                predicate: NSPredicate(format: "month == %@", month),
                                                reverse: true)
        
        let categoriesMonthTotal = transformer.transToCategoriesMonthTotal(accountings: accountings)
        
        return transformer.sortAmount(categoriesMonthTotal: categoriesMonthTotal)
        
    }
    
    func fetchExpenseIncomeMonthTotal(month: Month) -> (expense: [CategoryMonthTotal], income: [CategoryMonthTotal]) {
        
        let categoriesMonthTotal = fetchCategoriesMonthTotal(month: month)
        
        return transformer.sortExpenseIncome(categoriesMonthTotal: categoriesMonthTotal)
        
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
    
    func reviseAccounting(accounting: Accounting,
                          occurDate: Date,
                          createDate: Date,
                          amount: Int64,
                          account: Account,
                          category: CategoryCase) {
        
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
