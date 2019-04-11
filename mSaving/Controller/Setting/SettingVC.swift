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
    
    var accountArray: [Account] = []
    
    var isAddingNewAccount = false

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        guard let accountArray = StorageManager.shared.fetchAccount() else { return }
        
        self.accountArray = accountArray

    }

    func setUpCollectionView() {

        settingsCollectionView.helpRegister(cell: SettingCVCell())

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAccountDetail" {
            
            guard let tabBarVC = tabBarController as? TabBarController else { return }
            
            tabBarVC.blackView.isHidden = false
            
            guard let accountDetailVC = segue.destination as? AccountDetailVC else { return }
            
            accountDetailVC.delegate = self
            
        }
        
    }

}

extension SettingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 2

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = settingsCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: SettingCVCell.self),
            for: indexPath) as? SettingCVCell else { return SettingCVCell() }

        if indexPath.row == 0 {

            cell.initSettingCVCell(whichSetting: .accounts, accountArray: accountArray)

            cell.goToDetailPage = {
                
                self.isAddingNewAccount = false
                
                self.performSegue(withIdentifier: "goToAccountDetail", sender: nil)

            }
            
            cell.goToAddPage = {
                
                self.isAddingNewAccount = true
                
                self.performSegue(withIdentifier: "goToAccountDetail", sender: nil)
                
            }

        } else {

            cell.initSettingCVCell(whichSetting: .setting, accountArray: accountArray)

            cell.goToDetailPage = {

                self.performSegue(withIdentifier: "goToSetCategory", sender: nil)

            }

        }

        return cell

    }

}

extension SettingVC: UICollectionViewDelegate {

}

extension SettingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: settingsCollectionView.frame.width, height: settingsCollectionView.frame.height)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

}

extension SettingVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(settingsCollectionView) {

            segmentedBarView.frame.origin.x = 119 + settingsCollectionView.bounds.origin.x * 104 / 414

            if segmentedBarView.frame.origin.x > settingsCollectionView.frame.width / 2 {

                accountsButton.isSelected = false

                settingButton.isSelected = true
                
                accountsButton.setTitleColor(.lightGray, for: .normal)
                
                settingButton.setTitleColor(.black, for: .normal)
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x, y: segmentedBarView.frame.origin.y, width: settingButton.frame.width, height: 3)

            } else if segmentedBarView.frame.origin.x < settingsCollectionView.frame.width / 2 {

                accountsButton.isSelected = true

                settingButton.isSelected = false
                
                accountsButton.setTitleColor(.black, for: .normal)
                
                settingButton.setTitleColor(.lightGray, for: .normal)
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x, y: segmentedBarView.frame.origin.y, width: accountsButton.frame.width, height: 3)

            }

        }

    }

}
