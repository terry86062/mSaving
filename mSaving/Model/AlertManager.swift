//
//  AlertManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import AVFoundation

class AlertManager {
    
    func alertControllerWithCancel(title: String, message: String?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        return alertController
        
    }

    func showAlertWith(accounts: [Account], viewController: UIViewController, handler: @escaping (Account) -> Void) {

        let alertController = alertControllerWithCancel(title: "請選擇帳戶", message: nil)

        if accounts.count > 0 {

            for index in 0...accounts.count - 1 {

                let accountAction = UIAlertAction(title: accounts[index].name, style: .default, handler: { _ in

                    handler(accounts[index])

                })

                alertController.addAction(accountAction)

            }

        }

        viewController.present(alertController, animated: true, completion: nil)

    }
    
    func showDeleteAlertWith(saving: Saving?, viewController: UIViewController, handler: @escaping () -> Void) {
        
        guard let name = saving?.expenseCategory?.name else { return }
        
        let alertController = alertControllerWithCancel(title: "您確定要刪除\(name)預算嗎？", message: nil)
        
        alertController.addAction(UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let saving = saving else { return }
            
            SavingProvider().delete(saving: saving)
            
            handler()
            
        }))
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }

    func showDeleteAlertWith(accounting: Accounting?, viewController: UIViewController, handler: @escaping () -> Void) {
        
        let alertController = alertControllerWithCancel(title: "您確定要刪除交易記錄嗎？", message: nil)

        alertController.addAction(UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let accounting = accounting else { return }
            
            AccountingProvider().deleteAccounting(accounting: accounting)
            
            handler()
            
        }))

        viewController.present(alertController, animated: true, completion: nil)

    }
    
    func showDeleteAlertWith(account: Account?, viewController: UIViewController, handler: @escaping () -> Void) {
        
        let alertController = alertControllerWithCancel(title: "您確定要刪除此帳戶嗎？", message: nil)
        
        alertController.addAction(UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let account = account else { return }
            
            AccountProvider().deleteAccount(account: account)
            
            handler()
            
        }))
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    func showUserImageAlertWith(viewController: UIViewController & UIImagePickerControllerDelegate &
                                                UINavigationControllerDelegate) {
        
        let alertController = alertControllerWithCancel(title: "請選擇圖片來源", message: nil)
        
        let imagePC = UIImagePickerController()
        
        imagePC.delegate = viewController
        
        imagePC.allowsEditing = false
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            
            alertController.addAction(UIAlertAction(title: "相機", style: .default, handler: { _ in
                
                imagePC.sourceType = UIImagePickerController.SourceType.camera
                
                viewController.present(imagePC, animated: true, completion: nil)
                
            }))
            
        } else {
            
            alertController.addAction(UIAlertAction(title: "請開啟相機權限", style: .default) { _ in
                
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    
                    DispatchQueue.main.async {
                        
                        if granted {
                            
                            imagePC.sourceType = UIImagePickerController.SourceType.camera
                            
                            viewController.present(imagePC, animated: true, completion: nil)
                            
                        } else {
                            
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                      options: [:], completionHandler: nil)
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
        alertController.addAction(UIAlertAction(title: "相簿", style: .default, handler: { _ in
            
            imagePC.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            viewController.present(imagePC, animated: true, completion: nil)
            
        }))
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}
