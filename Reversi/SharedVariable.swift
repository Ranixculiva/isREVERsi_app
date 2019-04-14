//
//  SharedVariable.swift
//  Reversi
//
//  Created by john gospai on 2019/2/27.
//  Copyright © 2019 john gospai. All rights reserved.
//

import Foundation
class SharedVariable{
    enum key: String {
        case needToGuide = "needToGuide"
        case flips = "flips"
        case language = "language"
    }
    static var needToGuide = false
    static var flips = 99999
    enum lang: String{
        case defaultLang = "default"
        case zhHant = "zh-Hant"
        case zhHans = "zh-Hans"
        case en = "en"
    }
    static var language = lang.zhHant
    class func save(){
        UserDefaults.standard.set(needToGuide, forKey: key.needToGuide.rawValue)
        UserDefaults.standard.set(flips, forKey: key.flips.rawValue)
        UserDefaults.standard.set(language.rawValue, forKey: key.language.rawValue)
    }
    class func load(){
        needToGuide = UserDefaults.standard.value(forKey: key.needToGuide.rawValue) as! Bool? ?? needToGuide
        flips = UserDefaults.standard.value(forKey: key.flips.rawValue) as! Int? ?? flips
        if let languageRawValue = UserDefaults.standard.value(forKey: key.language.rawValue) as! String?{
            language =  lang(rawValue: languageRawValue) ?? language
        }
        
    }
}
