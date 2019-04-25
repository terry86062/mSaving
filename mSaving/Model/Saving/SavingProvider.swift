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
    
    let transformer = SavingTransformer()
    
    var savings: [Saving] {
        
        return coreDataManager.fetch(entityType: Saving(), sort: ["month", "amount"], predicate: "", reverse: true)
        
    }
    
//    var savingsWithDate: [SavingWithDate] {
//
//        return transformer.transformFrom(savings: savings)
//
//    }
    
//    var savingsWithDateGroup: [[SavingWithDate]] {
//        
//        return transformer.transformFrom(savingsWithDate: savingsWithDate)
//        
//    }
    
    func createSaving(month: Month, amount: Int64, main: Bool = true, selectedExpenseCategory: ExpenseCategory? = nil) {
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.month = month
        
        saving.amount = amount
        
        saving.main = main
        
        saving.expenseCategory = selectedExpenseCategory
        
        coreDataManager.saveContext()
        
    }
    
    func deleteSubSaving(subSaving: Saving) {
        
        coreDataManager.viewContext.delete(subSaving)
        
        coreDataManager.saveContext()
        
    }
    
}
