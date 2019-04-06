//
//  SettingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

enum Setting {
    
    case accounts
    
    case setting
    
}

class SettingCVCell: UICollectionViewCell {
    
    @IBOutlet weak var settingCollectionView: UICollectionView! {
        
        didSet {
            
            settingCollectionView.dataSource = self
            
            settingCollectionView.delegate = self
            
            setUpCollectionView()
            
        }
        
    }
    
    var setting: Setting?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func setUpCollectionView() {
        
        settingCollectionView.helpRegister(cell: AccountDateCVCell())
        
        settingCollectionView.helpRegister(cell: AccountCVCell())
        
    }
    
    func initSettingCVCell(whichSetting: Setting) {
        
        setting = whichSetting
        
    }
    
}

extension SettingCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let set = setting else { return 0 }

        switch set {

        case .accounts:

            return 5

        case .setting:

            return 3

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let set = setting else { return UICollectionViewCell() }
        
        switch set {

        case .accounts:

            guard let cell = settingCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountCVCell.self), for: indexPath) as? AccountCVCell else { return AccountCVCell() }

            return cell

        case .setting:
        
            guard let cell = settingCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountDateCVCell.self), for: indexPath) as? AccountDateCVCell else { return AccountDateCVCell() }
            
            return cell
            
        }
    
    }
    
}

extension SettingCVCell: UICollectionViewDelegate {
    
}

extension SettingCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        guard let set = setting else { return 0 }
        
        switch set {
            
        case .accounts:
            
            return 16
            
        case .setting:
            
            return 0
            
        }
        
    }
    
}
