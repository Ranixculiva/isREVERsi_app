//
//  ModeSelectScene.swift
//  Reversi
//
//  Created by john gospai on 2019/2/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class ModeSelectScene: SKScene, FetchValueDelegate {
    func didFetchValue(value: Int, name: String?) {
        currentMode = mode.init(rawValue: value)!
        modeToTheCurrentMode()
    }
    
    deinit {
        print("ModeSelectScene deinit")
    }
    var gameSize = 6
    var currentMode = mode.offline
    enum mode: Int{
        case offline = 0, offlineParty, online, onlineParty
    }
    func modeName(mode: mode) -> String{
        switch mode {
        case .online:
            return UI.Texts.online
        case .offline:
            return UI.Texts.offline
        case .offlineParty:
            return UI.Texts.offlineParty
        case .onlineParty:
            return UI.Texts.onlineParty
        }
    }
    
    fileprivate var numberOfModes = 2
    fileprivate var modeLabels: [SKLabelNode] = []
    fileprivate var modePictures: [SKSpriteNode] = []
    fileprivate var modeSelector: SelectButtons!
    //MARK: - menu
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var toTitleHint: HintBubble!
    //MARK: - parameters for touches
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var touchDownOnWhere: SKNode? = nil
    fileprivate var firstModeLabelOrigin = CGPoint.zero
    fileprivate var firstModePictureOrigin = CGPoint.zero
    fileprivate var everMoved = false
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = UI.rootSize
        //backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        ////m
        //set up background
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let bgCtx = UIGraphicsGetCurrentContext()
        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bgStartColor = UIColor(red: 122/255, green: 198/255, blue: 239/255, alpha: 1)
        
        let bgMidColor = UIColor(red: 222/510, green: 348/510, blue: 499/510, alpha: 1)
        
        let bgEndColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
        
        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
        
        let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
        
        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
        bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
        
        UI.addPattern(to: bgCtx)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        background.zPosition = UI.zPosition.background
        addChild(background)
        ////m
        //MARK: - set up modeSelector
        let modeSelectorLeftButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "leftSelecButton")), size: UI.modeSelectorButtonSize)
        let modeSelectorRightButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "rightSelectButton")), size: UI.modeSelectorButtonSize)
        modeSelector = SelectButtons(spacing: UI.modeSelectorSpacing, leftButton: modeSelectorLeftButton, rightButton: modeSelectorRightButton, isCyclic: false, upperBound: numberOfModes - 1)
        modeSelector.fetchValueDelegate = self
        modeSelector.zPosition = UI.zPosition.modeSelector
        modeSelector.position = UI.modeSelectorPosition
        addChild(modeSelector)
        //MARK: - set up flipsIndicator
        UI.flipsIndicator.withAnimation = true
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
            UIGraphicsBeginImageContextWithOptions(modePictureSize, false, UIScreen.main.scale)
            let modeContext = UIGraphicsGetCurrentContext()
            let roundedRect = UIBezierPath(roundedRect: CGRect(origin: .zero, size: modePictureSize), cornerRadius: UI.levelPictureRoundedCornerRadius)
            modeContext?.saveGState()
            roundedRect.addClip()
            let modeImg = UIImage(named: "mode\(i)")
            modeImg?.draw(in: CGRect(origin: .zero, size: modePictureSize))
            modeContext?.restoreGState()
            let modeImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let modePicture = SKSpriteNode(texture: SKTexture(image: modeImage), size: modePictureSize)
            modePicture.position = UI.levelPicturePosition(indexFromLeft: i)
            modePictures.append(modePicture)
            addChild(modePicture)
        }
        //MARK: - set up logo
        UI.logoSwitch.isUserInteractionEnabled = false
        UI.addLogoSwitch(to: self)
        
        
        //MARK: - set up gameSizeLabel
        let gameSizeLabel = SKLabelNode(text: "\(gameSize)X\(gameSize)")
        gameSizeLabel.fontName = UI.fontName.ChalkboardSEBold.rawValue
        gameSizeLabel.fontSize = UI.levelLabelFontSize
        gameSizeLabel.verticalAlignmentMode = .center
        gameSizeLabel.position = CGPoint(x: 0, y: modePictures[0].frame.minY/2 + toTitleNode.frame.maxY/2)
        addChild(gameSizeLabel)
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
    fileprivate func modeToTheCurrentMode() {
        for i in 0...numberOfModes - 1{
            modeLabels[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelLabelPosition(indexFromLeft: currentMode.rawValue).x
            modePictures[i].position.x = UI.levelLabelPosition(indexFromLeft: i).x - UI.levelPicturePosition(indexFromLeft: currentMode.rawValue).x
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
                switch currentMode{
                case .offline:
                        touchDownOnOffline()
                case .offlineParty:
                        touchDownOnOfflineParty()
                case .online:
                        touchDownOnOnline()
                case .onlineParty:
                        touchDownOnOnlineParty()
                }
            }
            modeToTheCurrentMode()
            modeSelector.value = currentMode.rawValue
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
//            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            //UI.logoSwitch.currentState = .half
            
            UI.rootViewController?.present(UI.loadingVC, animated: true){
                view.presentScene(scene)
                scene.run(SKAction.wait(forDuration: 0.1)){
                    UI.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
            //view.presentScene(scene, transition: transition)
        }
    }
    fileprivate func touchDownOnOffline(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.isAIMode = false
        scene.offline = true
        
        //settings
        scene.canPlayerUseAbility = false
        
        
        //view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
        //UI.rootViewController?.present(UI.loadingVC, animated: true){
        view.presentScene(scene)
          //  scene.run(SKAction.wait(forDuration: 0.1)){
            //    UI.loadingVC.dismiss(animated: false, completion: nil)
            //}
        //}
    }
    fileprivate func touchDownOnOfflineParty(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.isAIMode = false
        scene.offline =  true
        //settings
        scene.canPlayerUseAbility = true
        scene.withAbility = .none
        
        //view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
        //UI.rootViewController?.present(UI.loadingVC, animated: true){
            view.presentScene(scene)
//            scene.run(SKAction.wait(forDuration: 0.1)){
//                UI.loadingVC.dismiss(animated: false, completion: nil)
//            }
//        }
    }
    fileprivate func touchDownOnOnline(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.isAIMode = false
        scene.offline = false
        //settings
        scene.canPlayerUseAbility = false
        
        //view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
//        UI.rootViewController?.present(UI.loadingVC, animated: true){
            view.presentScene(scene)
//            scene.run(SKAction.wait(forDuration: 0.1)){
//                UI.loadingVC.dismiss(animated: false, completion: nil)
//            }
//        }
    }
    fileprivate func touchDownOnOnlineParty(){
        guard let view = view else{return}
        guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
        scene.scaleMode = .aspectFill
        scene.gameSize = gameSize
        scene.isAIMode = false
        scene.offline = false
        //settings
        scene.canPlayerUseAbility = true
        scene.withAbility = .none
        //view.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 1))
//        UI.rootViewController?.present(UI.loadingVC, animated: true){
        view.presentScene(scene)
//            scene.run(SKAction.wait(forDuration: 0.1)){
//                UI.loadingVC.dismiss(animated: false, completion: nil)
//            }
//        }
    }
}
