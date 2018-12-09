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
class GameScene: SKScene {
    var moveTimes = 0
    var isReviewMode = false
    var isAIMode = true
    let isComputerWhite = true
    var borderWidth: CGFloat = 0
    var borderHeight: CGFloat = 0
    var labels: [[SKLabelNode]] = []
    var blackScore_label: SKLabelNode!
    var whiteScore_label: SKLabelNode!
    var stateIndicator = SKCropNode()
    var chessBoard: SKTileMapNode!
    var stateIndicatorColorLeft : SKSpriteNode!
    var stateIndicatorColorRight: SKSpriteNode!
    var chessBoardScaledWidth: CGFloat!
    var chessBoardScaledHeight: CGFloat!
    var grid : Grid!
    var retryNode:SKSpriteNode!
    var toTitle: SKSpriteNode!
    var undoNode: SKSpriteNode!
    var isColorWhiteNow = false
    var nowAt = 0
    var Game = [Reversi()]
    var reviews:[SKSpriteNode] = []
    var touchOrigin = CGPoint()
    var indexWithMaxZPositionInReviews = 0
//    var reviewLight: SKLightNode!

    override func didMove(to view: SKView) {
       
        
        view.isMultipleTouchEnabled = false
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //define safeArea
        let safeAreaInsets = view.safeAreaInsets
        print(safeAreaInsets)
        print(view.frame.size)
        print(scene!.view?.bounds)
        self.isUserInteractionEnabled = true
        
        
        
        chessBoard = childNode(withName: "ChessBoard") as? SKTileMapNode
        chessBoard.xScale = (scene!.size.width * 7/8) / chessBoard.mapSize.width
        chessBoard.yScale = chessBoard.xScale
        
        chessBoardScaledWidth = chessBoard!.mapSize.width * chessBoard.xScale
        chessBoardScaledHeight = chessBoard!.mapSize.height * chessBoard.yScale
        
        borderWidth = (view.frame.width - chessBoard!.mapSize.width * chessBoard!.xScale * 5 / 6.0) / 2.0
        borderHeight = (view.frame.height -         chessBoard!.mapSize.height * chessBoard!.yScale * 5 / 6.0) / 2.0
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
        
        
        for row in 0...5{
            var row_label: [SKLabelNode] = []
            for col in 0...5{
                
                let position = CGPoint(
                    x:borderWidth + (chessBoard!.mapSize.width * chessBoard!.xScale)/6 * CGFloat(col) - view.frame.midX,
                    y: view.frame.midY - borderHeight -  (chessBoard!.mapSize.height * chessBoard!.yScale)/6 * CGFloat(row))
                //label
                let label = childNode(withName: "label_\(row)\(col)") as! SKLabelNode
                label.text = ""
               
                label.position = position
                label.fontName = "Avenir"
                label.fontColor = SKColor.yellow
                label.fontSize = chessBoard.mapSize.width * chessBoard.xScale / 6.0 * 3/5
                row_label.append(label)
                
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
        let blockSize = chessBoard!.mapSize.width * chessBoard!.xScale / 6.0
        grid = Grid(blockSize: blockSize, rows: 6, cols: 6)!
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
    
    func touchDownOnGrid(row: Int, col: Int){
        /*//AIblack vs AIwhite
        if !self.Game[self.nowAt].isEnd(){
            //black 5 white 3
            let searchDepth = isColorWhiteNow ? 5 : 1
            if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: UInt(searchDepth)){
                //save game state
                saveGameState()
                run(SKAction.wait(forDuration: 0.7)){
                    self.play(row: bestStep.row, col: bestStep.col){
                    //keep playing
                        self.touchDownOnGrid(row: 0, col: 0)
                    }
                }
            }
        }*/
        let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
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
        else if !self.Game[self.nowAt].isEnd(){
            let angleVeclocity = 8.0 * CGFloat.pi / 3.0
            undoNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: angleVeclocity, duration: 1)))
            serialQueue.async {
                if let bestStep = self.Game[self.nowAt].bestSolution(isWhite: self.isColorWhiteNow, searchDepth: 3){
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
    func play(row: Int, col: Int, action: @escaping () -> Void = {}) {

        
        
        var needToShake = false
        if Game[nowAt].fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){

            isColorWhiteNow = !isColorWhiteNow
            //change grid color
            if grid.color != (isColorWhiteNow ? .white : .black){
                grid.run(SKAction.wait(forDuration: 0.6)){
                    self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
                    action()
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
            for i in 0...35{
                nodes.append(labels[i/6][i % 6] as SKNode)
                
            }
            nodes.append(chessBoard! as SKNode)
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
        if let view = view {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene:SKScene = GameScene(fileNamed: "GameScene")!
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
    }
    func yOfReview(_ x: CGFloat) -> CGFloat{
        return 1 - abs(2 * x / CGFloat.pi)
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

        reviews.append(review)
        //review.lightingBitMask = 1
        review.name = "review_\(nowAt)"
        ///take the first screenshot
    }
    func showReview(){
        for i in 0...reviews.count - 1{
            reviews[i].setScale(UIScreen.main.scale)
            reviews[i].position = CGPoint(x:  -CGFloat(reviews.count - 1 - i) * scene!.size.width / CGFloat(5/*reviews.count*/), y: 0.0)
            reviews[i].zPosition = 4.0 + yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            addChild(reviews[i])
            let scaleAnimation = SKAction.scale(to: UIScreen.main.scale * 3/5 * yOfReview(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
            isUserInteractionEnabled = false
            reviews[i].run(scaleAnimation){self.isUserInteractionEnabled = true
                self.isReviewMode = true
            }
        }
    }
   
    func undo(){
        
        takeScreenShot(isWhite: self.isColorWhiteNow)
       
        
        let reviewBackground = SKSpriteNode(color: .black, size: scene!.size)
        print(scene!.size)
        reviewBackground.name = "reviewBackground"
        reviewBackground.zPosition = 2
        addChild(reviewBackground)
        showReview()
        
    }
    func touchMovedDuringReviewMode(toPoint pos : CGPoint) {
        if reviews.first!.position.x > 0 || reviews.last!.position.x < 0{
            for i in 0...reviews.count - 1{
                reviews[i].position.x += (touchOrigin.x - pos.x) / 20
            }
        }
        else{
            for i in 0...reviews.count - 1{
                reviews[i].position.x += (touchOrigin.x - pos.x) / 5
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
        var offset: CGFloat = 0.0
        let maxZPosition = reviews.map{$0.zPosition}.max()
        for i in 0...reviews.count - 1{
            if reviews[i].zPosition == maxZPosition{
                offset = -reviews[i].position.x
                indexWithMaxZPositionInReviews = i
            }
        }
        self.isUserInteractionEnabled = false
        for i in 0...reviews.count - 1{
            let moveToBestPosition = SKAction.sequence([
                SKAction.moveBy(x: offset, y: 0, duration: 0.1),
                SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
                ])
            reviews[i].run(moveToBestPosition){
                self.isUserInteractionEnabled = true
                
                
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("touchesBegan count = ", touches.count)
            let pos = touch.location(in: self)
            touchOrigin = pos
            let node = self.atPoint(pos)
            switch node{
            case childNode(withName: "toTitle")! :
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = MenuScene(fileNamed: "MenuScene")!
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: transition)
                }
            case childNode(withName: "retry")! :
                retry()
            case childNode(withName: "undo")! :
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
            case childNode(withName: "grid")! :
                self.isUserInteractionEnabled = false
                let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                if let row = touchPosOnGrid?.row, let col = touchPosOnGrid?.col{
                    touchDownOnGrid(row: row, col: col)
                }
            default:
                print(pos)
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
                if distance < 1{
                    //touch on the toppest review
                    
                    if (reviews[indexWithMaxZPositionInReviews] as SKNode) == node{
                        if indexWithMaxZPositionInReviews == reviews.count - 1{
                            self.touchOnTheToppestReview(node)
                            return
                        }
                       
                        let alert = UIAlertController(title: "Alert", message: "You will be unable to redo", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cool, sweet!", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                                self.touchOnTheToppestReview(node)
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        alert.addAction(UIAlertAction(title: "Wait, DON't!", style: .destructive, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            }}))
                        UIApplication.getPresentedViewController()!.present(alert, animated: true){}
                        print("outThere")
                        
                        
                        
                    }
                    // touch is not on the toppest review
                    else if (reviews as [SKNode]).contains(node){
                        let offset: CGFloat = -node.position.x
                        self.isUserInteractionEnabled = false
                        for i in 0...reviews.count - 1{
                            reviews[i].zPosition = 4.0 + yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width)
                            let moveToBestPosition = SKAction.sequence([
                                SKAction.moveBy(x: offset, y: 0, duration: 0.1),
                                SKAction.scale(to:UIScreen.main.scale * 3/5 * yOfReview((reviews[i].position.x + offset) * CGFloat.pi / 2 / scene!.size.width), duration: 0.1)
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
    }
    func touchOnTheToppestReview(_ node: SKNode){
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
            var numberShouldBeRemove = 0
            for i in 0...self.reviews.count - 1{
                if self.reviews[i].name == "review_\(turn!)"{
                    numberShouldBeRemove = self.reviews.count - i
                }
            }
            self.reviews.removeLast(numberShouldBeRemove)
            
            self.isUserInteractionEnabled = true
            
            self.showBoard(self.nowAt)
            
            
            if self.grid.color != (self.isColorWhiteNow ? .white : .black){
                self.grid.setGridColor(color: self.isColorWhiteNow ? .white : .black)
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
