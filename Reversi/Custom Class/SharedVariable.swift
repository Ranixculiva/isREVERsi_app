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
        case isThereGameToLoad = "isThereGameToLoad"
        case needToGuide = "sharedVariables-needToGuide"
        case withAds = "sharedVariables-withAds"
        case flips = "sharedVariables-flips"
        case language = "sharedVariables-language"
    }
    //TODO: withAds = true
    static var isThereGameToLoad = false
    static var withAds = false
    static var needToGuide = false
    static var flips = 0{
        didSet{
            save()
        }
    }
    enum lang: String{
        case defaultLang = "default"
        case zhHant = "zh-Hant"
        case zhHans = "zh-Hans"
        case en = "en"
    }
    static var language = lang.defaultLang
    class func save(){
        UserDefaults.standard.set(isThereGameToLoad, forKey: key.isThereGameToLoad.rawValue)
        UserDefaults.standard.set(needToGuide, forKey: key.needToGuide.rawValue)
        UserDefaults.standard.set(language.rawValue, forKey: key.language.rawValue)
        KeychainWrapper.standard.set(flips, forKey: key.flips.rawValue)
    }
    class func load(){
        isThereGameToLoad = UserDefaults.standard.value(forKey: key.isThereGameToLoad.rawValue) as! Bool? ?? isThereGameToLoad
        needToGuide = UserDefaults.standard.value(forKey: key.needToGuide.rawValue) as! Bool? ?? needToGuide
        if let languageRawValue = UserDefaults.standard.value(forKey: key.language.rawValue) as! String?{
            language =  lang(rawValue: languageRawValue) ?? language
        }
        withAds = KeychainWrapper.standard.bool(forKey: key.withAds.rawValue) ?? withAds
        flips = KeychainWrapper.standard.integer(forKey: key.flips.rawValue) ?? flips
        
    }
}
