//
//  SettingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

struct SettingText {
    
    let leadingText: String
    
    let trailingText: String
    
}

class SettingVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var accountsCollectionView: UICollectionView! {

        didSet {

            accountsCollectionView.dataSource = self

            accountsCollectionView.delegate = self

        }

    }
    
    @IBOutlet weak var settingsCollectionView: UICollectionView! {
        
        didSet {
            
            settingsCollectionView.dataSource = self
            
            settingsCollectionView.delegate = self
            
        }
        
    }

    @IBOutlet weak var segmentedBarView: UIView!

    @IBOutlet weak var accountsButton: UIButton!

    @IBOutlet weak var settingButton: UIButton!
    
    var isAddingNewAccount = false
    
    var selectedAccountName = ""
    
    var selectedAccountInitialValue = ""
    
    var accountArray: [Account] = []
    
    var accountArrayCount = 0
    
    var settings: [SettingText] = [
        SettingText(leadingText: "新增類別", trailingText: ">"),
        SettingText(leadingText: "隱私權聲明內容", trailingText: ">"),
        SettingText(leadingText: "給予評價", trailingText: ">")
    ]

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()
        
        scrollView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        fetchData()
        
    }

    func setUpCollectionView() {

        accountsCollectionView.helpRegisterView(cell: AccountingDateCVCell())
        
        accountsCollectionView.helpRegister(cell: AccountingDateCVCell())
        
        accountsCollectionView.helpRegister(cell: AddSavingDetailCVCell())
        
        settingsCollectionView.helpRegister(cell: AccountingDateCVCell())
        
        accountsCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAccountDetail" {
            
            guard let tabBarVC = tabBarController as? TabBarController else { return }
            
            tabBarVC.blackView.isHidden = false
            
            guard let accountDetailVC = segue.destination as? AccountDetailVC else { return }
            
            accountDetailVC.delegate = self
            
            if isAddingNewAccount {
                
                accountDetailVC.stringForTitle = "新增帳戶"
                
            } else {
                
                accountDetailVC.stringForTitle = "帳戶資訊"
                
            }
            
        }
        
    }
    
    func fetchData() {
        
        guard let accountArray = AccountProvider().accounts else { return }
        
        self.accountArray = accountArray
        
        accountArrayCount = accountArray.count
        
        accountsCollectionView.reloadData()
        
    }

}

extension SettingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == accountsCollectionView {
            
            return accountArrayCount + 1
            
        } else {
            
            return 3
            
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == accountsCollectionView {
            
            if indexPath.row == accountArrayCount {
                
                guard let cell = accountsCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                    for: indexPath) as? AddSavingDetailCVCell else {
                        return AddSavingDetailCVCell()
                }
                
                cell.initAddSavingDetailCVCell(addText: "新增帳戶")
                
                cell.presentSavingDetailAdd = {
                    
                    self.isAddingNewAccount = true
                    
                    self.performSegue(withIdentifier: "goToAccountDetail", sender: nil)
                }
                
                return cell
                
            } else {
                
                guard let cell = accountsCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountingDateCVCell.self),
                    for: indexPath) as? AccountingDateCVCell else {
                        return AccountingDateCVCell()
                }
                
                let anAccount = accountArray[indexPath.row]
                
                guard let name = anAccount.name else { return cell }
                
                cell.initAccountDateCVCell(leadingText: name,
                                           trailingText: String(anAccount.currentValue),
                                           trailingColor: .black,
                                           havingShadow: true)
                
                cell.goToDetialPage = {
                    
                    self.selectedAccountName = name
                    
                    self.selectedAccountInitialValue = String(anAccount.initialValue)
                    
                    self.isAddingNewAccount = false
                    
                    self.performSegue(withIdentifier: "goToAccountDetail", sender: nil)
                    
                }
                
                return cell
                
            }
            
        } else {
            
            guard let cell = settingsCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AccountingDateCVCell.self),
                for: indexPath) as? AccountingDateCVCell else {
                    return AccountingDateCVCell()
            }
            
            cell.initAccountDateCVCell(leadingText: settings[indexPath.row].leadingText,
                                       trailingText: settings[indexPath.row].trailingText,
                                       trailingColor: .black,
                                       havingShadow: true)
            
            cell.goToDetialPage = {
                
                self.performSegue(withIdentifier: "goToSetCategory", sender: nil)
                
            }
            
            return cell
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = accountsCollectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: AccountingDateCVCell.self),
            for: indexPath) as? AccountingDateCVCell else { return UICollectionReusableView() }
        
        var totalAmount = 0
        
        if accountArrayCount > 0 {
            
            for index in 0...accountArrayCount - 1 {
                
                totalAmount += Int(accountArray[index].currentValue)
                
            }
            
        }
        
        headerView.initAccountDateCVCell(leadingText: "總資產",
                                         trailingText: String(totalAmount),
                                         trailingColor: .black,
                                         havingShadow: true)
        
        return headerView
    }

}

extension SettingVC: UICollectionViewDelegate {

}

extension SettingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == accountsCollectionView {
            
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 382, height: 56)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 16

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView == accountsCollectionView {
            
            return CGSize(width: 0, height: 56)
            
        } else {
            
            return CGSize(width: 0, height: 0)
            
        }
        
    }

}

extension SettingVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(scrollView) {
            
            segmentedBarView.frame.origin.x = 119 + scrollView.bounds.origin.x * 104 / 414
            
            if segmentedBarView.frame.origin.x > scrollView.frame.width / 2 {

                accountsButton.isSelected = false

                settingButton.isSelected = true
                
                accountsButton.setTitleColor(.lightGray, for: .normal)
                
                settingButton.setTitleColor(.black, for: .normal)
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x, y: segmentedBarView.frame.origin.y,
                                                width: settingButton.frame.width, height: 3)

            } else if segmentedBarView.frame.origin.x < scrollView.frame.width / 2 {

                accountsButton.isSelected = true

                settingButton.isSelected = false
                
                accountsButton.setTitleColor(.black, for: .normal)
                
                settingButton.setTitleColor(.lightGray, for: .normal)
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x, y: segmentedBarView.frame.origin.y,
                                                width: accountsButton.frame.width, height: 3)

            }

        }

    }

}
