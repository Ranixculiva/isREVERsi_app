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
    static let flipsIndicator = FlipsIndicator(flips: 0)!
    class func addFlipsIndicator(to: SKNode){
        UI.flipsIndicator.removeFromParent()
        to.addChild(UI.flipsIndicator)
    }
    static let logoSwitch = LogoSwitch()
    class func addLogoSwitch(to: SKNode){
        UI.logoSwitch.removeFromParent()
        to.addChild(UI.logoSwitch)
    }
    weak static var rootViewController: UIViewController? = nil
    static func loadUIEssentials(){
        guard let rootView =  rootViewController?.view else{fatalError("cannot get rootView")}
        frameWidth = rootView.frame.width * UIScreen.main.scale
        frameHeight = rootView.frame.height * UIScreen.main.scale
        if #available(iOS 11.0, *) {
            safeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? safeInsets
        }
    }
    static var frameWidth = CGFloat(0)
    static var frameHeight = CGFloat(0)
    static var safeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static var rootSize: CGSize{
        return CGSize(width: frameWidth, height: frameHeight)
    }
    static var logoPosition: CGPoint{
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
        let x = CGFloat(indexFromLeft) * frameWidth
        let y = -(gridSize/15 + levelLabelFontSize)/2
        return CGPoint(x: x, y: y)
    }
    static var levelPictureSize: CGSize{
        return CGSize(width: gridSize * 2.5/6, height: gridSize * 2.5/6)
    }
    static var levelPictureRoundedCornerRadius: CGFloat{
        return levelPictureSize.height/4
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
        let scale = UIScreen.main.scale
        let x = frameWidth/4
        let y = (frameHeight/2 - safeInsets.top*scale + logoPosition.y + logoSize.height/2)/2
        return CGPoint(x: x, y: y)
    }
    static var flipsFontSize: CGFloat{
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
        return CGSize(width: messageBoxSize.width - messageBoxCornerRadius*2, height: messageBoxSize.height - messageBoxCornerRadius*4)
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
    static var scoreFontName: String{
        return fontName.ChalkboardSEBold.rawValue
    }
    //MARK: - AbilityMenu
    
    static var abilityMenuWidth: CGFloat{
        return primaryScoreFontSize
    }
    static var abilityMenuSpace: CGFloat{
        return abilityMenuWidth/6
    }
    static var abilityMenuRoundedCornerRadius: CGFloat{
        return primaryScoreFontSize/6
    }
    static var abilityMenuItemWidth: CGFloat{
        return abilityMenuWidth * 4/6
    }
    static var abilityMenuItemRoundedCornerRadius: CGFloat{
        return primaryScoreFontSize/10
    }
    //MARK: - difficultySelector
    static var difficultySelectorPosition: CGPoint{
        let a = (levelPicturePosition(indexFromLeft: 0).y - levelPictureSize.height/2)
        let b = (getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 1).y + menuIconSize.height/2)
        let y = ( a + b )/2
        return CGPoint(x: 0, y: y)
    }
    static var difficultySelectorSpacing: CGFloat{
        return levelPictureSize.width
    }
    static var difficultySelectorButtonSize: CGSize{
        return CGSize(width: fontSize.difficultySelector/2, height: fontSize.difficultySelector)
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
    static var difficultySelectorFontName: String{
        return (isLanguageEn ? fontName.ChalkboardSEBold:fontName.PingFangSCSemibold).rawValue
    }
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
        return fontName.ChalkboardSEBold.rawValue
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
    static var loadButtonPosition: CGPoint{
        let topOfMenuButtonY = getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 2).y + menuIconSize.height/2
        return CGPoint(x: 0, y: (-gridSize/2 + topOfMenuButtonY)/2)
    }
    static var loadButtonColor: UIColor{
        return UI.backFromUndoButtonColor
    }
    static var loadButtonCornerRadius: CGFloat{
        return UI.loadButtonFontSize
    }
    static var loadButtonFontSize: CGFloat{
        return UI.backFromUndoFontSize
    }
    //MARK: - levelSelector
    static var levelSelectorSpacing: CGFloat{
        return logoSize.width
    }
    static var levelSelectorPosition: CGPoint{
        return levelPicturePosition(indexFromLeft: 0)
    }
    static var levelSelectorButtonSize: CGSize{
        return difficultySelectorButtonSize
    }
    //MARK: - modeSelector
    static var modeSelectorSpacing: CGFloat{
        return levelSelectorSpacing
    }
    static var modeSelectorPosition: CGPoint{
        return levelSelectorPosition
    }
    static var modeSelectorButtonSize: CGSize{
        return difficultySelectorButtonSize
    }
    //MARK: - purchased button
    static var purchasedButtonColor: UIColor{
        return .white
    }
    static var purchasedButtonCornerRadius: CGFloat{
        return loadButtonCornerRadius
    }
    static var purchasedButtonFontSize: CGFloat{
        return UI.loadButtonFontSize
    }
    //MARK: - purchase button
    static var purchaseButtonColor: UIColor{
        return .white
    }
    static var purchaseButtonCornerRadius: CGFloat{
        return loadButtonCornerRadius
    }
    static var purchaseButtonFontSize: CGFloat{
        return UI.loadButtonFontSize
    }
    //MARK: - restore button
    static var restoreButtonColor: UIColor{
        return .white
    }
    static var restoreButtonCornerRadius: CGFloat{
        return loadButtonCornerRadius
    }
    static var restoreButtonFontSize: CGFloat{
        return UI.loadButtonFontSize
    }
    //MARK: - option menu
    static var optionMenuSpacing: CGFloat{
        return UI.gridSize/12
    }
    static var optionMenuCornerRadius: CGFloat{
        return UI.gridSize/12
    }
    //MARK: - language option
    static var languageOptionFontSize: CGFloat{
        return UI.loadButtonFontSize
    }
    static var languageOptionFontColor: UIColor{
        return .black
    }
    static var languageOptionSpacing: CGFloat{
        return 7*languageOptionFontSize
    }
    static var languageOptionButtonSize: CGSize{
        return CGSize(width: languageOptionFontSize/2, height: languageOptionFontSize)
    }
    //MARK: - closeButton in option menu
    static var closeButtonFrame: CGRect{
        
        let scale = UIScreen.main.scale
        let viewH = rootSize.height/scale
        let viewW = rootSize.width/scale
        let gridSize = UI.gridSize/scale
        let spacing = gridSize/24
        let y = viewH/2 - gridSize/2 + spacing
        let w = gridSize/10
        let h = gridSize/10
        let x = viewW/2 - gridSize/2 + spacing
        return CGRect(x: x, y: y, width: w, height: h)
    }
    //MARK: - confirmButton in option menu
    static var confirmButtonFrame: CGRect{
        
        let scale = UIScreen.main.scale
        let viewH = rootSize.height/scale
        let viewW = rootSize.width/scale
        let gridSize = UI.gridSize/scale
        let spacing = gridSize/24
        let y = viewH/2 - gridSize/2 + spacing
        let w = gridSize/10
        let h = gridSize/10
        let x = viewW/2 + gridSize/2 - w - spacing
        return CGRect(x: x, y: y, width: w, height: h)
    }
    //MARK: - loading view controller
    static let loadingVC = LoadingViewController()
    //MARK: - fontSize
    static var fontSize = (
        difficultySelector: levelLabelFontSize*3/4,
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
        backFromUndo: backFromUndoPosition,
        loadButton: loadButtonPosition
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
        abilityMenu:              CGFloat(2),
        abilityMenuItem:          CGFloat(3),
        //MARK: result in GameScene
        resultBackground:         CGFloat(6),
        shareButton:              CGFloat(7),
        shareHint:                CGFloat(140),
        screenshot:               CGFloat(120),
        challengeFlipLabel:       CGFloat(9.5),
        challengeLabel:           CGFloat(9),
        flashlight:               CGFloat(150),
        //MARK: in TitleScene
        loadButton:               CGFloat(0),
        backgroundGrid:           CGFloat(9),
        backgroundGridBackground: CGFloat(8),
        logo:                     CGFloat(10),
        guideBackground:          CGFloat(1000),
        guideLight:               CGFloat(1),//1001 globally
        guideLabel:               CGFloat(1),//1001 globally
        //MARK: in levelSelectScene
        levelSelector:            CGFloat(1000),
        difficultySelector:       CGFloat(1000),
        //MARK: In modeSelectScene
        modeSelector:             CGFloat(1000),
        //MARK: In option menu
        purchaseButton:          CGFloat(1),
        restoreButton:            CGFloat(1),
        purchasedButton:          CGFloat(1)
    )
    //MARK: - String
    struct Texts {
        //MARK: in Challenge.swift
        static var win: String{return "win".localized()}
        static var getPoints: String{return "getPoints".localized()}
        static var winTheComputerByPoints: String{return "winTheComputerByPoints".localized()}
        //MARK: in GameScene.swift
        static var backToTitle: String{return "back to title".localized()}
        static var undo: String{return "undo".localized()}
        static var retry: String{return "retry".localized()}
        static var help: String{return "help".localized()}
        static var option: String{return "option".localized()}
        static var state: String{return "state".localized()}
        static var resign: String{return "resign".localized()}
        static var back: String{return "back".localized()}
        static var share: String{return "share".localized()}
        struct guide {
            static var help: String{return "guide.help".localized()}
            struct logo {
                static var default_: String{return "guide.logo.default".localized()}
                static var destructive: String{return "guide.logo.destructive".localized()}
            }
            static func guide(_ guideKey: TitleScene.guideKey) -> String{
                return guideKey.rawValue.localized()
            }
        }
        struct message {
            struct help {
                static var title: String{return "message.help.title".localized()}
                static var default_: String{return "message.help.default".localized()}
                static var destructive: String{return "message.help.destructive".localized()}
            }
            struct undo {
                static var text: String{return "message.undo.text".localized()}
                static var title: String{return "message.undo.title".localized()}
                static var destructive: String{return "message.undo.destructive".localized()}
                static var destructiveWithoutAds: String{return "message.undo.destructive.withoutAds".localized()}
                static var default_: String{return "message.undo.default".localized()}
            }
            struct retry {
                static var text: String{return "message.retry.text".localized()}
                static var title: String{return "message.retry.title".localized()}
                static var default_: String{return "message.retry.default".localized()}
                static var destructive: String{return "message.retry.destructive".localized()}
            }
            struct earnFlips {
                static var text: String{return "message.earnFlips.text".localized()}
                static var title: String{return "message.earnFlips.title".localized()}
                static var default_: String{return "message.earnFlips.default".localized()}
                static var destructive: String{return "message.earnFlips.destructive".localized()}
            }
        }
        //MARK: in LevelSelectScene.swift
        static func level(_ level: Int) -> String{
            return "LEVEL\(level+1)".localized()
        }
        //MARK: in ModeSelectScene.swift
        static var online: String{return "ONLINE".localized()}
        static var offline: String{return "OFFLINE".localized()}
        static var offlineParty: String{return "OFFLINEPARTY".localized()}
        static var onlineParty: String{return "ONLINEPARTY".localized()}
        //MARK: in TitleScene.swift
        static var loadGame: String{return "loadGame".localized()}
        static var loading: String{return "Loading...".localized()}
        struct loadAlert{
            static var title: String{return "noGameToLoad.title".localized()}
            static var text: String{return "noGameToLoad.text".localized()}
            static var defaultAction: String{return "noGameToLoad.defaultAction".localized()}
        }
        //MARK: in purchaseButtons.swift
        static var purchase: String{return "purchase".localized()}
        static var restore: String{return "restore".localized()}
        static var purchased: String{return "purchased".localized()}
    }
}
