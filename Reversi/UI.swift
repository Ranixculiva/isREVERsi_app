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
    static func loadUIEssentials(){
        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        frameWidth = rootView.frame.width * UIScreen.main.scale
        frameHeight = rootView.frame.height * UIScreen.main.scale
        if #available(iOS 11.0, *) {
            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
        }
    }
    fileprivate static var frameWidth = CGFloat(0)
    fileprivate static var frameHeight = CGFloat(0)
    fileprivate static var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static var rootSize: CGSize{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
        return CGSize(width: frameWidth, height: frameHeight)
    }
    static var logoPosition: CGPoint{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //let frameWidth = rootView.frame.width * UIScreen.main.scale
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
//        var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *) {
//            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
//        }
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
    static func levelPicturePosition(indexFromLeft: Int) -> CGPoint{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
        
        let x = CGFloat(indexFromLeft) * frameWidth * 3/4
        let y = -(gridSize/15 + levelLabelFontSize)/2
        return CGPoint(x: x, y: y)
    }
    static var levelPictureSize: CGSize{
        return CGSize(width: gridSize * 2.5/6, height: gridSize * 2.5/6)
    }
    static var levelPictureRoundedCornerRadius: CGFloat{
        return levelPictureSize.height/6
    }
    static var modeLabelFontColor: UIColor{
        return .white
    }
    static var menuIconHintLabelFontSize: CGFloat{
        return menuIconSize.width / 2
    }
    static var menuIconSize: CGSize{
        return  CGSize(width: UI.gridSize / 8, height: UI.gridSize / 8)
    }
    static func getMenuIconPosition(indexFromLeft: Int, numberOfMenuIcon: Int) -> CGPoint{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//
//        var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *) {
//            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
//        }
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
        let scale = UIScreen.main.scale
        if numberOfMenuIcon == 0 {fatalError("wrong number of menu icon")}
        let y = -frameHeight/2 + safeInsets.bottom*scale + 10 * UIScreen.main.scale + menuIconSize.height/2
        if numberOfMenuIcon == 1{return CGPoint(x: 0, y: y)}
        let interval = (frameWidth - safeInsets.right*scale - safeInsets.left*scale -  20 * UIScreen.main.scale - menuIconSize.width) / CGFloat(numberOfMenuIcon - 1)
        let x = interval * CGFloat(indexFromLeft) - frameWidth / 2 + safeInsets.left*scale + 10 * UIScreen.main.scale + menuIconSize.width/2
        
        return CGPoint(x: x, y: y)
    }
    static var shareButtonPosition: CGPoint{
        let x = CGFloat(0)
        let y = -gridSize/4 + getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 1).y/2 + menuIconSize.height/2
        return CGPoint(x: x, y: y)
    }
    static var gridSize: CGFloat{
//        guard let rootViewFrame =  UIApplication.shared.delegate?.window??.rootViewController?.view.frame else{fatalError("cannot get rootViewFrame")}
//        
//        let frameWidth = rootViewFrame.width * UIScreen.main.scale
//        let frameHeight = rootViewFrame.height * UIScreen.main.scale
        
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
    static var guideFontColor: UIColor{
        return .white
    }
    static var guideBackgroundColor: UIColor{
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    static var flipsPosition: CGPoint{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
//        var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *) {
//            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
//        }
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
    ////m
    static var gestureGuideSize: CGSize{
        return CGSize(width: gridSize/8, height: gridSize/8)
    }
    static var gestureGuideStrokeWidth: CGFloat{
        return gestureGuideSize.width/15
    }
    static var gestureGuideStrokeColor: UIColor{
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
    }
    static var scrollTextSize: CGSize{
        //        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
        //        let frameHeight = rootView.frame.height * UIScreen.main.scale
        //        return CGSize(width: gridSize*14/16, height: frameHeight * 3/8)
        return CGSize(width: messageBoxSize.width - messageBoxCornerRadius*2, height: messageBoxSize.height - messageBoxCornerRadius*4)
        //return CGSize(width: 300, height: 500)
    }
    static var scrollTextFontSize: CGFloat{
        return menuIconHintLabelFontSize * 0.9
    }
    static var scrollTextFontColor: UIColor{
        return .black
    }
    static var scrollTextColor: UIColor{
        return .white
    }
    static var scrollTextCornerRadius: CGFloat{
        return scrollTextFontSize/2
    }
    static var scrollTextInsets: (top: CGFloat, bottom: CGFloat, right: CGFloat, left: CGFloat){
        let inset = scrollTextFontSize/2
        return (top: inset, bottom: inset, right: inset, left: inset)
    }
    static var messageBoxLabelWidth: CGFloat{
        return scrollTextSize.width - scrollTextInsets.left - scrollTextInsets.right
    }
    static var messageBoxCornerRadius: CGFloat{
        return scrollTextCornerRadius * 2
    }
    static var messageBoxSize: CGSize{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameHeight = rootView.frame.height * UIScreen.main.scale
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
        let width = gridSize*15/16
        let height = frameHeight - (frameWidth - width)
        return CGSize(width: width, height: height)
    }
    static var messageBoxColor: UIColor{
        return UIColor(red: 222/510, green: 348/510, blue: 499/510, alpha: 1)
    }
    static var messageBoxLineWidth: CGFloat{
        return gridSize/200
    }
    static var messageBoxTitleFontSize: CGFloat{
        return scrollTextFontSize*1.2
    }
    static var messageBoxActionButtonFontSize: CGFloat{
        return scrollTextFontSize
    }
    ////m
    static var loadingPhaseFontSize: CGFloat{
        return challengeLabelFontSize
    }
    //left back
    static var backFromUndoPosition: CGPoint{
//        guard let rootView =  UIApplication.shared.delegate?.window??.rootViewController?.view else{fatalError("cannot get rootViewFrame")}
//        let frameWidth = rootView.frame.width * UIScreen.main.scale
//        var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *) {
//            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
//        }
        return CGPoint(x: -frameWidth/2 + safeInsets.left + 10*UIScreen.main.scale, y: flipsPosition.y)
    }
    static var backFromUndoButtonColor: UIColor{
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    static var backFromUndoFontSize: CGFloat{
        return UI.flipsFontSize
    }
    //GameScene
    static var primaryScoreFontSize: CGFloat{
        return gridSize/6
    }
    static var secondaryScoreFontSize: CGFloat{
        return primaryScoreFontSize*0.7
    }
    static var blackScorePosition: CGPoint{
        return CGPoint(x: gridSize*(2.0/6.0), y: gridSize*(-7.0/12.0))
    }
    static var whiteScorePosition: CGPoint{
        return CGPoint(x: gridSize*(-2.0/6.0), y: gridSize*(-7.0/12.0))
    }
    //MARK: - fontName
    enum fontName: String{
        case PingFangSCSemibold = "PingFang-SC-Semibold"
        case PingFangSCRegular = "PingFang-SC-Regular"
        
        case ChalkboardSEBold = "ChalkboardSE-Bold"
        case ChalkboardSERegular = "ChalkboardSE-Regular"
        
        case negativeCircledNumber = "negative-circled-number"
    }
    
    static var isLanguageEn: Bool{
        let languageCode = Locale.current.languageCode ?? "en"
        return SharedVariable.language == .en || (SharedVariable.language == .defaultLang && languageCode == "en")
    }
    //MARK: in GameScene
    static var chessFontName = fontName.negativeCircledNumber.rawValue
    static var challengeFlipLabelFontName = fontName.negativeCircledNumber.rawValue
    static var challengeLabelFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSERegular : fontName.PingFangSCRegular).rawValue
    }
    //MARK: in TitleScene
    static var loadingTextFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSERegular : fontName.PingFangSCRegular).rawValue
    }
    static var guideFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    //MARK: in LevelSelectScene
    static var levelLabelFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    //MARK: in ModeSelectScene
    static var modeLabelFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    //MARK: in SKMultilineLabelNode
    static var SKMultilineLabelNodeFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSERegular : fontName.PingFangSCRegular).rawValue
    }
    //MARK: in HintBubble
    static var HintBubbleFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSERegular:fontName.PingFangSCRegular).rawValue
    }
    //MARK: in FlipsIndicator
    static var flipsIndicatorFlipsLabelFontName = fontName.negativeCircledNumber.rawValue
    static var flipsIndicatorFlipsNumberFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    //MARK: in Button
    static var buttonLabelFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSERegular:fontName.PingFangSCRegular).rawValue
    }
    static var messageBoxTitleFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    static var messageBoxActionButtonFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
    //MARK: - fontSize
    static var fontSize = (
        levelLabel: levelLabelFontSize,
        menuIconHintLabel: menuIconHintLabelFontSize,
        challengeLabel: challengeLabelFontSize,
        challengeFlipLabel: challengeFlipLabelFontSize,
        guide: guideFontSize,
        flips: flipsFontSize,
        flipNumber: flipNumberFontSize,
        loadingPhase: loadingPhaseFontSize
    )
    static var size = (
        logo: logoSize,
        levelPicture: levelPictureSize,
        menuIcon: menuIconSize,
        grid: gridSize
    )
    static var position = (
        logo: logoPosition,
        levelLabel: levelLabelPosition,
        levelPicture: levelPicturePosition,
        getMenuIcon: getMenuIconPosition,
        // set anchor point (x: 0, y: 0.5)
        backFromUndo: backFromUndoPosition
    )
    static var zPosition = (
        ////m
        //MARK: background
        croppedNode:              CGFloat(-10000000),
        background:               CGFloat(-100000),
        gestureGuide:             CGFloat(100000),
        messageBox:               CGFloat(10000),
        ////m
        loadingPahse:             CGFloat(1000000),
        menuIcon:                 CGFloat(10),
        menuHint:                 CGFloat(10),
        flipsIndicator:           CGFloat(100),
        flips:                    CGFloat(10),//110 globally
        flipNumber:               CGFloat(10),//110 globally
        //MARK: in GameScene
        chessBoardBackground:     CGFloat(-1),
        chessBoard:               CGFloat(-0.5),
        grid:                     CGFloat(1),
        brighterFilter:           CGFloat(1.5),
        reviewSlider:             CGFloat(3),
        stateIndicator:           CGFloat(-1),
        reviewBase:               CGFloat(4),
        reviewBackground:         CGFloat(2),
        back:                     CGFloat(3),
        //MARK: result in GameScene
        resultBackground:         CGFloat(6),
        shareButton:              CGFloat(7),
        shareHint:                CGFloat(140),
        screenshot:               CGFloat(120),
        challengeFlipLabel:       CGFloat(9.5),
        challengeLabel:           CGFloat(9),
        flashlight:               CGFloat(150),
        //MARK: in TitleScene
        backgroundGrid:           CGFloat(9),
        backgroundGridBackground: CGFloat(8),
        logo:                     CGFloat(10),
        guideBackground:          CGFloat(1000),
        guideLight:               CGFloat(1),//1001 globally
        guideLabel:               CGFloat(1)//1001 globally
    )
}
