//
//  SettingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var settingsCollectionView: UICollectionView! {
        
        didSet {
            
            settingsCollectionView.dataSource = self
            
            settingsCollectionView.delegate = self
            
        }
        
    }
    
    @IBOutlet weak var segmentedBarView: UIView!
    
    @IBOutlet weak var accountsButton: UIButton!
    
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        
        settingsCollectionView.helpRegister(cell: SettingCVCell())
        
    }

}

extension SettingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = settingsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingCVCell.self), for: indexPath) as? SettingCVCell else { return SettingCVCell() }
        
        if indexPath.row == 0 {
            
            cell.initSettingCVCell(whichSetting: .accounts)
            
        } else {
            
            cell.initSettingCVCell(whichSetting: .setting)
            
        }
        
        return cell
        
    }
    
}

extension SettingVC: UICollectionViewDelegate {
    
}

extension SettingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 414, height: settingsCollectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}

extension SettingVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(settingsCollectionView) {
            
            segmentedBarView.frame.origin.x = settingsCollectionView.bounds.origin.x / 2
            
            if segmentedBarView.frame.origin.x == segmentedBarView.frame.width {
                
                accountsButton.isSelected = false
                
                settingButton.isSelected = true
                
            } else if segmentedBarView.frame.origin.x == 0 {
                
                accountsButton.isSelected = true
                
                settingButton.isSelected = false
                
            }
            
        }
        
    }
    
}

