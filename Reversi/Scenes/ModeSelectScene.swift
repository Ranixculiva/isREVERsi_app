//
//  ModeSelectScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class ModeSelectScene: SKScene {
    deinit {
        print("ModeSelectScene deinit")
    }
    var gameSize = 6
    var currentMode = mode.offline
    enum mode: Int{
        case offline = 0, online, party
    }
    func modeName(mode: mode) -> String{
        switch mode {
        case .online:
            return "ONLINE".localized()
        case .offline:
            return "OFFLINE".localized()
        case .party:
            return "PARTY".localized()
        }
    }
    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
    
    fileprivate var numberOfModes = 3
    fileprivate var modeLabels: [SKLabelNode] = []
    fileprivate var modePictures: [SKSpriteNode] = []
    //MARK: - menu
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var toTitleHint: HintBubble!
    //MARK: - parameters for touches
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var touchDownOnWhere: SKNode? = nil
    fileprivate var firstModeLabelOrigin = CGPoint.zero
    fileprivate var firstModePictureOrigin = CGPoint.zero
    fileprivate var everMoved = false
    
    fileprivate let logo = SKCropNode()
    fileprivate let logoRightBlack = SKSpriteNode(color: .black, size: CGSize())
    fileprivate let logoLeftWhite = SKSpriteNode(color: .white, size: CGSize())
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        ////m
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
        ////m
        //MARK: - set up flipsIndicator
        flipsIndicator.position = UI.flipsPosition
        flipsIndicator.zPosition = UI.zPosition.flipsIndicator
        flipsIndicator.flips = SharedVariable.flips
        addChild(flipsIndicator)
        //MARK: - set up menu
        toTitleNode = SKSpriteNode(imageNamed: "toTitle")
        toTitleNode.size = UI.menuIconSize
        toTitleNode.position = UI.getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 3)
        toTitleNode.zPosition = 1
        addChild(toTitleNode)
        //MARK: set up hints
        let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        toTitleHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        toTitleHint.attachTo = toTitleNode
        toTitleHint.text = "back to title".localized()
        toTitleHint.isHidden = true
        toTitleHint.fontSize = UI.menuIconHintLabelFontSize
        addChild(toTitleHint)
        //MARK: - set up levelLabels and levelPictures
        for i in 0...numberOfModes - 1{
            //MARK: set up levelLabels
            let modeLabel = SKLabelNode(text: modeName(mode: mode.init(rawValue: i)!))
            modeLabel.position = UI.levelLabelPosition(indexFromLeft: i)
            modeLabel.fontSize = UI.levelLabelFontSize
            modeLabel.fontName = UI.modeLabelFontName
            modeLabel.fontColor = UI.modeLabelFontColor
            modeLabel.verticalAlignmentMode = .bottom
            modeLabels.append(modeLabel)
            addChild(modeLabel)
            //MARK: set up levelPictures
            let modePictureSize = UI.levelPictureSize
            let modePicture = SKSpriteNode(color: .red, size: modePictureSize)
            modePicture.position = UI.levelPicturePosition(indexFromLeft: i)
            modePictures.append(modePicture)
            addChild(modePicture)
        }
        //MARK: - set up logo
        guard let logoImage = UIImage(named: "Logo") else{fatalError("cannot find image Logo")}
        let logoSize = UI.logoSize
        logo.maskNode = SKSpriteNode(texture: SKTexture(image: logoImage), size: logoSize)
        logo.position = UI.logoPosition
        logo.zPosition = UI.zPosition.logo
        addChild(logo)
        //MARK: set up left-half white
        logoLeftWhite.size = CGSize(width: logoSize.width/2, height: logoSize.height)
        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
        logo.addChild(logoLeftWhite)
        //MARK: set up right-half black
        logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
        logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
        logo.addChild(logoRightBlack)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        touchOrigin = pos
        let node = atPoint(pos)
        switch node {
        case toTitleNode:
            toTitleHint.isHidden = false
        default:
            break
        }
        touchDownOnWhere = node
        if (modeLabels as [SKNode]).contains(node) || (modePictures as [SKNode]).contains(node){
            firstModePictureOrigin = modePictures[0].position
            firstModeLabelOrigin = modeLabels[0].position
        }
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        //MARK: hide hints
        toTitleHint.isHidden = true
        //MARK: if necessary, show hints
        let node = atPoint(pos)
        switch node {
        case toTitleNode:
            toTitleHint.isHidden = false
        default:
            break
        }
        let offset = pos.x - touchOrigin.x
        if abs(offset) >= 10{everMoved = true}
        guard let touchDownOnWhere = touchDownOnWhere else{return}
        if (modeLabels as [SKNode]).contains(touchDownOnWhere) || (modePictures as [SKNode]).contains(touchDownOnWhere){
            var shouldAddOffset = true
            if (modeLabels[currentMode.rawValue].position.x - modeLabels[0].position.x < offset) || (modeLabels[currentMode.rawValue].position.x - modeLabels.last!.position.x > offset) {shouldAddOffset = false}
            if shouldAddOffset{
                for i in 0...numberOfModes - 1{
                    modeLabels[i].position.x = firstModeLabelOrigin.x + offset + UI.levelLabelPosition(indexFromLeft: i).x
                    modePictures[i].position.x = firstModePictureOrigin.x + offset + UI.levelLabelPosition(indexFromLeft: i).x
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let pos = touch.location(in: self)
        //let node = atPoint(pos)
        let offset = pos.x - touchOrigin.x
        guard let touchDownOnWhere = touchDownOnWhere else{return}
        //MARK: - when touchDownOnWhere is contained in modeLabels or modePictures
        if (modeLabels as [SKNode]).contains(touchDownOnWhere) || (modePictures as [SKNode]).contains(touchDownOnWhere){
            if abs(offset) > 100{
                var shouldAddOffset = true
                if (modeLabels[currentMode.rawValue].position.x - modeLabels[0].position.x < offset) || (modeLabels[currentMode.rawValue].position.x - modeLabels.last!.position.x > offset) {shouldAddOffset = false}
                if shouldAddOffset{
                    let sign = offset > 0 ? -1 : 1
                    currentMode = mode.init(rawValue: currentMode.rawValue + sign)!
                }
            }
            else if abs(offset) < 10, !everMoved{
                touchDownOnModes()
            }
            for i in 0...numberOfModes - 1{
                modeLabels[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelLabelPosition(indexFromLeft: currentMode.rawValue).x
                modePictures[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelPicturePosition(indexFromLeft: currentMode.rawValue).x
            }
        }
        let node = atPoint(pos)
        switch node {
        case toTitleNode:
            toTitle()
        default:
            break
        }
        everMoved = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    fileprivate func toTitle(){
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            scene.currentMode = .two
            view.presentScene(scene, transition: transition)
        }
    }
    fileprivate func touchDownOnModes(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.isAIMode = false
        view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
}
