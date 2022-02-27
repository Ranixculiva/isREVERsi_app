//
//  OptionMenu.swift
//  Reversi
//
//  Created by john gospai on 2019/7/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class OptionMenu: SKSpriteNode{
    enum savedVariable: String{
        case originalLanguageOption = "originalLanguageOption"
        case originalVolumeOption = "originalVolumeOption"
        case originalNeedToGuide = "originalNeedToGuide"
    }
    var savedVariables: [savedVariable: Any] = [:]
    weak var VC: UIViewController? = nil
    fileprivate var items: [SKNode] = []
    convenience init(VC: UIViewController) {
        
        let items = [
            MusicVolumeSlider(),
            LanguageOption(),
            TutorialOption(),
            PurchaseButtons(),
            AboutOption(VCToPresentAboutWebPage: VC)
        ]
        let backgroundWidth = UI.gridSize
        let itemsTotalHeight = items.map{$0.frame.height}.reduce(0, +)
        let backgroundHeight = itemsTotalHeight + UI.closeButtonHeight + UI.optionMenuSpacing * (CGFloat(items.count)+1.5)
        let backgroundTexture = OptionMenu.drawBackground(size: CGSize(width: backgroundWidth, height: backgroundHeight))
        self.init(texture: backgroundTexture)
        self.items = items
        
        let spacing = UI.optionMenuSpacing
        var itemOffsetY = spacing - size.height/2
        for item in items.reversed() {
            item.zPosition = 1
            addChild(item)
            itemOffsetY += item.frame.height/2
            item.position.y = itemOffsetY
            itemOffsetY += item.frame.height/2 + spacing
        }
        
        
        
    }
    fileprivate class func drawBackground(size: CGSize) -> SKTexture{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let bgCtx = UIGraphicsGetCurrentContext()
        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
//        let bgStartColor = UIColor(red: 255/255, green: 126/255, blue: 179/255, alpha: 1)
//
//        let bgMidColor = UIColor(red: 510/510, green: 243/510, blue: 319/510, alpha: 1)
//
//        let bgEndColor = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1)
        let bgStartColor = UIColor(red: 255/255, green: 126/255, blue: 179/255, alpha: 1)
        
        let bgMidColor = UIColor(red: 510/510, green: 243/510, blue: 319/510, alpha: 1)
        
        let bgEndColor = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1)
        
        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
        
        let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
        
        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
        let roundedRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: UI.optionMenuCornerRadius)
        bgCtx?.saveGState()
        roundedRect.addClip()
        bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        bgCtx?.restoreGState()
        UIGraphicsEndImageContext()
        return SKTexture(image: backgroundImage!)
    }
}
