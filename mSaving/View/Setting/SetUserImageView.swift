//
//  SetUserImageView.swift
//  STYLiSH
//
//  Created by 黃偉勛 Terry on 2019/3/16.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

enum GetImageFrom {
    
    case camera
    
    case photoLibrary
}

protocol SetUserImageViewDelegate: AnyObject {
    
    func getImage(getImageFrom: GetImageFrom)
    
    func cancelSetImage()
}

class SetUserImageView: UIView {
    
    weak var delegate: SetUserImageViewDelegate?
    
    @IBAction func getImageFromCamera(_ sender: UIButton) {
        
        delegate?.getImage(getImageFrom: .camera)
    }
    
    @IBAction func getImageFromPhotoLibrary(_ sender: UIButton) {
        
        delegate?.getImage(getImageFrom: .photoLibrary)
    }
    
    @IBAction func cancelSetImage(_ sender: UIButton) {
        
        delegate?.cancelSetImage()
    }
}
