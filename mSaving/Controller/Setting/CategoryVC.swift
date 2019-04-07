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
    
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        
        didSet {
            
            categoryCollectionView.dataSource = self
            
            categoryCollectionView.delegate = self
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        categorySegmentedC.segments = LabelSegment.segments(withTitles: ["支出", "收入"], normalBackgroundColor: UIColor.white, normalFont: .systemFont(ofSize: 16), normalTextColor: UIColor.mSYellow, selectedBackgroundColor: UIColor.mSYellow, selectedFont: .systemFont(ofSize: 16), selectedTextColor: UIColor.black)
        
    }
    
    func setUpCollectionView() {
        
        categoryCollectionView.helpRegister(cell: IncomeExpenseCategoryCVCell())
        
    }
    
    @IBAction func pop(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension CategoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IncomeExpenseCategoryCVCell.self), for: indexPath) as? IncomeExpenseCategoryCVCell else { return IncomeExpenseCategoryCVCell() }
        
        return cell
        
    }
    
}

extension CategoryVC: UICollectionViewDelegate {
    
}

extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 382, height: categoryCollectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}
