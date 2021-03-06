//
//  GameScene.swift
//  Reversi
//
//  Created by john gospai on 2018/11/10.
//  Copyright © 2018 john gospai. All rights reserved.
//
import SpriteKit
import GameplayKit
import GoogleMobileAds
///TODO: change background music and record effect sound.
///TODO: resign
///TODO: change alert.

///TODO: sometimes disappear, maybe computer too fast
///TODO: once cannot place chess and brighterFilters flickering.
///TODO: when click undo quickly in reslut mode, may undo.
///TODO: load challenges
///FIXME: messageBox's closure
class GameScene: SKScene {
    deinit {
        if let GVC = UI.rootViewController as! GameViewController?{
            GVC.bannerView?.removeFromSuperview()
        }
        MusicPlayer.removePreparedMusic(music: .bgm(.game))
        MusicPlayer.removePreparedMusic(music: .sfx(.flip))
        MusicPlayer.removePreparedMusic(music: .sfx(.shake))
        MusicPlayer.removePreparedMusic(music: .sfx(.putChess))
        MusicPlayer.removePreparedMusic(music: .sfx(.win))
        MusicPlayer.removePreparedMusic(music: .sfx(.lose))
        MusicPlayer.removePreparedMusic(music: .sfx(.wind))
        print("GameScene deinit")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(notificationCenterName.reviewSlider.rawValue), object: nil)
    }
    //MARK: - test
    //fileprivate var slots = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    
    //MARK: - settings
    var computer = Player()
    var gameSize = 6
    var needToLoad = false
    var AIlevel = UInt(3)
    var isAIMode = true
    /**
     in online mode or online party, computer is the rival.
     */
    var isComputerWhite = true
    var level = 1
    var difficulty = Challenge.difficultyType.easy
    var withAbility = Reversi.ability.none
    var canPlayerUseAbility = false
    var offline = true
    
    fileprivate var doesPlayerLose = false
    fileprivate var challenges: [Challenge] = []
    //MARK: - parameters for UI designing.
    fileprivate var safeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //MARK: - effect filter
    fileprivate var brighterFilterRow: SKSpriteNode!
    fileprivate var brighterFilterCol: SKSpriteNode!
    
    //MARK: - nodes
    ////m
    fileprivate var background: SKSpriteNode!
    ////m
    fileprivate var backNode: Button!
    
    fileprivate var labels: [[SKLabelNode]] = []
    fileprivate var blackScore_label: ScoreLabel!
    fileprivate var whiteScore_label: ScoreLabel!
    fileprivate var stateIndicator: SKCropNode!
    fileprivate var stateHint: HintBubble!
    fileprivate lazy var computerLabel = SKLabelNode()
    //fileprivate var chessBoard: SKSpriteNode!
    fileprivate var stateIndicatorColorLeft : SKSpriteNode!
    fileprivate var stateIndicatorColorRight: SKSpriteNode!
    fileprivate var stateLabel: SKLabelNode!
    fileprivate var abilityIndicator: SKSpriteNode!
    fileprivate var retryNode:SKSpriteNode!
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var undoNode: SKSpriteNode!
    fileprivate var helpNode: SKSpriteNode!
    fileprivate var optionNode: SKSpriteNode!
    fileprivate var retryHint: HintBubble!
    fileprivate var toTitleHint: HintBubble!
    fileprivate var undoHint: HintBubble!
    fileprivate var helpHint: HintBubble!
    fileprivate var optionHint: HintBubble!
    fileprivate var grid : Grid!
    fileprivate var reviewSlider: CustomSlider!
    fileprivate var chessBoardBackground: SKSpriteNode!
    fileprivate var leftAbilityMenu: AbilityMenu? = nil
    fileprivate var rightAbilityMenu: AbilityMenu? = nil
    
    //MARK: - message boxes
//    fileprivate var helpMessage: MessageBox!
//    fileprivate var undoMessage: MessageBox!
//    fileprivate var retryMessage: MessageBox!
//    fileprivate var earnFlipsMessage: MessageBox!
    
    fileprivate var helpMessage: MessageViewController!
    fileprivate var undoMessage: MessageViewController!
    fileprivate var retryMessage: MessageViewController!
    fileprivate var earnFlipsMessage: MessageViewController!
    
    fileprivate var chessBoardScaledWidth: CGFloat!
    fileprivate var chessBoardScaledHeight: CGFloat!
    fileprivate var borderWidth: CGFloat = 0
    fileprivate var borderHeight: CGFloat = 0
    fileprivate var touchOrigin = CGPoint()
    fileprivate var indexOfTheToppestReview = 0
    fileprivate var scaledLabelAt = (row: 0, col: 0)
    //MARK: - parameters for touchDownCountdown
    //it solves the problem that if quickly move and touch up at other position. Screenshot will get the wrong position.
    fileprivate var touchDownCountdown = 0
    fileprivate var showResultCountdown = 0
    fileprivate var translateCountdown = 0
    //it solves problem that touch up offset < 10 may offset = 100 when move and offset < 10 when touch up
    fileprivate var everMoved = false
    //MARK: - parameters for time
    fileprivate var isComputerThinking = false
    var waitTimeToSetIsUserInteractionEnabledToTrue: TimeInterval = TimeInterval(0){
        didSet{
            if oldValue > waitTimeToSetIsUserInteractionEnabledToTrue{
                if waitTimeToSetIsUserInteractionEnabledToTrue != -1{
                    waitTimeToSetIsUserInteractionEnabledToTrue = oldValue
                }
                else {
                    waitTimeToSetIsUserInteractionEnabledToTrue = 0
                }
            }
        }
    }
    fileprivate var timingToSetIsUserInteractionEnabledToTrue: TimeInterval = TimeInterval(0){
        didSet{
            if oldValue > timingToSetIsUserInteractionEnabledToTrue{
                timingToSetIsUserInteractionEnabledToTrue = oldValue
            }
        }
    }
    fileprivate var canSetIsUserInteractionEnabledToTrue: Bool{
        get{
            if Date().timeIntervalSinceReferenceDate >= timingToSetIsUserInteractionEnabledToTrue {
                return true
            }
            return false
        }
    }
    override var isUserInteractionEnabled: Bool{
        didSet{
            if !canSetIsUserInteractionEnabledToTrue, isUserInteractionEnabled{
                isUserInteractionEnabled = false
            }
        }
    }
    //MARK: - ability option mode
    fileprivate var isDecideTranslateVectorMode = false
    
    //MARK: - parameters for pages
    fileprivate var isReviewMode = false
    fileprivate var isResultMode = false
    
    
    
    //MARK: - parameters for review
    fileprivate var imagesOfReview: [UIImage] = []
    fileprivate var reviews:[SKSpriteNode] = []
    //MARK: - parameters for result
    fileprivate var shareButton: SKSpriteNode!
    fileprivate var shareHint: HintBubble!
    fileprivate var winImage: UIImage!
    fileprivate var screenshotOriginX: CGFloat = 0
    fileprivate var challengeLabelOriginX: CGFloat = 0
    fileprivate var challengeFlipLabelOriginX: CGFloat = 0
    //MARK: - nodes in result
    fileprivate var screenshot: SKSpriteNode!
    fileprivate var challengeLabels: [SKMultilineLabel] = []
    fileprivate var challengeFlipLabels: [SKLabelNode] = []
    //MARK: - parameter for games
    fileprivate var isColorWhiteNow = false
    fileprivate var nowAt = 0
    fileprivate var Game:[Reversi] = []
    
    enum indicatorType: String{
        case translate = "translate"
    }
    
    //MARK: - variables for findBestSolution
    fileprivate var stopFinding: Bool = false
    
    fileprivate var previousPhaseBeforeUndo = phase.game
    enum phase: Int{
        case game, result
    }
    //MARK: - save with JSONEncoder or propertyList
    enum key: String{
        case difficulty = "difficulty"
        case isResultMode = "isResultMode"
        case isReviewMode = "isReviewMode"
        case isAIMode = "isAIMode"
        case isComputerWhite = "isComputerWhite"
        case isColorWhiteNow = "isColorWhiteNow"
        case nowAt = "nowAt"
        case gameSize = "gameSize"
        case AIlevel = "AIlevel"
        case level = "level"
        case withAbility = "withAbility"
        case canPlayerUseAbility = "canPlayerUseAbility"
        case offline = "offline"
    }
    enum notificationCenterName: String{
        case reviewSlider =  "reviewSlider"
    }
    
    
    
    /**
     use cleanUpSavedFile() before any save() to ensure the not too much data creates.
     ### Usage Example: ###
     ````
     let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
     serialQueue.async {
     cleanUpSavedFile()
     save()
     }
     ````
     */
    fileprivate func save(){
        saveUtility.saveImage(image: winImage, filenameOfImage: "winImage")
        UserDefaults.standard.setValue(difficulty.rawValue, forKey: key.difficulty.rawValue)
        UserDefaults.standard.setValue(isReviewMode, forKey: key.isReviewMode.rawValue)
        UserDefaults.standard.setValue(isResultMode, forKey: key.isResultMode.rawValue)
        UserDefaults.standard.setValue(isAIMode, forKey: key.isAIMode.rawValue)
        UserDefaults.standard.setValue(isComputerWhite, forKey: key.isComputerWhite.rawValue)
        UserDefaults.standard.setValue(gameSize, forKey: key.gameSize.rawValue)
        UserDefaults.standard.setValue(AIlevel, forKey: key.AIlevel.rawValue)
        UserDefaults.standard.setValue(level, forKey: key.level.rawValue)
        UserDefaults.standard.setValue(withAbility.rawValue, forKey: key.withAbility.rawValue)
        UserDefaults.standard.setValue(canPlayerUseAbility, forKey: key.canPlayerUseAbility.rawValue)
        UserDefaults.standard.setValue(offline, forKey: key.offline.rawValue)
        UserDefaults.standard.setValue(nowAt, forKey: key.nowAt.rawValue)
        saveUtility.saveGames(games: Game)
        saveUtility.saveImages(images: imagesOfReview, filenamesOfImages: reviews.map{$0.name!})
        print("saved successfully")
        // reviews:[SKSpriteNode] = []
    }
    /**Warning: not always successful*/
    fileprivate func load() {
        difficulty = Challenge.difficultyType(rawValue: UserDefaults.standard.value(forKey: key.difficulty.rawValue) as! Int? ?? difficulty.rawValue)!
        isResultMode = UserDefaults.standard.value(forKey: key.isResultMode.rawValue) as! Bool? ?? isResultMode
        isReviewMode = UserDefaults.standard.value(forKey: key.isReviewMode.rawValue) as! Bool? ?? isReviewMode
        winImage = saveUtility.loadImage(scale: UIScreen.main.scale, filenameOfImage: "winImage") ?? winImage
        Game = saveUtility.loadGames() ?? Game
        
        
        
        AIlevel = UserDefaults.standard.value(forKey: key.AIlevel.rawValue) as! UInt? ?? AIlevel
        level = UserDefaults.standard.value(forKey: key.level.rawValue) as! Int? ?? level
        withAbility = Reversi.ability(rawValue: UserDefaults.standard.value(forKey: key.withAbility.rawValue) as! Int? ?? withAbility.rawValue)!
        canPlayerUseAbility = UserDefaults.standard.value(forKey: key.canPlayerUseAbility.rawValue) as! Bool? ?? canPlayerUseAbility
        offline = UserDefaults.standard.value(forKey: key.offline.rawValue) as! Bool? ?? offline
        
        self.gameSize = Game.first!.n
        isAIMode = UserDefaults.standard.value(forKey: key.isAIMode.rawValue) as! Bool? ?? isAIMode
        isComputerWhite = UserDefaults.standard.value(forKey: key.isComputerWhite.rawValue) as! Bool? ?? isComputerWhite
        
        nowAt = Game.count - 1
        isColorWhiteNow = Game[nowAt].isColorWhiteNow
        //imagesOfReview = saveUtility.loadImages(scale: UIScreen.main.scale) ?? imagesOfReview
        imagesOfReview = saveUtility.loadImages(scale: 1) ?? imagesOfReview
        guard let filenamesOfImages = UserDefaults.standard.value(forKey: "filenamesOfImages") as! [String]? else {return}
        if filenamesOfImages.count == 0 || imagesOfReview.count == 0 {return}
        for i in 0...imagesOfReview.count - 1{
            let review = SKSpriteNode(texture: SKTexture(image: imagesOfReview[i]))
            //review.size = CGSize(width: imagesOfReview[i].size.width * UIScreen.main.scale, height: imagesOfReview[i].size.height * UIScreen.main.scale)
            review.color = .clear
            review.name = "\(filenamesOfImages[i])"
            reviews.append(review)
        }
    }
    fileprivate func cleanUpSavedFile(){
        UserDefaults.standard.removeObject(forKey: key.isAIMode.rawValue)
        UserDefaults.standard.removeObject(forKey: key.isComputerWhite.rawValue)
        saveUtility.removeGamesData()
        saveUtility.removeImagesData()
        
    }
    //TODO: may cause bug since remove too much reviews
    @objc func appMovedToBackground(notification: NSNotification){
        if isAIMode, isColorWhiteNow == isComputerWhite, !isResultMode, previousPhaseBeforeUndo != .result{
            reviews.removeLast()
            imagesOfReview.removeLast()
        }
        cleanUpSavedFile()
        save()
        print("app IN background")
    }
    fileprivate var originalReviewSliderValue: CGFloat = 0.0
    @objc func reviewSliderTouched(){
        let valueToLength = xOfReview(1) - xOfReview(0)
        switch reviewSlider.state! {
        case .begin:
            touchOrigin.x = 0
            originalReviewSliderValue = reviewSlider.value
            setIndexOfTheToppestReview()
            
            touchMovedDuringReviewMode(toPoint: CGPoint(x: -xOfReview(originalReviewSliderValue), y: 0),changeReviewSliderValue: false)
            setIndexOfTheToppestReview()
            touchOrigin.x = xOfReview(reviewSlider.value)
        case .move:
            let valueOffset = reviewSlider.value - originalReviewSliderValue
            touchMovedDuringReviewMode(toPoint: CGPoint(x: -valueOffset * valueToLength, y: 0), changeReviewSliderValue: false)
            
        case .end, .cancel:
            
            let valueOffset = reviewSlider.value - originalReviewSliderValue
            touchUpDuringReviewMode(atPoint: CGPoint(x: -valueOffset * valueToLength, y: 0), changeReviewSliderValue: false)
        }
    }
    //fileprivate let loadingVC = LoadingViewController()
    var doPlayMusicInDidMove = true
    override func didMove(to view: SKView) {
        
        
        winImage = UIImage()
        screenshot = SKSpriteNode()
        SharedVariable.isThereGameToLoad = true
        SharedVariable.save()
        
        Game = [Reversi(n: gameSize)]
        
        //MARK: load games
        if needToLoad {load()}
        
        //MARK: set up computer
        if isAIMode{
            //        scoreDifferenceWeight: 1
            //        sideWeight: 13
            //        CWeight: 32
            //        XWeight: 13
            //        cornerWeight: 50
            //        ,
            //        scoreDifferenceWeight: 1
            //        sideWeight: 55
            //        CWeight: 51
            //        XWeight: 8
            //        cornerWeight: 52
            //        ,
            //        scoreDifferenceWeight: 1
            //        sideWeight: 56
            //        CWeight: 14
            //        XWeight: 51
            //        cornerWeight: 55
            var computer0 = Player()
            let firstPartWeight0 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 54,
                CWeight: -2,
                XWeight: -60,
                cornerWeight: 38,
                mobilityWeight: 0)
            let secondPartWeight0 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 54,
                CWeight: -26,
                XWeight: -53,
                cornerWeight: 59,
                mobilityWeight: 0)
            let thirdPartWeight0 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 10,
                CWeight: -7,
                XWeight: -27,
                cornerWeight: 31,
                mobilityWeight: 0)
            //computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
            computer0.weights = [firstPartWeight0, secondPartWeight0, thirdPartWeight0]
            computer0.name = "computer0"
            computer0.searchDepth = AIlevel
            
            var computer1 = Player()
            let firstPartWeight1 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 54,
                CWeight: -2,
                XWeight: -60,
                cornerWeight: 38)
            let secondPartWeight1 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 54,
                CWeight: -26,
                XWeight: -53,
                cornerWeight: 59)
            let thirdPartWeight1 = Weight(
                scoreDifferenceWeight: 1,
                sideWeight: 10,
                CWeight: -7,
                XWeight: -27,
                cornerWeight: 31)
            //computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
            computer1.weights = [firstPartWeight1, secondPartWeight1, thirdPartWeight1]
            computer1.name = "computer1"
            computer1.searchDepth = AIlevel
            
            var computer2 = Player()
//            let firstPartWeight2 = Weight(
//                scoreDifferenceWeight: 1,
//                sideWeight: 54,
//                CWeight: -2,
//                XWeight: -60,
//                cornerWeight: 38)
//            let secondPartWeight2 = Weight(
//                scoreDifferenceWeight: 1,
//                sideWeight: 54,
//                CWeight: -26,
//                XWeight: -53,
//                cornerWeight: 59)
//            let thirdPartWeight2 = Weight(
//                scoreDifferenceWeight: 1,
//                sideWeight: 10,
//                CWeight: -7,
//                XWeight: -27,
//                cornerWeight: 31)
            //computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
            computer2.weights =
                [
                    Weight(
                    scoreDifferenceWeight: 1,
                    sideWeight: 5,
                    CWeight: -16,
                    XWeight: -48,
                    cornerWeight: 46,
                    mobilityWeight: 44)
                    ,Weight(
                    scoreDifferenceWeight: 1,
                    sideWeight: 5,
                    CWeight: -14,
                    XWeight: -34,
                    cornerWeight: 44,
                    mobilityWeight: 43)
                    ,Weight(
                    scoreDifferenceWeight: 1,
                    sideWeight: 1,
                    CWeight: -19,
                    XWeight: -34,
                    cornerWeight: 47,
                    mobilityWeight: 34)
            ]
            computer2.name = "computer2"
            computer2.searchDepth = AIlevel
            ///set up computer
            switch difficulty{
            case .easy:
                computer = computer0
            case .normal:
                computer = computer1
            case .hard:
                computer = computer2
            }
        }
        
        //MARK: set up challenge
        challenges = isAIMode ? Challenge.sharedChallenge(gameSize: gameSize, isColorWhite: !isComputerWhite, level: level, difficulty: difficulty) : []
        //MARK: set time
        timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSinceReferenceDate
        // set background
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
        //self.backgroundColor = UIColor.white
        
        //MARK: play background music
        if !doPlayMusicInDidMove{
            MusicPlayer.preparePlayer(music: .bgm(.game))
        }
        else{
            MusicPlayer.play(music: .bgm(.game))
        }
        
        
        
        
        
        //view.isMultipleTouchEnabled = false
        
        self.size = CGSize(width: UI.frameWidth, height: UI.frameHeight)
        
        
        
        
        
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
        if !isAIMode{
            UI.addPattern(to: bgCtx)
        }
        else {
            if !isComputerWhite{
                UI.addPattern(to: bgCtx, type: .white)
            }
            else {
                UI.addPattern(to: bgCtx, type: .black)
            }
        }
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        background.zPosition = UI.zPosition.background
        addChild(background)
        
        
        
        ////m
        // MARK: define safeArea
        safeAreaInsets = UI.safeInsets
        //print(safeAreaInsets)
        
        //print(view.frame.size)
        self.isUserInteractionEnabled = true
        //test
//        slots.position = UI.logoPosition
//        slots.zPosition = UI.zPosition.logo
//        addChild(slots)
        //test
        
        //MARK: - set ability
        Reversi.withAbility = withAbility
        //MARK: - set up flipsIndicator
        UI.flipsIndicator.withAnimation = false
        
        if !isComputerWhite && isAIMode {
            UI.flipsIndicator.flipsColor = .white}
        else {
            UI.flipsIndicator.flipsColor = .black
        }
        UI.flipsIndicator.flips = SharedVariable.flips
        UI.addFlipsIndicator(to: self)
//        chessBoard = SKSpriteNode(color: #colorLiteral(red: 0.5176470588, green: 0.7647058824, blue: 0.3019607843, alpha: 1), size: CGSize(width: UI.gridSize, height: UI.gridSize))
//        chessBoard.zPosition = UI.zPosition.chessBoard
        //        chessBoard.yScale = (scene!.size.height * 1/2) / chessBoard.mapSize.height
        //        chessBoard.xScale = chessBoard.yScale
        //
        //        if chessBoard!.mapSize.width * chessBoard.xScale > scene!.size.width{
        //            chessBoard.xScale = (scene!.size.width - 100) / chessBoard.mapSize.width
        //            chessBoard.yScale = chessBoard.xScale
        //        }
        //
        //
        //
        chessBoardScaledWidth = UI.gridSize
        chessBoardScaledHeight = UI.gridSize
        
        // MARK: set up chessBoard background
        let chessBoardBackgroundSize = CGSize(width: chessBoardScaledWidth * 12.0/11.0 ,height:  chessBoardScaledHeight * 12.0/11.0)
        chessBoardBackground = SKSpriteNode(texture: SKTexture(imageNamed: "chessBoardBackground"), size: chessBoardBackgroundSize)
        chessBoardBackground.zPosition = UI.zPosition.chessBoardBackground
        addChild(chessBoardBackground)
        ///set up chessBoard background
        
//        borderWidth = (view.frame.width - chessBoard!.mapSize.width * chessBoard!.xScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
//        borderHeight = (view.frame.height -         chessBoard!.mapSize.height * chessBoard!.yScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
        //print("borderWidth: ", borderWidth)
        
        
        
        
        //MARK: - set up menu
        //MARK: set up toTitleNode
        toTitleNode = SKSpriteNode(imageNamed: "toTitle")
        toTitleNode.size = UI.menuIconSize
        toTitleNode.position = UI.getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 3)
        toTitleNode.zPosition = UI.zPosition.menuIcon
        addChild(toTitleNode)
        //MARK: set up retryNode
        retryNode = SKSpriteNode(imageNamed: "retry")
        retryNode.size = UI.menuIconSize
        retryNode.position = UI.getMenuIconPosition(indexFromLeft: 2, numberOfMenuIcon: 3)
        retryNode.zPosition = UI.zPosition.menuIcon
        addChild(retryNode)
        //MARK: set up undoNode
        undoNode = SKSpriteNode(imageNamed: "undo")
        undoNode.size = UI.menuIconSize
        undoNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 3)
        undoNode.zPosition = UI.zPosition.menuIcon
        addChild(undoNode)
        //MARK: set up helpNode
        helpNode = SKSpriteNode(imageNamed: "help")
        helpNode.size = UI.menuIconSize
        helpNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 5)
        helpNode.zPosition = UI.zPosition.menuIcon
        addChild(helpNode)
        //MARK: set up optionNode
        optionNode = SKSpriteNode(imageNamed: "option")
        optionNode.size = UI.menuIconSize
        optionNode.position = UI.getMenuIconPosition(indexFromLeft: 3, numberOfMenuIcon: 5)
        optionNode.zPosition = UI.zPosition.menuIcon
        addChild(optionNode)
        //MARK: - set up hints
        //MARK: set up toTitleHint
        let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        toTitleHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        toTitleHint.attachTo = toTitleNode
        toTitleHint.text = UI.Texts.backToTitle
        toTitleHint.isHidden = true
        toTitleHint.fontSize = UI.menuIconHintLabelFontSize
        toTitleHint.zPosition = UI.zPosition.menuHint
        addChild(toTitleHint)
        //MARK: set up undoHint
        undoHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        undoHint.attachTo = undoNode
        undoHint.text = UI.Texts.undo
        undoHint.isHidden = true
        undoHint.fontSize = UI.menuIconHintLabelFontSize
        undoHint.zPosition = UI.zPosition.menuHint
        addChild(undoHint)
        //MARK: set up retryHint
        retryHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        retryHint.attachTo = retryNode
        retryHint.text = UI.Texts.retry
        retryHint.isHidden = true
        retryHint.fontSize = UI.menuIconHintLabelFontSize
        retryHint.zPosition = UI.zPosition.menuHint
        addChild(retryHint)
        //MARK: set up helpHint
        helpHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        helpHint.attachTo = helpNode
        helpHint.text = UI.Texts.help
        helpHint.isHidden = true
        helpHint.fontSize = UI.menuIconHintLabelFontSize
        helpHint.zPosition = UI.zPosition.menuHint
        addChild(helpHint)
        //MARK: set up optionHint
        optionHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        optionHint.attachTo = optionNode
        optionHint.text = UI.Texts.option
        optionHint.isHidden = true
        optionHint.fontSize = UI.menuIconHintLabelFontSize
        optionHint.zPosition = UI.zPosition.menuHint
        addChild(optionHint)
        
        // MARK: initialize labels in the game board.
        for row in 0...gameSize - 1{
            var row_label: [SKLabelNode] = []
            for col in 0...gameSize - 1{
                //let x = borderWidth + (chessBoard!.mapSize.width * chessBoard!.xScale) / CGFloat(gameSize) * CGFloat(col) - view.frame.midX
                //let y = view.frame.midY - borderHeight -  (chessBoard!.mapSize.height * chessBoard!.yScale) / CGFloat(gameSize) * CGFloat(row)
                let x = -UI.gridSize/2 + UI.gridSize/CGFloat(gameSize)*(CGFloat(col)+0.5)
                let y = UI.gridSize/2 - UI.gridSize/CGFloat(gameSize)*(CGFloat(row)+0.5)
                let position = CGPoint(x: x, y: y)
                //label
                let label = SKLabelNode()
                label.name = "label_\(row),\(col)"
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .center
                label.text = ""
                label.position = position
                label.fontName = UI.chessFontName
                label.fontColor = SKColor.yellow
                label.fontSize = UI.gridSize / CGFloat(gameSize) * 3/5
                row_label.append(label)
                addChild(label)
                
            }
            labels.append(row_label)
        }
        //TODO: online randomize isComputerWhite
        if !offline{
            isComputerWhite = true
        }
        // MARK: initialize score labels
        blackScore_label = ScoreLabel(fontColor: .black)
        whiteScore_label = ScoreLabel(fontColor: .white)
        addChild(blackScore_label)
        addChild(whiteScore_label)
        let needToArrangeUpDown = (isAIMode || !offline)
        
       // blackScore_label.fontColor = SKColor.black
        blackScore_label.fontSize = needToArrangeUpDown && !isComputerWhite ? UI.secondaryScoreFontSize:UI.primaryScoreFontSize
        blackScore_label.score = Game[nowAt].getBlackScore()
        blackScore_label.anchorPoint.y = needToArrangeUpDown && !isComputerWhite ? 0:1
        blackScore_label.zPosition = UI.zPosition.scoreLabel
        blackScore_label.position = UI.blackScorePosition
        blackScore_label.position.y *= needToArrangeUpDown && !isComputerWhite ? -1:1
        
        //whiteScore_label!.fontColor = SKColor.white
        whiteScore_label.fontSize = needToArrangeUpDown && isComputerWhite ? UI.secondaryScoreFontSize:UI.primaryScoreFontSize
        whiteScore_label.score = Game[nowAt].getWhiteScore()
        whiteScore_label.anchorPoint.y = needToArrangeUpDown && isComputerWhite ?  0:1
        whiteScore_label.zPosition = UI.zPosition.scoreLabel
        whiteScore_label.position = UI.whiteScorePosition
        whiteScore_label.position.y *= needToArrangeUpDown && isComputerWhite ? -1:1
        
        updateAbilityCoolDownStateOnScoreLabels()
        
        
        //MARK: initialize computer label
        if isAIMode{
            computerLabel.text = "COM\(difficulty.rawValue+1)"
            addChild(computerLabel)
            computerLabel.zPosition = UI.zPosition.scoreLabel
            computerLabel.position.x = isComputerWhite ? blackScore_label.position.x : whiteScore_label.position.x
            computerLabel.position.y = !isComputerWhite ? blackScore_label.position.y : whiteScore_label.position.y
            computerLabel.fontSize = UI.secondaryScoreFontSize
            computerLabel.fontColor = isComputerWhite ? .white : .black
            computerLabel.fontName = UI.fontName.ChalkboardSEBold.rawValue
            computerLabel.verticalAlignmentMode = .bottom
            
        }
        
        //MARK: initialize an abilityMenu
        let abilityMenuHandler: (_ ability: Reversi.ability) -> Void = {[unowned self] in
            switch $0 {
            case .translate:
                self.translate()
            default:
                break
            }
        }
        if canPlayerUseAbility{
            if !isComputerWhite{
                leftAbilityMenu = AbilityMenu(handler: abilityMenuHandler)
                leftAbilityMenu!.attachTo = whiteScore_label
                addChild(leftAbilityMenu!)
                
                if offline{
                    rightAbilityMenu = AbilityMenu(handler: abilityMenuHandler)
                    rightAbilityMenu!.attachTo = blackScore_label
                    addChild(rightAbilityMenu!)
                    
                }
            }
            else {
                rightAbilityMenu = AbilityMenu(handler: abilityMenuHandler)
                rightAbilityMenu!.attachTo = blackScore_label
                addChild(rightAbilityMenu!)
                
                if offline{
                    leftAbilityMenu = AbilityMenu(handler: abilityMenuHandler)
                    leftAbilityMenu!.attachTo = whiteScore_label
                    addChild(leftAbilityMenu!)
                }
            }
        }
        
        //initialize a grid
        let blockSize = UI.gridSize / CGFloat(gameSize)
        let lineWidth = blockSize/20
        grid = Grid(color: isColorWhiteNow ? SKColor.white : SKColor.black, blockSize: blockSize, rows: gameSize, cols: gameSize,lineWidth: lineWidth)!
        grid.position = CGPoint (x:0, y:0)
        grid.name = "grid"
        grid.zPosition = UI.zPosition.grid
        addChild(grid)
        
        //MARK: set brighterFilter
        brighterFilterRow = SKSpriteNode()
        brighterFilterCol = SKSpriteNode()
        brighterFilterRow.zPosition = UI.zPosition.brighterFilter
        brighterFilterCol.zPosition = UI.zPosition.brighterFilter
        brighterFilterCol.size = CGSize(width: (grid.frame.width-lineWidth) / CGFloat(gameSize) + lineWidth, height: grid.frame.height)
        brighterFilterRow.size = CGSize(width: grid.frame.width, height: (grid.frame.height-lineWidth)/CGFloat(gameSize) + lineWidth)
        brighterFilterCol.isHidden = true
        brighterFilterRow.isHidden = true
        addChild(brighterFilterCol)
        addChild(brighterFilterRow)
        //initialize a review slider
        let barColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        let sliderColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        let activeSliderColor = sliderColor.withAlphaComponent(1.0)
        reviewSlider = CustomSlider(notificationName: notificationCenterName.reviewSlider.rawValue, count: 1, barColor: barColor, sliderColor: sliderColor, activeSliderColor: activeSliderColor, barLength: 0.75 * size.width, barWidth: grid.size.width / 16)
        reviewSlider.position = CGPoint(x: 0, y: -4/10 * size.height)
        reviewSlider.zPosition = UI.zPosition.reviewSlider
        
        //initialize stateIndicator with mask and show upArrow
        stateIndicator = SKCropNode()
        let stateIndicatorSize =
            CGSize(
                width: UI.gridSize / 6.0,
                height: UI.gridSize / 6.0)
        
        let upArrowImageNode = SKSpriteNode(imageNamed: "upArrow")
        upArrowImageNode.size = stateIndicatorSize
        stateIndicator.maskNode = upArrowImageNode
        stateIndicator.position = CGPoint(x:0,y: (-8.0 / 12.0) * UI.gridSize)
        stateIndicator.zPosition = UI.zPosition.stateIndicator
        
        stateIndicatorColorLeft = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: stateIndicator.frame.width / 2, height: stateIndicator.frame.height))
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorLeft.name = "stateIndicatorColorLeft"
        stateIndicator.addChild(stateIndicatorColorLeft)
        
        
        stateIndicatorColorRight = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: stateIndicator.frame.width / 2, height: stateIndicator.frame.height))
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorRight.name = "stateIndicatorColorRight"
        stateIndicator.addChild(stateIndicatorColorRight)
        
        addChild(stateIndicator)
        //MARK: initialize state label
        stateLabel = SKLabelNode()
        stateLabel = (labels[0][0].copy() as! SKLabelNode)
        stateLabel.name = "stateLabel"
        stateLabel.isHidden = true
        stateLabel.fontSize = stateIndicatorSize.height
        stateLabel.zPosition = UI.zPosition.stateIndicator
        addChild(stateLabel)
        
        //MARK: prepare background color animation
        if self.isAIMode{
            self.prepareBackgroundColorAnimation(fps: 15, duration: 0.6)
        }
        //MARK: update state indicator
        updateStateIndicator(nowAt)
        //MARK: set up the state hint
        stateHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)!
        stateHint.attachTo = stateIndicator
        stateHint.text = isAIMode ? UI.Texts.state : UI.Texts.resign
        stateHint.isHidden = true
        stateHint.fontSize = UI.menuIconHintLabelFontSize
        stateHint.zPosition = UI.zPosition.menuHint
        addChild(stateHint)
        
        //MARK: set up abilityIndicator
        UIGraphicsBeginImageContextWithOptions(UI.menuIconSize, false, UIScreen.main.scale)
        let abilityCtx = UIGraphicsGetCurrentContext()
        let roundedRect = UIBezierPath(roundedRect: CGRect(origin: .zero, size: UI.menuIconSize), cornerRadius: UI.abilityMenuRoundedCornerRadius)
        abilityCtx?.saveGState()
        roundedRect.addClip()
        let translateImg = #imageLiteral(resourceName: "translate")
        translateImg.draw(in: CGRect(origin: .zero, size: UI.menuIconSize))
        abilityCtx?.restoreGState()
        let abilityImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        abilityIndicator = SKSpriteNode(texture: SKTexture(image: abilityImg), size: UI.menuIconSize)
        abilityIndicator.position = stateIndicator.position
        abilityIndicator.isHidden = true
        abilityIndicator.zPosition = UI.zPosition.stateIndicator
        addChild(abilityIndicator)
        
        //MARK: set up backNode
        backNode = Button(buttonColor: UI.backFromUndoButtonColor, cornerRadius: UI.backFromUndoFontSize)!
        backNode.fontSize = UI.backFromUndoFontSize
        backNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        backNode.position = UI.backFromUndoPosition
        backNode.zPosition = UI.zPosition.back
        backNode.text = UI.Texts.back
        
        self.showBoard(self.nowAt)
        Game[nowAt].showBoard(isWhite: isColorWhiteNow)
        
        //MARK: - set up bannerView
        if SharedVariable.withAds{
            if let GVC = UI.rootViewController as! GameViewController?{
                if let bannerView = GVC.bannerView{
                    view.addSubview(bannerView)
                    let x = CGFloat.zero//frame.width/2 - bannerView.frame.width/2
                    let minY = min(UI.flipsIndicator.frame.minY, backNode.frame.minY)
                    let topY = (frame.height/2 - minY)
                    let bottomY = frame.height/2 - max(-UI.whiteScorePosition.y + UI.secondaryScoreFontSize,  chessBoardBackground.frame.maxY,
                        3/5*frame.height/2)
                    let spacing = (bottomY - topY)/20
                    bannerView.frame.origin = CGPoint(x: x, y: topY + spacing)
                    let adSize = GADAdSizeFromCGSize(CGSize(width: frame.width, height: (bottomY - topY) - 2*spacing))
                    bannerView.adSize = adSize
                }
                
            }
        }
        
        //MARK: set up notificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.appMovedToBackground(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.reviewSliderTouched), name: NSNotification.Name(notificationCenterName.reviewSlider.rawValue), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.rewardBasedVideoAdDidClose), name: .rewardBasedVideoAdDidClose, object: nil)
        
        //MARK: set up help message box
        //let helpGuideText = UI.Texts.guide.help
        let helpGuideTitle = UI.Texts.message.help.title
        let helpMessageActionsTitle = [
            UI.Texts.message.help.default_,
            UI.Texts.message.help.destructive
        ]
        let helpMessageActions = [
            MessageAction(title: helpMessageActionsTitle[0], style: .default, handler: {}),
            MessageAction(title: helpMessageActionsTitle[1], style: .destructive, handler: {}),
        ]
        //self.helpMessage = MessageBox(title: helpGuideTitle, text: helpGuideText, actions: helpMessageActions)
        helpMessage = MessageViewController(title: helpGuideTitle, url: URL.html.help, actions: helpMessageActions)
        
        //self.addChild(self.helpMessage)
        //self.helpMessage.isHidden = true
        
        //MARK: set up undo message box
        let undoHandler: () -> Void = {[unowned self] in
            print("destructive")
            if SharedVariable.flips < 1, SharedVariable.withAds{
                print("you don't have enough Flips")
                //self.earnFlipsMessage.isHidden = false
                if UI.rootViewController?.presentedViewController?.isBeingPresented == true{
                    UI.rootViewController?.presentedViewController?.dismiss(animated: true)
                }
                 UI.rootViewController?.present(self.earnFlipsMessage,animated: true)
                
            }
            else{
                self.touchOnTheToppestReview(self.reviews[self.indexOfTheToppestReview])
                if SharedVariable.withAds{
                    SharedVariable.flips -= 1
                    UI.flipsIndicator.flips = SharedVariable.flips
                }
            }
            
        }
        let undoGuideText = UI.Texts.message.undo.text
        let undoGuideTitle = UI.Texts.message.undo.title
        let undoDestructiveText = SharedVariable.withAds ? UI.Texts.message.undo.destructive : UI.Texts.message.undo.destructiveWithoutAds
        let undoMessageActionsTitle = [
            UI.Texts.message.undo.default,
            undoDestructiveText
        ]
        let undoMessageActions = [
            MessageAction(title: undoMessageActionsTitle[0], style: .default, handler: {}),
            MessageAction(title: undoMessageActionsTitle[1], style: .destructive, handler: undoHandler),
        ]
        //self.undoMessage = MessageBox(title: undoGuideTitle, text: undoGuideText, actions: undoMessageActions, isWithScroll: false)
        self.undoMessage = MessageViewController(title: undoGuideTitle, message: undoGuideText, actions: undoMessageActions)
//        self.addChild(self.undoMessage)
//        self.undoMessage.isHidden = true
        
        //MARK: set up retry message box
        let retryHandler: () -> Void = {[unowned self] in
            NotificationCenter.default.post(name: .showGoogleAds, object: nil)
            print("destructive")
            //remove all saved data
            self.cleanUpSavedFile()
            if let view = self.view {
                //let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene = GameScene(fileNamed: "GameScene")!
                scene.gameSize = self.gameSize
                scene.isAIMode = self.isAIMode
                scene.isComputerWhite = self.isComputerWhite
                scene.AIlevel = self.AIlevel
                scene.level = self.level
                scene.difficulty = self.difficulty
                scene.withAbility =  self.withAbility
                scene.canPlayerUseAbility = self.canPlayerUseAbility
                scene.offline = self.offline
                if SharedVariable.withAds{
                    scene.doPlayMusicInDidMove = false
                }
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                //view.presentScene(scene, transition: transition)
            }
        }
        let retryGuideText = UI.Texts.message.retry.text
        let retryGuideTitle = UI.Texts.message.retry.title
        let retryMessageActionsTitle = [
            UI.Texts.message.retry.default_,
            UI.Texts.message.retry.destructive
        ]
        let retryMessageActions = [
            MessageAction(title: retryMessageActionsTitle[0], style: .default, handler: {}),
            MessageAction(title: retryMessageActionsTitle[1], style: .destructive, handler: retryHandler),
        ]
        //self.retryMessage = MessageBox(title: retryGuideTitle, text: retryGuideText, actions: retryMessageActions, isWithScroll: false)
        self.retryMessage = MessageViewController(title: retryGuideTitle, message: retryGuideText, actions: retryMessageActions)
        //self.addChild(self.retryMessage)
        //self.retryMessage.isHidden = true
        
        
        //MARK: set up earnFlips Messagebox
        let earnFlipsHandler: () -> Void = {
            print("default")
            notificationCenter.post(name: .showRewardedVideos, object: nil)
        }
        let earnFlipsGuideText = UI.Texts.message.earnFlips.text
        let earnFlipsGuideTitle = UI.Texts.message.earnFlips.title
        let earnFlipsMessageActionsTitle = [
            UI.Texts.message.earnFlips.default_,
            UI.Texts.message.earnFlips.destructive
        ]
        let earnFlipsMessageActions = [
            MessageAction(title: earnFlipsMessageActionsTitle[0], style: .default, handler: earnFlipsHandler),
            MessageAction(title: earnFlipsMessageActionsTitle[1], style: .destructive, handler: {}),
        ]
        //self.earnFlipsMessage = MessageBox(title: earnFlipsGuideTitle, text: earnFlipsGuideText, actions: earnFlipsMessageActions, isWithScroll: false)
        self.earnFlipsMessage = MessageViewController(title: earnFlipsGuideTitle, message: earnFlipsGuideText, actions: earnFlipsMessageActions)
        //self.addChild(self.earnFlipsMessage)
        //self.earnFlipsMessage.isHidden = true
        
        let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: DispatchQoS.userInteractive)
        if self.isAIMode && self.isColorWhiteNow == self.isComputerWhite && !self.Game[self.nowAt].isEnd(){
            computerPlay(serialQueue)
        }
        //FIXME: translate
//        let angleVeclocity = 8.0 * CGFloat.pi / 3.0
//        self.undoNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: angleVeclocity, duration: 1)))
//            if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: self.AIlevel, stopFinding: &self.stopFinding){
//                UI.loadingVC.dismiss(animated: true, completion: nil)
//                self.isUserInteractionEnabled = false
//                waitTimeToSetIsUserInteractionEnabledToTrue = 0.6
//                run(SKAction.wait(forDuration: 0.6)){
//                    self.undoNode.removeAllActions()
//                    self.undoNode.zRotation = 0
//                    //save game state
//                    self.saveGameState()
//                    self.play(row: bestStep.row, col: bestStep.col){
//                        //if player needs to pass, then computer will keep playing.
//                        if self.isColorWhiteNow == self.isComputerWhite{
//                            //self.run(SKAction.wait(forDuration: 0.65)){
//                            self.touchDownOnGrid(row: 0, col: 0)
//                            //}
//                        }
//                    }
//                }
//
//            }
//                //when stop finding
//            else{
//                self.undoNode.removeAllActions()
//                self.undoNode.zRotation = 0
//            }
//
//        }
        
        
        
        
        
        if isResultMode{
            //Challenge.loadSharedChallenge()
            showResult()
        }
        else if isReviewMode{
            undo(withTakingScreenshot: false, withAnimation: false)
        }
        /*
         //Light
         reviewLight = SKLightNode()
         reviewLight.position = CGPoint(x: 0, y: 0)
         reviewLight.isEnabled = true
         reviewLight.categoryBitMask = 1
         reviewLight.falloff = 0
         reviewLight.ambientColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.87)
         reviewLight.lightColor = SKColor(red: 0.8, green: 0.8, blue: 0.4, alpha: 0.8)
         reviewLight.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
         addChild(reviewLight)
         */
    }
    override func willMove(from view: SKView) {
        stopFinding = true
        cleanUpSavedFile()
        save()
    }
    fileprivate func lightCell(row: Int, col: Int, color: UIColor) {
        let blockSize = UI.gridSize / CGFloat(gameSize)
        let lineWidth = blockSize/20
        let filterRowPosX = CGFloat(0)
        let filterColPosY = CGFloat(0)
        let filterRowPosY = grid.frame.minY + 0.5*lineWidth + (grid.frame.height-lineWidth)/CGFloat(gameSize) * (CGFloat(gameSize-1 - row) + 0.5)
        let filterColPosX = grid.frame.minX + 0.5*lineWidth + (grid.frame.width-lineWidth)/CGFloat(gameSize) * (CGFloat(col) + 0.5)
        
        brighterFilterCol.position = CGPoint(x: filterColPosX, y: filterColPosY)
        
        brighterFilterRow.position = CGPoint(x: filterRowPosX, y: filterRowPosY)
        brighterFilterRow.color = color
        brighterFilterCol.color = color
        
        brighterFilterCol.isHidden = false
        brighterFilterRow.isHidden = false
    }
    fileprivate func updateAbilityCoolDownStateOnScoreLabels(withUpdate: Bool = true){
        if nowAt < 4, canPlayerUseAbility{
            whiteScore_label.currentNumber = 0
            blackScore_label.currentNumber = 0
        }
        else{
            whiteScore_label.currentNumber = 3 - Game[nowAt].getAbilityCoolDown(isWhite: true)
            blackScore_label.currentNumber = 3 - Game[nowAt].getAbilityCoolDown(isWhite: false)
        }
        
        if withUpdate{
            whiteScore_label.update()
            blackScore_label.update()
        }
        
    }
    fileprivate func play(currentCondition: Reversi.condition = .none, row: Int = -1, col: Int = -1, action: @escaping () -> Void = {}) {
        var needToShake = false
        var animationType = Reversi.ability.none
        let abilityCoolDown = Game[nowAt].getAbilityCoolDown(isWhite: isColorWhiteNow)
        Game[nowAt].setAbilityCoolDown(isWhite: isColorWhiteNow, duration: abilityCoolDown - 1)
        
//        if let currentAbilityMenu = isColorWhiteNow ? leftAbilityMenu:rightAbilityMenu{
        
//        }
        
        if abilityCoolDown == 0, withAbility == .translate, ((currentCondition == .translate && isAIMode && isComputerWhite == isColorWhiteNow) || (!isAIMode)){
            print("use ability translate")
            animationType = .translate
            Game[nowAt].translate(dx: translateVector.x, dy: translateVector.y)
            Game[nowAt].setAbilityCoolDown(isWhite: isColorWhiteNow, duration: 3)
            isColorWhiteNow = !isColorWhiteNow
            
//            self.isUserInteractionEnabled = false
//            self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.6
//            grid.run(SKAction.wait(forDuration: 0.6)){
//                self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
//                self.isUserInteractionEnabled = true
//            }
        }
        else{
            if Game[nowAt].fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){
                isColorWhiteNow = !isColorWhiteNow
                
//                //change grid color
//                if grid.color != (isColorWhiteNow ? .white : .black){
//                    self.isUserInteractionEnabled = false
//                    /////p
//                    self.waitTimeToSetIsUserInteractionEnabledToTrue = isThereAFlipBackAnimation ? 1.2:0.6
//                    grid.run(SKAction.wait(forDuration: self.isThereAFlipBackAnimation ? 1.2:0.6)){
//                        self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
//                        //action()
//                        self.isUserInteractionEnabled = true
//                    }
//                }
                
            }
            else {
                //shake!!
                needToShake = true
                Game[nowAt].setAbilityCoolDown(isWhite: isColorWhiteNow, duration: abilityCoolDown)
                print("Unavailable move at \(row), \(col)")
            }
        }
        
        updateAbilityCoolDownStateOnScoreLabels(withUpdate: false)
        if Game[nowAt].isEnd(){
//            //show crown
//            var isWinnerWhite: Bool? = Game[nowAt].getWhiteScore() > Game[nowAt].getBlackScore()  ? true : false
//            if Game[nowAt].getWhiteScore() == Game[nowAt].getBlackScore(){
//                isWinnerWhite = nil
//            }
//            if let isWinnerWhite = isWinnerWhite{
//                isColorWhiteNow = isWinnerWhite
//                let winColor = isWinnerWhite ? UIColor.white : UIColor.black
//                changeStateIndicator(imageNamed: "crown", width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4, leftColor: winColor, rightColor: winColor)
//
//                print("\(isWinnerWhite  ? "White" : "Black") won!! White: \(Game[nowAt].getWhiteScore()) Black: \(Game[nowAt].getBlackScore())")
//            }
//                //If the state is draw.
//            else {
//                changeStateIndicator(imageNamed: "scale", width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4, leftColor: .white, rightColor: .black)
//            }
//
            var isWinnerWhite: Bool? = Game[nowAt].getWhiteScore() > Game[nowAt].getBlackScore()  ? true : false
            if Game[nowAt].getWhiteScore() == Game[nowAt].getBlackScore(){
                isWinnerWhite = nil
            }
            if let isWinnerWhite = isWinnerWhite{
                isColorWhiteNow = isWinnerWhite
            }
        }
        else if Game[nowAt].needToPass(Color: isColorWhiteNow){
            print("\(isColorWhiteNow ? "White" : "Black") cannot move")
            isColorWhiteNow = !isColorWhiteNow
        }
        
        if !needToShake{
            //Game[nowAt].setAbilityCoolDown(isWhite: !isColorWhiteNow, duration: Game[nowAt-1].getAbilityCoolDown(isWhite: !isColorWhiteNow))
            self.showBoard(self.nowAt, withAnimation: true, animationType: animationType){
                action()
            }
            Game[nowAt].showBoard(isWhite: isColorWhiteNow)
        }
        
        
        
        
        //blackScore_label!.text = "\(Game[nowAt].getBlackScore())"
        //whiteScore_label!.text = "\(Game[nowAt].getWhiteScore())"
        
        if needToShake, !isComputerThinking{
            print("shake")
            var nodes: [SKNode] = []
            for i in 0...gameSize * gameSize - 1{
                nodes.append(labels[i / gameSize][i % gameSize] as SKNode)
                
            }
//            nodes.append(chessBoard! as SKNode)
            nodes.append(chessBoardBackground)
            
            grid.shake(duration: 0.6, amplitudeX:10.0, numberOfShakes: 4)
            grid.run(SKAction.run {
                MusicPlayer.reset(music: .sfx(.shake))
                MusicPlayer.play(music: .sfx(.shake))
            })
            for node in nodes{
                node.shake(duration: 0.6, amplitudeX: 10.0, numberOfShakes: 4)
            }
            self.isUserInteractionEnabled = false
            waitTimeToSetIsUserInteractionEnabledToTrue = 0.7
            nodes.first!.run(SKAction.wait(forDuration: 0.6)){self.isUserInteractionEnabled = true}
            
            needToShake = false
        }
        Game[nowAt].isColorWhiteNow = isColorWhiteNow
        //change the color of stateIndicator
//        if !Game[nowAt].isEnd() {
//            let color = isColorWhiteNow ? UIColor.white : UIColor.black
//            changeStateIndicator(imageNamed: "upArrow", width: stateIndicator.frame.width, height: stateIndicator.frame.height,leftColor: color,rightColor: color)
//        }
    }
    fileprivate func retryInResultMode(){
        NotificationCenter.default.post(name: .showGoogleAds, object: nil)
        isResultMode = false
        //remove all saved data
        self.cleanUpSavedFile()
        if let view = self.view {
            
            let scene = GameScene(fileNamed: "GameScene")!
            scene.gameSize = self.gameSize
            scene.isAIMode = self.isAIMode
            scene.isComputerWhite = self.isComputerWhite
            scene.AIlevel = self.AIlevel
            scene.level = self.level
            scene.difficulty = self.difficulty
            scene.withAbility =  self.withAbility
            scene.canPlayerUseAbility = self.canPlayerUseAbility
            scene.offline = self.offline
            
            scene.scaleMode = .aspectFill
            scene.cleanUpSavedFile()
            if SharedVariable.withAds{
                scene.doPlayMusicInDidMove = false
            }
            DispatchQueue.main.async {
                view.presentScene(scene)
            }
            
            
            
            
            
            
            
        }
    }
    fileprivate func retry(){
//        let handler: (UIAlertAction) -> Void  = { action in
//            switch action.style{
//            case .default:
//                print("default")
//                //remove all saved data
//                self.cleanUpSavedFile()
//                if let view = self.view {
//                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
//                    let scene = GameScene(fileNamed: "GameScene")!
//                    scene.gameSize = self.gameSize
//                    scene.isAIMode = self.isAIMode
//                    scene.isComputerWhite = self.isComputerWhite
//                    scene.scaleMode = .aspectFill
//                    view.presentScene(scene, transition: transition)
//                }
//            case .cancel:
//                print("cancel")
//
//            case .destructive:
//                print("destructive")
//            }}
//        let message = NSLocalizedString("alert.retry.message", comment: "")
//        let actionDefaultTitle = NSLocalizedString("alert.retry.action.default.title", comment: "")
//        let actionDestructiveTitle = NSLocalizedString("alert.retry.action.destructive.title", comment: "")
//        let alertTitle = NSLocalizedString("alert.retry.title", comment: "")
//        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: actionDefaultTitle, style: .default, handler: handler))
//        alert.addAction(UIAlertAction(title: actionDestructiveTitle, style: .destructive, handler: handler))
//        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
//
        UI.topMostController()?.present(retryMessage, animated: true)
        //retryMessage.isHidden = false
        //if retryMessage.parent == nil { addChild(retryMessage)}
        
        
    }
    fileprivate func yOfReview(_ x: CGFloat) -> CGFloat{
        return 1 - abs(2 * x / CGFloat.pi)
    }
    //this is based on the position of indexWithMaxZPositionInReviews
    fileprivate func xOfReview(_ i: CGFloat) -> CGFloat{
        return CGFloat(i - CGFloat(indexOfTheToppestReview)) * scene!.size.width / CGFloat(5)
    }
    fileprivate func xOfReview(_ i: CGFloat, base: Int) -> CGFloat{
        return CGFloat(i - CGFloat(base)) * scene!.size.width / CGFloat(5)
    }
    //this is based on the position of indexWithMaxZPositionInReviews
    fileprivate func xOfReview(_ i: Int) -> CGFloat{
        return CGFloat(i - indexOfTheToppestReview) * scene!.size.width / CGFloat(5)
    }
    fileprivate func xOfReview(_ i: Int, base: Int) -> CGFloat{
        return CGFloat(i - base) * scene!.size.width / CGFloat(5)
    }
    //get the scale of i-th review should be; offset is the base position; base is index
    fileprivate func scaleOfReview(_ i: Int, base: Int, offset: CGFloat = 0) -> CGFloat{
        return 3/5 * yOfReview((xOfReview(i,base: base) + offset) * CGFloat.pi / 2 / scene!.size.width)
    }
    fileprivate func zPositionOfReview(_ i: Int) -> CGFloat{
        return UI.zPosition.reviewBase + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
    }
    fileprivate func setIndexOfTheToppestReview(){
        for i in 0...reviews.count - 1{
            if reviews[i].zPosition > reviews[indexOfTheToppestReview].zPosition{
                indexOfTheToppestReview = i
            }
        }
        print("indexOfTheToppestReview = ", indexOfTheToppestReview)
    }
    fileprivate func takeScreenShot(isWhite: Bool){
        ///take the first screenshot
        guard let bounds = self.scene!.view?.bounds else{fatalError("cannot get bounds of view")}
    
        if Game[nowAt].isEnd(){
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        }
        else{
            UIGraphicsBeginImageContext(bounds.size)
        }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let roundedRaius = safeAreaInsets.bottom > 20 ? 40:safeAreaInsets.bottom
        let roundedBounds = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(roundedRaius))
        context.saveGState()
        roundedBounds.addClip()
        self.scene?.view?.drawHierarchy(in: bounds ,afterScreenUpdates: false)
        context.addPath(roundedBounds.cgPath)
        context.setLineWidth(10.0)
        context.setStrokeColor(isWhite ? UIColor.white.cgColor : UIColor.black.cgColor)
        context.strokePath()
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let review = SKSpriteNode(texture: SKTexture(image: image!))
        review.color = .clear
        imagesOfReview.append(image!)
        reviews.append(review)
        //review.lightingBitMask = 1
        review.name = "review_\(nowAt)"
        ///take the first screenshot
    }
    fileprivate func showReview(withAnimation: Bool){
        print("showReview")
        if withAnimation{
            for i in 0...reviews.count - 1{
                reviews[i].setScale(1)
                reviews[i].position = CGPoint(x:  xOfReview(i), y: 0.0)
                reviews[i].zPosition = UI.zPosition.reviewBase + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
                addChild(reviews[i])
                let scaleAnimation = SKAction.scale(to: 3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
                waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                isUserInteractionEnabled = false
                reviews[i].run(scaleAnimation){self.isUserInteractionEnabled = true
                    self.isReviewMode = true
                }
            }
        }
        else{
            for i in 0...reviews.count - 1{
                
                reviews[i].position = CGPoint(x:  xOfReview(i), y: 0.0)
                reviews[i].zPosition = UI.zPosition.reviewBase + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
                reviews[i].setScale(3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width))
                addChild(reviews[i])
                self.isReviewMode = true
            }
        }
        
    }
    fileprivate func addAllChildrenBeforePreview(){
        UI.addFlipsIndicator(to: self)
        for labelRow in labels{
            for label in labelRow{
                addChild(label)
            }
        }
        ////m
        addChild(background)
        ////m
        addChild(blackScore_label)
        addChild(whiteScore_label)
        addChild(stateIndicator)
        addChild(stateHint)
        addChild(stateLabel)
        addChild(abilityIndicator)
        addChild(computerLabel)
//        addChild(chessBoard)
        addChild(retryNode)
        addChild(toTitleNode)
        addChild(undoNode)
        addChild(helpNode)
        addChild(optionNode)
        addChild(retryHint)
        addChild(toTitleHint)
        addChild(undoHint)
        addChild(helpHint)
        addChild(optionHint)
        //addChild(helpMessage)
        //addChild(retryMessage)
        addChild(grid)
        addChild(brighterFilterRow)
        addChild(brighterFilterCol)
        addChild(chessBoardBackground)
        if let leftAbilityMenu = leftAbilityMenu{addChild(leftAbilityMenu)}
        if let rightAbilityMenu = rightAbilityMenu{addChild(rightAbilityMenu)}
    }
    fileprivate func undo(withTakingScreenshot: Bool = true, withAnimation: Bool = true){
        //NotificationCenter.default.post(name: .showGoogleAds, object: nil)
        if !isAIMode{
            isDecideTranslateVectorMode = false
            withAbility = .none
            abilityIndicator.isHidden = true
        }
        
        print("undo withTakingScreenshot: ", withTakingScreenshot, "withAnimation ", withAnimation)
        self.stopFinding = true
        
        if withTakingScreenshot{ takeScreenShot(isWhite: self.isColorWhiteNow) }
        indexOfTheToppestReview = reviews.count - 1
    
        removeAllChildren()
        //addChild(undoMessage)
        //addChild(earnFlipsMessage)
        let reviewBackground = SKSpriteNode(color: .black, size: scene!.size)
        print(scene!.size)
        reviewBackground.name = "reviewBackground"
        reviewBackground.zPosition = UI.zPosition.reviewBackground
        addChild(reviewBackground)
        UI.addFlipsIndicator(to: reviewBackground)
        
        reviewSlider.count = reviews.count
        reviewSlider.value = CGFloat(reviewSlider.count - 1)
        addChild(reviewSlider)
        
        addChild(backNode)
        
        showReview(withAnimation: withAnimation)
        
    }
    fileprivate func moveToDecideTranslateVector(){
        isDecideTranslateVectorMode = false
        abilityIndicator.isHidden = true
        if !isAIMode, withAbility == .translate, translateVector.x != 0 || translateVector.y != 0{
            
            takeScreenShot(isWhite: self.isColorWhiteNow)

            //save game state
            saveGameState()
            self.Game[self.nowAt].didLastTurnUseAbility = true
            play(currentCondition: .translate) {
                self.withAbility = .none
                if self.Game[self.nowAt].isEnd(){
                    //self.isUserInteractionEnabled = false
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                    if self.showResultCountdown == 0{
                        self.showResultCountdown = 2
                    }
                }
            }
        }
        else{
            withAbility = .none
        }
    }
    fileprivate func computerPlay(_ serialQueue: DispatchQueue) {
        let currentCondition = self.Game[self.nowAt].currentCondition
        let abilityCoolDown = Game[nowAt].getAbilityCoolDown(isWhite: isColorWhiteNow)
        if abilityCoolDown == 0, withAbility != .none, currentCondition != .none{
            //save game state
            saveGameState()
            play(currentCondition: currentCondition){
                if self.Game[self.nowAt].isEnd(){
                    //self.isUserInteractionEnabled = false
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                    if self.showResultCountdown == 0{
                        self.showResultCountdown = 2
                    }
                    
                }
                    //if player needs to pass, then computer will keep playing.
                else if self.isColorWhiteNow == self.isComputerWhite{
                    //self.run(SKAction.wait(forDuration: 0.65)){
                    self.touchDownOnGrid(row: 0, col: 0)
                    //}
                }
            }
        }
        else {
            
            let angleVeclocity = 8.0 * CGFloat.pi / 3.0
            undoNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: angleVeclocity, duration: 1)))
            self.isComputerThinking = true
            serialQueue.async {
                let weight = self.computer.weight(turn: self.nowAt, gameSize: self.gameSize)
                if let bestStep = self.Game[self.nowAt].bestSolution(
                    isWhite: self.isColorWhiteNow,
                    searchDepth: self.AIlevel,
                    stopFinding: &self.stopFinding,
                    weight: weight){
                    DispatchQueue.main.async {
                        self.isComputerThinking = false
                        self.undoNode.removeAllActions()
                        self.undoNode.zRotation = 0
                        //save game state
                        self.saveGameState()
                        self.play(row: bestStep.row, col: bestStep.col){
                            if self.Game[self.nowAt].isEnd(){
                                self.isUserInteractionEnabled = false
                                self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                                if self.showResultCountdown == 0{
                                    self.showResultCountdown = 2
                                }
                            }
                                //if player needs to pass, then computer will keep playing.
                            else if self.isColorWhiteNow == self.isComputerWhite{
                                //self.run(SKAction.wait(forDuration: 0.65)){
                                self.touchDownOnGrid(row: 0, col: 0)
                                //}
                            }
                        }
                    }
                }
                    //when stop finding
                else{
                    self.isComputerThinking = false
                    self.undoNode.removeAllActions()
                    self.undoNode.zRotation = 0
                }
            }
        }
    }
    
    fileprivate func touchDownOnGrid(row: Int, col: Int){
        //        //AIblack vs AIwhite
        //         if !self.Game[self.nowAt].isEnd(){
        //             //black 5 white 3
        //             let searchDepth = isColorWhiteNow ? 4 : 1
        //            if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: UInt(searchDepth), stopFinding: &stopFinding){
        //             //save game state
        //             saveGameState()
        //             run(SKAction.wait(forDuration: 0.7)){
        //                 self.play(row: bestStep.row, col: bestStep.col){
        //                 //keep playing
        //                    self.touchDownOnGrid(row: 0, col: 0)
        //                     }
        //                 }
        //             }
        //         }
        let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: DispatchQoS.userInteractive)
        self.isUserInteractionEnabled = false
        if !isAIMode || isColorWhiteNow != isComputerWhite{
            if self.Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
                
                //take a screenshot before play
                takeScreenShot(isWhite: self.isColorWhiteNow)
                //save game state
                saveGameState()
                Game[nowAt].didLastTurnUseAbility = false
            }
            play(row: row, col: col){
                if self.Game[self.nowAt].isEnd(){
                    //self.isUserInteractionEnabled = false
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                    if self.showResultCountdown == 0{
                        self.showResultCountdown = 2
                    }
                }
                    //if it is computer's turn
                else if self.isAIMode && self.isColorWhiteNow == self.isComputerWhite{
                    //self.run(SKAction.wait(forDuration: 0.5)){
                    self.touchDownOnGrid(row: 0, col: 0)
                    //}
                }
            }
        }
        else if !isComputerThinking{
            computerPlay(serialQueue)
        }
        
        
        
        /*
         if !isAIMode || isColorWhiteNow != isComputerWhite{
         if Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
         takeScreenShot(isWhite: self.isColorWhiteNow)
         
         if nowAt == Game.count - 1{
         Game.append(Game[nowAt])
         }
         else {
         Game[nowAt + 1] = Game[nowAt]
         
         }
         nowAt = nowAt + 1
         
         if grid.color != (isColorWhiteNow ? .white : .black){
         grid.run(SKAction.wait(forDuration: 0.6)){
         self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
         }
         }
         
         }
         touchDownOnGrid(row: row, col: col)
         }
         
         ///AI
         if self.isColorWhiteNow == isComputerWhite && isAIMode && !self.Game[nowAt].isEnd(){
         takeScreenShot(isWhite: self.isColorWhiteNow)
         self.run(SKAction.wait(forDuration: 0.7)){
         if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: 3){
         if self.nowAt == self.Game.count - 1{
         self.Game.append(self.Game[self.nowAt])
         }
         else {
         self.Game[self.nowAt + 1] = self.Game[self.nowAt]
         
         }
         self.nowAt = self.nowAt + 1
         self.touchDownOnGrid(row: bestStep.row, col: bestStep.col)
         }
         }
         
         }
         */
        ///AI
    }
    fileprivate func touchMovedDuringReviewMode(toPoint pos : CGPoint, changeReviewSliderValue: Bool = true) {
        let offset = pos.x - touchOrigin.x
        let distanceBetweenToppestAndFirst = reviews[indexOfTheToppestReview].position.x - reviews.first!.position.x
        let distanceBetweenToppestAndLast = reviews.last!.position.x -  reviews[indexOfTheToppestReview].position.x
        
        print("indexWithMaxZPositionInReviews = ", indexOfTheToppestReview)
        print("offset = ", offset)
        //        if reviews.first!.position.x > 0 {
        //            for i in 0...reviews.count - 1{
        //                reviews[i].position.x = xOfReview(i, base: 0) + offset - distanceBetweenToppestAndFirst
        //                reviews[i].setScale(scaleOfReview(i, base: 0))
        //                reviews[i].zPosition = zPositionOfReview(i)
        //            }
        //            if changeReviewSliderValue {reviewSlider.value = 0}
        //        }
        //        else if reviews.last!.position.x < 0{
        //            for i in 0...reviews.count - 1{
        //                reviews[i].position.x = xOfReview(i, base: reviews.count - 1) + offset + distanceBetweenToppestAndLast
        //                reviews[i].setScale(scaleOfReview(i, base: reviews.count - 1))
        //                reviews[i].zPosition = zPositionOfReview(i)
        //            }
        //            if changeReviewSliderValue {reviewSlider.value = CGFloat(reviews.count - 1)}
        //        }
        if offset >= distanceBetweenToppestAndFirst {
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i, base: 0)
                reviews[i].setScale(scaleOfReview(i, base: 0))
                reviews[i].zPosition = zPositionOfReview(i)
            }
            if changeReviewSliderValue {reviewSlider.value = 0}
        }
        else if -offset >= distanceBetweenToppestAndLast{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i, base: reviews.count - 1)
                reviews[i].setScale(scaleOfReview(i, base: reviews.count - 1))
                reviews[i].zPosition = zPositionOfReview(i)
            }
            if changeReviewSliderValue {reviewSlider.value = CGFloat(reviews.count - 1)}
        }
        else{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i) + offset
                reviews[i].setScale(3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width))
                reviews[i].zPosition = UI.zPosition.reviewBase + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            }
            
            if changeReviewSliderValue {
                let lengthBetweenTwoReviews = xOfReview(1, base: 0) - xOfReview(0,base: 0)
                print("lengthBetw tWEodfkjl : ", lengthBetweenTwoReviews)
                reviewSlider.value = CGFloat(indexOfTheToppestReview) - offset / lengthBetweenTwoReviews}
        }
    }
    fileprivate func touchUp(atPoint pos : CGPoint){
        
    }
    fileprivate func touchUpDuringReviewMode(atPoint pos : CGPoint, changeReviewSliderValue: Bool = true) {
        
        /* if reviews.first!.position.x > 0 {
         isUserInteractionEnabled = false
         for i in 0...reviews.count - 1{
         reviews[i].run(SKAction.moveTo(x: CGFloat(i) * scene!.size.width / CGFloat(reviews.count), duration: 0.5)){self.isUserInteractionEnabled = true}
         }
         }
         else if reviews.last!.position.x < 0{
         isUserInteractionEnabled = false
         for i in 0...reviews.count - 1{
         reviews[i].run(SKAction.moveTo(x: -CGFloat(reviews.count - 1 - i) * scene!.size.width / CGFloat(reviews.count), duration: 0.5)){self.isUserInteractionEnabled = true}
         }
         }*/
        /*let maxZPosition = reviews[indexWithMaxZPositionInReviews].zPosition
         for i in 0...reviews.count - 1{
         if reviews[i].zPosition > maxZPosition{
         offset = -reviews[i].position.x
         indexWithMaxZPositionInReviews = i
         }
         }*/
        setIndexOfTheToppestReview()
        //let offset = -reviews[indexOfTheToppestReview].position.x
        for i in 0...reviews.count - 1{
            reviews[i].position.x = xOfReview(i, base: indexOfTheToppestReview)
            reviews[i].setScale(3/5 * yOfReview(xOfReview(i, base: indexOfTheToppestReview) * CGFloat.pi / 2 / scene!.size.width))
        }
        if changeReviewSliderValue {reviewSlider.value = CGFloat(indexOfTheToppestReview)}
        //        self.isUserInteractionEnabled = false
        //        for i in 0...reviews.count - 1{
        //            let moveToBestPosition = SKAction.group([
        //                SKAction.moveTo(x: xOfReview(i, base: indexOfTheToppestReview), duration: 0.2),
        //                SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview(xOfReview(i, base: indexOfTheToppestReview) * CGFloat.pi / 2 / scene!.size.width), duration: 0.2)
        //                ])
        //            reviews[i].run(moveToBestPosition){
        //                self.isUserInteractionEnabled = true
        //            }
        //        }
        
        
    }
    fileprivate func showState(row: Int, col: Int){
        stateLabel.isHidden = false
        stateLabel.text = labels[row][col].text
        stateLabel.fontColor = labels[row][col].fontColor
        stateLabel.position = stateIndicator.position
        stateIndicator.isHidden = true
        abilityIndicator.isHidden = true
    }
    fileprivate func endShowingState(){
        stateLabel.isHidden = true
        
    }
    fileprivate func touchesUpOnShareButton(){
        //show share button
        if var top = scene?.view?.window?.rootViewController {
            while let presentedViewController = top.presentedViewController {
                top = presentedViewController
            }
            //let firstActivityItem = "Text you want"
            // If you want to put an image
            let image : UIImage = winImage
            
            let activityVC = UIActivityViewController(
                activityItems: [image], applicationActivities: nil)
            // This lines is for the popover you need to show in iPad
            activityVC.popoverPresentationController?.sourceView = view
            activityVC.excludedActivityTypes = [.addToReadingList, .airDrop,.assignToContact,.message,.postToFacebook,.postToFlickr,.postToTencentWeibo,.postToVimeo,.postToTwitter,.postToWeibo]
            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes?.append(.openInIBooks)
            }
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: max(10, size.width/2 + screenshot.position.x), y: size.height/2, width: 0, height: 0)
            // This line remove the arrow of the popover to show in iPad
            //activityVC.popoverPresentationController?.permittedArrowDirections = .down
            top.present(activityVC, animated: true, completion: nil)
        }
    }
    /**
     Decide which challenge finished and update the state of challenges.
     */
    fileprivate func updateTheStateOfChallenge() -> [UIColor]{
        var fontColor = Array(repeating: UIColor.white, count: challenges.count)
        
        if challenges.isEmpty{
            return []
        }
        for i in 0...challenges.count - 1{
            if self.isComputerWhite == challenges[i].isCompleted{
                fontColor[i] = .black
            }
            switch challenges[i].type{
            case .win:
                if (Game[nowAt].doesWhiteWin() && !isComputerWhite) ||
                    (Game[nowAt].doesBlackWin() && isComputerWhite){
                    challenges[i].isCompleted = true
                }
                else {challenges[i].isCompleted = challenges[i].isCompleted}
            case .getPoints:
                let points = challenges[i].getChallengeParametersForGetPoints()
                if (Game[nowAt].getWhiteScore() >= points && !isComputerWhite) ||
                    (Game[nowAt].getBlackScore() >= points && isComputerWhite){
                    challenges[i].isCompleted = true
                }
                else {challenges[i].isCompleted = challenges[i].isCompleted}
            case .winTheComputerByPoints:
                let byPoints = challenges[i].getChallengeParametersForWinTheComputerByPoints()
                if (Game[nowAt].getScoreDifference(isWhite: true) >= byPoints && !isComputerWhite) ||
                    (Game[nowAt].getScoreDifference(isWhite: false) >= byPoints && isComputerWhite){
                    challenges[i].isCompleted = true
                }
                else {challenges[i].isCompleted = challenges[i].isCompleted}
            }
            
            if !challenges[i].canGetOneFlip, challenges[i].isCompleted{
                fontColor[i] = fontColor[i].withAlphaComponent(0.5)
            }
        }
        return fontColor
    }
    
    fileprivate func showResult() {
        let fontColor = updateTheStateOfChallenge()
        isReviewMode = false
        isResultMode = true
        
        removeAllChildren()
        
        //MARK: set up the background
        ////m
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let bgCtx = UIGraphicsGetCurrentContext()
        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
        
        //        let bgStartColor = UIColor(red: 254/255, green: 207/255, blue: 239/255, alpha: 1)
        //
        //        let bgMidColor = UIColor(red: 509/510, green: 361/510, blue: 397/510, alpha: 1)
        //
        //        let bgEndColor = UIColor(red: 255/255, green: 154/255, blue: 158/255, alpha: 1)
        //let bgStartColor = UIColor(red: 255/255, green: 126/255, blue: 179/255, alpha: 1)
        let bgStartColor = !doesPlayerLose ? #colorLiteral(red: 1, green: 0.4941176471, blue: 0.7019607843, alpha: 1) : #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        
        //let bgMidColor = UIColor(red: 510/510, green: 243/510, blue: 319/510, alpha: 1)
        let bgMidColor = !doesPlayerLose ? #colorLiteral(red: 1, green: 0.4784313725, blue: 0.6274509804, alpha: 1) : #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
        //let bgEndColor = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1)
        let bgEndColor = !doesPlayerLose ? #colorLiteral(red: 0.9515926242, green: 0.4722153544, blue: 0.5480275154, alpha: 1) : #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        
        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
        
        let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
        
        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
        bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
        if !doesPlayerLose{
            UI.addHappyPattern(to: bgCtx)
        }
        else{
            UI.addSadPattern(to: bgCtx)
        }
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let background = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        ////m
        //let background = SKSpriteNode(color: .red, size: size)
        background.zPosition = UI.zPosition.resultBackground
        addChild(background)
        //MARK: add menu button
        UI.addFlipsIndicator(to: background)
        background.addChild(retryNode)
        background.addChild(undoNode)
        background.addChild(toTitleNode)
        background.addChild(retryHint)
        background.addChild(undoHint)
        background.addChild(toTitleHint)
        //MARK: set up a share button.
        shareButton = SKSpriteNode(texture: SKTexture(image: UIImage(named: "share")!))
        let iconSideLength = UI.gridSize / 8
        shareButton.size = CGSize(width: iconSideLength, height: iconSideLength)
        shareButton.position = UI.shareButtonPosition
        shareButton.zPosition = UI.zPosition.shareButton
        addChild(shareButton)
        //MARK: set up a shareHint
        let bubbleColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        shareHint = HintBubble(bubbleColor: bubbleColor, bounds: BoundsOfHintBubble)!
        shareHint.attachTo = shareButton
        shareHint.text = UI.Texts.share
        shareHint.isHidden = true
        shareHint.fontSize = UI.menuIconHintLabelFontSize
        shareHint.zPosition = UI.zPosition.shareHint
        background.addChild(shareHint)
        //MARK: add a screenshot.
        let screenshotRatio = winImage.size.width / winImage.size.height
        screenshot = SKSpriteNode(texture: SKTexture(image: winImage), size: size)
        screenshot.zPosition = UI.zPosition.screenshot
        addChild(screenshot)
        
        //MARK: set up challenges
        var defaultChallengeFlipLabelWidth: CGFloat = 0.0
        var accumulativeChallengeLabelHeight: CGFloat = 0.0
        if challenges.count != 0{
            for i in 0...challenges.count - 1{
                let challengeFlipLabelNumber = (challenges[i].isCompleted && !challenges[i].canGetOneFlip) ? 1 : 0
                let challengeFlipLabel = SKLabelNode(text: Unicode.circledNumber(challengeFlipLabelNumber))
                challengeFlipLabel.fontColor = fontColor[i]
                challengeFlipLabel.name = "challengeFilpLabel \(i)"
                //challengeFlipLabel.verticalAlignmentMode = .center
                challengeFlipLabel.verticalAlignmentMode = .top
                challengeFlipLabel.position.x = size.width - grid.size.width / 2.0 + challengeFlipLabel.frame.width / 2
                challengeFlipLabel.zPosition = UI.zPosition.challengeFlipLabel
                challengeFlipLabel.fontSize = UI.challengeFlipLabelFontSize
                challengeFlipLabel.fontName = UI.challengeFlipLabelFontName
                addChild(challengeFlipLabel)
                challengeFlipLabels.append(challengeFlipLabel)
                
                let challengeLabelText = "\(challenges[i].description)"
                let challengeLabelWidth = grid.size.width - challengeFlipLabels[i].frame.width * 2
                let challengeLabel = SKMultilineLabel(text: challengeLabelText, labelWidth: challengeLabelWidth)
                //let challengeLabel = SKLabelNode(text: "\(challenges[i].description)")
                challengeLabel.fontColor = fontColor[i]
                challengeLabel.name = "challengeLabel \(i)"
                //                if #available(iOS 11.0, *) {
                //                    challengeLabel.lineBreakMode = .byWordWrapping
                //                    challengeLabel.numberOfLines = 0
                //                    challengeLabel.preferredMaxLayoutWidth = grid.size.width - challengeFlipLabels[i].frame.width * 2
                //                } else {
                //                    fatalError("implement me for ios 10")
                //                    //TODO: Fallback on earlier versions
                //                }
                challengeLabel.anchorPoint = CGPoint(x: 0, y: 1)
                challengeLabel.alignment = .left
                challengeLabel.position.x = challengeFlipLabels[i].frame.maxX + challengeFlipLabels[i].frame.width
                challengeLabel.position.y =  -CGFloat(i) * undoHint.fontSize * 2 - accumulativeChallengeLabelHeight + grid.size.height / 2
                challengeLabel.zPosition = UI.zPosition.challengeLabel
                challengeLabel.fontSize = UI.challengeLabelFontSize
                challengeLabel.fontName = UI.challengeLabelFontName
                accumulativeChallengeLabelHeight += challengeLabel.frame.height
                addChild(challengeLabel)
                challengeLabels.append(challengeLabel)
                
            }
            //MARK: center challengeLabels vertically
            let center = (challengeLabels.first!.frame.maxY + challengeLabels.last!.frame.minY)/2
            let offset = -center
            for i in 0...challenges.count - 1{
                challengeLabels[i].position.y += offset
                challengeFlipLabels[i].position.y = challengeLabels[i].frame.maxY
            }
            defaultChallengeFlipLabelWidth = challengeFlipLabels.first!.frame.width
        }
        
        //MARK: animation of screenshot
        let screenshotRotation = -CGFloat.pi / 36.0
        let screenshotHeight = grid.size.height / (cos(screenshot.zRotation) - screenshotRatio * sin(screenshot.zRotation))
        let screenshotWidth = screenshotHeight * screenshotRatio
        let flashlight = SKSpriteNode(color: .white, size: size)
        flashlight.zPosition = UI.zPosition.flashlight
        addChild(flashlight)
        flashlight.alpha = 0.0
        let animationOfFlashlight =
            SKAction.sequence([
                SKAction.fadeIn(withDuration: 0.2),
                SKAction.fadeOut(withDuration: 0.2)
                ])
        let animationOfPlacingScreenshot = SKAction.group([
            SKAction.rotate(toAngle: screenshotRotation, duration: 0.6),
            SKAction.resize(toWidth: screenshotWidth, height: screenshotHeight, duration: 0.6)
            ])
        let animationOfMovingScreenshot = SKAction.moveTo(x: -size.width, duration: 0.2)
        //MARK: animation of moving challenge to the left
        
        let animationOfMovingChallenge =
            SKAction.moveTo(x: -grid.size.width / 2.0 + 2 * defaultChallengeFlipLabelWidth, duration: 0.2)
        let animationOfMovingChallengeFlip =
            SKAction.moveTo(x: -grid.size.width / 2.0 + defaultChallengeFlipLabelWidth / 2, duration: 0.2)
        
        self.isUserInteractionEnabled = false
        var animationWaitTime = 0.0
        // MARK: - run animations
        // MARK: run animation of flashlight
        flashlight.run(animationOfFlashlight){self.removeChildren(in: [flashlight])}
        animationWaitTime += 0.4
        //MARK: run animation of placing screenshot
        screenshot.run(SKAction.sequence([
            SKAction.wait(forDuration: animationWaitTime),
            animationOfPlacingScreenshot
            ]))
        animationWaitTime += 0.6
        //MARK: - run animation of moving the screenshot and challenges if there are challenges.
        if !self.challenges.isEmpty{
            //MARK: run animation of moving the screenshot
            screenshot.run(SKAction.sequence([
                SKAction.wait(forDuration: animationWaitTime),
                animationOfMovingScreenshot
                ]))
            //MARK: run animation of moving challenges
            for i in 0...challenges.count - 1{
                challengeLabels[i].run(SKAction.sequence([
                    SKAction.wait(forDuration: animationWaitTime),
                    animationOfMovingChallenge
                    ]))
                challengeFlipLabels[i].run(SKAction.sequence([
                    SKAction.wait(forDuration: animationWaitTime),
                    animationOfMovingChallengeFlip
                    ]))
            }
            animationWaitTime += 0.2
            var indexOfChallengesThatCanGetOneFlip: [Int] = []
            //MARK: - animation of getting flips
            //MARK: get the index that can get one flip
            for i in 0...challenges.count - 1{
                if challenges[i].canGetOneFlip{
                    indexOfChallengesThatCanGetOneFlip.append(i)
                }
            }
            var animationWaitTimeForFlips = animationWaitTime + 0.3
            for index in indexOfChallengesThatCanGetOneFlip{
                //MARK: flip
                challengeFlipLabels[index].run(SKAction.sequence([
                    SKAction.wait(forDuration: animationWaitTimeForFlips),
                    SKAction.scaleX(to: 0, duration: 0.3),
                    SKAction.changeFontColor(to: !isComputerWhite ? .white: .black),
                    SKAction.run {self.challengeFlipLabels[index].text = "\(Unicode.circledNumber(1))"},
                    SKAction.scaleX(to: 1, duration: 0.3)
                    ]))
                //MARK: change color of challenge label
                challengeLabels[index].run(SKAction.sequence([
                    SKAction.wait(forDuration: animationWaitTimeForFlips + 0.3),
                    SKAction.changeFontColor(to: !isComputerWhite ? .white : .black)
                    ]))
                //MARK: animation of flip flying
                let challengeFlipLabel = challengeFlipLabels[index].copy() as! SKLabelNode
                challengeFlipLabel.xScale = 1
                challengeFlipLabel.removeAllActions()
                challengeFlipLabel.fontColor = !isComputerWhite ? .white : .black
                challengeFlipLabel.position.x += -size.width
                challengeFlipLabel.text = "\(Unicode.circledNumber(1))"
                addChild(challengeFlipLabel)
                challengeFlipLabel.isHidden = true
                let path = CGMutablePath()
                path.move(to: challengeFlipLabel.position)
                path.addQuadCurve(to: UI.flipsIndicator.flipsLabelPosition,
                                  control:
                    CGPoint(x: UI.flipsIndicator.flipsLabelPosition.x,
                            y: challengeFlipLabel.position.y)
                )
                let animationOfFlipsFlying = SKAction.group([
                    SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1.2),
                    SKAction.scale(to: 8.5/10*UI.flipsFontSize/UI.challengeLabelFontSize, duration: 1.2)
                    ])
                challengeFlipLabel.run(SKAction.sequence([
                    SKAction.wait(forDuration: animationWaitTimeForFlips + 0.9),
                    SKAction.unhide(),
//                    SKAction.run{self.challengeFlipLabels[index].text = "\(Unicode.circledNumber(0))"},
                    animationOfFlipsFlying
                    ])){
                        SharedVariable.flips += 1
                        UI.flipsIndicator.flips = SharedVariable.flips
                        self.removeChildren(in: [challengeFlipLabel])
                }
                animationWaitTimeForFlips += 0.3
            }
            //MARK: plus time the animation of flips takes and 0.3 for last animation's end
            animationWaitTime += 0.3
            if !indexOfChallengesThatCanGetOneFlip.isEmpty{
                animationWaitTime += 2.1 + Double(indexOfChallengesThatCanGetOneFlip.count)*0.3
            }
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: animationWaitTime),
                SKAction.run{
                    Challenge.saveSharedChallenge()
                    SharedVariable.isThereGameToLoad = false
                    SharedVariable.save()
                    
                    if Challenge.areAllChallengesCompleted, SharedVariable.withAds{
                        KeychainWrapper.standard.set(false, forKey: SharedVariable.key.withAds.rawValue)
                        SharedVariable.withAds = false
                        if let GVC = UI.rootViewController as! GameViewController?{
                            GVC.bannerView?.removeFromSuperview()
                        }
                        let VC = GetUnlimitedUndosAndNoAdsVC()
                        UI.rootViewController?.present(VC, animated: true, completion: nil)
                    }
                    
                }
                ]))
        }
        else{
            SharedVariable.isThereGameToLoad = false
            SharedVariable.save()
        }
        waitTimeToSetIsUserInteractionEnabledToTrue = animationWaitTime
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if isResultMode, !challenges.isEmpty{
                challengeLabelOriginX = challengeLabels.first!.position.x
                challengeFlipLabelOriginX = challengeFlipLabels.first!.position.x
                screenshotOriginX = screenshot.position.x
            }
            touchOrigin = touch.location(in: self)
            let node = atPoint(touchOrigin)
            if node != grid, !isAIMode{
                withAbility = .none
                isDecideTranslateVectorMode = false
                abilityIndicator.isHidden = true
            }
            switch node{
            case childNode(withName: "grid") :
                let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: touchOrigin)
                guard let row = touchPosOnGrid?.row else {return}
                guard let col = touchPosOnGrid?.col else {return}
                
                if !isDecideTranslateVectorMode{
                    labels[row][col].fontSize = UI.gridSize / CGFloat(gameSize)
                    labels[row][col].zPosition = grid.zPosition + 1
                    scaledLabelAt.row = row
                    scaledLabelAt.col = col
                    showState(row: row, col: col)
                }
                
                let colorComponent: CGFloat = isColorWhiteNow ? 1.0 : 0.0
                let lightColor = UIColor(red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 0.3)
                lightCell(row: row, col: col, color: lightColor)
            case toTitleNode:
                toTitleHint.isHidden = false
            case retryNode:
                retryHint.isHidden = false
            case undoNode:
                undoHint.isHidden = false
            case helpNode:
                helpHint.isHidden = false
            case optionNode:
                optionHint.isHidden = false
            case shareButton:
                shareHint.isHidden = false
            case stateIndicatorColorLeft, stateIndicatorColorRight:
                stateHint.isHidden = false
            default:
                if backNode.nodesTouched.contains(node){
                    backNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                }
                break
            }
            
        }
    }
    fileprivate func touchMovedDuringResultMode(toPoint: CGPoint){
        toTitleHint.isHidden = true
        retryHint.isHidden = true
        undoHint.isHidden  = true
        shareHint.isHidden = true
        stateHint.isHidden = true
        if toPoint.y <= grid.frame.maxY, toPoint.y >= grid.frame.minY, !challenges.isEmpty{
            let offset = toPoint.x - touchOrigin.x
            //now is on screenshot page or now is on challenge page
            if (challengeFlipLabelOriginX >= size.width / 2 && offset <= 0) || (challengeFlipLabelOriginX < size.width / 2 && offset > 0){
                for i in 0...challenges.count - 1{
                    challengeFlipLabels[i].position.x = challengeFlipLabelOriginX + offset
                    challengeLabels[i].position.x = challengeLabelOriginX + offset
                }
                screenshot.position.x = screenshotOriginX + offset
            }
        }
        else{
            let node = atPoint(toPoint)
            switch node{
            case retryNode:
                retryHint.isHidden = false
            case undoNode:
                undoHint.isHidden = false
            case toTitleNode:
                toTitleHint.isHidden = false
            case shareButton:
                shareHint.isHidden = false
            case stateIndicatorColorRight, stateIndicatorColorLeft:
                stateHint.isHidden = false
            default:
                break
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first
        {
            backNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            if abs(t.location(in: self).x - touchOrigin.x) > 10{
                everMoved = true
            }
            endShowingState()
            stateIndicator.isHidden = isDecideTranslateVectorMode
            
            if isReviewMode{
                if backNode.nodesTouched.contains(atPoint(t.location(in: self))){
                    backNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                }
                else {
                    self.touchMovedDuringReviewMode(toPoint: t.location(in: self))
                }
                print("touches.count = ", touches.count)
            }
            else if isResultMode{
                self.touchMovedDuringResultMode(toPoint: t.location(in: self))
            }
            else{
                
                brighterFilterRow.isHidden = true
                brighterFilterCol.isHidden = true
                toTitleHint.isHidden = true
                retryHint.isHidden = true
                undoHint.isHidden  = true
                stateHint.isHidden = true
                helpHint.isHidden = true
                optionHint.isHidden = true
                
                labels[scaledLabelAt.row][scaledLabelAt.col].zPosition = 0
                let pos = t.location(in: self)
                let node = atPoint(pos)
                if isDecideTranslateVectorMode{
                    if node == grid{
                        responseOfMovingWhileDecidingTranslateVector(pos: pos)
                    }
                    else{
                        isDecideTranslateVectorMode = false
                        withAbility = .none
                        abilityIndicator.isHidden = true
                        labelsBackToTheirPos()
                    }
                }
                else{
                    labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = UI.gridSize / CGFloat(gameSize) * 3/5
                    //labels[scaledLabelAt.row][scaledLabelAt.col].zPosition = 0
                }
                switch node{
                case childNode(withName: "grid") :
                    
                    let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                    guard let row = touchPosOnGrid?.row else {return}
                    guard let col = touchPosOnGrid?.col else {return}
                    
                    
                    
                    if !isDecideTranslateVectorMode{
                        labels[row][col].fontSize = UI.gridSize / CGFloat(gameSize)
                        labels[row][col].zPosition = grid.zPosition + 1
                        if scaledLabelAt.row != row || scaledLabelAt.col != col{
                            scaledLabelAt.row = row
                            scaledLabelAt.col = col
                        }
                        showState(row: row, col: col)
                    }
                    
                    
                    let colorComponent: CGFloat = isColorWhiteNow ? 1.0 : 0.0
                    let lightColor = UIColor(red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 0.3)
                    lightCell(row: row, col: col, color: lightColor)
                case toTitleNode:
                    toTitleHint.isHidden = false
                case retryNode:
                    retryHint.isHidden = false
                case undoNode:
                    undoHint.isHidden  = false
                case helpNode:
                    helpHint.isHidden = false
                case optionNode:
                    optionHint.isHidden = false
                case stateIndicatorColorRight, stateIndicatorColorLeft:
                    stateHint.isHidden = false
                default:
                    break
                }
            }
        }
    }
    
    fileprivate func touchUpDuringResultMode(node: SKNode, atPoint: CGPoint) {
        let distance = (atPoint.x - touchOrigin.x) * (atPoint.x - touchOrigin.x) + (atPoint.y - touchOrigin.y) * (atPoint.y - touchOrigin.y)
        if distance < 10{
            switch node{
            case screenshot:
                let screenshotRotation = -CGFloat.pi / 36.0
                let screenshotRatio = winImage.size.width / winImage.size.height
                let screenshotHeight = grid.size.height / (cos(screenshot.zRotation) - screenshotRatio * sin(screenshot.zRotation))
                let screenshotWidth = screenshotHeight * screenshotRatio
                let animationOfShowingScreenshot = SKAction.group([
                    SKAction.rotate(toAngle: 0, duration: 0.3),
                    SKAction.resize(toWidth: size.width, height: size.height, duration: 0.3)
                    ])
                let animationOfPlacingScreenshot = SKAction.group([
                    SKAction.rotate(toAngle: screenshotRotation, duration: 0.3),
                    SKAction.resize(toWidth: screenshotWidth, height: screenshotHeight, duration: 0.3)
                    ])
                let animationOfScreenshot = screenshot.size.width == size.width ? animationOfPlacingScreenshot : animationOfShowingScreenshot
                isUserInteractionEnabled = false
                waitTimeToSetIsUserInteractionEnabledToTrue = 0.3
                screenshot.run(animationOfScreenshot){
                    self.isUserInteractionEnabled = true
                }
            default:
                break
            }
        }
        else if !challenges.isEmpty{
            if abs(challengeLabelOriginX - challengeLabels.first!.position.x) < size.width / 4{
                for i in 0...challenges.count - 1{
                    challengeLabels[i].position.x  = challengeLabelOriginX
                    challengeFlipLabels[i].position.x  = challengeFlipLabelOriginX
                }
                screenshot.position.x  = screenshotOriginX
            }
            else{
                let sign: CGFloat = challengeLabelOriginX > size.width / 2 ? -1 : 1
                for i in 0...challenges.count - 1{
                    challengeLabels[i].position.x = challengeLabelOriginX + sign * size.width
                    challengeFlipLabels[i].position.x = challengeFlipLabelOriginX + sign * size.width
                }
                screenshot.position.x = screenshotOriginX + sign * size.width
            }
            challengeLabelOriginX = challengeLabels.first!.position.x
            challengeFlipLabelOriginX = challengeFlipLabels.first!.position.x
            screenshotOriginX = screenshot.position.x
        }
        
        switch node{
        case shareButton:
            shareHint.isHidden = true
            touchesUpOnShareButton()
        case retryNode:
            retryInResultMode()
        case undoNode:
            Challenge.resetSharedChallengeCanGetOneFlip(challenges: challenges)
            undoHint.isHidden = true
            isResultMode = false
            removeAllChildren()
            challengeFlipLabels = []
            challengeLabels = []
            previousPhaseBeforeUndo = .result
            undo(withTakingScreenshot: false)
        case toTitleNode:
            toTitleInResultMode()
        default:
            break
            
        }
        
    }
    fileprivate func toTitleInResultMode() {
        isResultMode = false
        cleanUpSavedFile()
        reviews = []
        Game = [Reversi(n: gameSize)]
        nowAt = 0
        isColorWhiteNow = false
        imagesOfReview = []
        save()
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            UI.logoSwitch.currentState = LogoSwitch.state(rawValue: !isAIMode ? 1 : (!isComputerWhite ? 2 : 0))!
            view.presentScene(scene, transition: transition)
        }
    }
    fileprivate func toTitle() {
        if let view = view {
            
//            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            UI.logoSwitch.currentState = LogoSwitch.state(rawValue: !isAIMode ? 1 : (!isComputerWhite ? 2 : 0))!
            UI.rootViewController?.present(UI.loadingVC, animated: true){
                
                view.presentScene(scene)
                scene.run(SKAction.wait(forDuration: 0.1)){
                    UI.loadingVC.dismiss(animated: true){
                        NotificationCenter.default.post(name: .showGoogleAds, object: nil)
                    }
                }
            }
            //view.presentScene(scene, transition: transition)
        }
    }
    fileprivate var didLastTurnUseAbility = false
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let t = touches.first {
            
            endShowingState()
            stateIndicator.isHidden = false
            
            backNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            let pos = t.location(in: self)
            let node = atPoint(pos)
            //in review mode
            if isReviewMode{
                
                self.touchUpDuringReviewMode(atPoint: pos)
                let distance = (pos.x - touchOrigin.x) * (pos.x - touchOrigin.x) + (pos.y - touchOrigin.y) * (pos.y - touchOrigin.y)
                if distance < 10, !everMoved{
                    self.stopFinding = false
                    //touch on the toppest review
                    if (reviews[indexOfTheToppestReview] as SKNode) == node{
                        if indexOfTheToppestReview == reviews.count - 1{
                            self.touchOnTheToppestReview(node)
                            return
                        }
//                        let handler: (UIAlertAction) -> Void = { action in
//                            switch action.style{
//                            case .default:
//                                print("default")
//                                self.touchOnTheToppestReview(node)
//                            case .cancel:
//                                print("cancel")
//
//                            case .destructive:
//                                print("destructive")
//                            }
//                        }
//                        let message = NSLocalizedString("alert.undo.message", comment: "")
//                        let actionDefaultTitle = NSLocalizedString("alert.undo.action.default.title", comment: "")
//                        let actionDestructiveTitle = NSLocalizedString("alert.undo.action.destructive.title", comment: "")
//                        let alertTitle = NSLocalizedString("alert.undo.title", comment: "")
//                        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: actionDefaultTitle, style: .default, handler: handler))
//                        alert.addAction(UIAlertAction(title: actionDestructiveTitle, style: .destructive, handler: handler))
//                        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
                        UI.topMostController()?.present(undoMessage,animated: true)
                        //undoMessage.isHidden = false
                        
                        
                    }
                        // touch is not on the toppest review but in others
                    else if (reviews as [SKNode]).contains(node){
                        let offset: CGFloat = -node.position.x
                        let index = reviews.firstIndex(of: node as! SKSpriteNode)!
                        self.isUserInteractionEnabled = false
                        for i in 0...reviews.count - 1{
                            //reviews[i].zPosition = 4.0 + yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width)
                            let moveToBestPosition = SKAction.group([
                                SKAction.moveTo(x: xOfReview(i, base: index), duration: 0.2),
                                SKAction.scale(to:3/5 * yOfReview(xOfReview(i, base: index) * CGFloat.pi / 2 / scene!.size.width), duration: 0.2),
                                SKAction.moveZPositionTo(to: 4.0 + yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width), withDuration: 0.2),
                                ])
                            reviews[i].run(moveToBestPosition){
                                //self.reviewSlider.value = CGFloat(index)
                                // self.waitTimeToSetIsUserInteractionEnabledToTrue = 0
                                self.isUserInteractionEnabled = true
                            }
                        }
                        waitTimeToSetIsUserInteractionEnabledToTrue = 0.2
                        reviewSlider.run(SKAction.moveValueTo(to: CGFloat(index), withDuration: 0.2)){
                            self.isUserInteractionEnabled = true
                        }
                    }
                    else if backNode.nodesTouched.contains(node){
                        back()
                    }
                }
            }
            else if isResultMode{
                touchUpDuringResultMode(node: node, atPoint: pos)
            }
                //not in review mode
            else{
                if isDecideTranslateVectorMode{
                    labelsBackToTheirPos()
                }
                brighterFilterRow.isHidden = true
                brighterFilterCol.isHidden = true
                toTitleHint.isHidden = true
                retryHint.isHidden = true
                undoHint.isHidden  = true
                stateHint.isHidden = true
                helpHint.isHidden = true
                optionHint.isHidden = true
                
                print("touchesBegan count = ", touches.count)
                if !isDecideTranslateVectorMode{
                    labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = UI.gridSize / CGFloat(gameSize) * 3/5
                    labels[scaledLabelAt.row][scaledLabelAt.col].zPosition = 0
                }
                
                if isReviewMode {setIndexOfTheToppestReview()}
                let node = self.atPoint(pos)
                
                if canPlayerUseAbility{
                    if let leftAbilityMenu = leftAbilityMenu{
                        if leftAbilityMenu.isMenuOpened{
                            if node == whiteScore_label{
                                leftAbilityMenu.collapseAnimation()
                            }
                            else{
                                leftAbilityMenu.isMenuOpened = false
                                leftAbilityMenu.isHidden = true
                            }
                        }
                        else if node == whiteScore_label, !everMoved{
                            leftAbilityMenu.isActive = Game[nowAt].getAbilityCoolDown(isWhite: true) == 0 && isColorWhiteNow == true && !Game[nowAt].didLastTurnUseAbility && nowAt >= 4
                            leftAbilityMenu.popAnimation()
                        }
                    }
                    if let rightAbilityMenu = rightAbilityMenu{
                        
                        if rightAbilityMenu.isMenuOpened{
                            if node == blackScore_label{
                                rightAbilityMenu.collapseAnimation()
                            }
                            else {
                                rightAbilityMenu.isMenuOpened = false
                                rightAbilityMenu.isHidden = true}
                        }
                        else if node == blackScore_label, !everMoved{
                            rightAbilityMenu.isActive = Game[nowAt].getAbilityCoolDown(isWhite: false) == 0 && isColorWhiteNow == false && !Game[nowAt].didLastTurnUseAbility && nowAt >= 4
                            rightAbilityMenu.popAnimation()
                        }
                    }
                }
                switch node {
                case toTitleNode:
                    toTitle()
                case retryNode:
                    retry()
                case undoNode:
                    previousPhaseBeforeUndo = .game
                    undo()
                    /*case let review where (reviews as [SKNode]).contains(review):
                     var offset: CGFloat = -node.position.x
                     self.isUserInteractionEnabled = false
                     for i in 0...reviews.count - 1{
                     let moveToBestPosition = SKAction.sequence([
                     SKAction.moveBy(x: offset, y: 0, duration: 0.3),
                     SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width), duration: 0.3)
                     SKAction.move
                     ])
                     reviews[i].run(moveToBestPosition){
                     self.isUserInteractionEnabled = true}
                     
                     }*/
                case helpNode:
                    help()
                case optionNode:
                    option()
                case childNode(withName: "grid") :
                    
                    let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                    if let row = touchPosOnGrid?.row, let col = touchPosOnGrid?.col{
                        let firstTouchPosOnGrid = grid.positionToGridPosition(position: touchOrigin)
                        //MARK: - move to decide translate vector
                        if isDecideTranslateVectorMode{
                            if let firstTouchedRow = firstTouchPosOnGrid?.row, let firstTouchedCol = firstTouchPosOnGrid?.col, translateCountdown == 0{
                            //if Game[nowAt].getAbilityCoolDown(isWhite: isColorWhiteNow) == 0{
                                stateIndicator.isHidden = true
                                translateVector.x = col - firstTouchedCol
                                translateVector.y = row - firstTouchedRow
                                translateCountdown = 2
                            }
                            //}
                        }
                        else if !Game[nowAt].isEnd(), touchDownCountdown == 0{
                            isUserInteractionEnabled = false
                            waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                            touchDownCountdown = 2
                            scaledLabelAt.col = col
                            scaledLabelAt.row = row
                            labels[row][col].fontSize = UI.gridSize / CGFloat(gameSize)
                        }
                        
                        
                        //if scaledLabelAt.row != row || scaledLabelAt.col != col{
                        
                        
                        //scaledLabelAt.row = row
                        //scaledLabelAt.col = col
                        //}
                    }
                default:
                    print(pos)
                }
            }
        }
        everMoved = false
    }
    fileprivate func back(){
        switch previousPhaseBeforeUndo{
        case .game:
            
            touchOnTheToppestReview(reviews.last!, withAnimation: false)
        case .result:
            showResult()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    /////p
    fileprivate var isThereAFlipBackAnimation = false
    fileprivate var translateVector = (x: 1, y: 0)
    fileprivate func translate(){
        
        if Game[nowAt].getAbilityCoolDown(isWhite: isColorWhiteNow) == 0, canPlayerUseAbility{
            withAbility = .translate
            isDecideTranslateVectorMode = true
            abilityIndicator.isHidden = false
            stateIndicator.isHidden = true
            stateLabel.isHidden = true
        }
        else {
            withAbility = .none
            isDecideTranslateVectorMode = false
        }
        //Game[nowAt].translate(dx: translateVector.x, dy: translateVector.y)
        
    }
    fileprivate func responseOfMovingWhileDecidingTranslateVector(pos: CGPoint){
        if let firstPosOnGrid = grid.positionToGridPosition(position: touchOrigin), let finalPosOnGrid = grid.positionToGridPosition(position: pos){
            let rowDifference = finalPosOnGrid.row - firstPosOnGrid.row
            let colDifference = finalPosOnGrid.col - firstPosOnGrid.col
            for row in 0...gameSize-1{
                for col in 0...gameSize-1{
                    let finalRow = ((row+rowDifference)%gameSize + gameSize)%gameSize
                    let finalCol = ((col+colDifference)%gameSize + gameSize)%gameSize
                    let x = -UI.gridSize/2 + UI.gridSize/CGFloat(gameSize)*(CGFloat(finalCol)+0.5)
                    let y = UI.gridSize/2 - UI.gridSize/CGFloat(gameSize)*(CGFloat(finalRow)+0.5)
                    labels[row][col].position = CGPoint(x: x, y: y)
                    if labels[row][col].text == "\(UnicodeScalar(0x2726)!)"{
                        labels[row][col].text = ""
                    }
                }
            }
            
        }
    }
    fileprivate func labelsBackToTheirPos(){
        for row in 0...gameSize-1{
            for col in 0...gameSize-1{
                let x = -UI.gridSize/2 + UI.gridSize/CGFloat(gameSize)*(CGFloat(col)+0.5)
                let y = UI.gridSize/2 - UI.gridSize/CGFloat(gameSize)*(CGFloat(row)+0.5)
                labels[row][col].position = CGPoint(x: x, y: y)
            }
        }
        showBoard(nowAt)
    }
    fileprivate var isBackgroundGrayNow = false
    fileprivate var backgroundColorFromGrayToBlue: [SKTexture] = []
    fileprivate var backgroundColorFromBlueToGray: [SKTexture] = []
    //prepare background color animation
    fileprivate func prepareBackgroundColorAnimation(fps: CGFloat, duration: CGFloat){
        var initialBgStartColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        var initialBgMidColor = #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
        var initialBgEndColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        var finalBgStartColor = #colorLiteral(red: 0.4784313725, green: 0.7764705882, blue: 0.937254902, alpha: 1)
        var finalBgMidColor = #colorLiteral(red: 0.4352941176, green: 0.6823529412, blue: 0.9803921569, alpha: 1)
        var finalBgEndColor = #colorLiteral(red: 0.3921568627, green: 0.5882352941, blue: 1, alpha: 1)
        let numberOfAtlas = Int(fps * duration)
        backgroundColorFromGrayToBlue = []
        backgroundColorFromBlueToGray = []
        
        for i in 0...numberOfAtlas{
            let finalColorWeight = CGFloat(i)/CGFloat(numberOfAtlas)
            //let initalColorWeight = 1 - finalColorWeight
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let bgCtx = UIGraphicsGetCurrentContext()
            let bgColorSpace = CGColorSpaceCreateDeviceRGB()
            let bgStartColor = initialBgStartColor.blend(colorToBlend: finalBgStartColor, weightOfColorToBlend: finalColorWeight)
            let bgMidColor =  initialBgMidColor.blend(colorToBlend: finalBgMidColor, weightOfColorToBlend: finalColorWeight)
            let bgEndColor =  initialBgEndColor.blend(colorToBlend: finalBgEndColor, weightOfColorToBlend: finalColorWeight)
            
            let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
            
            let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
            
            guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
            bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
            if !isComputerWhite{
                UI.addPattern(to: bgCtx, type: .white)
            }
            else{
                UI.addPattern(to: bgCtx, type: .black)
            }
            
            
            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            backgroundColorFromGrayToBlue.append(SKTexture(image: backgroundImage!))
        }
        
        
        
        initialBgStartColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        initialBgMidColor = #colorLiteral(red: 0.4352941176, green: 0.6823529412, blue: 0.9803921569, alpha: 1)
        initialBgEndColor = #colorLiteral(red: 0.3921568627, green: 0.5882352941, blue: 1, alpha: 1)
        finalBgStartColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        finalBgMidColor = #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
        finalBgEndColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        for i in 0...numberOfAtlas{
            let finalColorWeight = CGFloat(i)/CGFloat(numberOfAtlas)
            //let initalColorWeight = 1 - finalColorWeight
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let bgCtx = UIGraphicsGetCurrentContext()
            let bgColorSpace = CGColorSpaceCreateDeviceRGB()
            let bgStartColor = initialBgStartColor.blend(colorToBlend: finalBgStartColor, weightOfColorToBlend: finalColorWeight)
            let bgMidColor =  initialBgMidColor.blend(colorToBlend: finalBgMidColor, weightOfColorToBlend: finalColorWeight)
            let bgEndColor =  initialBgEndColor.blend(colorToBlend: finalBgEndColor, weightOfColorToBlend: finalColorWeight)
            
            let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
            
            let bgColorsLocations: [CGFloat] = [0.0, 0.2, 1.0]
            
            guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
            bgCtx?.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
            if !isComputerWhite{
                UI.addPattern(to: bgCtx, type: .white)
            }
            else{
                UI.addPattern(to: bgCtx, type: .black)
            }
            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            backgroundColorFromBlueToGray.append(SKTexture(image: backgroundImage!))
        }
        
        
        
        
        
        
    }
    fileprivate func changeBackgroundColor(isScoreLower: Bool){
        if isBackgroundGrayNow == isScoreLower {return}
        let animatedColor = isScoreLower ? backgroundColorFromBlueToGray : backgroundColorFromGrayToBlue
        background.run(SKAction.animate(with: animatedColor, timePerFrame: 1/15))
        isBackgroundGrayNow = isScoreLower
        
    }
    fileprivate func updateStateIndicator(_ nowAt: Int) {
        //TODO:stateIndicator
        if isAIMode{
            if Game[nowAt].getScore(isWhite: isComputerWhite) > Game[nowAt].getScore(isWhite: !isComputerWhite){ changeBackgroundColor(isScoreLower: true)
            }
            else{ changeBackgroundColor(isScoreLower: false)
            }
        }
        
        if Game[nowAt].isEnd(){
            
            //show crown
            var isWinnerWhite: Bool? = Game[nowAt].getWhiteScore() > Game[nowAt].getBlackScore()  ? true : false
            if Game[nowAt].getWhiteScore() == Game[nowAt].getBlackScore(){
                isWinnerWhite = nil
            }
            
            if let isWinnerWhite = isWinnerWhite{
                if isWinnerWhite == isComputerWhite, isAIMode{
                    MusicPlayer.play(music: .sfx(.lose))
                    doesPlayerLose = true
                    stateIndicator.isHidden = true
                }
                else{
                    MusicPlayer.play(music: .sfx(.win))
                    doesPlayerLose = false
                    changeStateIndicator(imageNamed: "crown", width: UI.gridSize/2.5, height: UI.gridSize/4, leftColor: isWinnerWhite ? UIColor.white : UIColor.black, rightColor: isWinnerWhite ? UIColor.white : UIColor.black)
                }
                
            }
                //If the state is draw.
            else {
                changeStateIndicator(imageNamed: "scale", width: UI.gridSize/2.5, height: UI.gridSize/4,leftColor: .white, rightColor: .black)
            }
        }
        else{
            let color = isColorWhiteNow ? UIColor.white : UIColor.black
            changeStateIndicator(imageNamed: "upArrow", width: UI.gridSize/6.0, height: UI.gridSize/6.0, leftColor: color, rightColor: color)
        }
    }
    
    fileprivate func showBoard(_ nowAt: Int, withAnimation: Bool = false, animationType: Reversi.ability = .none, _ action: @escaping () -> Void = {}){
        if labels.count != gameSize {fatalError("wrong rows of labels")}
        /// with animation
        if withAnimation{
        //if let gameScene = labels[0][0].parent{
            //var timeToWait = 0.7
            isUserInteractionEnabled = false
            if animationType == .translate{
                var copyLabels: [[SKLabelNode]] = []
                //hide labels zposition and copy them
                for rowLabel in labels{
                    var copyRowLabel: [SKLabelNode] = []
                    for label in rowLabel{
                        
                        let copyLabel = label.copy() as! SKLabelNode
                        copyLabel.zPosition = grid.zPosition + 1
                        if copyLabel.text == "\(UnicodeScalar(0x2726)!)"{
                            copyLabel.text = ""
                        }
                        addChild(copyLabel)
                        copyRowLabel.append(copyLabel)
                        label.isHidden = true
                    }
                    copyLabels.append(copyRowLabel)
                }
                
                //animate translate
                for row in 0...gameSize-1{
                    for col in 0...gameSize-1{
                        let afterRow = row+translateVector.y
                        let afterCol = col+translateVector.x
                        if afterRow < gameSize, afterRow >= 0, afterCol < gameSize, afterCol >= 0{
                            
                            let posAfterTranslate = labels[afterRow][afterCol].position
                            copyLabels[row][col].run(SKAction.move(to: posAfterTranslate, duration: 0.6))
                        }
                        else{
                            
                            let posAfterTranslation = labels[(afterRow%gameSize + gameSize)%gameSize][(afterCol%gameSize + gameSize)%gameSize].position
                            let posBeforeTranslation = copyLabels[row][col].position
                            let path = CGMutablePath()
                            let moveVector = posAfterTranslation - posBeforeTranslation
                            let controlPoint = 0.25*CGPoint(x: moveVector.y, y: -moveVector.x) + 0.5*moveVector + posBeforeTranslation
                            path.move(to: posBeforeTranslation)
                            
                            path.addQuadCurve(to: posAfterTranslation,
                                              control: controlPoint
                            )
                            let moveAnimation = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 0.6)
                            let scaleAnimation = SKAction.sequence([
                                SKAction.scale(to: 1.5, duration: 0.3),
                                SKAction.scale(to: 1, duration: 0.3)
                            ])
                            let animation = SKAction.group([
                                moveAnimation,
                                scaleAnimation
                            ])
                            copyLabels[row][col].zPosition += 0.1
                            copyLabels[row][col].run(animation)
                        }
                    }
                }
                
                //unhide labels
                isUserInteractionEnabled = false
                waitTimeToSetIsUserInteractionEnabledToTrue = 0.7
                run(SKAction.wait(forDuration: 0.6)){
                    self.showBoard(nowAt)
                    for rowLabel in self.labels{
                        for label in rowLabel{
                            label.isHidden = false
                        }
                    }
                    for rowCopyLabel in copyLabels{
                        for copyLabel in rowCopyLabel{
                            copyLabel.removeFromParent()
                        }
                    }
                    copyLabels = []
                    self.updateStateIndicator(nowAt)
                    //change grid color
                    if self.grid.color != (self.isColorWhiteNow ? .white : .black){
                        
                        self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
                        
                    }
                    if !self.isAIMode{
                        UI.flipsIndicator.flipsColor = self.isColorWhiteNow ? .white : .black
                    }
                    action()
                }
                
                
            }
            else {
                //isThereAFlipBackAnimation
                isThereAFlipBackAnimation = false
                for row in 0...gameSize-1{
                    for col in 0...gameSize-1{
                        if let number = Game[nowAt].getNumber(Row: row, Col: col){
                            let label = labels[row][col]
                            if Unicode.circledNumber(number) != label.text{
                                if label.text != "\(Unicode.circledNumber(0))" && label.text != "\(UnicodeScalar(0x2726)!)"{
                                    isThereAFlipBackAnimation = true
                                }
                            }
                        }
                    }
                }
                
                let originScaleX = labels[0][0].xScale
                let flipFirstHalfPart = SKAction.scaleX(to: 0, duration: 0.3)
                let flipLastHalfPart = SKAction.scaleX(to: originScaleX, duration: 0.3)
                var flipWait = SKAction.wait(forDuration: 0.6)
                //var firstTimeAddTimeToWait = true
                let isToPresentColorWhite = Game[nowAt].isColorWhiteNow
                let scoreLabel = isToPresentColorWhite ? whiteScore_label!:blackScore_label!
                let secondaryScoreLabel = !isToPresentColorWhite ? whiteScore_label!:blackScore_label!
                //isThereAFlipBackAnimation = false
                //MARK: play put chess sound
                self.run(SKAction.run{
                    MusicPlayer.play(music: .sfx(.putChess))
                })
                //MARK: play flip back sound
                if isThereAFlipBackAnimation{
                    self.run(SKAction.run{
                        MusicPlayer.play(music: .sfx(.wind))
                    })
                }
                //MARK: play flip go sound
                self.run(SKAction.wait(forDuration: isThereAFlipBackAnimation ? 1.2 : 0.6)) {
                    MusicPlayer.play(music: .sfx(.wind))
                }
                //MARK: play flip sound
                self.run(SKAction.wait(forDuration: isThereAFlipBackAnimation ? 0.6 : 0)) {
                    MusicPlayer.play(music: .sfx(.flip))
                }
                for row in 0...gameSize - 1{
                    if labels[row].count != gameSize {fatalError("wrong columns of labels")}
                    for col in 0...gameSize - 1{
                        let label = labels[row][col]
                        var labelText = String()
                        var labelColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                        var animationOfLabel = SKAction.sequence([
                            flipFirstHalfPart,
                            SKAction.run{label.text = labelText
                                label.fontColor = labelColor},
                            flipLastHalfPart
                            ])
                        if isThereAFlipBackAnimation {
                            animationOfLabel = SKAction.sequence([
                                SKAction.wait(forDuration: 0.6),
                                animationOfLabel
                            ])
                        }
                        if let number = Game[nowAt].getNumber(Row: row, Col: col){
                            
                            if Unicode.circledNumber(number) != label.text{
                                if label.text == "\(UnicodeScalar(0x2726)!)"{
                                    labels[row][col].text = "\(Unicode.circledNumber(0))"
                                    labels[row][col].fontColor = isToPresentColorWhite ? UIColor.white:UIColor.black
                                }
                                else {
                                    labelText = Unicode.circledNumber(number)
                                    labelColor = (Game[nowAt].getColor(Row: row, Col: col)! ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1))
                                    
                                    //var isThereFlipBackAnimation = false
                                    
                                        //if firstTimeAddTimeToWait {
                                            //timeToWait += 0.6
                                            //chessFlipTimeToWait = timeToWait
                                            //firstTimeAddTimeToWait = false
                                        //}
                                        //flips fly
                                        let flipLabel = label.copy() as! SKLabelNode
                                        flipLabel.zPosition = grid.zPosition + 1
                                        flipLabel.setScale(1)
                                        flipLabel.fontSize = grid.size.width / CGFloat(gameSize) * 3/5
                                        flipLabel.removeAllActions()
                                        flipLabel.fontColor = labelColor
                                        flipLabel.text = "\(Unicode.circledNumber(number))"
                                        addChild(flipLabel)
                                        flipLabel.isHidden = true
                                        let path = CGMutablePath()
                                    
                                    
                                        path.move(to: flipLabel.position)
                                    
                                        path.addQuadCurve(to: scoreLabel.position,
                                                          control:
                                            CGPoint(x: scoreLabel.position.x,
                                                    y: label.position.y)
                                        )
                                        let animationOfFlipsFlying = SKAction.sequence([
                                            SKAction.group([
                                                SKAction.unhide(),
                                                SKAction.follow(path, asOffset: false, orientToPath: false, duration: 0.6),
                                                SKAction.scale(to: scoreLabel.fontSize/flipLabel.fontSize/4, duration: 0.6),
                                                
                                                ]),
                                            SKAction.hide()
                                            ])
                                    
                                        if label.text != "\(Unicode.circledNumber(0))"{
//                                            isThereAFlipBackAnimation = true
                                            //flips back
                                            let flipBackLabel = label.copy() as! SKLabelNode
                                            flipBackLabel.position = secondaryScoreLabel.position
                                            flipBackLabel.zPosition = grid.zPosition + 1
                                            flipBackLabel.setScale(secondaryScoreLabel.fontSize/flipBackLabel.fontSize/4)
                                            flipBackLabel.fontSize = grid.size.width / CGFloat(gameSize) * 3/5
                                            flipBackLabel.removeAllActions()
                                            addChild(flipBackLabel)
                                            flipBackLabel.isHidden = true
                                            let flipBackPath = CGMutablePath()
                                            
                                            
                                            flipBackPath.move(to: secondaryScoreLabel.position)
                                            
                                            flipBackPath.addQuadCurve(to: label.position,
                                                              control:
                                                CGPoint(x: label.position.x,
                                                        y: secondaryScoreLabel.position.y)
                                            )
                                            let animationOfFlipsBack = SKAction.sequence([
                                                SKAction.group([
                                                    SKAction.unhide(),
                                                    SKAction.follow(flipBackPath, asOffset: false, orientToPath: false, duration: 0.6),
                                                    SKAction.scale(to: 1, duration: 0.6),
                                                    
                                                    ]),
                                                SKAction.hide()
                                            ])
                                            animationOfLabel = SKAction.sequence([
                                                SKAction.run{
                                                    flipBackLabel.run(animationOfFlipsBack)
                                                },
                                                animationOfLabel
                                                ])
                                        }
                                    
                                        animationOfLabel = SKAction.sequence([
                                            animationOfLabel,
                                            SKAction.run {
                                                flipLabel.run(animationOfFlipsFlying)
                                            }
                                        ])
                                    
                                    
                                    run(SKAction.group([
                                        SKAction.run{
                                            secondaryScoreLabel.score = self.Game[nowAt].getScore(isWhite: !isToPresentColorWhite)
                                        },
                                        SKAction.run{
                                            label.run(animationOfLabel)
                                        },
                                        SKAction.run{
                                            self.run(SKAction.wait(forDuration: self.isThereAFlipBackAnimation ? 1.8:1.2)){
                                            scoreLabel.score = self.Game[nowAt].getScore(isWhite: isToPresentColorWhite)
                                            }
                                        }
                                    ]))
                                }
                            }
                        }
                        else if Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
                            label.text = "\(UnicodeScalar(0x2726)!)"
                            label.isHidden = true
                            labelColor = isColorWhiteNow ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                            if isThereAFlipBackAnimation{
                                flipWait = SKAction.wait(forDuration: 1.2)
                            }
                            label.run(SKAction.sequence([
                                flipWait,
                                SKAction.unhide(),
                                SKAction.changeFontColor(to: labelColor)
                                ]))
                        }
                        else {
                            label.text = ""
                        }
                    }
                }
                
                //change grid color
                if grid.color != (isColorWhiteNow ? .white : .black){
                    self.isUserInteractionEnabled = false
                    /////p
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = isThereAFlipBackAnimation ? 1.2:0.6
                    grid.run(SKAction.wait(forDuration: self.isThereAFlipBackAnimation ? 1.2:0.6)){
                        self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
                        self.updateStateIndicator(nowAt)
                        if !self.isAIMode{
                            UI.flipsIndicator.flipsColor = self.isColorWhiteNow ? .white : .black
                        }
                       
                        self.isUserInteractionEnabled = true
                    }
                }
                waitTimeToSetIsUserInteractionEnabledToTrue = isThereAFlipBackAnimation ? 1.9:1.3
                run(SKAction.wait(forDuration: isThereAFlipBackAnimation ? 1.9:1.3)){
                    action()
                    self.isUserInteractionEnabled = true}
            }
            
        
        }
            //without animation
        else{
            for row in 0...gameSize - 1{
                if labels[row].count != gameSize {fatalError("wrong columns of labels")}
                for col in 0...gameSize - 1{
                    let label = labels[row][col]
                    label.setScale(1)
                    label.isHidden = false
                    if let number = Game[nowAt].getNumber(Row: row, Col: col){
                        
                        label.text = Unicode.circledNumber(number)
                        label.fontColor = Game[nowAt].getColor(Row: row, Col: col)! ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        
                    }
                    else if Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
                        label.text = "\(UnicodeScalar(0x2726)!)"
                        label.fontColor = isColorWhiteNow ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        
                    }
                    else {
                        label.text = ""
                    }
                }
            }
            //ScoreLabel
            whiteScore_label.score = Game[nowAt].getWhiteScore()
            blackScore_label.score = Game[nowAt].getBlackScore()
            updateAbilityCoolDownStateOnScoreLabels()
            //change grid color
            if grid.color != (isColorWhiteNow ? .white : .black){
                    grid.setGridColor(color: isColorWhiteNow ? .white : .black)
            }
            updateStateIndicator(nowAt)
            if !isAIMode{
                UI.flipsIndicator.flipsColor = isColorWhiteNow ? .white : .black
            }
            action()
        }
    }
    fileprivate func changeStateIndicator(imageNamed: String, width: CGFloat, height: CGFloat, leftColor: UIColor, rightColor: UIColor) {
        let stateIndicatorSize =
            CGSize(width: width, height: height)
        let maskNode = SKSpriteNode(imageNamed: imageNamed)
        maskNode.size = stateIndicatorSize
        stateIndicator.maskNode = maskNode
        stateIndicatorColorLeft.color = leftColor
        stateIndicatorColorRight.color = rightColor
        stateIndicatorColorLeft.size.width = stateIndicator.frame.width/2
        stateIndicatorColorRight.size.width = stateIndicator.frame.width/2
        stateIndicatorColorLeft.size.height = stateIndicator.frame.height
        stateIndicatorColorRight.size.height = stateIndicator.frame.height
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
        stateIndicator.zRotation = 0
        if imageNamed == "upArrow"{
            let myColor = (!isComputerWhite ? UIColor.white : UIColor.black)
            if !isAIMode && offline {
                if leftColor != myColor {stateIndicator.zRotation = CGFloat.pi}
                stateIndicator.zRotation += CGFloat.pi/2
            }
            else{
                if leftColor != myColor {stateIndicator.zRotation = CGFloat.pi}
                else if leftColor == .black {stateIndicator.zRotation += CGFloat.pi/2}
                else {stateIndicator.zRotation += -CGFloat.pi/2}
            }
        }
    }
    //save game state and go to the next turn
    fileprivate func saveGameState(){
        if nowAt == Game.count - 1{
            Game.append(Game[nowAt])
        }
        else {
            Game[nowAt + 1] = Game[nowAt]
        }
        nowAt = nowAt + 1
        Game[nowAt].turn = nowAt
    }
    fileprivate func touchOnTheToppestReview(_ node: SKNode, withAnimation: Bool = true){
        print("touchOnTheToppestReview")
        removeChildren(in: [reviewSlider, backNode])
        addAllChildrenBeforePreview()
        
        var turnString = node.name
        turnString?.removeFirst(7)
        let turn = Int(turnString!)
        self.isReviewMode = false
        
        let animation = SKAction.group([
            SKAction.scale(to: 1, duration: 0.2),
            SKAction.move(to: CGPoint.zero, duration: 0.2),
            SKAction.moveZPositionTo(to: UI.zPosition.reviewBase + 1.1, withDuration: 0.2)
            ])
        self.isUserInteractionEnabled = false
        waitTimeToSetIsUserInteractionEnabledToTrue = 0.25
        node.run(animation){
            print("nowAt:", self.nowAt)
            self.nowAt = turn!
            print("turn:", turn!)
            self.isColorWhiteNow = self.Game[self.nowAt].isColorWhiteNow
            print("Color:\(self.isColorWhiteNow ? "white" : "black")")
            self.removeChildren(in: [self.childNode(withName: "reviewBackground")!])
            self.removeChildren(in: self.reviews)
            for i in stride(from: self.Game.count - 1, to: -1, by: -1){
                if i > turn!{self.Game.removeLast()}
                else {break}
            }
            for i in stride(from: self.reviews.count - 1, to: -1, by: -1){
                var name = self.reviews[i].name!
                name.removeFirst(7)
                if Int(name)! >= turn!{
                    self.imagesOfReview.removeLast()
                    self.reviews.removeLast()
                }
                else{break}
            }
            //self.cleanUpSavedFile()
            let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: DispatchQoS.background)
            serialQueue.async {
                self.cleanUpSavedFile()
                self.save()
                SharedVariable.isThereGameToLoad = true
                SharedVariable.save()
            }

            self.isUserInteractionEnabled = true

            self.showBoard(self.nowAt)
            self.Game[self.nowAt].showBoard(isWhite: self.isColorWhiteNow)


            if self.grid.color != (self.isColorWhiteNow ? .white : .black){
                self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
            }
            if self.isAIMode && self.isColorWhiteNow == self.isComputerWhite{
                self.touchDownOnGrid(row: -1, col: -1)
            }
            if !self.isAIMode{
                UI.flipsIndicator.flipsColor = self.isColorWhiteNow ? .white : .black
            }
            self.updateAbilityCoolDownStateOnScoreLabels()
            self.updateStateIndicator(self.nowAt)
        }
        //TODO: 4, review wipe speed not good for iphone XR  6,highCPU,
    }
    @objc func rewardBasedVideoAdDidClose(){
        UI.flipsIndicator.flips = SharedVariable.flips
    }
    
    override func update(_ currentTime: TimeInterval) {
        //FIXME: test restart quick click
//        slots.text = "\(Game[nowAt].getAbilityCoolDown(isWhite: isColorWhiteNow))"
        //test
        switch translateCountdown {
        case 2:
            translateCountdown = 1
        case 1:
            moveToDecideTranslateVector()
            stateIndicator.isHidden = false
            translateCountdown = 0
        default:
            break
        }
        switch touchDownCountdown {
        case 2:
//            flipsIndicator.flipsColor = isColorWhiteNow ? .white : .black
            touchDownCountdown = 1
        case 1:
            touchDownOnGrid(row: scaledLabelAt.row, col: scaledLabelAt.col)
            labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = UI.gridSize / CGFloat(gameSize) * 3/5
            //flipsIndicator.withAnimation = true
            let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: DispatchQoS.background)
            serialQueue.async {
                self.cleanUpSavedFile()
                self.save()
            }
            touchDownCountdown = 0
        default:
            break
        }
        switch showResultCountdown {
        case 2:
            if !isAIMode{
                UI.flipsIndicator.flipsColor = isColorWhiteNow ? .white : .black
            }
            showResultCountdown = 1
        case 1:
            self.takeScreenShot(isWhite: self.isColorWhiteNow)
            self.winImage = self.imagesOfReview.last!
            self.showResult()
            self.imagesOfReview.removeLast()
            self.reviews.removeLast()
            let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: DispatchQoS.background)
            serialQueue.async {
                self.cleanUpSavedFile()
                self.save()
            }
            //flipsIndicator.withAnimation = true
            showResultCountdown = 0
        default:
            break
        }
    }
    override func didEvaluateActions() {
        timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSinceReferenceDate +  waitTimeToSetIsUserInteractionEnabledToTrue
    }
    override func didFinishUpdate() {
        if UI.rootViewController?.presentedViewController == UI.loadingVC || UI.rootViewController?.presentingViewController == UI.loadingVC{
            UI.loadingVC.dismiss(animated: true, completion: nil)
        }
        
        
        self.isUserInteractionEnabled = true
        waitTimeToSetIsUserInteractionEnabledToTrue = -1
    }
    fileprivate func help(){
        UI.topMostController()?.present(helpMessage,animated: true)
        //helpMessage.isHidden = false
    }
    fileprivate func option(){
        let alert = OptionMenuVC()
        alert.delegate = self
        UI.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
extension GameScene: optionMenuDelegate{
    func didTapOnButton(type: OptionMenuVC.type, sender: OptionMenu) {
        func reloadGame(){
            guard let view = view else{return}
            guard let scene = GameScene(fileNamed: "GameScene") else {fatalError("cannot open GameScene.")}
            scene.needToLoad = SharedVariable.isThereGameToLoad
            UI.rootViewController?.present(UI.loadingVC, animated: true){
                view.presentScene(scene)
                scene.run(SKAction.wait(forDuration: 0.1)){
                    UI.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
        }
        switch type {
        case .close:
            let undoDestructiveText = SharedVariable.withAds ? UI.Texts.message.undo.destructive : UI.Texts.message.undo.destructiveWithoutAds
            undoMessage.changeTheLastActionTitle(withText: undoDestructiveText)
            if let GVC = UI.rootViewController as! GameViewController?, !SharedVariable.withAds{
                GVC.bannerView?.removeFromSuperview()
            }
        case .confirm:
            reloadGame()
        }
    }
}
