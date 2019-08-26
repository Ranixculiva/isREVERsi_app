//
//  LanguageOption.swift
//  Reversi
//
//  Created by john gospai on 2019/7/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class LanguageOption: TextOptionsWithSelectButtons{
    override func didFetchValue(value: Int, name: String?) {
        super.didFetchValue(value: value, name: name)
        switch value {
        case 0:
            SharedVariable.language = .zhHant
        case 1:
            SharedVariable.language = .zhHans
        case 2:
            SharedVariable.language = .en
        default:
            break
        }
    }
    convenience init() {
        let languages = ["繁體中文","简体中文","English"]
        let fontNames = [UI.fontName.PingFangSCSemibold.rawValue,UI.fontName.PingFangSCSemibold.rawValue,
        UI.fontName.ChalkboardSEBold.rawValue]
        let spacing = CGFloat(250)
        let leftButton = SKSpriteNode(color: .blue, size: CGSize(width: 25, height: 50))
        let rightButton = SKSpriteNode(color: .red, size: CGSize(width: 25, height: 50))
        self.init(texts: languages, spacing: UI.languageOptionSpacing, leftButton: leftButton, rightButton: rightButton, isCyclic: true, fontNames: fontNames, fontSize:  UI.languageOptionFontSize, fontColor: UI.languageOptionFontColor)
        selectButtons.fetchValueDelegate = self
        switch SharedVariable.language {
        case .defaultLang:
            if let defaultLang = Bundle.main.preferredLocalizations.first{
                if defaultLang == SharedVariable.lang.zhHant.rawValue{
                    value = 0
                }
                else if defaultLang == SharedVariable.lang.zhHans.rawValue{
                    value = 1
                }
                else{
                    value = 2
                }
            }
        case .zhHant:
            value = 0
        case .zhHans:
            value = 1
        case .en:
            value = 2
        }
    }
    //override init(texts: [String], spacing: CGFloat, leftButton: SKSpriteNode, rightButton: SKSpriteNode, isCyclic: Bool = true, fontNames: [String]? = nil, fontSize: CGFloat = UI.fontSize.difficultySelector, fontColor: UIColor = .black) {
       // super.init(texts: languages, spacing: spacing, leftButton: leftButton, rightButton: rightButton, isCyclic: true, fontNames: fontNames, fontSize:  UI.fontSize.difficultySelector, fontColor: .black)
    //}
    
    //required init?(coder aDecoder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
    //}
}
