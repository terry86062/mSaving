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
    
    var coreDataManager = CoreDataManager.shared
    
    var savings: [Saving]? {
        
        return coreDataManager.fetch(entityType: Saving(),
                                     sortFirst: "month",
                                     second: "amount",
                                     reverse: true)
        
    }
    
    func createSaving(main: Bool, date: Date, amount: Int64) {
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.main = main
        
        saving.month = Int64(date.timeIntervalSince1970)
        
        saving.amount = amount
        
        coreDataManager.saveContext()
        
    }
    
    func createSubSaving(main: Bool, date: Date, amount: Int64, selectedExpenseCategory: ExpenseCategory) {
        
        let saving = Saving(context: coreDataManager.viewContext)
        
        saving.main = main
        
        saving.month = Int64(date.timeIntervalSince1970)
        
        saving.amount = amount
        
        saving.expenseSubCategory = selectedExpenseCategory
        
        coreDataManager.saveContext()
        
    }
    
    func deleteSubSaving(subSaving: Saving) {
        
        coreDataManager.viewContext.delete(subSaving)
        
        coreDataManager.saveContext()
        
    }
    
}
