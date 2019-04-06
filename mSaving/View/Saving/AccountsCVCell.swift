//
//  AccountsCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var accountsCollectionView: UICollectionView! {
        
        didSet {
            
            accountsCollectionView.dataSource = self
            
            accountsCollectionView.delegate = self
            
            setUpCollectionView()
            
        }
        
    }
    
    var goToAccountDetail: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initAccountsCVCell() {
        
    }
    
    func setUpCollectionView() {
        
        accountsCollectionView.helpRegister(cell: AccountCVCell())
        
    }

}

extension AccountsCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountCVCell.self), for: indexPath) as? AccountCVCell else { return UICollectionViewCell() }
        
        cell.goToAccountDetail = goToAccountDetail
        
        return cell
        
    }
    
}

extension AccountsCVCell: UICollectionViewDelegate {
    
}

extension AccountsCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: 56)
        
    }
    
}
