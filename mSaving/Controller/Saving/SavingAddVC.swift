//
//  SavingAddVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingAddVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createGradientLayer()
        
        textField.becomeFirstResponder()
        
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.topView.bounds
        
        gradientLayer.colors = [UIColor(red: 173 / 255, green: 207 / 255, blue: 142 / 255, alpha: 1).cgColor, UIColor(red: 73 / 255, green: 161 / 255, blue: 84 / 255, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.view.layer.addSublayer(gradientLayer)
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}