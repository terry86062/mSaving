//
//  FetchedResultsController.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/11.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

class FetchedResultsController: NSFetchedResultsController<Account> {
    
    private let collectionView: UICollectionView
    
    init(managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        let request = NSFetchRequest<Account>(entityName: "Account")
        
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        
        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
}

extension FetchedResultsController: NSFetchedResultsControllerDelegate {
    // MARK: - Fetched Results Controller Delegate
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.beginUpdates()
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            collectionView.insertItems(at: [newIndexPath])
        case .delete:
            guard let indexPath = indexPath else { return }
            collectionView.deleteItems(at: [indexPath])
        case .update:
            guard let indexPath = indexPath else { return }
            collectionView.reloadItems(at: [indexPath])
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            collectionView.moveItem(at: indexPath, to: newIndexPath)
        }
    }
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//        collectionView.endUpdates()
//    }
}