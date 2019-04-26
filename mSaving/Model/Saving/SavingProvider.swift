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
    
    func createSaving(month: Month, amount: Int64, main: Bool = true, selectedExpenseCategory: ExpenseCategory? = nil) {
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.month = month
        
        saving.amount = amount
        
        saving.main = main
        
        saving.expenseCategory = selectedExpenseCategory
        
        coreDataManager.saveContext()
        
    }
    
    func fetchSaving(month: Month) -> [Saving] {
        
        return coreDataManager.fetch(entityType: Saving(),
                                     sort: ["main", "amount"],
                                     predicate: NSPredicate(format: "month == %@", month),
                                     reverse: true)
        
    }
    
    func delete(saving: Saving) {
        
        coreDataManager.viewContext.delete(saving)
        
        coreDataManager.saveContext()
        
    }
    
}
