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
    
    private init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSCustomPersistentContainer(name: "mSaving")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        })
        
        return container
        
    }()
    
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
    
    func fetch<T: NSManagedObject>(entityType: T, sortFirst: String, second: String, reverse: Bool) -> [T]? {
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        if second == "" {
            
            request.sortDescriptors = [NSSortDescriptor(key: sortFirst, ascending: true)]
            
        } else {
            
            request.sortDescriptors = [
                NSSortDescriptor(key: sortFirst, ascending: true),
                NSSortDescriptor(key: second, ascending: true)
            ]
            
        }
        
        do {
            
            if reverse {
                
                return try viewContext.fetch(request).reversed()
                
            } else {
                
                return try viewContext.fetch(request)
                
            }
            
        } catch {
            
            print("fetch \(String(describing: T.self)) fail")
            
            return nil
            
        }
        
    }
    
}

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.terry.mSaving")
        storeURL = storeURL?.appendingPathComponent("mSaving.sqlite")
        return storeURL!
    }
    
}
