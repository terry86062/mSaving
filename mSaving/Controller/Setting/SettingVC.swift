//
//  SettingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Photos

struct SettingText {
    
    let leadingText: String
    
    let trailingText: String
    
}

class SettingVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            
            scrollView.delegate = self
            
        }
        
    }
    
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
    
    @IBOutlet weak var userImageView: UIImageView! {
        
        didSet {
            
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
            
        }
        
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var changeUserNameButton: UIButton!
    
    @IBOutlet weak var finishUserNameButton: UIButton!
    
    @IBOutlet weak var segmentedBarView: UIView!

    @IBOutlet weak var accountsLabel: UILabel!
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    let notificationManager = NotificationManager()
    
    var accounts: [Account] = []
    
    var settings: [SettingText] = [
        SettingText(leadingText: "類別顯示", trailingText: ">"),
        SettingText(leadingText: "使用 Siri 記帳", trailingText: ">"),
        SettingText(leadingText: "隱私權聲明內容", trailingText: ">"),
        SettingText(leadingText: "給予評價", trailingText: ">")
    ]
    
    var selectedAccount: Account?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        setUpUserImage()
        
        setUpCollectionView()
        
        fetchData()
        
        setUpNotification()
        
        segmentedBarView.frame = CGRect(x: accountsLabel.frame.origin.x,
                                        y: accountsLabel.frame.origin.y + 18 + 3,
                                        width: accountsLabel.frame.width, height: 3)
        
    }
    
    func setUpUserImage() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            guard let data = UserDefaults.standard.object(forKey: "userImage") as? NSData else { return }
            
            let image = UIImage(data: data as Data)
            
            DispatchQueue.main.async {
                
                self.userImageView.image = image
                
            }
            
        }
        
    }
    
    func setUpCollectionView() {
        
        accountsCollectionView.helpRegisterView(cell: AccountingDateCVCell())
        
        accountsCollectionView.helpRegister(cell: AccountingDateCVCell())
        
        accountsCollectionView.helpRegister(cell: AddSavingDetailCVCell())
        
        settingsCollectionView.helpRegister(cell: AccountingDateCVCell())
        
        accountsCollectionView.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
        
    }
    
    func fetchData() {
        
        accounts = AccountProvider().accounts
        
    }
    
    func setUpNotification() {
        
        notificationManager.addAccountNotification { [weak self] in
            
            self?.fetchData()
            
            self?.accountsCollectionView.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAccountDetail" {
            
            guard let tabBarVC = tabBarController as? TabBarController else { return }
            
            tabBarVC.blackView.isHidden = false
            
            guard let accountDetailVC = segue.destination as? AccountVC else { return }
            
            accountDetailVC.selectedAccount = selectedAccount
            
        }
        
    }
    
    @IBAction func changeUserImage(_ sender: UIButton) {
        
        AlertManager().showUserImageAlertWith(title: "請選擇圖片來源", message: nil, viewController: self)
        
    }
    
    @IBAction func changeUserName(_ sender: UIButton) {
        
        helpChangeUserName()
        
        userNameTextField.becomeFirstResponder()
        
    }
    
    @IBAction func finishChangeUserName(_ sender: UIButton) {
        
        helpChangeUserName()
        
        userNameTextField.resignFirstResponder()
        
    }
    
    func helpChangeUserName() {
        
        changeUserNameButton.isHidden = !changeUserNameButton.isHidden
        
        finishUserNameButton.isHidden = !finishUserNameButton.isHidden
        
        userNameTextField.isEnabled = !userNameTextField.isEnabled
        
    }
    
}

extension SettingVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == accountsCollectionView {
            
            return accounts.count + 1
            
        } else {
            
            return 2
            
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == accountsCollectionView {
            
            if indexPath.row == accounts.count {
                
                guard let cell = accountsCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                    for: indexPath) as? AddSavingDetailCVCell else {
                        return AddSavingDetailCVCell()
                }
                
                cell.initAddSavingDetailCVCell(addText: "新增帳戶")
                
                cell.presentSavingDetailAdd = {
                    
                    self.selectedAccount = nil
                    
                    self.performSegue(withIdentifier: "goToAccountDetail", sender: nil)
                    
                }
                
                return cell
                
            } else {
                
                guard let cell = accountsCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountingDateCVCell.self),
                    for: indexPath) as? AccountingDateCVCell else {
                        return AccountingDateCVCell()
                }
                
                let account = accounts[indexPath.row]
                
                guard let name = account.name else { return cell }
                
                if account.currentValue >= 0 {
                    
                    cell.initAccountDateCVCell(leadingText: name,
                                               trailingText: "$\(Int(account.currentValue).formattedWithSeparator)",
                                               trailingColor: .black,
                                               havingShadow: true)
                    
                } else {
                    
                    cell.initAccountDateCVCell(leadingText: name,
                                    trailingText: "-$\(abs(Int(account.currentValue)).formattedWithSeparator)",
                                               trailingColor: .red,
                                               havingShadow: true)
                    
                }
                
                cell.goToDetialPage = {
                    
                    self.selectedAccount = account
                    
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
                
                if indexPath.row == 0 {
                    
                    self.performSegue(withIdentifier: "goToSetCategory", sender: nil)
                    
                } else if indexPath.row == 1 {
                    
                    self.performSegue(withIdentifier: "goToUseSiriVC", sender: nil)
                    
                }
                
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
        
        if accounts.count > 0 {
            
            for index in 0...accounts.count - 1 {
                
                totalAmount += Int(accounts[index].currentValue)
                
            }
            
        }
        
        if totalAmount >= 0 {
            
            headerView.initAccountDateCVCell(leadingText: "總資產",
                                             trailingText: "$\(totalAmount.formattedWithSeparator)",
                                             trailingColor: .black,
                                             havingShadow: true)
            
        } else {
            
            headerView.initAccountDateCVCell(leadingText: "總資產",
                                             trailingText: "-$\(abs(totalAmount).formattedWithSeparator)",
                                             trailingColor: .red,
                                             havingShadow: true)
            
        }
        
        return headerView
        
    }

}

extension SettingVC: UICollectionViewDelegate { }

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

        return CGSize(width: Int(UIScreen.main.bounds.width - 32), height: 53)

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

            return CGSize(width: 0, height: 53)

        } else {

            return CGSize(width: 0, height: 0)

        }

    }

}

extension SettingVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(scrollView) {
            
            let width = UIScreen.main.bounds.width / 2
            
            segmentedBarView.frame.origin.x = width - 16 - 61.5 + scrollView.contentOffset.x * 93.5 / 414.fitScreen
            //129.5 + scrollView.contentOffset.x * 93.5 / 414
            
            if segmentedBarView.frame.origin.x + segmentedBarView.frame.width
                >= settingsLabel.frame.origin.x + settingsLabel.frame.width / 2 {

                accountsLabel.textColor = .lightGray

                settingsLabel.textColor = .black

                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x,
                                                y: segmentedBarView.frame.origin.y,
                                                width: settingsLabel.frame.width, height: 3)

            } else if segmentedBarView.frame.origin.x < accountsLabel.frame.origin.x + accountsLabel.frame.width / 2 {

                accountsLabel.textColor = .black
                
                settingsLabel.textColor = .lightGray
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x,
                                                y: segmentedBarView.frame.origin.y,
                                                width: accountsLabel.frame.width, height: 3)

            }

        }

    }

}

extension SettingVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [
        UIImagePickerController.InfoKey: Any]) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                DispatchQueue.main.async {
                    
                    self.userImageView.image = image
                    
                }
                
                let imageData = image.pngData()! as NSData
                
                UserDefaults.standard.set(imageData, forKey: "userImage")
                
            } else {
                
                print("user get image fail")
                
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension SettingVC: UINavigationControllerDelegate { }
