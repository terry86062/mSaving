//
//  TopView.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

@IBDesignable class TopView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    override func draw(_ rect: CGRect) {
        
        createGradientLayer()
        
        setUpShadow()
        
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [
            UIColor.mSLightGreen.cgColor,
            UIColor.mSGreen.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func setUpShadow() {
        
        msShadowOffset = CGSize(width: 0, height: 2)
        
        msShadowOpacity = 0.8
        
        msShadowRadius = 5
        
        msShadowColor = .gray
        
    }

}
