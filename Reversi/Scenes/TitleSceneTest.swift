////
////  TitleScene.swift
////  Reversi
////
////  Created by john gospai on 2019/2/13.
////  Copyright © 2019 john gospai. All rights reserved.
////
//import GoogleMobileAds
//import SpriteKit
//class TitleScene: SKScene, optionMenuDelegate{
//    @objc func didTapOnButton(type: OptionMenuVC.type) {
//        switch type {
//        case .confirm:
//            reloadScene()
//        default:
//            break
//        }
//    }
//    deinit {
//        print("TitleScene deinit")
//    }
//    fileprivate var optionMenu: OptionMenu!
//    ////m
//    fileprivate var guideGesture = GestureGuide(color: UI.gestureGuideStrokeColor)
//    ////m
//    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
//    fileprivate var loadButton = Button()
//    fileprivate var helpNode = SKSpriteNode()
//    fileprivate var helpHint: HintBubble!
//    fileprivate var optionNode = SKSpriteNode()
//    fileprivate var optionHint: HintBubble!
//    fileprivate var backgroundGrids: [Grid] = []
//    fileprivate var backgroundGridBackgrounds: [SKSpriteNode] = []
//    fileprivate let logo = SKCropNode()
//    fileprivate let logoRightBlack = SKSpriteNode(color: .black, size: CGSize())
//    fileprivate let logoLeftWhite = SKSpriteNode(color: .white, size: CGSize())
//    //MARK: - parameters for logo switch
//    fileprivate var currentWhiteSwitchPosition = CGPoint.zero
//    fileprivate var switchTouchCycle = 1
//    //MARK: - parameters for touches
//    fileprivate var touchOrigin = CGPoint.zero
//    fileprivate weak var touchDownOnWhere: SKNode? = nil
//    fileprivate var firstGridOrigin = CGPoint.zero
//    fileprivate var everMoved = false
//    
//    enum gameSize : Int{
//        case four = 4, six = 6, eight = 8
//    }
//    var currentGameSize = gameSize.six
//    
//    enum mode: Int{
//        case black = 0, two, white
//    }
//    var currentMode = mode.two
//    enum guideKey: String, CaseIterable{
//        case welcome = "guide.welcome"
//        case hint = "guide.hint"
//        case help = "guide.help"
//        case logo = "guide.logo"
//        case gameboardSwipe = "guide.gameboard.swipe"
//        case gameboardTap = "guide.gameboard.tap"
//    }
//    var currentGuide = guideKey.welcome
//    fileprivate func touchUpOnBackgroundGrids(){
//        var scene = SKScene()
//        switch currentMode {
//        case .black:
//            scene = LevelSelectScene()
//            let scene = scene as! LevelSelectScene
//            scene.isComputerWhite = true
//            scene.gameSize = currentGameSize.rawValue
//        case .white:
//            scene = LevelSelectScene()
//            let scene = scene as! LevelSelectScene
//            scene.isComputerWhite = false
//            scene.gameSize = currentGameSize.rawValue
//        case .two:
//            scene = ModeSelectScene()
//            let scene = scene as! ModeSelectScene
//            scene.gameSize = currentGameSize.rawValue
//        }
//        scene.scaleMode = .aspectFill
//        guard let view = view else{return}
//        view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
//        view.ignoresSiblingOrder = true
//    }
//    ////m
//    fileprivate var helpMessage: MessageBox!
//    fileprivate var doesClickOnHelpMessageDefaultButton = true
//    ////m
//    override func didMove(to view: SKView) {
//        
//        anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
//        //backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
//        ////m
//        //set up guide gesture
//        addChild(guideGesture)
//        guideGesture.position.y = (-UI.gridSize/2 + UI.menuIconSize.height/2 + UI.getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 1).y)/2
//        guideGesture.zPosition = UI.zPosition.gestureGuide
//        guideGesture.isHidden = true
//        
//        
//        //set up background
//        UIGraphicsBeginImageContext(size)
//        let bgCtx = UIGraphicsGetCurrentContext()
//        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
//        
//        let bgStartColor = UIColor(red: 122/255, green: 198/255, blue: 239/255, alpha: 1)
//        
//        let bgMidColor = UIColor(red: 222/510, green: 348/510, blue: 499/510, alpha: 1)
//        
//        let bgEndColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
//        
//        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
//        
//        let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
//        
//        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
//        bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
//        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        let background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
//        background.zPosition = UI.zPosition.background
//        addChild(background)
//        ///test gestureGuide
//        //        let gestureGuide = GestureGuide(color: UI.gestureGuideStrokeColor)
//        //        gestureGuide.zPosition = UI.zPosition.gestureGuide
//        //        addChild(gestureGuide)
//        //        gestureGuide.position.y = -size.height*3/8
//        //        gestureGuide.holdGuide(afterDelay: 0.6, downForDuration: 0.6, holdForDuration: 1.2)
//        ///test scrollText
//        //        let scrollText = NSLocalizedString(guideKey.help.rawValue, comment: "")
//        //        let scrollTextBox = ScrollTextBox(text: "")
//        //        scrollTextBox.zPosition = UI.zPosition.messageBox
//        //        scrollTextBox.anchorPoint.y = 0.25
//        //        scrollTextBox.anchorPoint.x = 0.25
//        //        scrollTextBox.position = CGPoint(x: 25, y: 75)
//        //        scrollTextBox.text = scrollText
//        //        addChild(scrollTextBox)
//        ///test messageBox
//        //        let actions = [
//        //            MessageAction(title: "Thanks!", style: .default, handler: {print("Thanks!")}),
//        //            MessageAction(title: "Shut up!", style: .destructive, handler: {print("Shut up!")}),
//        //            MessageAction(title: "Give up!", style: .destructive, handler: {print("Give up!")}),
//        //        ]
//        //        let messageBox = MessageBox(title: "scrollText", text: scrollText + scrollText, actions: actions)
//        //        messageBox.title = "T==T Help me"
//        //        messageBox.zPosition = UI.zPosition.messageBox
//        //        addChild(messageBox)
//        ////m
//        
//        // MARK: set up chessBoard background
//        let chessBoardBackgroundSize = CGSize(width: UI.gridSize * 12.0/11.0 ,height:  UI.gridSize * 12.0/11.0)
//        let chessBoardBackground = SKSpriteNode(texture: SKTexture(imageNamed: "chessBoardBackground"), size: chessBoardBackgroundSize)
//        chessBoardBackground.zPosition = UI.zPosition.chessBoardBackground
//        addChild(chessBoardBackground)
//        ///set up chessBoard background
//        /////test
//        //        let sourceBox = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
//        //        sourceBox.zPosition = 999
//        //        let spark = SKEmitterNode(fileNamed: "abilityHint.sks")!
//        //        spark.zPosition = 1000
//        //        sourceBox.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: frame.width/2, dy: frame.height/2), duration: 1)))
//        //        addChild(sourceBox)
//        //        sourceBox.addChild(spark)
//        /////test
//        //MARK: - set to default for guide. This should place in the first place of didMove.
//        ///Ori
//        //        SharedVariable.load()
//        //        Challenge.loadSharedChallenge()
//        ///ori
//        if SharedVariable.needToGuide{
//            ////m
//            guideGesture.isHidden = false
//            self.guideGesture.isPaused = false
//            guideGesture.tapGuide()
//            ////m
//            currentGuide = .welcome
//            currentGameSize = .six
//            currentMode = .two
//            switchTouchCycle = 1
//        }
//        
//        
//        //        optionMenu = OptionMenu()
//        //        addChild(optionMenu)
//        //        optionMenu.zPosition = 10000
//        //        optionMenu.isHidden = true
//        //        //MARK: - set up purchaseButtons
//        //        let purchaseButton = PurchaseButtons()
//        //        addChild(purchaseButton)
//        //        purchaseButton.zPosition = 1000
//        //MARK: - set up flipsIndicator
//        flipsIndicator.position = UI.flipsPosition
//        flipsIndicator.zPosition = UI.zPosition.flipsIndicator
//        flipsIndicator.flips = SharedVariable.flips
//        addChild(flipsIndicator)
//        //MARK: - set up loadButton
//        loadButton = Button(buttonColor: UI.loadButtonColor, cornerRadius: UI.loadButtonCornerRadius)!
//        loadButton.fontSize = UI.loadButtonFontSize
//        loadButton.position = UI.loadButtonPosition
//        loadButton.zPosition = UI.zPosition.loadButton
//        loadButton.text = UI.Texts.loadGame
//        addChild(loadButton)
//        
//        //MARK: - set up helpNode
//        helpNode = SKSpriteNode(imageNamed: "help")
//        helpNode.size = UI.menuIconSize
//        helpNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 4)
//        helpNode.zPosition = UI.zPosition.menuIcon
//        addChild(helpNode)
//        //MARK: set up helpHint
//        let boundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        helpHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: boundsOfHintBubble)!
//        helpHint.attachTo = (helpNode as (SKNode & attachable))
//        helpHint.text = UI.Texts.help
//        helpHint.isHidden = true
//        helpHint.fontSize = UI.menuIconHintLabelFontSize
//        addChild(helpHint)
//        //MARK: - set up optionNode
//        optionNode = SKSpriteNode(imageNamed: "option")
//        optionNode.size = UI.menuIconSize
//        optionNode.position = UI.getMenuIconPosition(indexFromLeft: 2, numberOfMenuIcon: 4)
//        optionNode.zPosition = UI.zPosition.menuIcon
//        addChild(optionNode)
//        //MARK: set up optionHint
//        let boundsOfOptionBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        optionHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: boundsOfOptionBubble)!
//        optionHint.attachTo = (optionNode as (SKNode & attachable))
//        optionHint.text = UI.Texts.option
//        optionHint.isHidden = true
//        optionHint.fontSize = UI.menuIconHintLabelFontSize
//        addChild(optionHint)
//        //MARK: - set up backgroundGrid
//        
//        let gridColor = SKColor(red: 132/255*0.6, green: 195/255*0.6, blue: 77/255*0.6, alpha: 1)
//        for i in 0...2{
//            let blockSize = UI.gridSize / CGFloat(2 * i + 4)
//            let backgroundGrid = Grid.init(color: gridColor, blockSize: blockSize, rows: 2 * i + 4, cols: 2 * i + 4, lineWidth: blockSize / 20)!
//            backgroundGrid.zPosition = UI.zPosition.backgroundGrid
//            backgroundGrid.position.x = size.width * CGFloat(i - currentGameSize.rawValue/2 + 2)
//            addChild(backgroundGrid)
//            backgroundGrids.append(backgroundGrid)
//            //MARK: set up background of backgroundGrid
//            let backgroundGridBackgroundColor = SKColor(red: 132/255, green: 195/255, blue: 77/255, alpha: 1)
//            let backgroundGridBackground = SKSpriteNode(color: backgroundGridBackgroundColor, size: CGSize(width: UI.gridSize, height: UI.gridSize))
//            backgroundGridBackground.zPosition = UI.zPosition.backgroundGridBackground
//            backgroundGridBackground.position.x = size.width * CGFloat(i)
//            addChild(backgroundGridBackground)
//            backgroundGridBackgrounds.append(backgroundGridBackground)
//        }
//        
//        //MARK: - set up logo
//        guard let logoImage = UIImage(named: "Logo") else{fatalError("cannot find image Logo")}
//        let logoSize = UI.logoSize
//        logo.maskNode = SKSpriteNode(texture: SKTexture(image: logoImage), size: logoSize)
//        logo.position = UI.logoPosition
//        logo.zPosition = UI.zPosition.logo
//        
//        addChild(logo)
//        //MARK: set up left-half white
//        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentMode.rawValue), height: logoSize.height)
//        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
//        logo.addChild(logoLeftWhite)
//        //MARK: set up right-half black
//        logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
//        logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
//        logo.addChild(logoRightBlack)
//        
//        
//        //        ////test abilityMenu
//        //        let abilityMenu = AbilityMenu{
//        //            print($0.rawValue)
//        //        }
//        //        abilityMenu.zPosition = 1000
//        //        abilityMenu.attachTo = helpNode
//        //        abilityMenu.popAnimation{abilityMenu.collapseAnimation{abilityMenu.popAnimation()}}
//        //        addChild(abilityMenu)
//        //
//        //        //// test abilityMenu
//        ////test scoreLabel
//        //        let scoreLabel = ScoreLabel(fontColor: .black, fontSize: UI.secondaryScoreFontSize, numberOfParts: 4, currentNumber: 3, score: 10)
//        //        scoreLabel.zPosition = 1000000
//        //        addChild(scoreLabel)
//        ////test scoreLabel
//        
//        
//        
//        
//        
//    }
//    ////m
//    fileprivate var originalGuideGestureShouldHide = false
//    fileprivate var originalGuideGestureIsPaused = false
//    ////m
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else{return}
//        ////m
//        originalGuideGestureShouldHide = SharedVariable.needToGuide ? false:true
//        originalGuideGestureIsPaused = guideGesture.isPaused
//        guideGesture.isHidden = true
//        guideGesture.isPaused = true
//        
//        ////m
//        ////m
//        //        else if currentGuide == .help{
//        //            removeGuide(nodesToRecover: [], key: .help)
//        //            if SharedVariable.needToGuide{
//        //                currentGuide = .logo
//        //                let lightRegionOfLogo = CGRect(origin: CGPoint(x: logo.frame.minX, y: logo.frame.minY), size: logo.frame.size)
//        //                guideLitByEllipse(nodesToLight: [logo], lightRegion: lightRegionOfLogo, key: .logo)
//        //            }
//        //        }
//        ////m
//        
//        let pos = touch.location(in: self)
//        touchOrigin = pos
//        let node = atPoint(touch.location(in: self))
//        touchDownOnWhere = node
//        firstGridOrigin = backgroundGrids.first!.position
//        currentWhiteSwitchPosition = logoLeftWhite.position
//        switch node{
//        case helpNode:
//            helpHint.isHidden = false
//        case optionNode:
//            optionHint.isHidden = false
//        default:
//            if loadButton.nodesTouched.contains(node){
//                loadButton.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//            }
//            break
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else{return}
//        loadButton.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        let pos = touch.location(in: self)
//        let node = atPoint(pos)
//        //MARK: when move on hints
//        //        helpNode.alpha = 1
//        //        optionNode.alpha = 1
//        helpHint.isHidden = true
//        optionHint.isHidden = true
//        switch node {
//        case helpNode:
//            //            helpNode.alpha = 0.5
//            helpHint.isHidden = false
//        case optionNode:
//            //            optionNode.alpha = 0.5
//            optionHint.isHidden = false
//        default:
//            if loadButton.nodesTouched.contains(node){
//                loadButton.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//            }
//            break
//        }
//        
//        let offset = pos.x - touchOrigin.x
//        if abs(offset) > 10 {everMoved = true}
//        if let touchDownOnWhere = touchDownOnWhere{
//            //MARK: move on logo
//            if touchDownOnWhere == logoLeftWhite || touchDownOnWhere == logoRightBlack{
//                
//                logoLeftWhite.position.x = currentWhiteSwitchPosition.x + offset/2
//                logoLeftWhite.position.x = min(max(logoLeftWhite.position.x,-logo.frame.width/2),0)
//                logoLeftWhite.size.width = (logoLeftWhite.position.x + logo.frame.width/2)*2
//                logoRightBlack.position.x = logoLeftWhite.position.x + logo.frame.width/2
//                logoRightBlack.size.width = logo.frame.width - logoLeftWhite.size.width
//                
//            }
//        }
//    }
//    fileprivate func help(){
//        if currentGuide == .hint{
//            
//            ////m
//            guideGesture.isHidden = true
//            guideGesture.isPaused = true
//            originalGuideGestureShouldHide = true
//            originalGuideGestureIsPaused = guideGesture.isPaused
//            ////m
//        }
//        currentGuide = .help
//        //guide(textPosition: CGPoint.zero, key: .help)
//        ////m
//        helpMessage.isHidden = false
//        ////m
//    }
//    fileprivate func reloadScene(){
//        let scene = TitleScene()
//        scene.scaleMode = .aspectFill
//        guard let view = view else{return}
//        view.presentScene(scene)
//    }
//    fileprivate func option(){
//        let alert = OptionMenuVC()
//        alert.delegate = self
//        UI.rootViewController?.present(alert, animated: true, completion: nil)
//        
//        //        if !optionMenu.isHidden{
//        //            optionMenu.close()
//        //            SharedVariable.save()
//        //            reloadScene()
//        //        }
//        //        else{
//        //            optionMenu.show()
//        //        }
//    }
//    fileprivate func showTuorial(){
//        currentGuide = .welcome
//        guideGesture.isHidden = false
//        guideGesture.isPaused = false
//        guideGesture.tapGuide()
//        currentGameSize = .six
//        currentMode = .two
//        switchTouchCycle = 1
//        let logoSize = UI.logoSize
//        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentMode.rawValue), height: logoSize.height)
//        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
//        logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
//        logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
//        for i in 0...backgroundGrids.count - 1{
//            backgroundGrids[i].position.x = size.width * CGFloat(i - currentGameSize.rawValue/2 + 2)
//            backgroundGridBackgrounds[i].position.x = size.width * CGFloat(i)
//        }
//        
//        SharedVariable.needToGuide = true
//        
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else{return}
//        loadButton.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        let pos = touch.location(in: self)
//        let node = atPoint(pos)
//        //MARK: remove welcome guide and add help guide
//        
//        if currentGuide == .welcome, SharedVariable.needToGuide{
//           
//            ////m
//            guideGesture.holdGuide()
//            guideGesture.isHidden = false
//            guideGesture.isPaused = false
//            guideGesture.position = helpNode.position
//            ////m
//            currentGuide = .hint
//            
//            return
//        }
//        //MARK: touch up on hints
//        helpHint.isHidden = true
//        optionHint.isHidden = true
//        //        helpNode.alpha = 1
//        //        optionNode.alpha = 1
//        switch node{
//        case helpNode:
//            help()
//        case optionNode:
//            option()
//        default:
//            break
//        }
//        if let touchDownOnWhere = touchDownOnWhere{
//            //MARK: - touch up on laodButton
//            if loadButton.nodesTouched.contains(touchDownOnWhere){
//                if !everMoved{
//                    
//                }
//            }
//                //MARK: - touch up on backgroundGrids
//            else if (backgroundGrids as [SKNode]).contains(touchDownOnWhere){
//                let offset = pos.x - touchOrigin.x
//                var shouldAddOffset = true
//                if (currentGameSize == .four && offset > 0) || (currentGameSize == .eight && offset < 0) || (SharedVariable.needToGuide && currentGuide == .gameboardTap){shouldAddOffset = false}
//                var currentGameSizeIndex = (currentGameSize.rawValue - 4)/2
//                if abs(offset) > 100{
//                    if shouldAddOffset{
//                        let sign = offset > 0 ? -1 : 1
//                        currentGameSizeIndex += sign
//                        currentGameSizeIndex = min(max(currentGameSizeIndex,0),2)
//                        currentGameSize = gameSize.init(rawValue: currentGameSizeIndex * 2 + 4)!
//                    }
//                    
//                }
//                    //MARK: touch up on backgroundGrids
//                else if abs(offset) < 10, !everMoved{
//                    if SharedVariable.needToGuide, currentGuide == .gameboardTap{
//                        var nodesToRecover: [SKNode] = backgroundGrids
//                        nodesToRecover.append(contentsOf: backgroundGridBackgrounds)
//                        
//                        SharedVariable.needToGuide = false
//                    }
//                    
//                }
//                // MARK: show the current size of the gameboard.
//                for i in 0...2{
//                    backgroundGrids[i].position.x = size.width * CGFloat(i - currentGameSizeIndex)
//                    backgroundGridBackgrounds[i].position.x = size.width * CGFloat(i - currentGameSizeIndex)
//                }
//                //MARK: remove the guide of the gameboard.
//                if SharedVariable.needToGuide, currentGuide == .gameboardSwipe,currentGameSize == .four{
//                    ////m
//                    self.guideGesture.isHidden = false
//                    self.guideGesture.isPaused = false
//                    self.guideGesture.position = CGPoint.zero
//                    self.guideGesture.tapGuide()
//                    ////m
//                    var nodesToRecover: [SKNode] = backgroundGrids
//                    nodesToRecover.append(contentsOf: backgroundGridBackgrounds)
//                   
//                    currentGuide = .gameboardTap
//                    
//                }
//            }
//                //MARK: - touch up on logo
//            else if touchDownOnWhere == logoRightBlack || touchDownOnWhere == logoLeftWhite{
//                let offset = pos.x - touchOrigin.x
//                var state = floor(2 * logoLeftWhite.size.width / logo.frame.width + 0.5)
//                if abs(offset) < 10, !everMoved{
//                    switch state{
//                    case 0:
//                        state = 1
//                        switchTouchCycle = 1
//                    case 1:
//                        state = CGFloat(2 * switchTouchCycle)
//                        switchTouchCycle = 1 - switchTouchCycle
//                    case 2:
//                        state = 1
//                        switchTouchCycle = 0
//                    default:
//                        break
//                    }
//                }
//                currentMode = mode.init(rawValue: Int(state))!
//                logoLeftWhite.size.width = state * logo.frame.width/2
//                logoLeftWhite.position.x = -logo.frame.width / 2 + logoLeftWhite.size.width/2
//                logoRightBlack.position.x = logoLeftWhite.position.x + logo.frame.width/2
//                logoRightBlack.size.width = logo.frame.width - logoLeftWhite.size.width
//                //MARK: guide to logo
//                if SharedVariable.needToGuide, currentGuide == .logo, (currentMode == .white && doesClickOnHelpMessageDefaultButton) || (currentMode == .black && !doesClickOnHelpMessageDefaultButton){
//                    ////m
//                    self.guideGesture.isHidden = false
//                    self.guideGesture.isPaused = false
//                    self.guideGesture.position = CGPoint.zero
//                    let swipeGuideVector = CGVector(dx: UI.gridSize/2, dy: 0)
//                    self.guideGesture.swipeGuide(by: swipeGuideVector)
//                    ////m
//                    
//                    currentGuide = .gameboardSwipe
//                    var nodesToLight: [SKNode] = backgroundGrids
//                    nodesToLight.append(contentsOf: backgroundGridBackgrounds)
//                    
//                }
//            }
//        }
//        everMoved = false
//        ////m
//        guideGesture.isHidden = originalGuideGestureShouldHide
//        guideGesture.isPaused = originalGuideGestureIsPaused
//        ////m
//    }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchesEnded(touches, with: event)
//    }
//}
