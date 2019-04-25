//
//  SavingProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

class SavingProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    let transformer = SavingTransformer()
    
    var savings: [Saving] {
        
        return coreDataManager.fetch(entityType: Saving(),
                                     sortFirst: "month",
                                     second: "amount",
                                     reverse: true)
        
    }
    
    var savingsWithDate: [SavingWithDate] {
        
        return transformer.transformFrom(savings: savings)
        
    }
    
    var savingsWithDateGroup: [[SavingWithDate]] {
        
        return transformer.transformFrom(savingsWithDate: savingsWithDate)
        
    }
    
    func createSaving(date: Date, amount: Int64, main: Bool = true, selectedExpenseCategory: ExpenseCategory? = nil) {
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.month = Int64(date.timeIntervalSince1970)
        
        saving.amount = amount
        
        saving.main = main
        
        saving.expenseSubCategory = selectedExpenseCategory
        
        coreDataManager.saveContext()
        
    }
    
    func deleteSubSaving(subSaving: Saving) {
        
        coreDataManager.viewContext.delete(subSaving)
        
        coreDataManager.saveContext()
        
    }
    
}
