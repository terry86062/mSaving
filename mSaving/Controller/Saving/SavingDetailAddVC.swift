//
//  SavingDetailAddVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingDetailAddVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var savingDetailTextField: UITextField!
    
    @IBOutlet weak var savingCategoryCollectionView: UICollectionView!
    
    var selectedYear = ""
    
    var selectedMonth = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        savingDetailTextField.becomeFirstResponder()
        
//        titleLabel.text = "\(selectedMonth)月預算"
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveSaving()
        
        helpDismiss()
        
    }
    
    func helpDismiss() {
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = true
        
    }
    
    func saveSaving() {
        
        
        
    }

}
