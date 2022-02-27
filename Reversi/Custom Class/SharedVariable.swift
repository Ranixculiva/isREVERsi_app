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
        case bgmVolumeRatio = "bgmVolumeRatio"
        case isThereGameToLoad = "isThereGameToLoad"
        case needToGuide = "sharedVariables-needToGuide"
        case withAds = "sharedVariables-withAds"
        case flips = "sharedVariables-flips"
        case language = "sharedVariables-language"
    }
    //TODO: withAds = true
    static var bgmVolume: Float{
        return bgmVolumeRatio > sfxVolumeRatio ? 1 : bgmVolumeRatio/sfxVolumeRatio
    }
    static var sfxVolume: Float{
        return sfxVolumeRatio > bgmVolumeRatio ? 1 : sfxVolumeRatio/bgmVolumeRatio
    }
    static var bgmVolumeRatio: Float{
        get{
            return stored_bgmVolumeRatio
        }
        set{
            stored_bgmVolumeRatio = min(1, max(0, newValue))
            stored_sfxVolumeRatio = 1 - stored_bgmVolumeRatio
            MusicPlayer.updatePlyersVolume()
        }
    }
    static var sfxVolumeRatio: Float{
        get{
            return stored_sfxVolumeRatio
        }
        set{
            stored_sfxVolumeRatio = min(1, max(0, newValue))
            stored_bgmVolumeRatio = 1 - stored_sfxVolumeRatio
            MusicPlayer.updatePlyersVolume()
        }
    }
    fileprivate static var stored_bgmVolumeRatio: Float = 0.5
    fileprivate static var stored_sfxVolumeRatio: Float = 0.5
    static var isThereGameToLoad = false
    static var withAds = true
    static var needToGuide = true
    static var flips = 3{
        didSet{
            save()
        }
    }
    enum lang: String{
        case `default` = "default"
        case zhHant = "zh-Hant"
        case zhHans = "zh-Hans"
        case en = "en"
    }
    static var language = lang.default
    static var localization: String{
        if SharedVariable.language == .`default`{
            if let defaultLang = Bundle.preferredLocalizations(from: ["en", "zh-Hans", "zh-Hant"]).first{
                return defaultLang
            }
        }
        else {
            return SharedVariable.language.rawValue
        }
        return "en"
    }
    class func save(){
        UserDefaults.standard.set(isThereGameToLoad, forKey: key.isThereGameToLoad.rawValue)
        UserDefaults.standard.set(needToGuide, forKey: key.needToGuide.rawValue)
        UserDefaults.standard.set(language.rawValue, forKey: key.language.rawValue)
        UserDefaults.standard.set(bgmVolumeRatio, forKey: key.bgmVolumeRatio.rawValue)
        KeychainWrapper.standard.set(flips, forKey: key.flips.rawValue)
        //KeychainWrapper.standard.set(true, forKey: key.withAds.rawValue)
    }
    class func load(){
        bgmVolumeRatio = UserDefaults.standard.value(forKey: key.bgmVolumeRatio.rawValue) as! Float? ?? bgmVolumeRatio
        isThereGameToLoad = UserDefaults.standard.value(forKey: key.isThereGameToLoad.rawValue) as! Bool? ?? isThereGameToLoad
        needToGuide = UserDefaults.standard.value(forKey: key.needToGuide.rawValue) as! Bool? ?? needToGuide
        if let languageRawValue = UserDefaults.standard.value(forKey: key.language.rawValue) as! String?{
            language =  lang(rawValue: languageRawValue) ?? language
        }
        withAds = KeychainWrapper.standard.bool(forKey: key.withAds.rawValue) ?? withAds
        flips = KeychainWrapper.standard.integer(forKey: key.flips.rawValue) ?? flips
        
    }
}
