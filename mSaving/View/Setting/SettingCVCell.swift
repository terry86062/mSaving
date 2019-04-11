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
    
    lazy var fetchedResultsController = {
        
        return FetchedResultsController(managedObjectContext: StorageManager.shared.viewContext,
                                        collectionView: settingCollectionView)
        
    }()
    
    var setting: Setting?

    var goToAddPage: (() -> Void)?
    
    var goToDetailPage: (() -> Void)?

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

        settingCollectionView.helpRegisterView(cell: AccountDateCVCell())
        
        settingCollectionView.helpRegister(cell: AccountDateCVCell())

        settingCollectionView.helpRegister(cell: AddSavingDetailCVCell())
        
        settingCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)

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
            
            guard let count = fetchedResultsController.sections?[0].numberOfObjects else { return 0 }
            
            return count + 1

        case .setting:

            return 3

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let set = setting else { return UICollectionViewCell() }

        switch set {

        case .accounts:
            
            guard let count = fetchedResultsController.sections?[0].numberOfObjects else { return UICollectionViewCell() }
            
            if indexPath.row == count {

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
                
                let account = fetchedResultsController.object(at: indexPath)
                
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = settingCollectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: AccountDateCVCell.self),
            for: indexPath) as? AccountDateCVCell else { return UICollectionReusableView() }
        
        var totalAmount = 0
        
        guard let count = fetchedResultsController.sections?[0].numberOfObjects else { return UICollectionViewCell() }
        
        if count > 0 {
            
            for index in 0...count - 1 {
                
                guard let account = fetchedResultsController.fetchedObjects?[index] else { return AccountDateCVCell() }
                
                totalAmount += Int(account.currentValue)
                
            }
            
        }
        
        headerView.initAccountDateCVCell(style: .setting(leadingText: "總資產", trailingText: String(totalAmount)))
        
        return headerView
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 0, height: 56)
        
    }

}
