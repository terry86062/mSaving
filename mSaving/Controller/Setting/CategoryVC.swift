//
//  CategoryVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import BetterSegmentedControl

class CategoryVC: UIViewController {

    @IBOutlet weak var categorySegmentedC: BetterSegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        categorySegmentedC.segments = LabelSegment.segments(withTitles: ["支出", "收入"], normalBackgroundColor: UIColor.white, normalFont: .systemFont(ofSize: 16), normalTextColor: UIColor.mSYellow, selectedBackgroundColor: UIColor.mSYellow, selectedFont: .systemFont(ofSize: 16), selectedTextColor: UIColor.black)
        
    }
    
    @IBAction func pop(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
