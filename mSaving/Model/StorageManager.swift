//
//  StorageManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    lazy var persistanceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "STYLiSH")
        
        container.loadPersistentStores(completionHandler: { (description, error) in
            
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistanceContainer.viewContext
    }
    
    func initExpenseIncomeCategory() {
        
        
        
    }
    
}
