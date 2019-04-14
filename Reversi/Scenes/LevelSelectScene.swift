//
//  LevelSelectScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class LevelSelectScene: SKScene {
    deinit {
        print("LevelSelectScene deinit")
    }
    var isComputerWhite = true
    var gameSize = 6
    var needToLoad = false
    var AIlevel: UInt{
        switch difficulty{
        case .easy:
            return UInt(2)
        case .normal:
            return UInt(4)
        case .hard:
            return UInt(6)
        }
    }
    var currentLevel = 0
    var difficulty = Challenge.difficultyType.easy
    var challenges: [Challenge] = []
    
    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
    
    fileprivate var numberOfLevels = 3
    fileprivate var levelLabels: [SKLabelNode] = []
    fileprivate var levelPictures: [SKSpriteNode] = []
    //MARK: - menu
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var toTitleHint: HintBubble!
    //MARK: - parameters for touches
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var touchDownOnWhere: SKNode? = nil
    fileprivate var firstLevelLabelOrigin = CGPoint.zero
    fileprivate var firstLevelPictureOrigin = CGPoint.zero
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
        for i in 0...numberOfLevels - 1{
            //MARK: set up levelLabels
            let levelLabel = SKLabelNode(text: String.init(format: "LEVEL".localized(), i + 1))
            levelLabel.position = UI.levelLabelPosition(indexFromLeft: i)
            levelLabel.fontSize = UI.levelLabelFontSize
            levelLabel.fontName = UI.levelLabelFontName
            levelLabel.fontColor = !isComputerWhite ? .white: .black
            levelLabel.verticalAlignmentMode = .bottom
            levelLabels.append(levelLabel)
            addChild(levelLabel)
            //MARK: set up levelPictures
            let levelPictureSize = UI.levelPictureSize
            //MARK: draw a rounded frame for the picture
            UIGraphicsBeginImageContext(levelPictureSize)
            let context = UIGraphicsGetCurrentContext()
            let imageFrame = CGRect(origin: CGPoint.zero, size: levelPictureSize)
            let roundedImageFrame = UIBezierPath(roundedRect: imageFrame, cornerRadius: UI.levelPictureRoundedCornerRadius)
            context?.saveGState()
            roundedImageFrame.addClip()
            let image = UIImage(named: "level\(i + 1)")!
            image.draw(in: imageFrame)
            context?.restoreGState()
            let levelImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let levelPicture = SKSpriteNode(texture: SKTexture(image: levelImage), size: levelPictureSize)
            levelPicture.position = UI.levelPicturePosition(indexFromLeft: i)
            levelPictures.append(levelPicture)
            addChild(levelPicture)
        }
        //MARK: - set up logo
        guard let logoImage = UIImage(named: "Logo") else{fatalError("cannot find image Logo")}
        let logoSize = UI.logoSize
        logo.maskNode = SKSpriteNode(texture: SKTexture(image: logoImage), size: logoSize)
        logo.position = UI.logoPosition
        logo.zPosition = UI.zPosition.logo
        addChild(logo)
        //MARK: set up left-half white
        logoLeftWhite.size = CGSize(width: logoSize.width *  CGFloat(!isComputerWhite ? 1 : 0 ), height: logoSize.height)
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
        if (levelLabels as [SKNode]).contains(node) || (levelPictures as [SKNode]).contains(node){
            firstLevelPictureOrigin = levelPictures[0].position
            firstLevelLabelOrigin = levelLabels[0].position
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
        if (levelLabels as [SKNode]).contains(touchDownOnWhere) || (levelPictures as [SKNode]).contains(touchDownOnWhere){
            var shouldAddOffset = true
            if (levelLabels[currentLevel].position.x - levelLabels[0].position.x < offset) || (levelLabels[currentLevel].position.x - levelLabels.last!.position.x > offset) {shouldAddOffset = false}
            if shouldAddOffset{
                for i in 0...numberOfLevels - 1{
                    levelLabels[i].position.x = firstLevelLabelOrigin.x + offset + UI.levelLabelPosition(indexFromLeft: i).x
                    levelPictures[i].position.x = firstLevelPictureOrigin.x + offset + UI.levelLabelPosition(indexFromLeft: i).x
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        //MARK: hide all hints
        toTitleHint.isHidden = true
        let pos = touch.location(in: self)
        let offset = pos.x - touchOrigin.x
        guard let touchDownOnWhere = touchDownOnWhere else{return}
        //MARK: - when touchDownOnWhere is contained in levelLabels or levelPictures
        if (levelLabels as [SKNode]).contains(touchDownOnWhere) || (levelPictures as [SKNode]).contains(touchDownOnWhere){
            if abs(offset) > 100{
                var shouldAddOffset = true
                if (levelLabels[currentLevel].position.x - levelLabels[0].position.x < offset) || (levelLabels[currentLevel].position.x - levelLabels.last!.position.x > offset) {shouldAddOffset = false}
                if shouldAddOffset{
                    let sign = offset > 0 ? -1 : 1
                    currentLevel += sign
                }
            }
            else if abs(offset) < 10, !everMoved{
                touchDownOnLevels()
            }
            for i in 0...numberOfLevels - 1{
                levelLabels[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelLabelPosition(indexFromLeft: currentLevel).x
                levelPictures[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelPicturePosition(indexFromLeft: currentLevel).x
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
    fileprivate func touchDownOnLevels(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.AIlevel = AIlevel
        scene.isAIMode = true
        scene.isComputerWhite = isComputerWhite
        scene.level = currentLevel + 1
        view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    fileprivate func toTitle(){
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            scene.currentMode = !isComputerWhite ? .white : .black
            view.presentScene(scene, transition: transition)
        }
    }
}