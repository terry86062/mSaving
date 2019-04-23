//
//  AccountingProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

struct CategoryAccountingMonthTotal {
    
    let year: Int
    
    let month: Int
    
    var amount: Int64
    
    let expenseCategory: ExpenseCategory
    
    var accountings: [[AccountingWithDate]]
    
}

class AccountingProvider {
    
    var coreDataManager = CoreDataManager.shared
    
    var accountingWithDateArray: [AccountingWithDate] {
        
        guard let accountingArray = self.fetchAccounting() else { return [] }
        
        var accountingWithDateArray: [AccountingWithDate] = []
        
        guard accountingArray.count > 0 else { return accountingWithDateArray }
        
        for index in 0...accountingArray.count - 1 {
            
            let date = Date(timeIntervalSince1970: TimeInterval(accountingArray[index].occurDate))
            
            accountingWithDateArray.append(
                AccountingWithDate(accounting: accountingArray[index],
                                   date: date,
                                   dateComponents: Calendar.current.dateComponents(
                                    [.year, .month, .day, .weekday, .hour, .minute], from: date)))
            
        }
        
        return accountingWithDateArray
        
    }
    
    var accountingWithDateGroupArray: [[[AccountingWithDate]]] {
        
        var accountingWithDateGroupArray: [[[AccountingWithDate]]] = []
        
        guard accountingWithDateArray.count > 0 else { return accountingWithDateGroupArray }
        
        for index in 0...accountingWithDateArray.count - 1 {
            
            if index == 0 {
                
                accountingWithDateGroupArray.append([[accountingWithDateArray[index]]])
                
            } else {
                
                if accountingWithDateArray[index].dateComponents.month == accountingWithDateArray[index - 1].dateComponents.month &&
                    accountingWithDateArray[index].dateComponents.day == accountingWithDateArray[index - 1].dateComponents.day {
                    
                    let temp = accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1]
                    
                    accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1][temp.count - 1].append(accountingWithDateArray[index])
                    
                } else if accountingWithDateArray[index].dateComponents.month == accountingWithDateArray[index - 1].dateComponents.month {
                    
                    accountingWithDateGroupArray[accountingWithDateGroupArray.count - 1].append([accountingWithDateArray[index]])
                    
                } else {
                    
                    accountingWithDateGroupArray.insert([[accountingWithDateArray[index]]], at: 0)
                    
                }
                
            }
            
        }
        
        return accountingWithDateGroupArray
        
    }
    
    var categoryAccountingMonthTotalArray: [[CategoryAccountingMonthTotal]] {
        
        guard let accountingArray = self.fetchAccounting(sortOnlyWithDate: false) else { return [] }
        
        var accountingWithDateArray: [AccountingWithDate] = []
        
        guard accountingArray.count > 0 else { return [] }
        
        for index in 0...accountingArray.count - 1 {
            
            let date = Date(timeIntervalSince1970: TimeInterval(accountingArray[index].occurDate))
            
            accountingWithDateArray.append(
                AccountingWithDate(accounting: accountingArray[index],
                                   date: date,
                                   dateComponents: Calendar.current.dateComponents(
                                    [.year, .month, .day, .weekday, .hour, .minute], from: date)))
            
        }
        
        var categoryAccountingMonthTotals: [CategoryAccountingMonthTotal] = []
        
        guard accountingWithDateArray.count > 0 else { return [] }
        
        for index in 0...accountingWithDateArray.count - 1 {
            
            let accountingWithDate = accountingWithDateArray[index]
            
            guard let year = accountingWithDate.dateComponents.year,
                let month = accountingWithDate.dateComponents.month,
                let day = accountingWithDate.dateComponents.day,
                let expenseCategory = accountingWithDate.accounting.expenseSubCategory else { return [] }
            
            if index == 0 {
                
                categoryAccountingMonthTotals.append(
                    CategoryAccountingMonthTotal(year: year,
                                                 month: month,
                                                 amount: accountingWithDate.accounting.amount,
                                                 expenseCategory: expenseCategory,
                                                 accountings: [[accountingWithDate]]))
                
            } else {
                
                let accountingWithDatePreivous = accountingWithDateArray[index - 1]
                
                let lastNumber = categoryAccountingMonthTotals.count - 1
                
                let lastNumberInside = categoryAccountingMonthTotals[lastNumber].accountings.count - 1
                
                guard let yearPreivous = accountingWithDatePreivous.dateComponents.year,
                    let monthPreivous = accountingWithDatePreivous.dateComponents.month,
                    let dayPreivous = accountingWithDatePreivous.dateComponents.day,
                    let expenseCategoryPreivous = accountingWithDatePreivous.accounting.expenseSubCategory else { return [] }
                
                if expenseCategory == expenseCategoryPreivous &&
                    year == yearPreivous &&
                    month == monthPreivous &&
                    day == dayPreivous {
                    
                    categoryAccountingMonthTotals[lastNumber].amount += accountingWithDate.accounting.amount
                    categoryAccountingMonthTotals[lastNumber].accountings[lastNumberInside].append(accountingWithDate)
                    
                } else if expenseCategory == expenseCategoryPreivous &&
                    year == yearPreivous &&
                    month == monthPreivous {
                    
                    categoryAccountingMonthTotals[lastNumber].amount += accountingWithDate.accounting.amount
                    categoryAccountingMonthTotals[lastNumber].accountings.append([accountingWithDate])
                    
                } else {
                    
                    categoryAccountingMonthTotals.append(
                        CategoryAccountingMonthTotal(year: year,
                                                     month: month,
                                                     amount: accountingWithDate.accounting.amount,
                                                     expenseCategory: expenseCategory,
                                                     accountings: [[accountingWithDate]]))
                    
                }
                
            }
            
        }
        
        var categoryAccountingMonthTotalArray: [[CategoryAccountingMonthTotal]] = []
        
        guard categoryAccountingMonthTotals.count > 0 else { return [] }
        
        for index in 0...categoryAccountingMonthTotals.count - 1 {
            
            let categoryAccountingMonthTotal = categoryAccountingMonthTotals[index]
            
            let year = categoryAccountingMonthTotal.year
            let month = categoryAccountingMonthTotal.month
            let amount = categoryAccountingMonthTotal.amount
            
            if index == 0 {
                
                categoryAccountingMonthTotalArray.append([categoryAccountingMonthTotal])
                
            } else {
                
                for indexx in 0...categoryAccountingMonthTotalArray.count - 1 {
                    
                    var count = 0
                    
                    guard let yearInside = categoryAccountingMonthTotalArray[indexx].first?.year,
                        let monthInside = categoryAccountingMonthTotalArray[indexx].first?.month else { return [] }
                    
                    if year < yearInside {
                        
                        categoryAccountingMonthTotalArray.insert([categoryAccountingMonthTotal], at: indexx)
                        
                        break
                        
                    } else if year == yearInside && month < monthInside {
                        
                        categoryAccountingMonthTotalArray.insert([categoryAccountingMonthTotal], at: indexx)
                        
                        break
                        
                    } else if year == yearInside && month == monthInside {
                        
                        var countInside = 0
                        
                        for indexxx in 0...categoryAccountingMonthTotalArray[indexx].count - 1 {
                            
                            if amount >= categoryAccountingMonthTotalArray[indexx][indexxx].amount {
                                
                                categoryAccountingMonthTotalArray[indexx].insert(categoryAccountingMonthTotal, at: indexxx)
                                
                                break
                                
                            } else {
                                
                                countInside += 1
                                
                            }
                            
                        }
                        
                        if countInside == categoryAccountingMonthTotalArray[indexx].count {
                            
                            categoryAccountingMonthTotalArray[indexx].append(categoryAccountingMonthTotal)
                            
                        }
                        
                        break
                        
                    } else {
                        
                        count += 1
                        
                    }
                    
                    if count == categoryAccountingMonthTotalArray.count {
                        
                        categoryAccountingMonthTotalArray.append([categoryAccountingMonthTotal])
                        
                    }
                    
                }
                
            }
            
        }
        
        return categoryAccountingMonthTotalArray
        
    }
    
    func saveAccounting(date: Date, amount: Int64, accountName: String, selectedExpenseCategory: ExpenseCategory?, selectedIncomeCategory: IncomeCategory?, selectedExpense: Bool) {
        
        let accounting = Accounting(context: coreDataManager.viewContext)
        
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
            
            let accountings = try coreDataManager.viewContext.fetch(request)
            
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
            
            let account = try coreDataManager.viewContext.fetch(accountRequest)
            
            accounting.amount = amount
            
            if account.count > 0 {
                
                accounting.accountName = account[0]
                
            }
            
            if selectedExpense {
                
                accounting.expenseSubCategory = selectedExpenseCategory
                
                if account.count > 0 {
                    
                    account[0].currentValue -= amount
                    
                } else {
                    
                    let account = Account(context: coreDataManager.viewContext)
                    
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
                    
                    let account = Account(context: coreDataManager.viewContext)
                    
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
        
        coreDataManager.saveContext()
        
    }
    
    func fetchAccounting(sortOnlyWithDate: Bool = true) -> [Accounting]? {
        
        let request = NSFetchRequest<Accounting>(entityName: "Accounting")
        
        if sortOnlyWithDate {
            
            request.sortDescriptors = [NSSortDescriptor(key: "occurDate", ascending: true)]
            
        } else {
            
            request.sortDescriptors = [
                NSSortDescriptor(key: "expenseSubCategory", ascending: true),
                NSSortDescriptor(key: "occurDate", ascending: true)
            ]
            
        }
        
        do {
            
            return try coreDataManager.viewContext.fetch(request).reversed()
            
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
                
                accounting[0].expenseSubCategory = selectedExpenseCategory
                
                accounting[0].incomeSubCategory = nil
                
            } else {
                
                accounting[0].expenseSubCategory = nil
                
                accounting[0].incomeSubCategory = selectedIncomeCategory
                
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
