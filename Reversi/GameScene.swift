//
//  GameScene.swift
//  Reversi
//
//  Created by john gospai on 2018/11/10.
//  Copyright © 2018 john gospai. All rights reserved.
//
import SpriteKit
import GameplayKit
///TODO: win grid color
///TODO: add sound
///TODO: touch on unavailable place when computer thinks will shake later
///TODO: the effect when touch on button
///TODO: when game finish, and then touch will crash if I win
///TODO: label becomes bigger before taking a screenshot. It's good but wrong position.
///TODO: sometimes disappear, maybe computer too fast
class GameScene: SKScene {
    
    var gameSize = 6
    var needToLoad = false
    
    var labels: [[SKLabelNode]] = []
    var blackScore_label: SKLabelNode!
    var whiteScore_label: SKLabelNode!
    var stateIndicator = SKCropNode()
    var chessBoard: SKTileMapNode!
    var stateIndicatorColorLeft : SKSpriteNode!
    var stateIndicatorColorRight: SKSpriteNode!
    var retryNode:SKSpriteNode!
    var toTitle: SKSpriteNode!
    var undoNode: SKSpriteNode!
    var grid : Grid!
    var chessBoardBackground: SKSpriteNode!
    
    var reviews:[SKSpriteNode] = []
    
    var chessBoardScaledWidth: CGFloat!
    var chessBoardScaledHeight: CGFloat!
    var borderWidth: CGFloat = 0
    var borderHeight: CGFloat = 0
    var touchOrigin = CGPoint()
    var indexOfTheToppestReview = 0
    var moveTimes = 0
    var scaledLabelAt = (row: 0, col: 0)
    //save with JSONEncoder or propertyList
    var AIlevel = UInt(6)
    var isReviewMode = false
    var isAIMode = true
    var isComputerWhite = true
    var isColorWhiteNow = false
    var nowAt = 0
    var Game:[Reversi] = []
    var imagesOfReview: [UIImage] = []
    var computer = Player()
    
    //variables for findBestSolution
    var stopFinding: Bool = false
    enum key: String{
        case isReviewMode = "isReviewMode"
        case isAIMode = "isAIMode"
        case isComputerWhite = "isComputerWhite"
        case isColorWhiteNow = "isColorWhiteNow"
        case nowAt = "nowAt"
    }
    
    /**
     use cleanUpSavedFile() before any save() to ensure the not too much data creates.
     */
    func save(){
        //UserDefaults.standard.setValue(isReviewMode, forKey: key.isReviewMode.rawValue)
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
    func load() {
//        var isReviewMode = false
//        var isAIMode = false
//        var isComputerWhite = true
//        var isColorWhiteNow = false
//        var nowAt = 0
//
        Game = saveUtility.loadGames() ?? Game
        self.gameSize = Game.first!.n
        //if GameWillBeLoad.isEmpty {throw saveUtility.ErrorType.fileDoesNotExist}
        //if GameWillBeLoad.first!.n != gameSize {
            //Game = [Reversi(n: gameSize)]
            //return}
        //else {Game = GameWillBeLoad}
        //isReviewMode = UserDefaults.standard.value(forKey: key.isReviewMode.rawValue) as! Bool? ?? isReviewMode
        isAIMode = UserDefaults.standard.value(forKey: key.isAIMode.rawValue) as! Bool? ?? isAIMode
        isComputerWhite = UserDefaults.standard.value(forKey: key.isComputerWhite.rawValue) as! Bool? ?? isComputerWhite
        //isColorWhiteNow = UserDefaults.standard.value(forKey: key.isColorWhiteNow.rawValue) as! Bool? ?? isColorWhiteNow
        //nowAt = UserDefaults.standard.value(forKey: key.nowAt.rawValue) as! Int? ?? nowAt
        
        nowAt = Game.count - 1
        isColorWhiteNow = Game[nowAt].isColorWhiteNow
        imagesOfReview = saveUtility.loadImages(scale: UIScreen.main.scale) ?? imagesOfReview
        guard let filenamesOfImages = UserDefaults.standard.value(forKey: "filenamesOfImages") as! [String]? else {return}
        if filenamesOfImages.count == 0 || imagesOfReview.count == 0 {return}
        for i in 0...imagesOfReview.count - 1{
            let review = SKSpriteNode(texture: SKTexture(image: imagesOfReview[i]))
            review.name = "\(filenamesOfImages[i])"
            reviews.append(review)
        }
    }
    func cleanUpSavedFile(){
        //UserDefaults.standard.removeObject(forKey: key.isReviewMode.rawValue)
        UserDefaults.standard.removeObject(forKey: key.isAIMode.rawValue)
        UserDefaults.standard.removeObject(forKey: key.isComputerWhite.rawValue)
       // UserDefaults.standard.removeObject(forKey: key.isColorWhiteNow.rawValue)
        //UserDefaults.standard.removeObject(forKey: key.nowAt.rawValue)
        saveUtility.removeGamesData()
        saveUtility.removeImagesData()
        
    }
    @objc func appMovedToBackground(notification: NSNotification){
        if isAIMode && isColorWhiteNow == isComputerWhite{
            reviews.removeLast()
            imagesOfReview.removeLast()
        }
        cleanUpSavedFile()
        save()
        print("app IN background")
    }
    
    override func didMove(to view: SKView) {
        Game = [Reversi(n: gameSize)]
        
///load games
        if needToLoad {load()}
/// load games
        
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
            sideWeight: 13,
            CWeight: 32,
            XWeight: 13,
            cornerWeight: 50)
        let secondPartWeight = Weight(
            scoreDifferenceWeight: 1,
            sideWeight: 55,
            CWeight: 51,
            XWeight: 8,
            cornerWeight: 52)
        let thirdPartWeight = Weight(
            scoreDifferenceWeight: 1,
            sideWeight: 56,
            CWeight: 14,
            XWeight: 51,
            cornerWeight: 55)
        //computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
        computer.weights = [Weight()]
        computer.name = "computer"
        computer.searchDepth = 4
///set up computer

        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        view.isMultipleTouchEnabled = false
        
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //define safeArea
        let safeAreaInsets = view.safeAreaInsets
        print(safeAreaInsets)
        print(view.frame.size)
        self.isUserInteractionEnabled = true
        
        
        
        chessBoard = childNode(withName: "ChessBoard") as? SKTileMapNode
        chessBoard.yScale = (scene!.size.height * 1/2) / chessBoard.mapSize.height
        chessBoard.xScale = chessBoard.yScale
        
        if chessBoard!.mapSize.width * chessBoard.xScale > scene!.size.width{
            chessBoard.xScale = (scene!.size.width - 100) / chessBoard.mapSize.width
            chessBoard.yScale = chessBoard.xScale
        }
        
        
        
        chessBoardScaledWidth = chessBoard!.mapSize.width * chessBoard.xScale
        chessBoardScaledHeight = chessBoard!.mapSize.height * chessBoard.yScale
        
        ///set up chessBoard background
        let chessBoardBackgroundSize = CGSize(width: chessBoardScaledWidth * 12.0/11.0 ,height:  chessBoardScaledHeight * 12.0/11.0)
        chessBoardBackground = SKSpriteNode(texture: SKTexture(imageNamed: "chessBoardBackground"), size: chessBoardBackgroundSize)
        chessBoardBackground.zPosition = -1
        addChild(chessBoardBackground)
        ///set up chessBoard background
        
        borderWidth = (view.frame.width - chessBoard!.mapSize.width * chessBoard!.xScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
        borderHeight = (view.frame.height -         chessBoard!.mapSize.height * chessBoard!.yScale * CGFloat(gameSize - 1) / CGFloat(gameSize)) / 2.0
        print("borderWidth: ", borderWidth)
        
        //initialize labels and cells
        retryNode = childNode(withName: "retry") as? SKSpriteNode
        toTitle = childNode(withName: "toTitle") as? SKSpriteNode
        undoNode = childNode(withName: "undo") as? SKSpriteNode
        
        retryNode?.position = CGPoint(x: scene!.size.width/2 - safeAreaInsets.right - 20, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        toTitle?.position = CGPoint(x: -scene!.size.width/2 + safeAreaInsets.left + 20, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        undoNode?.position = CGPoint(x: 0, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        let iconSideLength = chessBoard.mapSize.width * chessBoard.xScale / 6
        retryNode?.size = CGSize(width: iconSideLength, height: iconSideLength)
        toTitle?.size = CGSize(width: iconSideLength, height: iconSideLength)
        undoNode?.size = CGSize(width: iconSideLength, height: iconSideLength)
        
        undoNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        undoNode.position.y = undoNode.position.y + undoNode.frame.height / 2
        
        
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
                label.fontName = "Avenir"
                label.fontColor = SKColor.yellow
                label.fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                row_label.append(label)
                addChild(label)
                
            }
            labels.append(row_label)
        }
        //initialize score labels
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
        grid = Grid(color: isColorWhiteNow ? SKColor.white : SKColor.black, blockSize: blockSize, rows: gameSize, cols: gameSize)!
        grid.position = CGPoint (x:0, y:0)
        grid.name = "grid"
        grid.zPosition = 1
        addChild(grid)
        
        
        
        
        //initialize stateIndicator with mask and show upArrow
        
        let stateIndicatorSize =
            CGSize(
            width: chessBoard!.mapSize.width * chessBoard!.xScale / 6.0,
            height: chessBoard!.mapSize.height * chessBoard!.yScale / 6.0)
        
        stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "upArrow"), size: stateIndicatorSize)
        stateIndicatorColorLeft = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: view.frame.width / 2, height: view.frame.height))
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * view.frame.width,y:0)
        stateIndicatorColorLeft.name = "stateIndicatorColorLeft"
        stateIndicator.addChild(stateIndicatorColorLeft)
        

        stateIndicatorColorRight = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: view.frame.width / 2, height: view.frame.height))
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * view.frame.width,y:0)
        stateIndicatorColorRight.name = "stateIndicatorColorRight"
        stateIndicator.addChild(stateIndicatorColorRight)
        
        stateIndicator.position = CGPoint(x:0,y: (-8.0 / 12.0) * chessBoard!.mapSize.height * chessBoard!.yScale)
        stateIndicator.zPosition = -1
        addChild(stateIndicator)
        
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
    
    func play(row: Int, col: Int, action: @escaping () -> Void = {}) {

        
        
        var needToShake = false
        if Game[nowAt].fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){

            isColorWhiteNow = !isColorWhiteNow
            //change grid color
            if grid.color != (isColorWhiteNow ? .white : .black){
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
                
                let stateIndicatorSize =
                    CGSize(width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4)
                
                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "crown"), size: stateIndicatorSize)
                stateIndicatorColorLeft.color = isWinnerWhite ? UIColor.white : UIColor.black
               stateIndicatorColorRight.color = isWinnerWhite ? UIColor.white : UIColor.black
                 print("\(isWinnerWhite  ? "White" : "Black") won!! White: \(Game[nowAt].getWhiteScore()) Black: \(Game[nowAt].getBlackScore())")
            }
            //If the state is draw.
            else {
                let stateIndicatorSize =
                    CGSize(width: chessBoard!.mapSize.width * chessBoard!.xScale / 2.5, height: chessBoard!.mapSize.height * chessBoard!.yScale / 4)
                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "scale"), size: stateIndicatorSize)
                stateIndicatorColorLeft.color = UIColor.white
                stateIndicatorColorRight.color = UIColor.black
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
        
        if needToShake{
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
            grid.shake(duration: 0.6, amplitudeX:20.0, numberOfShakes: 4)
            for node in nodes{
                node.shake(duration: 0.6, amplitudeX: 20.0, numberOfShakes: 4)
            }
            nodes.first!.run(SKAction.wait(forDuration: 0.6)){self.isUserInteractionEnabled = true}
            
            needToShake = false
        }
        
        //change the color of stateIndicator
        if !Game[nowAt].isEnd() {
            
            stateIndicatorColorLeft.color = isColorWhiteNow ? UIColor.white : UIColor.black
            stateIndicatorColorRight.color = isColorWhiteNow ? UIColor.white : UIColor.black
        }
        
        Game[nowAt].isColorWhiteNow = isColorWhiteNow
    }
    func retry(){
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
        let alert = UIAlertController(title: "Alert", message: "You will lose your progress now. Are you sure to start a new game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cool, sweet!", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "No. Let me think", style: .destructive, handler: handler))
        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
        
        
        
       
    }
    func yOfReview(_ x: CGFloat) -> CGFloat{
        return 1 - abs(2 * x / CGFloat.pi)
    }
    //this is based on the position of indexWithMaxZPositionInReviews
    func xOfReview(_ i: Int) -> CGFloat{
        return CGFloat(i - indexOfTheToppestReview) * scene!.size.width / CGFloat(5)
    }
    func xOfReview(_ i: Int, base: Int) -> CGFloat{
        return CGFloat(i - base) * scene!.size.width / CGFloat(5)
    }
    //get the scale of i-th review should be; offset is the base position; base is index
    func scaleOfReview(_ i: Int, base: Int, offset: CGFloat = 0) -> CGFloat{
        return UIScreen.main.scale * 3/5 * yOfReview((xOfReview(i,base: base) + offset) * CGFloat.pi / 2 / scene!.size.width)
    }
    func zPositionOfReview(_ i: Int) -> CGFloat{
        return 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
    }
    func setIndexOfTheToppestReview(){
        for i in 0...reviews.count - 1{
            if reviews[i].zPosition > reviews[indexOfTheToppestReview].zPosition{
                indexOfTheToppestReview = i
            }
        }
        print("indexOfTheToppestReview = ", indexOfTheToppestReview)
    }
    func takeScreenShot(isWhite: Bool){
        ///take the first screenshot
        let bounds = self.scene!.view?.bounds
        UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
        
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.scene?.view?.drawHierarchy(in: bounds!,afterScreenUpdates: true)
        context.setLineWidth(10.0)
        context.setStrokeColor(isWhite ? UIColor.white.cgColor : UIColor.black.cgColor)
        context.stroke(bounds!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let review = SKSpriteNode(texture: SKTexture(image: image!))
        imagesOfReview.append(image!)
        reviews.append(review)
        //review.lightingBitMask = 1
        review.name = "review_\(nowAt)"
        ///take the first screenshot
    }
    func showReview(){
        for i in 0...reviews.count - 1{
            reviews[i].setScale(UIScreen.main.scale)
            reviews[i].position = CGPoint(x:  xOfReview(i), y: 0.0)
            reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            addChild(reviews[i])
            let scaleAnimation = SKAction.scale(to: UIScreen.main.scale * 3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
            isUserInteractionEnabled = false
            reviews[i].run(scaleAnimation){self.isUserInteractionEnabled = true
                self.isReviewMode = true
            }
        }
    }
    func addAllChildrenBeforePreview(){
        for labelRow in labels{
            for label in labelRow{
                addChild(label)
            }
        }
        addChild(blackScore_label)
        addChild(whiteScore_label)
        addChild(stateIndicator)
        addChild(chessBoard)
        addChild(retryNode)
        addChild(toTitle)
        addChild(undoNode)
        addChild(grid)
        addChild(chessBoardBackground)
    }
    func undo(){
        self.stopFinding = true
        
        takeScreenShot(isWhite: self.isColorWhiteNow)
        indexOfTheToppestReview = reviews.count - 1
        
        removeAllChildren()
        
        let reviewBackground = SKSpriteNode(color: .black, size: scene!.size)
        print(scene!.size)
        reviewBackground.name = "reviewBackground"
        reviewBackground.zPosition = 2
        addChild(reviewBackground)
        
        showReview()
        
    }
    func touchDownOnGrid(row: Int, col: Int){
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
                //if it is computer's turn
                if self.isAIMode && self.isColorWhiteNow == self.isComputerWhite{
                    //self.run(SKAction.wait(forDuration: 0.5)){
                    self.touchDownOnGrid(row: 0, col: 0)
                    //}
                }
            }
        }
        else{
            let angleVeclocity = 8.0 * CGFloat.pi / 3.0
            undoNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: angleVeclocity, duration: 1)))
            serialQueue.async {
                let weight = self.computer.weight(turn: self.nowAt, gameSize: self.gameSize)
                if let bestStep = self.Game[self.nowAt].bestSolution(
                    isWhite: self.isColorWhiteNow,
                    searchDepth: self.AIlevel,
                    stopFinding: &self.stopFinding,
                    weight: weight){
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
         //TODO: messy screenshot, needToPass, clickfast will make turn messy
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
    func touchMovedDuringReviewMode(toPoint pos : CGPoint) {
        let offset = touchOrigin.x - pos.x
        let distanceBetweenToppestAndFirst = reviews[indexOfTheToppestReview].position.x - reviews.first!.position.x
        let distanceBetweenToppestAndLast = reviews.last!.position.x -  reviews[indexOfTheToppestReview].position.x

        print("indexWithMaxZPositionInReviews = ", indexOfTheToppestReview)
        print("offset = ", offset)
        if reviews.first!.position.x > 0 {
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i, base: 0) + offset - distanceBetweenToppestAndFirst
                reviews[i].setScale(scaleOfReview(i, base: 0))
                reviews[i].zPosition = zPositionOfReview(i)
            }
        }
        else if reviews.last!.position.x < 0{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i, base: reviews.count - 1) + offset + distanceBetweenToppestAndLast
                reviews[i].setScale(scaleOfReview(i, base: reviews.count - 1))
                reviews[i].zPosition = zPositionOfReview(i)
            }
        }
        else{
            for i in 0...reviews.count - 1{
                reviews[i].position.x = xOfReview(i) + offset
                reviews[i].setScale(3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width) * UIScreen.main.scale)
                reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            }
        }
    }
    func touchUp(atPoint pos : CGPoint){
        
    }
    func touchUpDuringReviewMode(atPoint pos : CGPoint) {
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
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
                
                
            default:
                break
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first
        {
            
            if isReviewMode{
                self.touchMovedDuringReviewMode(toPoint: t.location(in: self))
                moveTimes += 1
                print(moveTimes)
                print("touches.count = ", touches.count)
            }
            else{
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
                    
                default:
                    break
                }
            }
        }
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(moveTimes)
        
        if let t = touches.first {
            let pos = t.location(in: self)
            let node = atPoint(pos)
            //in review mode
            if isReviewMode{
                
                self.touchUpDuringReviewMode(atPoint: pos)
                let distance = (pos.x - touchOrigin.x) * (pos.x - touchOrigin.x) + (pos.y - touchOrigin.y) * (pos.y - touchOrigin.y)
                if distance < 10{
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
                        let alert = UIAlertController(title: "Alert", message: "You will be unable to redo", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cool, sweet!", style: .default, handler: handler))
                        alert.addAction(UIAlertAction(title: "Wait, DON't!", style: .destructive, handler: handler))
                        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
                        
                        
                        
                    }
                    // touch is not on the toppest review but in others
                    else if (reviews as [SKNode]).contains(node){
                        let offset: CGFloat = -node.position.x
                        let index = reviews.firstIndex(of: node as! SKSpriteNode)!
                        self.isUserInteractionEnabled = false
                        for i in 0...reviews.count - 1{
                            reviews[i].zPosition = 4.0 + yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width)
                            let moveToBestPosition = SKAction.group([
                                SKAction.moveTo(x: xOfReview(i, base: index), duration: 0.2),
                                SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview(xOfReview(i, base: index) * CGFloat.pi / 2 / scene!.size.width), duration: 0.2)
                                ])
                            reviews[i].run(moveToBestPosition){
                                self.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
            //not in review mode
            else{
                print("touchesBegan count = ", touches.count)
                labels[scaledLabelAt.row][scaledLabelAt.col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                if isReviewMode {setIndexOfTheToppestReview()}
                let node = self.atPoint(pos)
                switch node {
                case childNode(withName: "toTitle") :
                    if let view = view {
                        let transition:SKTransition = SKTransition.fade(withDuration: 1)
                        let scene:SKScene = MenuScene(fileNamed: "MenuScene")!
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene, transition: transition)
                    }
                case childNode(withName: "retry") :
                    retry()
                case childNode(withName: "undo") :
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
                        if !Game[nowAt].isEnd() {touchDownOnGrid(row: row, col: col)}
                        labels[row][col].fontSize = chessBoard.mapSize.width * chessBoard.xScale / CGFloat(gameSize) * 3/5
                        
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
    }
    /*
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
   
 */
    func showBoard(_ nowAt: Int, withAnimation: Bool = false){
        self.Game[self.nowAt].showBoard(labels: self.labels, whiteScoreLabel: self.whiteScore_label, blackScoreLabel: self.blackScore_label, stateIndicator: self.stateIndicator, stateIndicatorColorLeft: self.stateIndicatorColorLeft, stateIndicatorColorRight: self.stateIndicatorColorRight, chessBoardScaledWidth: self.chessBoardScaledWidth, chessBoardScaledHeight: self.chessBoardScaledHeight, isWhite: self.isColorWhiteNow, withAnimation: withAnimation)
    }
    //save game state and go to the next turn
    func saveGameState(){
        if nowAt == Game.count - 1{
            Game.append(Game[nowAt])
        }
        else {
            Game[nowAt + 1] = Game[nowAt]
        }
        nowAt = nowAt + 1
        Game[nowAt].turn = nowAt
    }
    func touchOnTheToppestReview(_ node: SKNode){
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
        //TODO: 4, review wipe speed not good for iphone X  6,highCPU,
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        //start after animation
        /*if isUserInteractionEnabled{
             if let grid = childNode(withName: "grid") as? Grid{
                 if grid.color != (isColorWhiteNow ? .white : .black){
                 grid.setGridColor(color: isColorWhiteNow ? .white : .black)
                 }
             }
            //AI turn (white)
            //TODO:when needToPass computer won't move
            if isColorWhiteNow == isComputerWhite && isAIMode && !Game[nowAt].isEnd(){
                if let bestStep = Game[nowAt].bestSolution(isWhite: isColorWhiteNow, searchDepth: 3){
                    if nowAt == Game.count - 1{
                        Game.append(Game[nowAt])
                    }
                    else {
                        Game[nowAt + 1] = Game[nowAt]
                        
                    }
                    nowAt = nowAt + 1
                    touchDownOnGrid(row: bestStep.row, col: bestStep.col)
                }
            }
        }*/
    }
 
}
