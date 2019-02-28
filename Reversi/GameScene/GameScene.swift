//
//  GameScene.swift
//  Reversi
//
//  Created by john gospai on 2018/11/10.
//  Copyright © 2018 john gospai. All rights reserved.
//
import SpriteKit
import GameplayKit
///TODO: change background music and record effect sound.
///TODO: resign
///TODO: change alert.

///TODO: sometimes disappear, maybe computer too fast
///TODO: once cannot place chess and brighterFilters flickering.
///TODO: when click undo quickly in reslut mode, may undo.
///TODO: load challenges
class GameScene: SKScene {
    
    
    
    //MARK: - settings
    var computer = Player()
    var gameSize = 6
    var needToLoad = false
    var AIlevel = UInt(3)
    var isAIMode = true
    var isComputerWhite = true
    var level = 1
    var difficulty = Challenge.difficultyType.easy
    var challenges: [Challenge] = []
    //MARK: - parameters for UI designing.
    fileprivate var safeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //MARK: - effect filter
    fileprivate var brighterFilterRow = UIView()
    fileprivate var brighterFilterCol = UIView()
    //MARK: - music
    fileprivate var backgroundMusic = musicPlayer(musicName: "background")
    //MARK: - nodes
    fileprivate var flipsIndicator = FlipsIndicator(flips: 0)!
    fileprivate var labels: [[SKLabelNode]] = []
    fileprivate var blackScore_label: SKLabelNode!
    fileprivate var whiteScore_label: SKLabelNode!
    fileprivate var stateIndicator = SKCropNode()
    fileprivate var stateHint: HintBubble!
    fileprivate var chessBoard: SKTileMapNode!
    fileprivate var stateIndicatorColorLeft : SKSpriteNode!
    fileprivate var stateIndicatorColorRight: SKSpriteNode!
    fileprivate var stateLabel = SKLabelNode()
    fileprivate var retryNode:SKSpriteNode!
    fileprivate var toTitleNode: SKSpriteNode!
    fileprivate var undoNode: SKSpriteNode!
    fileprivate var retryHint: HintBubble!
    fileprivate var toTitleHint: HintBubble!
    fileprivate var undoHint: HintBubble!
    fileprivate var grid : Grid!
    fileprivate var reviewSlider: CustomSlider!
    fileprivate var chessBoardBackground: SKSpriteNode!
    
    
    
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
    //MARK: - parameters for pages
    fileprivate var isReviewMode = false
    fileprivate var isResultMode = false
    
    //MARK: - parameters for review
    fileprivate var imagesOfReview: [UIImage] = []
    fileprivate var reviews:[SKSpriteNode] = []
    //MARK: - parameters for result
    fileprivate var shareButton = SKSpriteNode()
    fileprivate var shareHint: HintBubble!
    fileprivate var winImage = UIImage()
    fileprivate var screenshotOriginX: CGFloat = 0
    fileprivate var challengeLabelOriginX: CGFloat = 0
    fileprivate var challengeFlipLabelOriginX: CGFloat = 0
    //MARK: - nodes in result
    fileprivate var screenshot = SKSpriteNode()
    fileprivate var challengeLabels: [SKLabelNode] = []
    fileprivate var challengeFlipLabels: [SKLabelNode] = []
    //MARK: - parameter for games
    fileprivate var isColorWhiteNow = false
    fileprivate var nowAt = 0
    fileprivate var Game:[Reversi] = []
    
    //MARK: - variables for findBestSolution
    fileprivate var stopFinding: Bool = false
    //MARK: - save with JSONEncoder or propertyList
    enum key: String{
        case isResultMode = "isResultMode"
        case isReviewMode = "isReviewMode"
        case isAIMode = "isAIMode"
        case isComputerWhite = "isComputerWhite"
        case isColorWhiteNow = "isColorWhiteNow"
        case nowAt = "nowAt"
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
        UserDefaults.standard.setValue(isReviewMode, forKey: key.isReviewMode.rawValue)
        UserDefaults.standard.setValue(isResultMode, forKey: key.isResultMode.rawValue)
        UserDefaults.standard.setValue(isAIMode, forKey: key.isAIMode.rawValue)
        UserDefaults.standard.setValue(isComputerWhite, forKey: key.isComputerWhite.rawValue)
        //UserDefaults.standard.setValue(isColorWhiteNow, forKey: key.isColorWhiteNow.rawValue)
        UserDefaults.standard.setValue(nowAt, forKey: key.nowAt.rawValue)
        saveUtility.saveGames(games: Game)
        saveUtility.saveImages(images: imagesOfReview, filenamesOfImages: reviews.map{$0.name!})
        print("saved successfully")
       // reviews:[SKSpriteNode] = []
    }
    /**Warning: not always successful*/
    fileprivate func load() {
        isResultMode = UserDefaults.standard.value(forKey: key.isResultMode.rawValue) as! Bool? ?? isResultMode
        isReviewMode = UserDefaults.standard.value(forKey: key.isReviewMode.rawValue) as! Bool? ?? isReviewMode
        winImage = saveUtility.loadImage(scale: UIScreen.main.scale, filenameOfImage: "winImage") ?? winImage
        Game = saveUtility.loadGames() ?? Game
        self.gameSize = Game.first!.n
        isAIMode = UserDefaults.standard.value(forKey: key.isAIMode.rawValue) as! Bool? ?? isAIMode
        isComputerWhite = UserDefaults.standard.value(forKey: key.isComputerWhite.rawValue) as! Bool? ?? isComputerWhite
        
        nowAt = Game.count - 1
        isColorWhiteNow = Game[nowAt].isColorWhiteNow
        imagesOfReview = saveUtility.loadImages(scale: UIScreen.main.scale) ?? imagesOfReview
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
        if isAIMode, isColorWhiteNow == isComputerWhite, !isResultMode{
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
    override func didMove(to view: SKView) {
        Game = [Reversi(n: gameSize)]
        
        //MARK: load games
        if needToLoad {load()}
        //MARK: up set challenge
        challenges = isAIMode ? Challenge.sharedChallenge(gameSize: gameSize, isColorWhite: !isComputerWhite, level: level, difficulty: difficulty) : []
        //MARK: set time
        timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSinceReferenceDate
// set background
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
        //self.backgroundColor = UIColor.white
        //MARK: set brighterFilter
        brighterFilterCol.isHidden = true
        brighterFilterRow.isHidden = true
        view.addSubview(brighterFilterRow)
        view.addSubview(brighterFilterCol)
        //MARK: play background music
        backgroundMusic.playMusic()
///set up computer
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

        let firstPartWeight = Weight(
            scoreDifferenceWeight: 1,
            sideWeight: 54,
            CWeight: -2,
            XWeight: -60,
            cornerWeight: 38)
        let secondPartWeight = Weight(
            scoreDifferenceWeight: 1,
            sideWeight: 54,
            CWeight: -26,
            XWeight: -53,
            cornerWeight: 59)
        let thirdPartWeight = Weight(
            scoreDifferenceWeight: 1,
            sideWeight: 10,
            CWeight: -7,
            XWeight: -27,
            cornerWeight: 31)
        //computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
        computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
        computer.name = "computer"
        computer.searchDepth = AIlevel
///set up computer

        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(reviewSliderTouched), name: NSNotification.Name(notificationCenterName.reviewSlider.rawValue), object: nil)
        
        view.isMultipleTouchEnabled = false
        
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        // MARK: define safeArea
        if #available(iOS 11.0, *) {
            safeAreaInsets = view.safeAreaInsets
        }
        print(safeAreaInsets)
       
        print(view.frame.size)
        self.isUserInteractionEnabled = true
        
        //MARK: - set up flipsIndicator
        flipsIndicator.position = UI.flipsPosition
        flipsIndicator.zPosition = UI.zPosition.flipsIndicator
        flipsIndicator.flips = SharedVariable.flips
        addChild(flipsIndicator)
        
        chessBoard = childNode(withName: "ChessBoard") as? SKTileMapNode
        chessBoard.yScale = UI.gridSize / chessBoard.mapSize.height
        chessBoard.xScale = chessBoard.yScale
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
        chessBoardScaledWidth = chessBoard!.mapSize.width * chessBoard.xScale
        chessBoardScaledHeight = chessBoard!.mapSize.height * chessBoard.yScale
        
        // MARK: set up chessBoard background
        let chessBoardBackgroundSize = CGSize(width: chessBoardScaledWidth * 12.0/11.0 ,height:  chessBoardScaledHeight * 12.0/11.0)
        chessBoardBackground = SKSpriteNode(texture: SKTexture(imageNamed: "chessBoardBackground"), size: chessBoardBackgroundSize)
        chessBoardBackground.zPosition = -1
        addChild(chessBoardBackground)
        ///set up chessBoard background
        
        borderWidth = (view.frame.width - chessBoard!.mapSize.width * chessBoard!.xScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
        borderHeight = (view.frame.height -         chessBoard!.mapSize.height * chessBoard!.yScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
        print("borderWidth: ", borderWidth)
        //MARK: - set up menu
        //MARK: set up toTitleNode
        toTitleNode = SKSpriteNode(imageNamed: "toTitle")
        toTitleNode.size = UI.menuIconSize
        toTitleNode.position = UI.getMenuIconPosition(indexFromLeft: 0, numberOfMenuIcon: 3)
        toTitleNode.zPosition = 1
        addChild(toTitleNode)
        //MARK: set up retryNode
        retryNode = SKSpriteNode(imageNamed: "retry")
        retryNode.size = UI.menuIconSize
        retryNode.position = UI.getMenuIconPosition(indexFromLeft: 2, numberOfMenuIcon: 3)
        retryNode.zPosition = 1
        addChild(retryNode)
        //MARK: set up undoNode
        undoNode = SKSpriteNode(imageNamed: "undo")
        undoNode.size = UI.menuIconSize
        undoNode.position = UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 3)
        undoNode.zPosition = 1
        addChild(undoNode)
        //MARK: - set up hints
        //MARK: set up toTitleHint
        let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        toTitleHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        toTitleHint.attachTo = toTitleNode
        toTitleHint.text = NSLocalizedString("back to title", comment: "")
        toTitleHint.isHidden = true
        toTitleHint.fontSize = UI.menuIconHintLabelFontSize
        toTitleHint.zPosition = 10
        addChild(toTitleHint)
        //MARK: set up undoHint
        undoHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        undoHint.attachTo = undoNode
        undoHint.text = NSLocalizedString("undo", comment: "")
        undoHint.isHidden = true
        undoHint.fontSize = UI.menuIconHintLabelFontSize
        undoHint.zPosition = 10
        addChild(undoHint)
        //MARK: set up retryHint
        retryHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)
        retryHint.attachTo = retryNode
        retryHint.text = NSLocalizedString("retry", comment: "")
        retryHint.isHidden = true
        retryHint.fontSize = UI.menuIconHintLabelFontSize
        retryHint.zPosition = 10
        addChild(retryHint)
        
        // MARK: initialize labels in the game board.
        for row in 0...gameSize - 1{
            var row_label: [SKLabelNode] = []
            for col in 0...gameSize - 1{
                let x = borderWidth + (chessBoard!.mapSize.width * chessBoard!.xScale) / CGFloat(gameSize) * CGFloat(col) - view.frame.midX
                let y = view.frame.midY - borderHeight -  (chessBoard!.mapSize.height * chessBoard!.yScale) / CGFloat(gameSize) * CGFloat(row)
                let position = CGPoint(x: x, y: y)
                //label
                let label = SKLabelNode()
                label.name = "label_\(row),\(col)"
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .center
                label.text = ""
                label.position = position
                label.fontName = "negative-circled-number"
                label.fontColor = SKColor.yellow
                label.fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                row_label.append(label)
                addChild(label)
                
            }
            labels.append(row_label)
        }
        // MARK: initialize score labels
        blackScore_label = childNode(withName: "blackScore") as? SKLabelNode
        whiteScore_label = childNode(withName: "whiteScore") as? SKLabelNode
        
        blackScore_label!.fontColor = SKColor.black
        blackScore_label!.fontSize = chessBoard.mapSize.width * chessBoard.xScale / 6.0
        blackScore_label!.text = "\(Game[nowAt].getBlackScore())"
        blackScore_label!.position = CGPoint(x: (2.0 / 6.0) * chessBoard!.mapSize.width * chessBoard!.xScale,y: (-8.0 / 12.0) * chessBoard!.mapSize.height * chessBoard!.yScale)
        
        whiteScore_label!.fontColor = SKColor.white
        whiteScore_label!.fontSize = chessBoard.mapSize.width * chessBoard.xScale / 6.0
        whiteScore_label!.text = "\(Game[nowAt].getWhiteScore())"
        whiteScore_label!.position = CGPoint(x: (-2.0 / 6.0) * chessBoard!.mapSize.width * chessBoard!.xScale,y: (-8.0 / 12.0) * chessBoard!.mapSize.height * chessBoard!.yScale)
        
        //initialize a grid
        let blockSize = chessBoard!.mapSize.width * chessBoard!.xScale / CGFloat(gameSize)
        grid = Grid(color: isColorWhiteNow ? SKColor.white : SKColor.black, blockSize: blockSize, rows: gameSize, cols: gameSize,lineWidth: blockSize / 20)!
        grid.position = CGPoint (x:0, y:0)
        grid.name = "grid"
        grid.zPosition = 1
        addChild(grid)
        
        //initialize a review slider
        let barColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        let sliderColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        let activeSliderColor = sliderColor.withAlphaComponent(1.0)
        reviewSlider = CustomSlider(notificationName: notificationCenterName.reviewSlider.rawValue, count: 1, barColor: barColor, sliderColor: sliderColor, activeSliderColor: activeSliderColor, barLength: 0.75 * size.width, barWidth: grid.size.width / 16)
        reviewSlider.position = CGPoint(x: 0, y: -4/10 * size.height)
        reviewSlider.zPosition = 3
        
        //initialize stateIndicator with mask and show upArrow
        
        let stateIndicatorSize =
            CGSize(
            width: chessBoard!.mapSize.width * chessBoard!.xScale / 6.0,
            height: chessBoard!.mapSize.height * chessBoard!.yScale / 6.0)
        
        stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "upArrow"), size: stateIndicatorSize)
        stateIndicator.position = CGPoint(x:0,y: (-8.0 / 12.0) * chessBoard!.mapSize.height * chessBoard!.yScale)
        stateIndicator.zPosition = -1
        
        stateIndicatorColorLeft = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: stateIndicator.frame.width / 2, height: stateIndicator.frame.height))
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorLeft.name = "stateIndicatorColorLeft"
        stateIndicator.addChild(stateIndicatorColorLeft)
        
        
        stateIndicatorColorRight = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: stateIndicator.frame.width / 2, height: stateIndicator.frame.height))
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorRight.name = "stateIndicatorColorRight"
        stateIndicator.addChild(stateIndicatorColorRight)
        
        addChild(stateIndicator)
        //initialize state label
        stateLabel = labels[0][0].copy() as! SKLabelNode
        stateLabel.name = "stateLabel"
        stateLabel.isHidden = true
        stateLabel.fontSize = stateIndicatorSize.height
        addChild(stateLabel)
        //MARK: set up the state hint
        stateHint = HintBubble(bubbleColor: UI.hintBubbleColor, bounds: BoundsOfHintBubble)!
        stateHint.attachTo = stateIndicator
        stateHint.text = NSLocalizedString("resign", comment: "")
        stateHint.isHidden = true
        stateHint.fontSize = UI.menuIconHintLabelFontSize
        stateHint.zPosition = 10
        addChild(stateHint)
        self.showBoard(self.nowAt)
        
        if isAIMode && isColorWhiteNow == isComputerWhite && !Game[nowAt].isEnd(){
            let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
            let angleVeclocity = 8.0 * CGFloat.pi / 3.0
            undoNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: angleVeclocity, duration: 1)))
            serialQueue.async {
                if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: self.AIlevel, stopFinding: &self.stopFinding){
                    DispatchQueue.main.async {
                        self.undoNode.removeAllActions()
                        self.undoNode.zRotation = 0
                        //save game state
                        self.saveGameState()
                        self.play(row: bestStep.row, col: bestStep.col){
                            //if player needs to pass, then computer will keep playing.
                            if self.isColorWhiteNow == self.isComputerWhite{
                                //self.run(SKAction.wait(forDuration: 0.65)){
                                self.touchDownOnGrid(row: 0, col: 0)
                                //}
                                
                            }
                        }
                        
                    }
                }
                    //when stop finding
                else{
                    self.undoNode.removeAllActions()
                    self.undoNode.zRotation = 0
                }
            }
        }
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
        let filterRowPosX = (size.width - grid.frame.width) * 0.5 / UIScreen.main.scale
        let filterColPosY = (size.height - grid.frame.height) * 0.5 / UIScreen.main.scale
        let filterRowPosY =  grid.frame.height / CGFloat(gameSize) / UIScreen.main.scale * CGFloat(row) + filterColPosY
        let filterColPosX = grid.frame.width / CGFloat(gameSize) / UIScreen.main.scale * CGFloat(col) + filterRowPosX
        
        brighterFilterCol.frame = CGRect(x: filterColPosX, y: filterColPosY, width: grid.frame.width / CGFloat(gameSize) / UIScreen.main.scale, height: grid.frame.height / UIScreen.main.scale)
        brighterFilterRow.frame = CGRect(x: filterRowPosX, y: filterRowPosY, width: grid.frame.width / UIScreen.main.scale, height: grid.frame.height / CGFloat(gameSize) / UIScreen.main.scale)
        brighterFilterRow.backgroundColor = color
        brighterFilterCol.backgroundColor = color
        brighterFilterCol.isHidden = false
        brighterFilterRow.isHidden = false
    }
    fileprivate func play(row: Int, col: Int, action: @escaping () -> Void = {}) {

        
        
        var needToShake = false
        if Game[nowAt].fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){

            isColorWhiteNow = !isColorWhiteNow
            //change grid color
            
            if grid.color != (isColorWhiteNow ? .white : .black){
                waitTimeToSetIsUserInteractionEnabledToTrue = 0.6
                grid.run(SKAction.wait(forDuration: 0.6)){
                    self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
                    action()
                    self.isUserInteractionEnabled = true
                }
            }
            
        }
        else {
            //shake!!
            needToShake = true
            print("Unavailable move at \(row), \(col)")
        }
        
        if Game[nowAt].isEnd(){
            //show crown
            var isWinnerWhite: Bool? = Game[nowAt].getWhiteScore() > Game[nowAt].getBlackScore()  ? true : false
            if Game[nowAt].getWhiteScore() == Game[nowAt].getBlackScore(){
                isWinnerWhite = nil
            }
            if let isWinnerWhite = isWinnerWhite{
                isColorWhiteNow = isWinnerWhite
                let winColor = isWinnerWhite ? UIColor.white : UIColor.black
                changeStateIndicator(imageNamed: "crown", width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4, leftColor: winColor, rightColor: winColor)
//                let stateIndicatorSize =
//                    CGSize(width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4)
//
//                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "crown"), size: stateIndicatorSize)
//                stateIndicatorColorLeft.color = isWinnerWhite ? UIColor.white : UIColor.black
//               stateIndicatorColorRight.color = isWinnerWhite ? UIColor.white : UIColor.black
//                stateIndicatorColorLeft.size.width = stateIndicator.frame.width/2
//                stateIndicatorColorRight.size.width = stateIndicator.frame.width/2
//                stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
//                stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
                 print("\(isWinnerWhite  ? "White" : "Black") won!! White: \(Game[nowAt].getWhiteScore()) Black: \(Game[nowAt].getBlackScore())")
            }
            //If the state is draw.
            else {
                changeStateIndicator(imageNamed: "scale", width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4, leftColor: .white, rightColor: .black)
//                let stateIndicatorSize =
//                    CGSize(width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4)
//                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "scale"), size: stateIndicatorSize)
//                stateIndicatorColorLeft.color = UIColor.white
//                stateIndicatorColorRight.color = UIColor.black
//                stateIndicatorColorLeft.size.width = stateIndicator.frame.width/2
//                stateIndicatorColorRight.size.width = stateIndicator.frame.width/2
//                stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
//                stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
            }
           
        }
        else if Game[nowAt].needToPass(Color: isColorWhiteNow){
            print("\(isColorWhiteNow ? "White" : "Black") cannot move")
            isColorWhiteNow = !isColorWhiteNow
        }
     
        self.showBoard(self.nowAt, withAnimation: true)
        Game[nowAt].showBoard(isWhite: isColorWhiteNow)
    
        
        
        blackScore_label!.text = "\(Game[nowAt].getBlackScore())"
        whiteScore_label!.text = "\(Game[nowAt].getWhiteScore())"
        
        if needToShake, !isComputerThinking{
            print("shake")
            let date = Date()
            let calendar = Calendar.current
            let seconds = calendar.component(.second, from: date)
            let nanoseconds = calendar.component(.nanosecond, from: date)
            print("second: ", Double(nanoseconds) / 1000000000.0 + Double(seconds))
            var nodes: [SKNode] = []
            for i in 0...gameSize * gameSize - 1{
                nodes.append(labels[i / gameSize][i % gameSize] as SKNode)
                
            }
            nodes.append(chessBoard! as SKNode)
            nodes.append(chessBoardBackground)
            
            grid.shake(duration: 0.6, amplitudeX:10.0 * UIScreen.main.scale, numberOfShakes: 4)
            for node in nodes{
                node.shake(duration: 0.6, amplitudeX: 10.0 * UIScreen.main.scale, numberOfShakes: 4)
            }
            self.isUserInteractionEnabled = false
            waitTimeToSetIsUserInteractionEnabledToTrue = 0.7
            nodes.first!.run(SKAction.wait(forDuration: 0.6)){self.isUserInteractionEnabled = true}
            
            needToShake = false
        }
        Game[nowAt].isColorWhiteNow = isColorWhiteNow
        //change the color of stateIndicator
        if !Game[nowAt].isEnd() {
            let color = isColorWhiteNow ? UIColor.white : UIColor.black
            changeStateIndicator(imageNamed: "upArrow", width: stateIndicator.frame.width, height: stateIndicator.frame.height,leftColor: color,rightColor: color)
//            stateIndicatorColorLeft.color = isColorWhiteNow ? UIColor.white : UIColor.black
//            stateIndicatorColorRight.color = isColorWhiteNow ? UIColor.white : UIColor.black
//            stateIndicatorColorLeft.size.width = stateIndicator.frame.width/2
//            stateIndicatorColorRight.size.width = stateIndicator.frame.width/2
//            stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
//            stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
        }
    }
    fileprivate func retryInResultMode(){
        isResultMode = false
        //remove all saved data
        self.cleanUpSavedFile()
        if let view = self.view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = GameScene(fileNamed: "GameScene")!
            scene.gameSize = self.gameSize
            scene.isAIMode = self.isAIMode
            scene.isComputerWhite = self.isComputerWhite
            scene.scaleMode = .aspectFill
            scene.cleanUpSavedFile()
            view.presentScene(scene, transition: transition)
            scene.save()
        }
    }
    fileprivate func retry(){
        let handler: (UIAlertAction) -> Void  = { action in
            switch action.style{
            case .default:
                print("default")
                //remove all saved data
                self.cleanUpSavedFile()
                if let view = self.view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene = GameScene(fileNamed: "GameScene")!
                    scene.gameSize = self.gameSize
                    scene.isAIMode = self.isAIMode
                    scene.isComputerWhite = self.isComputerWhite
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: transition)
                }
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}
        let message = NSLocalizedString("alert.retry.message", comment: "")
        let actionDefaultTitle = NSLocalizedString("alert.retry.action.default.title", comment: "")
        let actionDestructiveTitle = NSLocalizedString("alert.retry.action.destructive.title", comment: "")
        let alertTitle = NSLocalizedString("alert.retry.title", comment: "")
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionDefaultTitle, style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: actionDestructiveTitle, style: .destructive, handler: handler))
        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
        
        
        
       
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
        return UIScreen.main.scale * 3/5 * yOfReview((xOfReview(i,base: base) + offset) * CGFloat.pi / 2 / scene!.size.width)
    }
    fileprivate func zPositionOfReview(_ i: Int) -> CGFloat{
        return 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
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
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        //UIGraphicsBeginImageContext(bounds.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let roundedBounds = UIBezierPath.init(roundedRect: bounds, cornerRadius: safeAreaInsets.bottom)
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
        if withAnimation{
            for i in 0...reviews.count - 1{
                reviews[i].setScale(UIScreen.main.scale)
                reviews[i].position = CGPoint(x:  xOfReview(i), y: 0.0)
                reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
                addChild(reviews[i])
                let scaleAnimation = SKAction.scale(to: UIScreen.main.scale * 3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
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
                reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
                reviews[i].setScale(UIScreen.main.scale * 3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width))
                addChild(reviews[i])
                self.isReviewMode = true
            }
        }
        
    }
    fileprivate func addAllChildrenBeforePreview(){
        flipsIndicator.removeFromParent()
        addChild(flipsIndicator)
        for labelRow in labels{
            for label in labelRow{
                addChild(label)
            }
        }
        addChild(blackScore_label)
        addChild(whiteScore_label)
        addChild(stateIndicator)
        addChild(stateHint)
        addChild(stateLabel)
        addChild(chessBoard)
        addChild(retryNode)
        addChild(toTitleNode)
        addChild(undoNode)
        addChild(retryHint)
        addChild(toTitleHint)
        addChild(undoHint)
        addChild(grid)
        addChild(chessBoardBackground)
    }
    fileprivate func undo(withTakingScreenshot: Bool = true, withAnimation: Bool = true){
        self.stopFinding = true
        
        if withTakingScreenshot{ takeScreenShot(isWhite: self.isColorWhiteNow) }
        indexOfTheToppestReview = reviews.count - 1
        
        removeAllChildren()
        
        let reviewBackground = SKSpriteNode(color: .black, size: scene!.size)
        print(scene!.size)
        reviewBackground.name = "reviewBackground"
        reviewBackground.zPosition = 2
        addChild(reviewBackground)
        reviewBackground.addChild(flipsIndicator)
        
        reviewSlider.count = reviews.count
        reviewSlider.value = CGFloat(reviewSlider.count - 1)
        addChild(reviewSlider)
        
        showReview(withAnimation: withAnimation)
        
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
        let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
        self.isUserInteractionEnabled = false
        if !isAIMode || isColorWhiteNow != isComputerWhite{
            if self.Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
                //take a screenshot before play
                takeScreenShot(isWhite: self.isColorWhiteNow)
                //save game state
                saveGameState()
            }
            play(row: row, col: col){
                if self.Game[self.nowAt].isEnd(){
                    //self.isUserInteractionEnabled = false
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                    self.run(SKAction.wait(forDuration: 0.1)){
                        if self.showResultCountdown == 0{
                            self.showResultCountdown = 2
                        }
//                        self.takeScreenShot(isWhite: self.isColorWhiteNow)
//                        self.winImage = self.imagesOfReview.last!
//                        self.showResult()
//                        self.imagesOfReview.removeLast()
//                        self.reviews.removeLast()
//                        let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
//                        serialQueue.async {
//                            self.cleanUpSavedFile()
//                            self.save()
//                        }
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
                                //self.isUserInteractionEnabled = false
                                self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                                self.run(SKAction.wait(forDuration: 0.1)){
                                    if self.showResultCountdown == 0{
                                        self.showResultCountdown = 2
                                    }
//                                    self.takeScreenShot(isWhite: self.isColorWhiteNow)
//                                    self.winImage = self.imagesOfReview.last!
//                                    self.showResult()
//                                    self.imagesOfReview.removeLast()
//                                    self.reviews.removeLast()
//                                    let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
//                                    serialQueue.async {
//                                        self.cleanUpSavedFile()
//                                        self.save()
//                                    }
                                    //self.isUserInteractionEnabled = true
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
                reviews[i].position.x = xOfReview(i, base: 0) + offset - distanceBetweenToppestAndFirst
                reviews[i].setScale(scaleOfReview(i, base: 0))
                reviews[i].zPosition = zPositionOfReview(i)
            }
            if changeReviewSliderValue {reviewSlider.value = 0}
        }
        else if -offset >= distanceBetweenToppestAndLast{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i, base: reviews.count - 1) + offset + distanceBetweenToppestAndLast
                reviews[i].setScale(scaleOfReview(i, base: reviews.count - 1))
                reviews[i].zPosition = zPositionOfReview(i)
            }
            if changeReviewSliderValue {reviewSlider.value = CGFloat(reviews.count - 1)}
        }
        else{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i) + offset
                reviews[i].setScale(3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width) * UIScreen.main.scale)
                reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
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
            reviews[i].setScale(UIScreen.main.scale * 3/5 * yOfReview(xOfReview(i, base: indexOfTheToppestReview) * CGFloat.pi / 2 / scene!.size.width))
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
    }
    fileprivate func endShowingState(){
        stateLabel.isHidden = true
        stateIndicator.isHidden = false
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
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
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
            case .getPoints:
                let points = challenges[i].getChallengeParametersForGetPoints()
                if (Game[nowAt].getWhiteScore() >= points && !isComputerWhite) ||
                    (Game[nowAt].getBlackScore() >= points && isComputerWhite){
                    challenges[i].isCompleted = true
                }
            case .winTheComputerByPoints:
                let byPoints = challenges[i].getChallengeParametersForWinTheComputerByPoints()
                if (Game[nowAt].getScoreDifference(isWhite: true) >= byPoints && !isComputerWhite) ||
                    (Game[nowAt].getScoreDifference(isWhite: false) >= byPoints && isComputerWhite){
                    challenges[i].isCompleted = true
                }
            }
        }
        return fontColor
    }
    
    fileprivate func showResult() {
        var fontColor = updateTheStateOfChallenge()
        
        Challenge.saveSharedChallenge()
        isResultMode = true
        
        removeAllChildren()
        
        //MARK: set up the background
        let background = SKSpriteNode(color: .red, size: size)
        background.zPosition = 6
        addChild(background)
        //MARK: add menu button
        background.addChild(flipsIndicator)
        background.addChild(retryNode)
        background.addChild(undoNode)
        background.addChild(toTitleNode)
        background.addChild(retryHint)
        background.addChild(undoHint)
        background.addChild(toTitleHint)
        //MARK: set up a share button.
        shareButton = SKSpriteNode(texture: SKTexture(image: UIImage(named: "share")!))
        let iconSideLength = chessBoard.mapSize.width * chessBoard.xScale / 8
        shareButton.size = CGSize(width: iconSideLength, height: iconSideLength)
        shareButton.position = stateIndicator.position
        shareButton.zPosition = 7
        addChild(shareButton)
        //MARK: set up a shareHint
        let bubbleColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        shareHint = HintBubble(bubbleColor: bubbleColor, bounds: BoundsOfHintBubble)!
        shareHint.attachTo = shareButton
        shareHint.text = NSLocalizedString("share", comment: "")
        shareHint.isHidden = true
        shareHint.fontSize = toTitleHint.fontSize
        toTitleHint.zPosition = 10
        background.addChild(shareHint)
        //MARK: add a screenshot.
        let screenshotRatio = winImage.size.width / winImage.size.height
        screenshot = SKSpriteNode(texture: SKTexture(image: winImage), size: size)
        screenshot.zPosition = background.zPosition + flipsIndicator.zPosition + 100
        addChild(screenshot)
        
        //MARK: set up challenges
        var defaultChallengeFlipLabelWidth: CGFloat = 0.0
        var accumulativeChallengeLabelHeight: CGFloat = 0.0
        if challenges.count != 0{
            for i in 0...challenges.count - 1{
                
                let challengeFlipLabel = SKLabelNode(text: "\(Unicode.circledNumber(0))")
                challengeFlipLabel.fontColor = fontColor[i]
                challengeFlipLabel.name = "challengeFilpLabel \(i)"
                challengeFlipLabel.verticalAlignmentMode = .center
                challengeFlipLabel.position.x = size.width - grid.size.width / 2.0 + challengeFlipLabel.frame.width / 2
                challengeFlipLabel.zPosition = 9
                challengeFlipLabel.fontSize = UI.challengeFlipLabelFontSize
                challengeFlipLabel.fontName = labels[0][0].fontName
                addChild(challengeFlipLabel)
                challengeFlipLabels.append(challengeFlipLabel)
                
                
                let challengeLabel = SKLabelNode(text: "\(challenges[i].description)")
                challengeLabel.fontColor = fontColor[i]
                challengeLabel.name = "challengeLabel \(i)"
                if #available(iOS 11.0, *) {
                    challengeLabel.numberOfLines = 0
                    challengeLabel.preferredMaxLayoutWidth = grid.size.width - challengeFlipLabels[i].frame.width * 2
                } else {
                    fatalError("implement me for ios 10")
                    //TODO: Fallback on earlier versions
                }
                
                challengeLabel.verticalAlignmentMode = .top
                challengeLabel.horizontalAlignmentMode = .left
                challengeLabel.position.x = challengeFlipLabels[i].frame.maxX + challengeFlipLabels[i].frame.width
                challengeLabel.position.y =  -CGFloat(i) * undoHint.fontSize * 2 - accumulativeChallengeLabelHeight + grid.size.height / 2
                challengeLabel.zPosition = 9
                challengeLabel.fontSize = UI.challengeLabelFontSize
                challengeLabel.fontName = undoHint.fontName
                accumulativeChallengeLabelHeight += challengeLabel.frame.height
                addChild(challengeLabel)
                challengeLabels.append(challengeLabel)
                
                challengeFlipLabel.position.y = challengeLabel.frame.midY
            }
            defaultChallengeFlipLabelWidth = challengeFlipLabels.first!.frame.width
        }
        //MARK: animation of screenshot
        let screenshotRotation = -CGFloat.pi / 36.0
        let screenshotHeight = grid.size.height / (cos(screenshot.zRotation) - screenshotRatio * sin(screenshot.zRotation))
        let screenshotWidth = screenshotHeight * screenshotRatio
        let flashlight = SKSpriteNode(color: .white, size: size)
        flashlight.zPosition = 9
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
        let animationOfMovingScreenshot = SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.moveTo(x: -size.width, duration: 0.2)])
        //MARK: animation of moving challenge to the left
       
        let animationOfMovingChallenge = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.moveTo(x: -grid.size.width / 2.0 + 2 * defaultChallengeFlipLabelWidth, duration: 0.2)
            ])
        let animationOfMovingChallengeFlip = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.moveTo(x: -grid.size.width / 2.0 + defaultChallengeFlipLabelWidth / 2, duration: 0.2)
            ])
        //MARK: transition between screenshot and challenge
        self.isUserInteractionEnabled = false
        waitTimeToSetIsUserInteractionEnabledToTrue = 1.0
        flashlight.run(animationOfFlashlight){
            self.screenshot.run(animationOfPlacingScreenshot){
                self.removeChildren(in: [flashlight])
                if self.challenges.count != 0{
                    self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.8
                    self.screenshot.run(animationOfMovingScreenshot){
                        
                        var waitTime = 0.0
                        var indexOfChallengesThatCanGetOneFlip: [Int] = []
                        
                        for i in 0...self.challenges.count - 1{
                            if self.challenges[i].canGetOneFilp{
                                indexOfChallengesThatCanGetOneFlip.append(i)
                                
                                self.run(SKAction.wait(forDuration: waitTime)){
                                    self.challengeFlipLabels[i].run(SKAction.scaleX(to: 0, duration: 0.3)){
                                        self.challengeFlipLabels[i].text = "\(Unicode.circledNumber(1))"
                                        self.challengeFlipLabels[i].fontColor = !self.isComputerWhite ? .white : .black
                                        self.challengeLabels[i].fontColor = !self.isComputerWhite ? .white : .black
                                        self.challengeFlipLabels[i].run(SKAction.scaleX(to: 1, duration: 0.3))
                                    }
                                }
                                
                                waitTime += 0.6
                            }
                        }
                        
                        //MARK: animation of adding FLIP to currentFlips
                        waitTime += 0.4
                        self.run(SKAction.wait(forDuration: waitTime)){
                            if !indexOfChallengesThatCanGetOneFlip.isEmpty{
                                for i in 0...indexOfChallengesThatCanGetOneFlip.count - 1{
                                    waitTime += 1.2
                                    let challengeFlipLabel = self.challengeFlipLabels[indexOfChallengesThatCanGetOneFlip[i]].copy() as! SKLabelNode
                                    challengeFlipLabel.xScale = 1
                                    challengeFlipLabel.removeAllActions()
                                    self.challengeFlipLabels[indexOfChallengesThatCanGetOneFlip[i]].text = "\(Unicode.circledNumber(0))"
                                    self.addChild(challengeFlipLabel)
                                    let path = CGMutablePath()
                                    path.move(to: challengeFlipLabel.position)
                                    path.addQuadCurve(to:
                                        self.flipsIndicator.flipsLabelPosition,
                                        control:
                                        CGPoint(x: self.flipsIndicator.flipsLabelPosition.x,
                                                y: challengeFlipLabel.position.y)
                                    )
                                    let animationOfFlipsFlying = SKAction.group([
                                        SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1.2),
                                        SKAction.scale(to: UI.flipsFontSize/UI.challengeLabelFontSize, duration: 1.2)
                                        ])
                                    challengeFlipLabel.run(animationOfFlipsFlying){
                                        SharedVariable.flips += 1
                                        self.flipsIndicator.flips = SharedVariable.flips
                                        self.removeChildren(in: [challengeFlipLabel])
                                    }
                                }
                            }
                        }
                        
                        self.waitTimeToSetIsUserInteractionEnabledToTrue = waitTime
//                        }
//                        self.waitTimeToSetIsUserInteractionEnabledToTrue = waitTime + 0.5
//                        self.run(SKAction.wait(forDuration: waitTime + 0.5)){self.isUserInteractionEnabled = true}
                    }
                    for i in 0...self.challenges.count - 1{
                        self.waitTimeToSetIsUserInteractionEnabledToTrue = 0.8
                        self.challengeLabels[i].run(animationOfMovingChallenge)
                        self.challengeFlipLabels[i].run(animationOfMovingChallengeFlip)
                    }
                }
                else {
                    self.isUserInteractionEnabled = true
                }
            }
        }
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
            switch node{
            case childNode(withName: "grid") :
                let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: touchOrigin)
                guard let row = touchPosOnGrid?.row else {return}
                guard let col = touchPosOnGrid?.col else {return}
                
                labels[row][col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize)
                scaledLabelAt.row = row
                scaledLabelAt.col = col
                showState(row: row, col: col)
                
                let colorComponent: CGFloat = isColorWhiteNow ? 1.0 : 0.0
                let lightColor = UIColor(red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 0.3)
                lightCell(row: row, col: col, color: lightColor)
            case toTitleNode:
                toTitleHint.isHidden = false
            case retryNode:
                retryHint.isHidden = false
            case undoNode:
                undoHint.isHidden = false
            case shareButton:
                shareHint.isHidden = false
            case stateIndicatorColorLeft, stateIndicatorColorRight:
                stateHint.isHidden = false
            default:
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
            if abs(t.location(in: self).x - touchOrigin.x) > 10{
                everMoved = true
            }
            endShowingState()
            if isReviewMode{
                self.touchMovedDuringReviewMode(toPoint: t.location(in: self))
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
                labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                let pos = t.location(in: self)
                let node = atPoint(pos)
                switch node{
                case childNode(withName: "grid") :
                    let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                    guard let row = touchPosOnGrid?.row else {return}
                    guard let col = touchPosOnGrid?.col else {return}
                    
                        
                    labels[row][col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize)
                    if scaledLabelAt.row != row || scaledLabelAt.col != col{
                        scaledLabelAt.row = row
                        scaledLabelAt.col = col
                    }
                    showState(row: row, col: col)
                    
                    let colorComponent: CGFloat = isColorWhiteNow ? 1.0 : 0.0
                    let lightColor = UIColor(red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 0.3)
                    lightCell(row: row, col: col, color: lightColor)
                case toTitleNode:
                    toTitleHint.isHidden = false
                case retryNode:
                    retryHint.isHidden = false
                case undoNode:
                    undoHint.isHidden  = false
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
            scene.currentMode = TitleScene.mode(rawValue: !isAIMode ? 1 : (!isComputerWhite ? 2 : 0))!
            view.presentScene(scene, transition: transition)
        }
    }
    fileprivate func toTitle() {
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = TitleScene()
            scene.scaleMode = .aspectFill
            scene.currentGameSize = TitleScene.gameSize(rawValue: gameSize)!
            scene.currentMode = TitleScene.mode(rawValue: !isAIMode ? 1 : (!isComputerWhite ? 2 : 0))!
            view.presentScene(scene, transition: transition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let t = touches.first {
            endShowingState()
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
                        let handler: (UIAlertAction) -> Void = { action in
                            switch action.style{
                            case .default:
                                print("default")
                                self.touchOnTheToppestReview(node)
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }
                        }
                        let message = NSLocalizedString("alert.undo.message", comment: "")
                        let actionDefaultTitle = NSLocalizedString("alert.undo.action.default.title", comment: "")
                        let actionDestructiveTitle = NSLocalizedString("alert.undo.action.destructive.title", comment: "")
                        let alertTitle = NSLocalizedString("alert.undo.title", comment: "")
                        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: actionDefaultTitle, style: .default, handler: handler))
                        alert.addAction(UIAlertAction(title: actionDestructiveTitle, style: .destructive, handler: handler))
                        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
                        
                        
                        
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
                                SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview(xOfReview(i, base: index) * CGFloat.pi / 2 / scene!.size.width), duration: 0.2),
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
                }
            }
            else if isResultMode{
                touchUpDuringResultMode(node: node, atPoint: pos)
            }
            //not in review mode
            else{
                brighterFilterRow.isHidden = true
                brighterFilterCol.isHidden = true
                toTitleHint.isHidden = true
                retryHint.isHidden = true
                undoHint.isHidden  = true
                stateHint.isHidden = true
                
                print("touchesBegan count = ", touches.count)
                labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                if isReviewMode {setIndexOfTheToppestReview()}
                let node = self.atPoint(pos)
                switch node {
                case toTitleNode:
                    toTitle()
                case retryNode:
                    retry()
                case undoNode:
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
                case childNode(withName: "grid") :
                    
                    let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                    if let row = touchPosOnGrid?.row, let col = touchPosOnGrid?.col{
                        if !Game[nowAt].isEnd(), touchDownCountdown == 0{
                            isUserInteractionEnabled = false
                            waitTimeToSetIsUserInteractionEnabledToTrue = 0.1
                            touchDownCountdown = 2
                            scaledLabelAt.col = col
                            scaledLabelAt.row = row
                            labels[row][col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize)
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
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    fileprivate func showBoard(_ nowAt: Int, withAnimation: Bool = false){
        self.Game[self.nowAt].showBoard(labels: self.labels, whiteScoreLabel: self.whiteScore_label, blackScoreLabel: self.blackScore_label, stateIndicator: self.stateIndicator, stateIndicatorColorLeft: self.stateIndicatorColorLeft, stateIndicatorColorRight: self.stateIndicatorColorRight, chessBoardScaledWidth: self.chessBoardScaledWidth, chessBoardScaledHeight: self.chessBoardScaledHeight, isWhite: self.isColorWhiteNow, withAnimation: withAnimation)
    }
    fileprivate func changeStateIndicator(imageNamed: String, width: CGFloat, height: CGFloat, leftColor: UIColor, rightColor: UIColor) {
        let stateIndicatorSize =
            CGSize(width: width, height: height)
        stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: stateIndicatorSize)
        stateIndicatorColorLeft.color = leftColor
        stateIndicatorColorRight.color = rightColor
        stateIndicatorColorLeft.size.width = stateIndicator.frame.width/2
        stateIndicatorColorRight.size.width = stateIndicator.frame.width/2
        stateIndicatorColorLeft.size.height = stateIndicator.frame.height
        stateIndicatorColorRight.size.height = stateIndicator.frame.height
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * stateIndicator.frame.width,y:0)
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * stateIndicator.frame.width,y:0)
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
    fileprivate func touchOnTheToppestReview(_ node: SKNode){
        removeChildren(in: [reviewSlider])
        addAllChildrenBeforePreview()
        
        var turnString = node.name
        turnString?.removeFirst(7)
        let turn = Int(turnString!)
        self.isReviewMode = false
        self.isUserInteractionEnabled = false
        node.run(SKAction.scale(to: UIScreen.main.scale, duration: 0.1)){
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
            let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
            serialQueue.async {
                self.cleanUpSavedFile()
                self.save()
            }
            
            self.isUserInteractionEnabled = true
            
            self.showBoard(self.nowAt)
            
            
            if self.grid.color != (self.isColorWhiteNow ? .white : .black){
                self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
            }
            if self.isAIMode && self.isColorWhiteNow == self.isComputerWhite{
                self.touchDownOnGrid(row: -1, col: -1)
            }
        }
        //TODO: 4, review wipe speed not good for iphone XR  6,highCPU,
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch touchDownCountdown {
        case 2:
            flipsIndicator.flipsColor = isColorWhiteNow ? .white : .black
            touchDownCountdown = 1
        case 1:
            touchDownOnGrid(row: scaledLabelAt.row, col: scaledLabelAt.col)
            labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
            flipsIndicator.withAnimation = true
            touchDownCountdown = 0
        default:
            break
        }
        switch showResultCountdown {
        case 2:
            flipsIndicator.flipsColor = isColorWhiteNow ? .white : .black
            showResultCountdown = 1
        case 1:
            self.takeScreenShot(isWhite: self.isColorWhiteNow)
            self.winImage = self.imagesOfReview.last!
            self.showResult()
            self.imagesOfReview.removeLast()
            self.reviews.removeLast()
            let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
            serialQueue.async {
                self.cleanUpSavedFile()
                self.save()
            }
            flipsIndicator.withAnimation = true
            showResultCountdown = 0
        default:
            break
        }
    }
    override func didEvaluateActions() {
        timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSinceReferenceDate +  waitTimeToSetIsUserInteractionEnabledToTrue
    }
    override func didFinishUpdate() {
        self.isUserInteractionEnabled = true
        waitTimeToSetIsUserInteractionEnabledToTrue = -1
    }
 
}
