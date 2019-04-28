//
//  UILabel - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/28.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

@IBDesignable
extension UILabel {
    
    @IBInspectable var characterSpacing: CGFloat {
        
        get {
            
            return (attributedText?.value(forKey: NSAttributedString.Key.kern.rawValue) as? CGFloat)!
            
        }
        
        set {
            
            if let labelText = text, labelText.count > 0 {
                
                let attributedString = NSMutableAttributedString(attributedString: attributedText!)
                
                attributedString.addAttribute(
                    NSAttributedString.Key.kern,
                    value: newValue,
                    range: NSRange(location: 0, length: attributedString.length - 1)
                )
                
                attributedText = attributedString
                
            }
            
        }
        
    }
    
}
