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
    
    func showUserImageAlertWith(title: String, message: String, viewController: UIViewController &
        UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let imagePC = UIImagePickerController()
        
        imagePC.delegate = viewController
        
        imagePC.allowsEditing = false
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            
            //already authorized
            let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { _ in
                
                imagePC.sourceType = UIImagePickerController.SourceType.camera
                
                viewController.present(imagePC, animated: true, completion: nil)
                
            })
            
            alertController.addAction(cameraAction)
            
        } else {
            
            let cameraAction = UIAlertAction(title: "請開啟相機權限", style: .default, handler: { _ in
                
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    
                    DispatchQueue.main.async {
                        
                        if granted {
                            
                            //access allowed
                            imagePC.sourceType = UIImagePickerController.SourceType.camera
                            
                            viewController.present(imagePC, animated: true, completion: nil)
                            
                        } else {
                            
                            //access denied
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                      options: [:], completionHandler: nil)
                            
                        }
                        
                    }
                    
                })
                
            })
            
            alertController.addAction(cameraAction)
            
        }
        
        let photoAction = UIAlertAction(title: "相簿", style: .default, handler: { _ in
            
            imagePC.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            viewController.present(imagePC, animated: true, completion: nil)
            
        })
        
        alertController.addAction(photoAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}
