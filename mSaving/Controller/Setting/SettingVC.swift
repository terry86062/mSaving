//
//  SettingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Photos

import Intents

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
    
    var isAddingNewAccount = false
    
    var selectedAccountName = ""
    
    var selectedAccountInitialValue = ""
    
    var accountArray: [Account] = []
    
    var accountArrayCount = 0
    
    var settings: [SettingText] = [
        SettingText(leadingText: "類別顯示", trailingText: ">"),
        SettingText(leadingText: "啟用 Siri", trailingText: "未啟用"),
        SettingText(leadingText: "隱私權聲明內容", trailingText: ">"),
        SettingText(leadingText: "給予評價", trailingText: ">")
    ]

    override func viewDidLoad() {

        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let data = UserDefaults.standard.object(forKey: "userImage") as? NSData {

                let image = UIImage(data: data as Data)

                DispatchQueue.main.async {

                    self.userImageView.image = image

                }

            }
            
        }
        
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
            
            tabBarVC.blackButton.isHidden = false
            
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
        
        let accountArray = AccountProvider().accounts
        
        self.accountArray = accountArray
        
        accountArrayCount = accountArray.count
        
        accountsCollectionView.reloadData()
        
    }
    
    @IBAction func changeUserImage(_ sender: UIButton) {
        
        guard let tabBarVC = tabBarController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = false
        
        tabBarVC.setUserImageView.delegate = self
        
        tabBarVC.setUserImageView.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            
            tabBarVC.setUserImageView.center.y -= 180
            
        }
        
    }
    
    @IBAction func changeUserName(_ sender: UIButton) {
        
        changeUserNameButton.isHidden = true
        
        finishUserNameButton.isHidden = false
        
        userNameTextField.isEnabled = true
        
        userNameTextField.becomeFirstResponder()
        
    }
    
    @IBAction func finishChangeUserName(_ sender: UIButton) {
        
        finishUserNameButton.isHidden = true
        
        changeUserNameButton.isHidden = false
        
        userNameTextField.isEnabled = false
        
        userNameTextField.resignFirstResponder()
        
    }
    
    func askSiriAuthorization() {
        
        INPreferences.requestSiriAuthorization { [weak self] (status) in
            
            switch status {
                
            case .authorized:
                
                print("Authorized")
                
                self?.settingsCollectionView.reloadData()
                
            default:
                
                print("Not Authorized")
                
            }
            
        }
        
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
            
            if indexPath.row == 1 {
                
                if INPreferences.siriAuthorizationStatus() == .authorized {
                    
                    cell.initAccountDateCVCell(leadingText: settings[indexPath.row].leadingText,
                                               trailingText: "已啟用",
                                               trailingColor: .black,
                                               havingShadow: true)
                    
                } else {
                    
                    cell.initAccountDateCVCell(leadingText: settings[indexPath.row].leadingText,
                                               trailingText: settings[indexPath.row].trailingText,
                                               trailingColor: .black,
                                               havingShadow: true)
                    
                }
                
            } else {
                
                cell.initAccountDateCVCell(leadingText: settings[indexPath.row].leadingText,
                                           trailingText: settings[indexPath.row].trailingText,
                                           trailingColor: .black,
                                           havingShadow: true)
                
            }
            
            cell.goToDetialPage = {
                
                if indexPath.row == 0 {
                    
                    self.performSegue(withIdentifier: "goToSetCategory", sender: nil)
                    
                } else if indexPath.row == 1 {
                    
                    self.askSiriAuthorization()
                    
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

extension SettingVC: UICollectionViewDelegate { }

extension SettingVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == accountsCollectionView {
            
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
            
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Int(UIScreen.main.bounds.width - 24), height: 53)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 12

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
            
            segmentedBarView.frame.origin.x = 129.5 + scrollView.contentOffset.x * 93.5 / 414
            
            if segmentedBarView.frame.origin.x > scrollView.frame.width / 2 {

                accountsLabel.textColor = .lightGray

                settingsLabel.textColor = .black

                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x,
                                                y: segmentedBarView.frame.origin.y,
                                                width: settingsLabel.frame.width, height: 3)

            } else if segmentedBarView.frame.origin.x < scrollView.frame.width / 2 {

                accountsLabel.textColor = .black
                
                settingsLabel.textColor = .lightGray
                
                segmentedBarView.frame = CGRect(x: segmentedBarView.frame.origin.x,
                                                y: segmentedBarView.frame.origin.y,
                                                width: accountsLabel.frame.width, height: 3)

            }

        }

    }

}

extension SettingVC: SetUserImageViewDelegate {
    
    func getImage(getImageFrom: GetImageFrom) {
        
        let imagePC = UIImagePickerController()
        
        imagePC.delegate = self
        
        switch getImageFrom {
            
        case .camera:
            
            imagePC.sourceType = UIImagePickerController.SourceType.camera
            
        case .photoLibrary:
            
            imagePC.sourceType = UIImagePickerController.SourceType.photoLibrary
            
        }
        
        imagePC.allowsEditing = false
        
        self.present(imagePC, animated: true, completion: nil)
        
    }
    
    func cancelSetImage() {
        
        guard let tabBarVC = tabBarController as? TabBarController else { return }
        
        tabBarVC.hideBlackButton()
        
    }
    
}

extension SettingVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [
        UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            userImageView.image = image
            
            let imageData = image.pngData()! as NSData
            
            UserDefaults.standard.set(imageData, forKey: "userImage")
            
        } else {
            
            print("user get image fail")
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
        guard let tabBarVC = tabBarController as? TabBarController else { return }
        
        tabBarVC.hideBlackButton()
        
    }
    
}

extension SettingVC: UINavigationControllerDelegate { }
