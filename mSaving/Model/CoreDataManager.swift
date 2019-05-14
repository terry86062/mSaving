//
//  StorageManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    static let persistentContainer: NSPersistentContainer = {
        
        let container = NSCustomPersistentContainer(name: "mSaving")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        })
        
        return container
        
    }()
    
    init(container: NSPersistentContainer = CoreDataManager.persistentContainer) {
        
        persistentContainer = container
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: - Core Data stack
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
        
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if viewContext.hasChanges {
            
            do {
                
                try viewContext.save()
                
                print("save success")
                
            } catch {
                
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                
            }
            
        }
        
    }
    
    func fetch<T: NSManagedObject>(entityType: T,
                                   sort: [String],
                                   predicate: NSPredicate? = nil,
                                   reverse: Bool = false) -> [T] {
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        if predicate != nil {
            
            request.predicate = predicate
            
        }
        
        request.sortDescriptors = helpSortWith(stringArray: sort)
        
        do {
            
            if reverse {
                
                return try viewContext.fetch(request).reversed()
                
            } else {
                
                return try viewContext.fetch(request)
                
            }
            
        } catch {
            
            print("fetch \(String(describing: T.self)) fail")
            
            return []
            
        }
        
    }
    
    func helpSortWith(stringArray: [String]) -> [NSSortDescriptor] {
        
        var sortDescriptors: [NSSortDescriptor] = []
        
        guard stringArray != [] else { return [] }
        
        for index in 0...stringArray.count - 1 {
            
            sortDescriptors.append(NSSortDescriptor(key: stringArray[index], ascending: true))
            
        }
        
        return sortDescriptors
        
    }
    
}

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        
        var storeURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.terry.mSaving")
        
        if let url = storeURL {
            
            print(url)
            
        }
        
        storeURL = storeURL?.appendingPathComponent("mSaving.sqlite")
        
        return storeURL!
        
    }
    
}
