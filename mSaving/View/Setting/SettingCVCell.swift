//
//  SettingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

enum Setting {

    case accounts

    case setting

}

struct SettingText {

    let leadingText: String

    let trailingText: String

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

    var goToAddPage: (() -> Void)?
    
    var goToDetailPage: (() -> Void)?

    var accounts: [SettingText] = [
        SettingText(leadingText: "總資產", trailingText: "10000"),
        SettingText(leadingText: "現金", trailingText: "3000"),
        SettingText(leadingText: "銀行", trailingText: "7000"),
        SettingText(leadingText: "悠遊卡", trailingText: "100"),
        SettingText(leadingText: "隨行卡", trailingText: "500")
    ]

    var settings: [SettingText] = [
        SettingText(leadingText: "新增類別", trailingText: ">"),
        SettingText(leadingText: "隱私權聲明內容", trailingText: ">"),
        SettingText(leadingText: "給予評價", trailingText: ">")
    ]
    
    var accountArray: [Account] = []

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func setUpCollectionView() {

        settingCollectionView.helpRegister(cell: AccountDateCVCell())

        settingCollectionView.helpRegister(cell: AddSavingDetailCVCell())

        settingCollectionView.helpRegister(cell: AccountCVCell())

    }

    func initSettingCVCell(whichSetting: Setting, accountArray: [Account]) {

        setting = whichSetting
        
        self.accountArray = accountArray

    }

}

extension SettingCVCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let set = setting else { return 0 }

        switch set {

        case .accounts:

            return accountArray.count + 1

        case .setting:

            return 3

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let set = setting else { return UICollectionViewCell() }

        switch set {

        case .accounts:

            if indexPath.row == accountArray.count {

                guard let cell = settingCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AddSavingDetailCVCell.self),
                    for: indexPath) as? AddSavingDetailCVCell else {
                        return AddSavingDetailCVCell()
                }

                cell.showSavingDetailAdd = goToAddPage

                return cell

            } else {

                guard let cell = settingCollectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AccountDateCVCell.self),
                    for: indexPath) as? AccountDateCVCell else {
                        return AccountDateCVCell()
                }

                let account = accountArray[indexPath.row]
                
                guard let name = account.name else { return cell }
                
                cell.initAccountDateCVCell(style: .setting(
                    leadingText: name,
                    trailingText: String(account.currentValue)))

                cell.goToDetialPage = goToDetailPage

                return cell

            }

        case .setting:

            guard let cell = settingCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AccountDateCVCell.self),
                for: indexPath) as? AccountDateCVCell else {
                    return AccountDateCVCell()
            }

            cell.initAccountDateCVCell(style: .setting(
                leadingText: settings[indexPath.row].leadingText,
                trailingText: settings[indexPath.row].trailingText))

            cell.goToDetialPage = goToDetailPage

            return cell

        }

    }

}

extension SettingCVCell: UICollectionViewDelegate {

}

extension SettingCVCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 382, height: 56)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        guard let set = setting else { return 0 }

        switch set {

        case .accounts:

            return 16

        case .setting:

            return 16

        }

    }

}
