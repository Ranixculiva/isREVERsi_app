//
//  TitleScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class TitleScene: SKScene {
    deinit {
        print("TitleScene deinit")
    }
    ////m
    fileprivate var guideGesture = GestureGuide(color: UI.gestureGuideStrokeColor)
    ////m
    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
    fileprivate var helpNode = SKSpriteNode()
    fileprivate var helpHint = HintBubble()
    fileprivate var optionNode = SKSpriteNode()
    fileprivate var optionHint = HintBubble()
    fileprivate var backgroundGrids: [Grid] = []
    fileprivate var backgroundGridBackgrounds: [SKSpriteNode] = []
    fileprivate let logo = SKCropNode()
    fileprivate let logoRightBlack = SKSpriteNode(color: .black, size: CGSize())
    fileprivate let logoLeftWhite = SKSpriteNode(color: .white, size: CGSize())
    //MARK: - parameters for logo switch
    fileprivate var currentWhiteSwitchPosition = CGPoint.zero
    fileprivate var switchTouchCycle = 1
    //MARK: - parameters for touches
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var touchDownOnWhere: SKNode? = nil
    fileprivate var firstGridOrigin = CGPoint.zero
    fileprivate var everMoved = false
    fileprivate var loadingPhase = SKSpriteNode()
    
    enum gameSize : Int{
        case four = 4, six = 6, eight = 8
    }
    var currentGameSize = gameSize.six
    
    enum mode: Int{
        case black = 0, two, white
    }
    var currentMode = mode.two
    enum guideKey: String, CaseIterable{
        case welcome = "guide.welcome"
        case hint = "guide.hint"
        case help = "guide.help"
        case logo = "guide.logo"
        case gameboardSwipe = "guide.gameboard.swipe"
        case gameboardTap = "guide.gameboard.tap"
    }
    var currentGuide = guideKey.welcome
    fileprivate func touchUpOnBackgroundGrids(){
        var scene = SKScene()
        switch currentMode {
        case .black:
            scene = LevelSelectScene()
            let scene = scene as! LevelSelectScene
            scene.isComputerWhite = true
            scene.gameSize = currentGameSize.rawValue
        case .white:
            scene = LevelSelectScene()
            let scene = scene as! LevelSelectScene
            scene.isComputerWhite = false
            scene.gameSize = currentGameSize.rawValue
        case .two:
            scene = ModeSelectScene()
            let scene = scene as! ModeSelectScene
            scene.gameSize = currentGameSize.rawValue
        }
        scene.scaleMode = .aspectFill
        guard let view = view else{return}
        view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    ////m
    fileprivate var helpMessage: MessageBox!
    fileprivate var doesClickOnHelpMessageDefaultButton = true
    ////m
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        ////m
        //set up guide gesture
        addChild(guideGesture)
        guideGesture.position.y = (-UI.gridSize/2 + UI.menuIconSize.height/2 + UI.getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 1).y)/2
        guideGesture.zPosition = UI.zPosition.gestureGuide
        guideGesture.isHidden = true
        
        
        
        //set up background
        UIGraphicsBeginImageContext(size)
        let bgCtx = UIGraphicsGetCurrentContext()
        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bgStartColor = UIColor(red: 122/255, green: 198/255, blue: 239/255, alpha: 1)
        
        let bgMidColor = UIColor(red: 222/510, green: 348/510, blue: 499/510, alpha: 1)
        
        let bgEndColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
        
        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
        
        let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
        
        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
        bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        background.zPosition = UI.zPosition.background
        addChild(background)
        ///test gestureGuide
        //        let gestureGuide = GestureGuide(color: UI.gestureGuideStrokeColor)
        //        gestureGuide.zPosition = UI.zPosition.gestureGuide
        //        addChild(gestureGuide)
        //        gestureGuide.position.y = -size.height*3/8
        //        gestureGuide.holdGuide(afterDelay: 0.6, downForDuration: 0.6, holdForDuration: 1.2)
        ///test scrollText
        //        let scrollText = NSLocalizedString(guideKey.help.rawValue, comment: "")
        //        let scrollTextBox = ScrollTextBox(text: "")
        //        scrollTextBox.zPosition = UI.zPosition.messageBox
        //        scrollTextBox.anchorPoint.y = 0.25
        //        scrollTextBox.anchorPoint.x = 0.25
        //        scrollTextBox.position = CGPoint(x: 25, y: 75)
        //        scrollTextBox.text = scrollText
        //        addChild(scrollTextBox)
        ///test messageBox
        //        let actions = [
        //            MessageAction(title: "Thanks!", style: .default, handler: {print("Thanks!")}),
        //            MessageAction(title: "Shut up!", style: .destructive, handler: {print("Shut up!")}),
        //            MessageAction(title: "Give up!", style: .destructive, handler: {print("Give up!")}),
        //        ]
        //        let messageBox = MessageBox(title: "scrollText", text: scrollText + scrollText, actions: actions)
        //        messageBox.title = "T==T Help me"
        //        messageBox.zPosition = UI.zPosition.messageBox
        //        addChild(messageBox)
        ////m
        
        
        
        
        
        
        //MARK: - set to default for guide. This should place in the first place of didMove.
        //SharedVariable.load()
        //Challenge.loadSharedChallenge()
        if SharedVariable.needToGuide{
            ////m
            guideGesture.isHidden = false
            self.guideGesture.isPaused = false
            guideGesture.tapGuide()
            ////m
            currentGuide = .welcome
            currentGameSize = .six
            currentMode = .two
            switchTouchCycle = 1
        }
        //MARK: - set up flipsIndicator
        flipsIndicator.position = UI.flipsPosition
        flipsIndicator.zPosition = UI.zPosition.flipsIndicator
        flipsIndicator.flips = SharedVariable.flips
        addChild(flipsIndicator)
        //MARK: - set up helpNode
        helpNode = SKSpriteNode(imageNamed: "help")
        helpNode.size = UI.menuIconSize
        helpNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 4)
        helpNode.zPosition = UI.zPosition.menuIcon
        addChild(helpNode)
        //MARK: set up helpHint
        let boundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        helpHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: boundsOfHintBubble)!
        helpHint.attachTo = (helpNode as (SKNode & attachable))
        helpHint.text = "help".localized()
        helpHint.isHidden = true
        helpHint.fontSize = UI.menuIconHintLabelFontSize
        addChild(helpHint)
        //MARK: - set up optionNode
        optionNode = SKSpriteNode(imageNamed: "option")
        optionNode.size = UI.menuIconSize
        optionNode.position = UI.getMenuIconPosition(indexFromLeft: 2, numberOfMenuIcon: 4)
        optionNode.zPosition = UI.zPosition.menuIcon
        addChild(optionNode)
        //MARK: set up optionHint
        let boundsOfOptionBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        optionHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: boundsOfOptionBubble)!
        optionHint.attachTo = (optionNode as (SKNode & attachable))
        optionHint.text = "option".localized()
        optionHint.isHidden = true
        optionHint.fontSize = UI.menuIconHintLabelFontSize
        addChild(optionHint)
        //MARK: - set up backgroundGrid
        
        let gridColor = SKColor(red: 132/255*0.6, green: 195/255*0.6, blue: 77/255*0.6, alpha: 1)
        for i in 0...2{
            let blockSize = UI.gridSize / CGFloat(2 * i + 4)
            let backgroundGrid = Grid.init(color: gridColor, blockSize: blockSize, rows: 2 * i + 4, cols: 2 * i + 4, lineWidth: blockSize / 20)!
            backgroundGrid.zPosition = UI.zPosition.backgroundGrid
            backgroundGrid.position.x = size.width * CGFloat(i - currentGameSize.rawValue/2 + 2)
            addChild(backgroundGrid)
            backgroundGrids.append(backgroundGrid)
            //MARK: set up background of backgroundGrid
            let backgroundGridBackgroundColor = SKColor(red: 132/255, green: 195/255, blue: 77/255, alpha: 1)
            let backgroundGridBackground = SKSpriteNode(color: backgroundGridBackgroundColor, size: CGSize(width: UI.gridSize, height: UI.gridSize))
            backgroundGridBackground.zPosition = UI.zPosition.backgroundGridBackground
            backgroundGridBackground.position.x = size.width * CGFloat(i)
            addChild(backgroundGridBackground)
            backgroundGridBackgrounds.append(backgroundGridBackground)
        }
        
        //MARK: - set up logo
        guard let logoImage = UIImage(named: "Logo") else{fatalError("cannot find image Logo")}
        let logoSize = UI.logoSize
        logo.maskNode = SKSpriteNode(texture: SKTexture(image: logoImage), size: logoSize)
        logo.position = UI.logoPosition
        logo.zPosition = UI.zPosition.logo
        
        addChild(logo)
        //MARK: set up left-half white
        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentMode.rawValue), height: logoSize.height)
        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
        logo.addChild(logoLeftWhite)
        //MARK: set up right-half black
        logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
        logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
        logo.addChild(logoRightBlack)
        
        //MARK: set up loadingPhase
        loadingPhase = SKSpriteNode(color: UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1), size: size)
        let loadingText = SKLabelNode(text: "Loading...".localized())
        loadingText.fontName = UI.loadingTextFontName
        loadingText.fontSize = UI.fontSize.loadingPhase
        loadingPhase.addChild(loadingText)
        loadingPhase.zPosition = UI.zPosition.loadingPahse
        addChild(loadingPhase)
        loadAllGuideTexts()
        
    }
    ////m
    fileprivate var originalGuideGestureShouldHide = false
    fileprivate var originalGuideGestureIsPaused = false
    ////m
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        ////m
        originalGuideGestureShouldHide = SharedVariable.needToGuide ? false:true
        originalGuideGestureIsPaused = guideGesture.isPaused
        guideGesture.isHidden = true
        guideGesture.isPaused = true
        
        ////m
        ////m
//        else if currentGuide == .help{
//            removeGuide(nodesToRecover: [], key: .help)
//            if SharedVariable.needToGuide{
//                currentGuide = .logo
//                let lightRegionOfLogo = CGRect(origin: CGPoint(x: logo.frame.minX, y: logo.frame.minY), size: logo.frame.size)
//                guideLitByEllipse(nodesToLight: [logo], lightRegion: lightRegionOfLogo, key: .logo)
//            }
//        }
        ////m
        
        let pos = touch.location(in: self)
        touchOrigin = pos
        let node = atPoint(touch.location(in: self))
        touchDownOnWhere = node
        firstGridOrigin = backgroundGrids.first!.position
        currentWhiteSwitchPosition = logoLeftWhite.position
        switch node{
        case helpNode:
            helpHint.isHidden = false
        case optionNode:
            optionHint.isHidden = false
        default:
            break
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        let node = atPoint(pos)
        //MARK: when move on hints
        helpHint.isHidden = true
        optionHint.isHidden = true
        switch node {
        case helpNode:
            helpHint.isHidden = false
        case optionNode:
            optionHint.isHidden = false
        default:
            break
        }
        
        let offset = pos.x - touchOrigin.x
        if abs(offset) > 10 {everMoved = true}
        if let touchDownOnWhere = touchDownOnWhere{
            //MARK: move on logo
            if touchDownOnWhere == logoLeftWhite || touchDownOnWhere == logoRightBlack{
                
                logoLeftWhite.position.x = currentWhiteSwitchPosition.x + offset/2
                logoLeftWhite.position.x = min(max(logoLeftWhite.position.x,-logo.frame.width/2),0)
                logoLeftWhite.size.width = (logoLeftWhite.position.x + logo.frame.width/2)*2
                logoRightBlack.position.x = logoLeftWhite.position.x + logo.frame.width/2
                logoRightBlack.size.width = logo.frame.width - logoLeftWhite.size.width
                
            }
        }
    }
    fileprivate func help(){
        if currentGuide == .hint{
            removeGuide(nodesToRecover: [helpNode, helpHint], key: .hint)
            ////m
            guideGesture.isHidden = true
            guideGesture.isPaused = true
            originalGuideGestureShouldHide = true
            originalGuideGestureIsPaused = guideGesture.isPaused
            ////m
        }
        currentGuide = .help
        //guide(textPosition: CGPoint.zero, key: .help)
        ////m
        helpMessage.isHidden = false
        ////m
    }
    fileprivate func option(){
        currentGuide = .welcome
        currentGameSize = .six
        currentMode = .two
        switchTouchCycle = 1
        let logoSize = UI.logoSize
        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentMode.rawValue), height: logoSize.height)
        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
        logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
        logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
        for i in 0...backgroundGrids.count - 1{
            backgroundGrids[i].position.x = size.width * CGFloat(i - currentGameSize.rawValue/2 + 2)
            backgroundGridBackgrounds[i].position.x = size.width * CGFloat(i)
        }
        
        SharedVariable.needToGuide = true
        guide(textPosition: CGPoint.zero, key: .welcome)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        let node = atPoint(pos)
        //MARK: remove welcome guide and add help guide
        
        if currentGuide == .welcome, SharedVariable.needToGuide{
            removeGuide(nodesToRecover: [], key: .welcome)
            ////m
            guideGesture.holdGuide()
            guideGesture.isHidden = false
            guideGesture.isPaused = false
            guideGesture.position = helpNode.position
            ////m
            currentGuide = .hint
            let hintGuideLightRegion = CGRect(origin: helpNode.position - CGPoint(x: helpNode.frame.width/2, y: helpNode.frame.height/2), size: helpNode.size)
            guideLitByEllipse(nodesToLight: [helpNode, helpHint], lightRegion: hintGuideLightRegion, key: .hint)
            return
        }
        //MARK: touch up on hints
        helpHint.isHidden = true
        optionHint.isHidden = true
        switch node{
        case helpNode:
            help()
        case optionNode:
            option()
        default:
            break
        }
        if let touchDownOnWhere = touchDownOnWhere{
            //MARK: - touch up on backgroundGrids
            if (backgroundGrids as [SKNode]).contains(touchDownOnWhere){
                let offset = pos.x - touchOrigin.x
                var shouldAddOffset = true
                if (currentGameSize == .four && offset > 0) || (currentGameSize == .eight && offset < 0){shouldAddOffset = false}
                var currentGameSizeIndex = (currentGameSize.rawValue - 4)/2
                if abs(offset) > 100{
                    if shouldAddOffset{
                        let sign = offset > 0 ? -1 : 1
                        currentGameSizeIndex += sign
                        currentGameSizeIndex = min(max(currentGameSizeIndex,0),2)
                        currentGameSize = gameSize.init(rawValue: currentGameSizeIndex * 2 + 4)!
                    }
                    
                }
                    //MARK: touch up on backgroundGrids
                else if abs(offset) < 10, !everMoved{
                    if SharedVariable.needToGuide, currentGuide == .gameboardTap{
                        var nodesToRecover: [SKNode] = backgroundGrids
                        nodesToRecover.append(contentsOf: backgroundGridBackgrounds)
                        removeGuide(nodesToRecover: nodesToRecover, key: .gameboardTap)
                    }
                    if !SharedVariable.needToGuide || currentGuide == .gameboardTap {touchUpOnBackgroundGrids()}
                }
                // MARK: show the current size of the gameboard.
                for i in 0...2{
                    backgroundGrids[i].position.x = size.width * CGFloat(i - currentGameSizeIndex)
                    backgroundGridBackgrounds[i].position.x = size.width * CGFloat(i - currentGameSizeIndex)
                }
                //MARK: remove the guide of the gameboard.
                if SharedVariable.needToGuide, currentGuide == .gameboardSwipe,currentGameSize == .four{
                    ////m
                    self.guideGesture.isHidden = false
                    self.guideGesture.isPaused = false
                    self.guideGesture.position = CGPoint.zero
                    self.guideGesture.tapGuide()
                    ////m
                    var nodesToRecover: [SKNode] = backgroundGrids
                    nodesToRecover.append(contentsOf: backgroundGridBackgrounds)
                    removeGuide(nodesToRecover: nodesToRecover, key: .gameboardSwipe)
                    currentGuide = .gameboardTap
                    let lightRegion = CGRect(x: -UI.gridSize/2, y: -UI.gridSize/2, width: UI.gridSize, height: UI.gridSize)
                    guideLitByRoundedRectangle(nodesToLight: nodesToRecover, lightRegion: lightRegion, cornerRadius: 5*UIScreen.main.scale, key: .gameboardTap)
                    SharedVariable.needToGuide = false
                }
            }
                //MARK: - touch up on logo
            else if touchDownOnWhere == logoRightBlack || touchDownOnWhere == logoLeftWhite{
                let offset = pos.x - touchOrigin.x
                var state = floor(2 * logoLeftWhite.size.width / logo.frame.width + 0.5)
                if abs(offset) < 10, !everMoved{
                    switch state{
                    case 0:
                        state = 1
                        switchTouchCycle = 1
                    case 1:
                        state = CGFloat(2 * switchTouchCycle)
                        switchTouchCycle = 1 - switchTouchCycle
                    case 2:
                        state = 1
                        switchTouchCycle = 0
                    default:
                        break
                    }
                }
                currentMode = mode.init(rawValue: Int(state))!
                logoLeftWhite.size.width = state * logo.frame.width/2
                logoLeftWhite.position.x = -logo.frame.width / 2 + logoLeftWhite.size.width/2
                logoRightBlack.position.x = logoLeftWhite.position.x + logo.frame.width/2
                logoRightBlack.size.width = logo.frame.width - logoLeftWhite.size.width
                //MARK: guide to logo
                if SharedVariable.needToGuide, currentGuide == .logo, (currentMode == .white && doesClickOnHelpMessageDefaultButton) || (currentMode == .black && !doesClickOnHelpMessageDefaultButton){
                    ////m
                    self.guideGesture.isHidden = false
                    self.guideGesture.isPaused = false
                    self.guideGesture.position = CGPoint.zero
                    let swipeGuideVector = CGVector(dx: UI.gridSize/2, dy: 0)
                    self.guideGesture.swipeGuide(by: swipeGuideVector)
                    ////m
                    removeGuide(nodesToRecover: [logo], key: guideKey.logo)
                    currentGuide = .gameboardSwipe
                    var nodesToLight: [SKNode] = backgroundGrids
                    nodesToLight.append(contentsOf: backgroundGridBackgrounds)
                    let lightRegion = CGRect(x: -UI.gridSize/2, y: -UI.gridSize/2, width: UI.gridSize, height: UI.gridSize)
                    guideLitByRoundedRectangle(nodesToLight: nodesToLight, lightRegion: lightRegion, cornerRadius: 5*UIScreen.main.scale, key: .gameboardSwipe)
                }
            }
        }
        everMoved = false
        ////m
        guideGesture.isHidden = originalGuideGestureShouldHide
        guideGesture.isPaused = originalGuideGestureIsPaused
        ////m
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    fileprivate func loadAllGuideTexts(){
        self.isUserInteractionEnabled = false
        let serialQueue = DispatchQueue(label: "com.Ranixculiva.isREVERsi", qos: DispatchQoS.userInteractive)
        let gridSize = UI.gridSize
        let fontSize = UI.guideFontSize
        
        serialQueue.async {
            for aGuideKey in guideKey.allCases{
                if aGuideKey == .logo{
                    let logoText1 = (guideKey.logo.rawValue+".default").localized()
                    let label1 = SKMultilineLabel(text: logoText1, labelWidth: gridSize)
                    label1.fontName = UI.guideFontName
                    label1.fontColor = UI.guideFontColor
                    label1.fontSize = fontSize
                    label1.zPosition = UI.zPosition.guideLabel
                    label1.alignment = .center
                    label1.anchorPoint = CGPoint(x: 0.5,y: 0.5)
                    label1.position = CGPoint.zero
                    label1.name = aGuideKey.rawValue + ".default" + ".label"
                    label1.isHidden = true
                    self.addChild(label1)
                    
                    let logoText2 = (guideKey.logo.rawValue+".destructive").localized()
                    let label2 = SKMultilineLabel(text: logoText2, labelWidth: gridSize)
                    label2.fontName = UI.guideFontName
                    label2.fontColor = UI.guideFontColor
                    label2.fontSize = fontSize
                    label2.zPosition = UI.zPosition.guideLabel
                    label2.alignment = .center
                    label2.anchorPoint = CGPoint(x: 0.5,y: 0.5)
                    label2.position = CGPoint.zero
                    label2.name = aGuideKey.rawValue + ".destructive" + ".label"
                    label2.isHidden = true
                    self.addChild(label2)
                    continue
                }
                if aGuideKey == .help {
                    //set up messageBox
                    let helpGuideText = guideKey.help.rawValue.localized()
                    let helpGuideTitle = "message.help.title".localized()
                    let helpMessageActionsTitle = [
                        "message.help.default".localized(),
                        "message.help.destructive".localized()
                    ]
                    let switchGuideFromHelpToLogo: () -> Void = {[unowned self] in
                        if self.currentGuide == .help, SharedVariable.needToGuide{
                            
                            self.guideGesture.isHidden = false
                            self.guideGesture.isPaused = false
                            self.guideGesture.position = self.logo.position
                            let swipeGuideVector = CGVector(dx: (self.doesClickOnHelpMessageDefaultButton ? 1:-1)*self.logo.frame.width/2, dy: 0)
                            self.guideGesture.swipeGuide(by: swipeGuideVector)
                            
                            self.removeGuide(nodesToRecover: [], key: .help)
                            if SharedVariable.needToGuide{
                                self.currentGuide = .logo
                                let lightRegionOfLogo = CGRect(origin: CGPoint(x: self.logo.frame.minX, y: self.logo.frame.minY), size: self.logo.frame.size)
                                //not com
                                self.guideLitByEllipse(nodesToLight: [self.logo], lightRegion: lightRegionOfLogo, key: .logo)
                            }
                        }
                    }
                    
                    let thanksHandler: () -> Void = {[unowned self] in
                        self.doesClickOnHelpMessageDefaultButton = true
                        switchGuideFromHelpToLogo()
                        
                    }
                    let shutUpHandler: () -> Void = {[unowned self] in
                        self.doesClickOnHelpMessageDefaultButton = false
                        switchGuideFromHelpToLogo()
                    }
                    let helpMessageActions = [
                        MessageAction(title: helpMessageActionsTitle[0], style: .default, handler: thanksHandler),
                        MessageAction(title: helpMessageActionsTitle[1], style: .destructive, handler: shutUpHandler),
                        ]
                    self.helpMessage = MessageBox(title: helpGuideTitle, text: helpGuideText, actions: helpMessageActions)
                    self.addChild(self.helpMessage)
                    self.helpMessage.isHidden = true
                    continue
                    
                }
                let text = aGuideKey.rawValue.localized()
                let label = SKMultilineLabel(text: text, labelWidth: gridSize)
                label.fontName = UI.guideFontName
                label.fontColor = UI.guideFontColor
                label.fontSize = fontSize
                label.zPosition = UI.zPosition.guideLabel
                label.alignment = .center
                label.anchorPoint = CGPoint(x: 0.5,y: 0.5)
                label.position = CGPoint.zero
                label.name = aGuideKey.rawValue + ".label"
                label.isHidden = true
                self.addChild(label)
            }
            DispatchQueue.main.async{
                self.removeChildren(in: [self.loadingPhase])
                if SharedVariable.needToGuide{
                    self.guide(textPosition: CGPoint.zero, key: .welcome)
                }
                self.isUserInteractionEnabled = true
            }
        }
    }
    fileprivate func guide(textPosition: CGPoint, key: guideKey){
        let backgroundColor = UI.guideBackgroundColor
        let background = SKSpriteNode(color: backgroundColor, size: size)
        background.name = key.rawValue
        background.zPosition = UI.zPosition.guideBackground
        addChild(background)
        
        //        let label = SKMultilineLabel(text: text, labelWidth: UI.gridSize)
        //        label.fontName = UI.guideFontName
        //        label.fontColor = UI.guideFontColor
        //        label.fontSize = UI.guideFontSize
        //        label.zPosition = UI.zPosition.guideLabel
        //        label.alignment = .center
        //        label.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        //        label.position = textPosition
        if key == .help{
            return
        }
        else if key == .logo{
            let withName = doesClickOnHelpMessageDefaultButton ? key.rawValue+".default"+".label" : key.rawValue+".destructive"+".label"
            guard let label = childNode(withName: withName) as? SKMultilineLabel else {return}
            label.position = textPosition
            label.isHidden = false
            label.removeFromParent()
            background.addChild(label)
            return
        }
        guard let label = childNode(withName: key.rawValue + ".label") as? SKMultilineLabel else {return}
        label.position = textPosition
        label.isHidden = false
        label.removeFromParent()
        background.addChild(label)
    }
    fileprivate func guideLitByRoundedRectangle(nodesToLight: [SKNode], lightRegion: CGRect, cornerRadius: CGFloat,key: guideKey){
        if nodesToLight.isEmpty{fatalError("empty nodeToLights")}
        removeChildren(in: nodesToLight)
        let backgroundColor = UI.guideBackgroundColor
        let background = SKSpriteNode(color: backgroundColor, size: size)
        background.name = key.rawValue
        background.zPosition = UI.zPosition.guideBackground
        addChild(background)
        
        
        let lightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        let lightWidth = lightRegion.width + 2*cornerRadius
        let lightHeight = lightRegion.height + 2*cornerRadius
        let lightSize = CGSize(width: lightWidth, height: lightHeight)
        //MARK: draw light
        UIGraphicsBeginImageContext(lightSize)
        let context = UIGraphicsGetCurrentContext()
        let lightBounds = CGRect(origin: CGPoint.zero, size: lightSize)
        let lightShape = UIBezierPath(roundedRect: lightBounds, cornerRadius: cornerRadius)
        context?.addPath(lightShape.cgPath)
        lightColor.setFill()
        context?.fillPath()
        let lightImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let light = SKSpriteNode(texture: SKTexture(image: lightImage), size: lightSize)
        light.position.x = lightRegion.midX
        light.position.y = lightRegion.midY
        light.zPosition = UI.zPosition.guideLight
        background.addChild(light)
        
        for nodeToLight in nodesToLight{
            background.addChild(nodeToLight)
        }
        var withName = key.rawValue + ".label"
        if key == .logo{
            withName = doesClickOnHelpMessageDefaultButton ? key.rawValue+".default"+".label" : key.rawValue+".destructive"+".label"
        }
        guard let label = childNode(withName: withName) as? SKMultilineLabel else {return}
        //        let label = SKMultilineLabel(text: text, labelWidth: UI.gridSize)
        //        label.fontName = UI.guideFontName
        //        label.fontColor = UI.guideFontColor
        //        label.fontSize = UI.guideFontSize
        //        label.zPosition = UI.zPosition.guideLabel
        //        label.alignment = .center
        if lightRegion.midY >= 0{
            label.anchorPoint.y = 1
            label.position.y = light.frame.minY - 40 * UIScreen.main.scale
        }
        else if lightRegion.midY < 0{
            label.anchorPoint.y = 0
            label.position.y = light.frame.maxY + 40 * UIScreen.main.scale
        }
        label.isHidden = false
        label.removeFromParent()
        background.addChild(label)
    }
    fileprivate func guideLitByEllipse(nodesToLight: [SKNode], lightRegion: CGRect, key: guideKey){
        removeChildren(in: nodesToLight)
        let backgroundColor = UI.guideBackgroundColor
        let background = SKSpriteNode(color: backgroundColor, size: size)
        background.name = key.rawValue
        background.zPosition = UI.zPosition.guideBackground
        addChild(background)
        for nodeToLight in nodesToLight{
            background.addChild(nodeToLight)
        }
        
        let lightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        let ellipseLightWidth = lightRegion.width * 1.4
        let ellipseLightHeight = lightRegion.height / sqrt(1 - lightRegion.width * lightRegion.width / (ellipseLightWidth * ellipseLightWidth))
        let ellipseLightSize = CGSize(width: ellipseLightWidth, height: ellipseLightHeight)
        //MARK: draw ellipseLight
        UIGraphicsBeginImageContext(ellipseLightSize)
        let context = UIGraphicsGetCurrentContext()
        let ellipseLightBounds = CGRect(origin: CGPoint.zero, size: ellipseLightSize)
        lightColor.setFill()
        context?.fillEllipse(in: ellipseLightBounds)
        let ellipseLightImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let ellipseLight = SKSpriteNode(texture: SKTexture(image: ellipseLightImage), size: ellipseLightSize)
        ellipseLight.position = CGPoint(x: lightRegion.midX, y: lightRegion.midY)
        ellipseLight.zPosition = UI.zPosition.guideLight
        background.addChild(ellipseLight)
        
        var withName = key.rawValue + ".label"
        if key == .logo{
            withName = doesClickOnHelpMessageDefaultButton ? key.rawValue+".default"+".label" : key.rawValue+".destructive"+".label"
        }
        guard let label = childNode(withName: withName) as? SKMultilineLabel else {return}
        //let label = SKMultilineLabel(text: text, labelWidth: UI.gridSize)
        label.fontName = UI.guideFontName
        label.fontColor = UI.guideFontColor
        label.fontSize = UI.guideFontSize
        label.zPosition = UI.zPosition.guideLabel
        label.alignment = .center
        if lightRegion.midY >= 0{
            label.anchorPoint.y = 1
            label.position.y = ellipseLight.frame.minY - 40 * UIScreen.main.scale
        }
        else if lightRegion.midY < 0{
            label.anchorPoint.y = 0
            label.position.y = ellipseLight.frame.maxY + 40 * UIScreen.main.scale
        }
        label.isHidden = false
        label.removeFromParent()
        background.addChild(label)
        
    }
    fileprivate func removeGuide(nodesToRecover: [SKNode], key: guideKey){
        guard let background = childNode(withName: key.rawValue) else {return}
        var withName = key.rawValue + ".label"
        if key == .logo{
            withName = doesClickOnHelpMessageDefaultButton ? key.rawValue+".default"+".label" : key.rawValue+".destructive"+".label"
        }
        guard let aGuideText = background.childNode(withName: withName) as? SKMultilineLabel else {return}
        aGuideText.removeFromParent()
        aGuideText.isHidden = true
        addChild(aGuideText)
        
        removeChildren(in: [background])
        for nodeToRecover in nodesToRecover{
            nodeToRecover.removeFromParent()
            addChild(nodeToRecover)
        }
        originalGuideGestureShouldHide = true
        return
    }
}
