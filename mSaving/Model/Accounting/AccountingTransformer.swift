//
//  AccountingTransformer.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class AccountingTransformer {
    
    func transToAccountingsGroup(accountings: [Accounting]) -> [[Accounting]] {
        
        var accountingsGroup: [[Accounting]] = []
        
        guard accountings != [] else { return [] }
        
        for index in 0...accountings.count - 1 {
            
            let accounting = accountings[index]
            
            if index == 0 {
                
                accountingsGroup.append([accounting])
                
            } else {
                
                let preAccounting = accountings[index - 1]
                
                if accounting.occurDate == preAccounting.occurDate {
                    
                    accountingsGroup[accountingsGroup.count - 1].append(accounting)
                    
                } else {
                    
                    accountingsGroup.append([accounting])
                    
                }
                
            }
            
        }
        
        return accountingsGroup
        
    }
    
    
    func transformFrom(accountings: [Accounting]) -> [AccountingWithDate] {
        
        var accountingsWithDate: [AccountingWithDate] = []
        
        guard accountings.count > 0 else { return [] }
        
        for index in 0...accountings.count - 1 {
            
            let date = Date(timeIntervalSince1970: TimeInterval(accountings[index].occurDate))
            
            accountingsWithDate.append(
                AccountingWithDate(accounting: accountings[index],
                                   date: date,
                                   dateComponents: Calendar.current.dateComponents(
                                    [.year, .month, .day, .weekday, .hour, .minute], from: date)))
            
        }
        
        return accountingsWithDate
        
    }
    
    func transformFrom(accountingsWithDate: [AccountingWithDate]) -> [[[AccountingWithDate]]] {
        
        var accountingsWithDateGroup: [[[AccountingWithDate]]] = []
        
        guard accountingsWithDate.count > 0 else { return [] }
        
        for index in 0...accountingsWithDate.count - 1 {
            
            if index == 0 {
                
                accountingsWithDateGroup.append([[accountingsWithDate[index]]])
                
            } else {
                
                let dateComponents = accountingsWithDate[index].dateComponents
                
                let preDateComponents = accountingsWithDate[index - 1].dateComponents
                
                if dateComponents.month == preDateComponents.month &&
                    dateComponents.day == preDateComponents.day {
                    
                    let lastOne = accountingsWithDateGroup[0]
                    
                    accountingsWithDateGroup[0][lastOne.count - 1].append(accountingsWithDate[index])
                    
                } else if dateComponents.month == preDateComponents.month {
                    
                    accountingsWithDateGroup[0].append([accountingsWithDate[index]])
                    
                } else {
                    
                    accountingsWithDateGroup.insert([[accountingsWithDate[index]]], at: 0)
                    
                }
                
            }
            
        }
        
        return accountingsWithDateGroup
        
    }
    
    func transformToTotal(accountingsWithDate: [AccountingWithDate]) -> [CategoryMonthTotal] {
        
        var categoriesMonthTotal: [CategoryMonthTotal] = []
        
        guard accountingsWithDate.count > 0 else { return [] }
        
        for index in 0...accountingsWithDate.count - 1 {
            
            let accountingWithDate = accountingsWithDate[index]
            
            let accounting = accountingWithDate.accounting
            
            let dateComponents = accountingWithDate.dateComponents
            
            guard let year = dateComponents.year,let month = dateComponents.month, let day = dateComponents.day
                else { return [] }
            
            if index == 0 {
                
                categoriesMonthTotal.append(CategoryMonthTotal(year: year, month: month,
                                                               amount: accountingWithDate.accounting.amount,
                                                               expenseCategory: accounting.expenseCategory,
                                                               incomeCategory: accounting.incomeCategory,
                                                               accountings: [[accountingWithDate]]))
                
            } else {
                
                let preAccountingWithDate = accountingsWithDate[index - 1]
                
                let preAccounting = preAccountingWithDate.accounting
                
                let lastNumber = categoriesMonthTotal.count - 1
                
                let lastNumberInside = categoriesMonthTotal[lastNumber].accountings.count - 1
                
                let preDateComponents = preAccountingWithDate.dateComponents
                
                guard let preYear = preDateComponents.year,
                    let preMonth = preDateComponents.month,
                    let preDay = preDateComponents.day
                    else { return [] }
                
                if year == preYear && month == preMonth && day == preDay &&
                    accounting.expenseCategory == preAccounting.expenseCategory &&
                    accounting.incomeCategory == preAccounting.incomeCategory {
                    
                    categoriesMonthTotal[lastNumber].amount += accountingWithDate.accounting.amount
                    categoriesMonthTotal[lastNumber].accountings[lastNumberInside].append(accountingWithDate)
                    
                } else if year == preYear && month == preMonth &&
                    accounting.expenseCategory == preAccounting.expenseCategory &&
                    accounting.incomeCategory == preAccounting.incomeCategory {
                    
                    categoriesMonthTotal[lastNumber].amount += accountingWithDate.accounting.amount
                    categoriesMonthTotal[lastNumber].accountings.append([accountingWithDate])
                    
                } else {
                    
                    categoriesMonthTotal.append(
                        CategoryMonthTotal(year: year, month: month,
                                           amount: accountingWithDate.accounting.amount,
                                           expenseCategory: accounting.expenseCategory,
                                           incomeCategory: accounting.incomeCategory,
                                           accountings: [[accountingWithDate]]))
                    
                }
                
            }
            
        }
        
        return categoriesMonthTotal
        
    }
    
    func transformFrom(categoriesMonthTotal: [CategoryMonthTotal]) -> [[CategoryMonthTotal]] {
        
        var categoriesMonthTotalGroup: [[CategoryMonthTotal]] = []
        
        guard categoriesMonthTotal.count > 0 else { return [] }
        
        for index in 0...categoriesMonthTotal.count - 1 {
            
            let categoryMonthTotal = categoriesMonthTotal[index]
            
            let year = categoryMonthTotal.year
            let month = categoryMonthTotal.month
            let amount = categoryMonthTotal.amount
            
            if index == 0 {
                
                categoriesMonthTotalGroup.append([categoryMonthTotal])
                
            } else {
                
                for indexx in 0...categoriesMonthTotalGroup.count - 1 {
                    
                    var count = 0
                    
                    guard let yearInside = categoriesMonthTotalGroup[indexx].first?.year,
                        let monthInside = categoriesMonthTotalGroup[indexx].first?.month else { return [] }
                    
                    if year < yearInside {
                        
                        categoriesMonthTotalGroup.insert([categoryMonthTotal], at: indexx)
                        
                        break
                        
                    } else if year == yearInside && month < monthInside {
                        
                        categoriesMonthTotalGroup.insert([categoryMonthTotal], at: indexx)
                        
                        break
                        
                    } else if year == yearInside && month == monthInside {
                        
                        var countInside = 0
                        
                        for indexxx in 0...categoriesMonthTotalGroup[indexx].count - 1 {
                            
                            if amount >= categoriesMonthTotalGroup[indexx][indexxx].amount {
                                
                                categoriesMonthTotalGroup[indexx].insert(categoryMonthTotal, at: indexxx)
                                
                                break
                                
                            } else {
                                
                                countInside += 1
                                
                            }
                            
                        }
                        
                        if countInside == categoriesMonthTotalGroup[indexx].count {
                            
                            categoriesMonthTotalGroup[indexx].append(categoryMonthTotal)
                            
                        }
                        
                        break
                        
                    } else {
                        
                        count += 1
                        
                    }
                    
                    if count == categoriesMonthTotalGroup.count {
                        
                        categoriesMonthTotalGroup.append([categoryMonthTotal])
                        
                    }
                    
                }
                
            }
            
        }
        
        return categoriesMonthTotalGroup
        
    }
    
}
