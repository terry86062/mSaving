//
//  CategorySelectCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategorySelectCVCell: UICollectionViewCell {
    
    @IBOutlet weak var subCategoryImageView: UIImageView!
    
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    
    var selectSubCategory: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func initCategorySelectCVCell(imageName: String, subCategoryName: String) {
        
        subCategoryImageView.image = UIImage(named: imageName)
        
        subCategoryNameLabel.text = subCategoryName
        
    }

    @IBAction func selectSubCategory(_ sender: UIButton) {
        
        guard let select = selectSubCategory else { return }
        
        select()
        
    }
    
}
