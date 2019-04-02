//
//  UIStoryboard - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let saving = "Saving"
    
    static let chart = "Chart"
    
    static let accounting = "Accounting"
    
    static let invoice = "Invoice"
    
    static let setting = "Setting"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.main) }
    
    static var saving: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.saving) }
    
    static var chart: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.chart) }
    
    static var accounting: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.accounting) }
    
    static var invoice: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.invoice) }
    
    static var setting: UIStoryboard { return helpMakeStoryboard(name: StoryboardCategory.setting) }
    
    private static func helpMakeStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
        
    }
    
}
