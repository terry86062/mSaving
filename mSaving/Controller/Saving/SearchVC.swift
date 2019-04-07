//
//  SearchVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/8.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage()

    }

    @IBAction func pop(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
