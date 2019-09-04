//
//  LevelSelectScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class LevelSelectScene: SKScene, FetchValueDelegate {
    func didFetchValue(value: Int, name: String?) {
        guard let name = name else {return}
        if name == "levelSelector"{
            currentLevel = value
            levelPictureToTheCurrentLevel()
        }
        else if name == "difficultySelector"{
            difficulty = Challenge.difficultyType(rawValue: value)!
            updateLevelPictures(difficulty)
        }
    }
    
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
            return UInt(4)
        }
    }
    var currentLevel = 0
    var difficulty = Challenge.difficultyType.easy
    var challenges: [Challenge] = []
    
    
    
    fileprivate var numberOfLevels = 2
    fileprivate var levelLabels: [SKLabelNode] = []
    fileprivate var levelPictures: [SKSpriteNode] = []
    fileprivate var levelSelector: SelectButtons!
    //MARK: - menu
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var toTitleHint: HintBubble!
    //MARK: - parameters for touches
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var touchDownOnWhere: SKNode? = nil
    fileprivate var firstLevelLabelOrigin = CGPoint.zero
    fileprivate var firstLevelPictureOrigin = CGPoint.zero
    fileprivate var everMoved = false
    
    fileprivate var difficultySelector: TextOptionsWithSelectButtons!
    fileprivate func drawLevelPicture(_ level: Int, difficulty: Challenge.difficultyType = .easy) -> UIImage{
        let levelPictureSize = UI.levelPictureSize
        //MARK: draw a rounded frame for the picture
        UIGraphicsBeginImageContext(levelPictureSize)
        let context = UIGraphicsGetCurrentContext()
        //draw corner according to the number of completed chanllenges.
        let theCompletedNumbers = Challenge.getTheNumberOfCompletedChallenge(gameSize: gameSize, isColorWhite: !isComputerWhite, level: level+1, difficulty: difficulty)
        if theCompletedNumbers > 0{
            let rect = CGRect(x: levelPictureSize.width/2, y: levelPictureSize.height/2, width: levelPictureSize.width/2, height: levelPictureSize.height/2)
            let copper = UIColor(red: 184/255, green: 115/255, blue: 51/255, alpha: 1)
            copper.setFill()
            context?.fill(rect)
            
        }
        if theCompletedNumbers > 1{
            let rect = CGRect(x: 0, y: levelPictureSize.height/2, width: levelPictureSize.width/2, height: levelPictureSize.height/2)
            let silver = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            silver.setFill()
            context?.fill(rect)
        }
        if theCompletedNumbers > 2{
            let rect = CGRect(x: levelPictureSize.width/2, y: 0, width: levelPictureSize.width/2, height: levelPictureSize.height/2)
            let gold = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
            gold.setFill()
            context?.fill(rect)
        }
        //            if theCompletedNumbers > 3{
        //                let rect = CGRect(x: levelPictureSize.width/2, y: levelPictureSize.height/2, width: levelPictureSize.width/2, height: levelPictureSize.height/2)
        //                let copper = UIColor(red: 184/255, green: 115/255, blue: 51/255, alpha: 1)
        //
        //                context?.stroke(rect)
        //            }
        
        
        
        
        
        
        let imageFrame = CGRect(origin: CGPoint.zero, size: levelPictureSize)
        let roundedImageFrame = UIBezierPath(roundedRect: imageFrame, cornerRadius: UI.levelPictureRoundedCornerRadius)
        context?.saveGState()
        roundedImageFrame.addClip()
        let image = UIImage(named: "level\(level + 1)")!
        image.draw(in: imageFrame)
        context?.restoreGState()
        let levelImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return levelImage
    }
    fileprivate func updateLevelPictures(_ difficulty: Challenge.difficultyType){
        for i in 0...numberOfLevels - 1{
            let levelImage = drawLevelPicture(i, difficulty: difficulty)
            levelPictures[i].texture = SKTexture(image: levelImage)
        }
    }
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
        
        UI.addPattern(to: bgCtx, type: !isComputerWhite ? .white: .black)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        background.zPosition = UI.zPosition.background
        addChild(background)
        //MARK: - set up levelSelector
        let levelSelectorLeftButton = SKSpriteNode(texture: SKTexture(image:  #imageLiteral(resourceName: "leftSelecButton")), size: UI.levelSelectorButtonSize)
        let levelSelectorRightButton = SKSpriteNode(texture: SKTexture(image:  #imageLiteral(resourceName: "rightSelectButton")), size: UI.levelSelectorButtonSize)
        levelSelector = SelectButtons(spacing: UI.levelSelectorSpacing, leftButton: levelSelectorLeftButton, rightButton: levelSelectorRightButton, isCyclic: false, upperBound: numberOfLevels - 1)
        levelSelector.name = "levelSelector"
        levelSelector.fetchValueDelegate = self
        levelSelector.zPosition = UI.zPosition.levelSelector
        levelSelector.position = UI.levelSelectorPosition
        addChild(levelSelector)
        //MARK: - set up difficultySelector
        let difficultyOptions = ["COM 1", "COM 2", "COM 3"]
        
        let difficultySelectorLeftButton = SKSpriteNode(texture: SKTexture(image:  #imageLiteral(resourceName: "leftSelecButton")), size: UI.difficultySelectorButtonSize)
        let difficultySelectorRightButton = SKSpriteNode(texture: SKTexture(image:  #imageLiteral(resourceName: "rightSelectButton")), size: UI.difficultySelectorButtonSize)
        difficultySelector = TextOptionsWithSelectButtons(texts: difficultyOptions, spacing: UI.difficultySelectorSpacing, leftButton: difficultySelectorLeftButton, rightButton: difficultySelectorRightButton, fontColor: isComputerWhite ? .white:.black)
        difficultySelector.fetchValueDelegate = self
        difficultySelector.name = "difficultySelector"
        difficultySelector.zPosition = UI.zPosition.difficultySelector
        difficultySelector.position = UI.difficultySelectorPosition
        addChild(difficultySelector)
        
        ////m
        //MARK: - set up flipsIndicator
        UI.flipsIndicator.flipsColor = !isComputerWhite ? .white:.black
        UI.flipsIndicator.flips = SharedVariable.flips
        UI.addFlipsIndicator(to: self)
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
        toTitleHint.text = UI.Texts.backToTitle
        toTitleHint.isHidden = true
        toTitleHint.fontSize = UI.menuIconHintLabelFontSize
        addChild(toTitleHint)
        //MARK: - set up levelLabels and levelPictures
        for i in 0...numberOfLevels - 1{
            //MARK: set up levelLabels
            let levelLabel = SKLabelNode(text: UI.Texts.level(i))
            levelLabel.position = UI.levelLabelPosition(indexFromLeft: i)
            levelLabel.fontSize = UI.levelLabelFontSize
            levelLabel.fontName = UI.levelLabelFontName
            levelLabel.fontColor = !isComputerWhite ? .white: .black
            levelLabel.verticalAlignmentMode = .bottom
            levelLabels.append(levelLabel)
            addChild(levelLabel)
            //MARK: set up levelPictures
            let levelPictureSize = UI.levelPictureSize
            let levelImage = drawLevelPicture(i,difficulty: difficulty)
            let levelPicture = SKSpriteNode(texture: SKTexture(image: levelImage), size: levelPictureSize)
            levelPicture.position = UI.levelPicturePosition(indexFromLeft: i)
            levelPictures.append(levelPicture)
            addChild(levelPicture)
        }
        //MARK: - set up logo
        UI.logoSwitch.isUserInteractionEnabled = false
        UI.addLogoSwitch(to: self)
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
    fileprivate func levelPictureToTheCurrentLevel() {
        for i in 0...numberOfLevels - 1{
            levelLabels[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelLabelPosition(indexFromLeft: currentLevel).x
            levelPictures[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelPicturePosition(indexFromLeft: currentLevel).x
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
            levelPictureToTheCurrentLevel()
            levelSelector.value = currentLevel
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
        switch difficultySelector.value {
        case 0:
            difficulty = .easy
        case 1:
            difficulty = .normal
        case 2:
            difficulty = .hard
        default:
            break
        }
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.difficulty = difficulty
        scene.gameSize = gameSize
        scene.AIlevel = AIlevel
        scene.isAIMode = true
        scene.isComputerWhite = isComputerWhite
        scene.level = currentLevel + 1
        scene.withAbility = .none
        //settings
        
        if currentLevel == 1{
            scene.withAbility = .translate
        }
        
        UI.rootViewController?.present(UI.loadingVC, animated: true){
            view.presentScene(scene)
            UI.loadingVC.dismiss(animated: true, completion: nil)
        }
        
    }
    fileprivate func toTitle(){
        if let view = view {
//            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            //UI.logoSwitch.currentState = !isComputerWhite ? .white : .black
            UI.rootViewController?.present(UI.loadingVC, animated: true){
                view.presentScene(scene)
                scene.run(SKAction.wait(forDuration: 0.1)){
                    UI.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
            //view.presentScene(scene, transition: transition)
        }
    }
}
