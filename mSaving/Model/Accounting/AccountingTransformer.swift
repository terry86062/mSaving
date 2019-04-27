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
    
    func transToCategoriesMonthTotal(accountings: [Accounting]) -> [CategoryMonthTotal] {
        
        var categoriesMonthTotal: [CategoryMonthTotal] = []
        
        guard accountings != [] else { return [] }
        
        for index in 0...accountings.count - 1 {
            
            let accounting = accountings[index]
            
            if index == 0 {
                
                categoriesMonthTotal.append(CategoryMonthTotal(amount: accounting.amount,
                                                               accountings: [[accounting]]))
                
            } else {
                
                let preAccounting = accountings[index - 1]
                
                let lastNumber = categoriesMonthTotal.count - 1
                
                let lastNumberInside = categoriesMonthTotal[lastNumber].accountings.count - 1
                
                if accounting.expenseCategory == preAccounting.expenseCategory &&
                    accounting.incomeCategory == preAccounting.incomeCategory &&
                    accounting.occurDate == preAccounting.occurDate {
                    
                    categoriesMonthTotal[lastNumber].amount += accounting.amount
                    categoriesMonthTotal[lastNumber].accountings[lastNumberInside].append(accounting)
                    
                } else {
                    
                    categoriesMonthTotal.append(CategoryMonthTotal(amount: accounting.amount,
                                                                   accountings: [[accounting]]))
                    
                }
                
            }
            
        }
        
        return categoriesMonthTotal
        
    }
    
    func sortAmount(categoriesMonthTotal: [CategoryMonthTotal]) -> [CategoryMonthTotal] {
        
        var newCategoriesMonthTotal: [CategoryMonthTotal] = []
        
        guard categoriesMonthTotal.count > 0 else { return [] }
        
        for index in 0...categoriesMonthTotal.count - 1 {
            
            let categoryMonthTotal = categoriesMonthTotal[index]
            
            if index == 0 {
                
                newCategoriesMonthTotal.append(categoryMonthTotal)
                
            } else {
                
                var count = 0
                
                for indexx in 0...newCategoriesMonthTotal.count - 1 {
                    
                    if categoryMonthTotal.amount >= newCategoriesMonthTotal[indexx].amount {
                        
                        newCategoriesMonthTotal.insert(categoryMonthTotal, at: indexx)
                        
                        count = 0
                        
                        break
                        
                    } else {
                        
                        count += 1
                        
                    }
                    
                    if count == newCategoriesMonthTotal.count {
                        
                        newCategoriesMonthTotal.append(categoryMonthTotal)
                        
                        count = 0
                        
                    }
                    
                }
                
            }
            
        }
        
        return newCategoriesMonthTotal
        
    }
    
    func sortExpenseIncome(categoriesMonthTotal: [CategoryMonthTotal]) ->
        (expense: [CategoryMonthTotal], income: [CategoryMonthTotal]) {
        
        var expense: [CategoryMonthTotal] = []
        
        var income: [CategoryMonthTotal] = []
        
        guard categoriesMonthTotal.count > 0 else { return (expense, income) }
        
        for index in 0...categoriesMonthTotal.count - 1 {
            
            let categoryMonthTotal = categoriesMonthTotal[index]
            
            if categoryMonthTotal.accountings[0][0].expenseCategory != nil {
                
                expense.append(categoryMonthTotal)
                
            } else {
                
                income.append(categoryMonthTotal)
                
            }
            
        }
        
        return (expense, income)
        
    }
    
}
