//
//  CategorysCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategorysCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categorysCollectionView: UICollectionView! {
        
        didSet {
            
            categorysCollectionView.dataSource = self
            
            categorysCollectionView.delegate = self
            
            setUpCollectionView()
            
        }
        
    }
    
    var goToSetCategory: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func setUpCollectionView() {
        
        categorysCollectionView.helpRegister(cell: CategoryCVCell())
        
    }
    
}

extension CategorysCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categorysCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCVCell.self), for: indexPath) as? CategoryCVCell else { return CategoryCVCell() }
        
        cell.goToSetCategory = goToSetCategory
        
        return cell
        
    }
    
}

extension CategorysCVCell: UICollectionViewDelegate {
    
}

extension CategorysCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
