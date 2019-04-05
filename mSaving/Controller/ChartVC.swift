//
//  ChartVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Charts

class ChartVC: UIViewController {
    
    @IBOutlet weak var analysisCollectionView: UICollectionView! {
        
        didSet {
            
            analysisCollectionView.dataSource = self
            
            analysisCollectionView.delegate = self
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        
        analysisCollectionView.helpRegister(cell: PieChartCVCell())
        
        analysisCollectionView.helpRegister(cell: BarChartCVCell())
        
    }
    
}

extension ChartVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = analysisCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PieChartCVCell.self), for: indexPath) as? PieChartCVCell else { return UICollectionViewCell() }
            
            cell.pieChartUpdate()
            
            return cell
            
        } else {
            
            guard let cell = analysisCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BarChartCVCell.self), for: indexPath) as? BarChartCVCell else { return UICollectionViewCell() }
            
            cell.barChartUpdate()
            
            return cell
            
        }
        
    }
    
}

extension ChartVC: UICollectionViewDelegate {
    
    
    
}

extension ChartVC: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 320)
        
    }
    
}
