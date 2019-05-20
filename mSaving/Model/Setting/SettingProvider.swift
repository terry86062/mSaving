//
//  SettingProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/19.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

struct SettingText {
    
    let leadingText: String
    
    let trailingText: String
    
}

class SettingProvider {
    
    var settings: [SettingText] = [
        SettingText(leadingText: "類別顯示", trailingText: ">"),
        SettingText(leadingText: "使用 Siri 記帳", trailingText: ">"),
        SettingText(leadingText: "隱私權聲明內容", trailingText: ">"),
        SettingText(leadingText: "給予評價", trailingText: ">")
    ]
    
}
