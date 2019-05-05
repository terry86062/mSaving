//
//  AskCameraView.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import AVFoundation

class AskCameraView: UIView {
    
    weak var delegate: InvoiceVC?
    
    @IBAction func askCamera(_ sender: UIButton) {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            
            DispatchQueue.main.async {
                
                if response {
                    
                    self.delegate?.setUpCaptureSession()
                    
                    self.isHidden = true
                    
                } else {
                    
                    print("request camera failure")
                    
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                              options: [:], completionHandler: nil)
                    
                }
                
            }
            
        }
        
    }
    
}
