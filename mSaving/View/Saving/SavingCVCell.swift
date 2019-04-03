//
//  SavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingCVCell: UICollectionViewCell {
    
    lazy var savingGoalView: SavingGoalView = {
        
        guard let goalView = Bundle.main.loadNibNamed(String(describing: SavingGoalView.self), owner: nil, options: nil)?[0] as? SavingGoalView else { return SavingGoalView() }
        
        goalView.frame = CGRect(x: 0, y: 0, width: savingGoalContainView.frame.width, height: savingGoalContainView.frame.height)
        
        return goalView
        
    }()
    
    @IBOutlet weak var savingGoalContainView: SavingGoalView! {
        
        didSet {
            
            savingGoalContainView.addSubview(savingGoalView)
            
        }
        
    }
    
    @IBOutlet weak var accountTableView: UITableView! {
        
        didSet {
            
            accountTableView.estimatedRowHeight = 0
            
//            accountTableView.estimatedSectionHeaderHeight = 0
//            
//            accountTableView.estimatedSectionFooterHeight = 0
            
            accountTableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 1000)
            
            setUpTableView()
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initSavingCVCell(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        
        accountTableView.dataSource = dataSource
        
        accountTableView.delegate = delegate
        
    }
    
    func setUpTableView() {
        
        accountTableView.helpRegister(cell: SearchBarTVCell())
        
//        accountTableView.beginUpdates()
//
//        accountTableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 1000000)
//
//        accountTableView.endUpdates()
//
//        accountTableView.reloadData()
        
//        accountTableView.contentOffset = CGPoint(x: 0, y: 56)
        
//        accountTableView.contentInset.top = -56
        
    }

}

