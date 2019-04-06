//
//  AnalysisCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AnalysisCVCell: UICollectionViewCell {
    
    @IBOutlet weak var analysisCollectionView: UICollectionView! {
        
        didSet {
            
            setUpCollectionView()
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initAnalysisCVCell(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        
        analysisCollectionView.dataSource = dataSource
        
        analysisCollectionView.delegate = delegate
        
    }
    
    func setUpCollectionView() {
        
        analysisCollectionView.helpRegister(cell: PieChartCVCell())
        
        analysisCollectionView.helpRegister(cell: BarChartCVCell())
        
        analysisCollectionView.helpRegister(cell: AccountsCVCell())
        
        analysisCollectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        
    }

}
