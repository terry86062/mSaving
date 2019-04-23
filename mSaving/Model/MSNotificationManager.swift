//
//  MSNotificationManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MSNotificationManager {
    
    var collectionView: UICollectionView?
    
    var fetchNewDataClosure: (() -> Void)?
    
    func addNotificationForRenew(collectionView: UICollectionView, fetchNewDataClosure: @escaping () -> Void) {
        
        self.collectionView = collectionView
        
        self.fetchNewDataClosure = fetchNewDataClosure
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(renewCollectionView(notification:)),
                                               name: .renewCollectionView,
                                               object: nil)
        
    }
    
    func postNotificationForRenew() {
        
        NotificationCenter.default.post(name: .renewCollectionView, object: nil)
        
    }
    
    @objc func renewCollectionView(notification: Notification) {
        
        fetchNewDataClosure?()
        
        collectionView?.reloadData()
        
    }
    
}
