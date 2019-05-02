//
//  AlertManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AlertManager {
    
    func showUserImageAlertWith(title: String, message: String, viewController: UIViewController &
        UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let imagePC = UIImagePickerController()
        
        imagePC.delegate = viewController
        
        imagePC.allowsEditing = false
        
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { _ in
            
            imagePC.sourceType = UIImagePickerController.SourceType.camera
            
            viewController.present(imagePC, animated: true, completion: nil)
            
        })
        
        alertController.addAction(cameraAction)
        
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
