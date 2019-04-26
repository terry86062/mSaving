//
//  MSNotificationManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MSNotificationManager {
    
    var collectionViews: [UICollectionView] = []
    
    var fetchData: (() -> Void)?
    
    func addAccountingNotification(collectionViews: [UICollectionView], fetchData: @escaping () -> Void) {
        
        self.collectionViews = collectionViews
        
        self.fetchData = fetchData
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(accountingChanged(notification:)),
                                               name: .accountingChanged,
                                               object: nil)
        
    }
    
    @objc func accountingChanged(notification: Notification) {
        
        fetchData?()
        
        guard collectionViews != [] else { return }
        
        for index in 0...collectionViews.count - 1 {
            
            collectionViews[index].reloadData()
            
        }
        
    }
    
    func postAccountingChanged() {
        
        NotificationCenter.default.post(name: .accountingChanged, object: nil)
        
    }
    
}
