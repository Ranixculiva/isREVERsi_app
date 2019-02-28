//
//  TitleScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class TitleScene: SKScene {
    
    //fileprivate var flips = SKLabelNode(text: "\(Unicode.circledNumber(1))")
    //fileprivate var flipsNumber = SKLabelNode(text: "0")
    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
    fileprivate var helpNode = SKSpriteNode()
    fileprivate var helpHint = HintBubble()
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
    
    enum gameSize : Int{
        case four = 4, six = 6, eight = 8
    }
    var currentGameSize = gameSize.six
    
    enum mode: Int{
        case black = 0, two, white
    }
    var currentMode = mode.two
    enum guideKey: String{
        case logo = "guide.logo"
        case gameboardSwipe = "guide.gameboard.swipe"
        case gameboardTap = "guide.gameboard.tap"
    }
    var currentGuide = guideKey.logo
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
        view.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        //MARK: - set to default for guide. This should place in the first place of didMove.
        if SharedVariable.needToGuide{
            currentGameSize = .six
            currentMode = .two
            switchTouchCycle = 1
        }
//        //MARK: - set up flips
//        flips.verticalAlignmentMode = .center
//        flips.fontColor = .black
//        flips.fontName = "negative-circled-number"
//        flips.fontSize = UI.flipsFontSize
//        flips.position = UI.flipsPosition
//        flips.zPosition = UI.zPosition.flips
//        addChild(flips)
//        //MARK: add flip animation to flips
//        let flipAnimation = SKAction.sequence([
//            SKAction.scaleX(to: 0, duration: 0.4),
//            SKAction.changeFontColor(to: .white),
//            SKAction.scaleX(to: 1, duration: 0.4),
//            SKAction.scaleX(to: 0, duration: 0.4),
//            SKAction.changeFontColor(to: .black),
//            SKAction.scaleX(to: 1, duration: 0.4),
//            ])
//        flips.run(SKAction.repeatForever(flipAnimation))
//        //MARK: - set up flipsNumberLabel
//        flipsNumber.verticalAlignmentMode = .center
//        flipsNumber.horizontalAlignmentMode = .left
//        flipsNumber.fontColor = UIColor.darkGray
//        flipsNumber.fontName = "chalkboard SE"
//        flipsNumber.fontSize = UI.flipsFontSize
//        flipsNumber.position = UI.flipNumberPosition
//        flipsNumber.zPosition = UI.zPosition.flipNumber
//        addChild(flipsNumber)
        //MARK: - set up flipsIndicator
        flipsIndicator.position = UI.flipsPosition
        flipsIndicator.zPosition = UI.zPosition.flipsIndicator
        flipsIndicator.flips = SharedVariable.flips
        addChild(flipsIndicator)
        //MARK: - set up helpNode
        helpNode = SKSpriteNode(imageNamed: "help")
        helpNode.size = UI.menuIconSize
        helpNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 4)
        helpNode.zPosition = UI.zPosition.helpNode
        addChild(helpNode)
        //MARK: set up helpHint
        let boundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        helpHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: boundsOfHintBubble)!
        helpHint.attachTo = (helpNode as (SKNode & attachable))
        helpHint.text = NSLocalizedString("help", comment: "")
        helpHint.isHidden = true
        helpHint.fontSize = UI.menuIconHintLabelFontSize
        addChild(helpHint)
        //safeAreaInsets = view.safeAreaInsets
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
        //MARK: show the guide if necessary
        if SharedVariable.needToGuide{
            let logoGuideText = NSLocalizedString("guide.logo", comment: "")
            guideLitByEllipse(nodeToLight: logo, nodeSize: logoSize, text: logoGuideText, key: guideKey.logo)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        touchOrigin = pos
        let node = atPoint(touch.location(in: self))
        touchDownOnWhere = node
        firstGridOrigin = backgroundGrids.first!.position
        currentWhiteSwitchPosition = logoLeftWhite.position
        switch node{
        case helpNode:
            helpHint.isHidden = false
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
        switch node {
        case helpNode:
            helpHint.isHidden = false
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
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        let node = atPoint(pos)
        //MARK: touch up on hints
        switch node{
        case helpNode:
            helpHint.isHidden = true
            help()
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
                    var nodesToRecover: [SKNode] = backgroundGrids
                    nodesToRecover.append(contentsOf: backgroundGridBackgrounds)
                    removeGuide(nodesToRecover: nodesToRecover, key: .gameboardSwipe)
                    currentGuide = .gameboardTap
                    let guideText = NSLocalizedString("guide.gameboard.tap", comment: "")
                    let lightRegion = CGRect(x: -UI.gridSize/2, y: -UI.gridSize/2, width: UI.gridSize, height: UI.gridSize)
                    guideLitByRoundedRectangle(nodesToLight: nodesToRecover, lightRegion: lightRegion, text: guideText, cornerRadius: 5*UIScreen.main.scale, key: .gameboardTap)
                    //SharedVariable.needToGuide = false
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
                if SharedVariable.needToGuide, currentGuide == .logo, currentMode == .black{
                    removeGuide(nodesToRecover: [logo], key: guideKey.logo)
                    currentGuide = .gameboardSwipe
                    var nodesToLight: [SKNode] = backgroundGrids
                    nodesToLight.append(contentsOf: backgroundGridBackgrounds)
                    let guideText = NSLocalizedString(guideKey.gameboardSwipe.rawValue, comment: "")
                    let lightRegion = CGRect(x: -UI.gridSize/2, y: -UI.gridSize/2, width: UI.gridSize, height: UI.gridSize)
                    guideLitByRoundedRectangle(nodesToLight: nodesToLight, lightRegion: lightRegion, text: guideText, cornerRadius: 5*UIScreen.main.scale, key: .gameboardSwipe)
                }
            }
        }
        everMoved = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    fileprivate func guideLitByRoundedRectangle(nodesToLight: [SKNode], lightRegion: CGRect, text: String, cornerRadius: CGFloat,key: guideKey){
        if nodesToLight.isEmpty{fatalError("empty nodeToLights")}
        removeChildren(in: nodesToLight)
        let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
        
        let label = SKLabelNode(text: text)
        label.fontName = UI.guideFontName
        label.fontColor = UI.guideFontColor
        label.fontSize = UI.guideFontSize
        label.numberOfLines = 0
        label.zPosition = UI.zPosition.guideLabel
        label.preferredMaxLayoutWidth = UI.gridSize
        if lightRegion.midY >= 0{
            label.verticalAlignmentMode = .top
            label.position.y = light.frame.minY - 10 * UIScreen.main.scale
        }
        else if lightRegion.midY < 0{
            label.verticalAlignmentMode = .bottom
            label.position.y = light.frame.maxY + 10 * UIScreen.main.scale
        }
        background.addChild(label)
        
    }
    fileprivate func guideLitByEllipse(nodeToLight: SKNode, nodeSize: CGSize, text: String, key: guideKey){
        removeChildren(in: [nodeToLight])
        let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let background = SKSpriteNode(color: backgroundColor, size: size)
        background.name = key.rawValue
        background.zPosition = UI.zPosition.guideBackground
        addChild(background)
        background.addChild(nodeToLight)
        let lightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        let ellipseLightWidth = nodeSize.width * 1.4
        let ellipseLightHeight = nodeSize.height / sqrt(1 - nodeSize.width * nodeSize.width / (ellipseLightWidth * ellipseLightWidth))
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
        ellipseLight.position = nodeToLight.position
        ellipseLight.zPosition = UI.zPosition.guideLight
        background.addChild(ellipseLight)
        
        let label = SKLabelNode(text: text)
        label.zPosition = UI.zPosition.guideLabel
        label.fontName = UI.guideFontName
        label.fontColor = UI.guideFontColor
        label.fontSize = UI.guideFontSize
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UI.gridSize
        if nodeToLight.position.y > 0{
            label.verticalAlignmentMode = .top
            label.position.y = ellipseLight.frame.minY - 10 * UIScreen.main.scale
        }
        else if nodeToLight.position.y <= 0{
            label.verticalAlignmentMode = .bottom
            label.position.y = ellipseLight.frame.maxY + 10 * UIScreen.main.scale
        }
        background.addChild(label)
    
    }
    fileprivate func removeGuide(nodesToRecover: [SKNode], key: guideKey){
        guard let background = childNode(withName: key.rawValue) else {return}
        removeChildren(in: [background])
        for nodeToRecover in nodesToRecover{
            nodeToRecover.removeFromParent()
            addChild(nodeToRecover)
        }
        
        return
    }
}
