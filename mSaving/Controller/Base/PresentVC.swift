//
//  PresentVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/8.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class PresentVC: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        showTabBarCBlackView()
        
    }
    
    func showTabBarCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        hideTabBarCBlackView()
        
    }
    
    func hideTabBarCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = true
        
    }

}
