//
//  CategoryAccountsDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryAccountsDetailVC: UIViewController {
    
    @IBOutlet weak var categoryAccountsCollectionView: UICollectionView! {
        
        didSet {
            
            categoryAccountsCollectionView.dataSource = self
            
            categoryAccountsCollectionView.delegate = self
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        
        categoryAccountsCollectionView.helpRegister(cell: AccountCVCell())
        
    }
    
    @IBAction func pop(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension CategoryAccountsDetailVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return 3
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryAccountsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountCVCell.self), for: indexPath) as? AccountCVCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
}

extension CategoryAccountsDetailVC: UICollectionViewDelegate {
    
}

extension CategoryAccountsDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
