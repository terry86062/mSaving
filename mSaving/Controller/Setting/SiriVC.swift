//
//  SiriVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Intents

class SiriVC: UIViewController {
    
    @IBOutlet weak var useSiriButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if INPreferences.siriAuthorizationStatus() == .authorized {
            
            useSiriButton.setTitle("Siri 使用權限已開啟", for: .normal)
            
        } else {
            
            useSiriButton.setTitle("開啟 Siri 使用權限", for: .normal)
            
        }
        
    }
    
    @IBAction func useSiri(_ sender: UIButton) {
        
        if useSiriButton.titleLabel?.text == "開啟 Siri 使用權限" {
            
            askSiriAuthorization()
            
        }
        
    }
    
    func askSiriAuthorization() {
        
        INPreferences.requestSiriAuthorization { status in
            
            switch status {
                
            case .authorized:
                
                print("Authorized")
                
                self.useSiriButton.setTitle("Siri 使用權限已開啟", for: .normal)
                
            default:
                
                print("Not Authorized")
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:], completionHandler: nil)
                
            }
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
