//
//  SavingProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class SavingProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let notificationManager = NotificationManager()
    
    let messageViewManager = MessageViewManager()
    
    func createSaving(month: Month, amount: Int64, main: Bool = true, selectedExpenseCategory: ExpenseCategory? = nil) {
        
        if checkSaving(month: month, amount: amount, main: main,
                       selectedExpenseCategory: selectedExpenseCategory) == false {
            
            return
            
        }
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.month = month
        
        saving.amount = amount
        
        saving.main = main
        
        saving.expenseCategory = selectedExpenseCategory
        
        coreDataManager.saveContext()
        
        notificationManager.postSavingChanged()
        
        if main {
            
            messageViewManager.show(saving: saving, type: .add)
            
        } else {
            
            messageViewManager.show(subSaving: saving, type: .add)
            
        }
        
    }
    
    func fetchSaving(month: Month) -> [Saving] {
        
        return coreDataManager.fetch(entityType: Saving(),
                                               sort: ["main", "amount"],
                                               predicate: NSPredicate(format: "month == %@", month),
                                               reverse: true)
        
    }
    
    func checkSaving(month: Month, amount: Int64, main: Bool = true,
                     selectedExpenseCategory: ExpenseCategory? = nil) -> Bool {
        
        if main == false {
            
            let savings = fetchSaving(month: month)
            
            if savings == [] {
                
                createSaving(month: month, amount: amount)
                
            } else {
                
                for index in 0...savings.count - 1 where savings[index].expenseCategory == selectedExpenseCategory {
                    
                    print("already exist subsaving for \(month.year) \(month.month)")
                    
                    return false
                    
                }
                
                var countTotal = amount
                
                var mainSaving: Saving?
                
                for index in 0...savings.count - 1 {
                    
                    if savings[index].expenseCategory != nil {
                        
                        countTotal += savings[index].amount
                        
                    } else {
                        
                        mainSaving = savings[index]
                        
                    }
                    
                }
                
                if let main = mainSaving, countTotal > main.amount {
                    
                    main.amount = countTotal
                    
                }
                
            }
            
        }
        
        return true
        
    }
    
    func reviseSaving(saving: Saving, amount: Int64, selectedExpenseCategory: ExpenseCategory? = nil) {
        
        if saving.main {
            
            saving.amount = amount
            
        } else {
            
            guard let month = saving.month else { return }
            
            if saving.expenseCategory == selectedExpenseCategory {
                
                checkSaving(month: month, amount: amount - saving.amount,
                            main: saving.main, selectedExpenseCategory: nil)
                
            } else {
                
                if checkSaving(month: month, amount: amount - saving.amount,
                               main: saving.main, selectedExpenseCategory: selectedExpenseCategory) == false {
                    
                    return
                    
                }
                
            }
            
            saving.amount = amount
            
            saving.expenseCategory = selectedExpenseCategory
            
        }
        
        CoreDataManager.shared.saveContext()
        
        NotificationManager().postSavingChanged()
        
        if saving.main {
            
            messageViewManager.show(saving: saving, type: .revise)
            
        } else {
            
            messageViewManager.show(subSaving: saving, type: .revise)
            
        }
        
    }
    
    func delete(saving: Saving) {
        
        messageViewManager.show(subSaving: saving, type: .delete)
        
        coreDataManager.viewContext.delete(saving)
        
        coreDataManager.saveContext()
        
        notificationManager.postSavingChanged()
        
    }
    
}
