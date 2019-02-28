//
//  UI.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class UI {
//    class func getIconPosition() -> CGPoint{
//        guard let safeInsets = UIApplication.shared.keyWindow?.safeAreaInsets else{fatalError("cannot get safeInsets")}
//    }
    static var logoPosition: CGPoint{
        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //let frameWidth = rootView.frame.width * UIScreen.main.scale
        let frameHeight = rootView.frame.height * UIScreen.main.scale
        guard let safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {fatalError("cannot get safeInsets")}
        let scale = UIScreen.main.scale
        let y = (frameHeight/2 - safeInsets.top*scale + gridSize/2)/2
        return CGPoint(x: 0, y: y)
    }
    static var logoSize: CGSize{
        guard let logoImage = UIImage(named: "Logo") else{fatalError("cannot find image Logo")}
        return CGSize(width: 4/6 * UI.gridSize, height: logoImage.size.height * (4/6 * UI.gridSize) /  logoImage.size.width)
    }
    static var hintBubbleColor: UIColor{
        return SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    static var levelLabelFontSize: CGFloat{
        return gridSize * 0.8/6
    }
    /**
     remember to set levelLabel.verticalAlignmentMode = .bottom
     */
    static func levelLabelPosition(indexFromLeft: Int) -> CGPoint{
        
        var pos = levelPicturePosition(indexFromLeft: indexFromLeft)
        pos.y += levelPictureSize.height/2 + gridSize/15
        return pos
    }
    static var levelLabelFontName: String{
        return "chalkboard SE"
    }
    static var levelLabelFontColor: UIColor{
        return .white
    }
    static func levelPicturePosition(indexFromLeft: Int) -> CGPoint{
         guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        let frameWidth = rootView.frame.width * UIScreen.main.scale
    
        let x = CGFloat(indexFromLeft) * frameWidth * 3/4
        let y = -(gridSize/15 + levelLabelFontSize)/2
        return CGPoint(x: x, y: y)
    }
    static var levelPictureSize: CGSize{
        return CGSize(width: gridSize * 2.5/6, height: gridSize * 2.5/6)
    }
    static var menuIconHintLabelFontSize: CGFloat{
        return menuIconSize.width / 2
    }
    static var menuIconSize: CGSize{
        return  CGSize(width: UI.gridSize / 8, height: UI.gridSize / 8) 
    }
    static func getMenuIconPosition(indexFromLeft: Int, numberOfMenuIcon: Int) -> CGPoint{
         guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        guard let safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {fatalError("cannot get safeInsets")}
        let frameWidth = rootView.frame.width * UIScreen.main.scale
        let frameHeight = rootView.frame.height * UIScreen.main.scale
        let scale = UIScreen.main.scale
        if numberOfMenuIcon == 0 {fatalError("wrong number of menu icon")}
        let y = -frameHeight/2 + safeInsets.bottom*scale + 10 * UIScreen.main.scale + menuIconSize.height/2
        if numberOfMenuIcon == 1{return CGPoint(x: 0, y: y)}
        let interval = (frameWidth - safeInsets.right*scale - safeInsets.left*scale -  20 * UIScreen.main.scale - menuIconSize.width) / CGFloat(numberOfMenuIcon - 1)
        let x = interval * CGFloat(indexFromLeft) - frameWidth / 2 + safeInsets.left*scale + 10 * UIScreen.main.scale + menuIconSize.width/2
        
        return CGPoint(x: x, y: y)
    }
    static var gridSize: CGFloat{
         guard let rootViewFrame =  UIApplication.shared.delegate?.window??.rootViewController?.view.frame else{fatalError("cannot get rootViewFrame")}
        //guard let rootViewFrame = UIApplication.shared.keyWindow?.rootViewController?.view.frame else{fatalError("cannot get rootViewFrame")}
        
        let frameWidth = rootViewFrame.width * UIScreen.main.scale
        let frameHeight = rootViewFrame.height * UIScreen.main.scale
        
        var gridSideLength = frameHeight / 2
        
        if gridSideLength > frameWidth{
            gridSideLength = frameWidth - 50 * UIScreen.main.scale
        }
        return gridSideLength
    }
    static var challengeLabelFontSize: CGFloat{
        return menuIconHintLabelFontSize * 1.6
    }
    static var challengeFlipLabelFontSize: CGFloat{
        return menuIconHintLabelFontSize * 1.6
    }
    static var guideFontSize: CGFloat{
        return menuIconHintLabelFontSize * 1.2
    }
    static var guideFontName: String{
        return "chalkboard SE"
    }
    static var guideFontColor: UIColor{
        return .white
    }
    static var flipsPosition: CGPoint{
        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        let frameWidth = rootView.frame.width * UIScreen.main.scale
        let frameHeight = rootView.frame.height * UIScreen.main.scale
        guard let safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {fatalError("cannot get safeInsets")}
        let scale = UIScreen.main.scale
        let x = frameWidth/4
        let y = (frameHeight/2 - safeInsets.top*scale + logoPosition.y + logoSize.height/2)/2
        return CGPoint(x: x, y: y)
    }
    static var flipsFontSize: CGFloat{
//        guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
//        let safeInsets = rootView.safeAreaInsets
        return challengeLabelFontSize * 0.8
    }
    static var flipNumberFontSize: CGFloat{
        return flipsFontSize
    }
    static var flipNumberPosition: CGPoint{
        return CGPoint(x: flipsPosition.x + flipsFontSize/2 + 10*UIScreen.main.scale, y: flipsPosition.y)
    }
    static var zPosition = (
        flipsIndicator: CGFloat(100),
        flips: CGFloat(10),//110 globally
        flipNumber: CGFloat(10),//110 globally
        //MARK: in TitleScene
        helpNode: CGFloat(10),
        backgroundGrid: CGFloat(9),
        backgroundGridBackground: CGFloat(8),
        logo: CGFloat(10),
        guideBackground: CGFloat(1000),
        guideLight: CGFloat(1),//1001 globally
        guideLabel: CGFloat(1)//1001 globally
    )
}
