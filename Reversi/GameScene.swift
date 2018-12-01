//
//  GameScene.swift
//  Reversi
//
//  Created by john gospai on 2018/11/10.
//  Copyright © 2018 john gospai. All rights reserved.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var isAIMode = false
    let isComputerWhite = true
    var borderWidth: CGFloat = 0
    var borderHeight: CGFloat = 0
    var labels: [[SKLabelNode]] = []
    var blackScore_label: SKLabelNode!
    var whiteScore_label: SKLabelNode!
    var stateIndicator = SKCropNode()
    var chessBoard: SKTileMapNode!
    var isColorWhiteNow = false
    var nowAt = 0
    var Game = [Reversi()]
    var reviews:[SKSpriteNode] = []
    var touchOrigin = CGPoint()

    override func didMove(to view: SKView) {
        scene!.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //define safeArea
        let safeAreaInsets = view.safeAreaInsets
        print(safeAreaInsets)
        print(view.frame.size)
        print(scene!.view?.bounds)
        self.isUserInteractionEnabled = true
        
        
        
        chessBoard = childNode(withName: "ChessBoard") as? SKTileMapNode
        //initialize labels and cells
        let retry = childNode(withName: "retry") as? SKSpriteNode
        let toTitle = childNode(withName: "toTitle") as? SKSpriteNode
        let undo = childNode(withName: "undo") as? SKSpriteNode
        
        retry?.position = CGPoint(x: scene!.size.width/2 - safeAreaInsets.right - 20, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        toTitle?.position = CGPoint(x: -scene!.size.width/2 + safeAreaInsets.left + 20, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        undo?.position = CGPoint(x: 0, y: -scene!.size.height/2 + safeAreaInsets.bottom + 20)
        let iconSideLength = chessBoard.mapSize.width * chessBoard.xScale / 3
        retry?.size = CGSize(width: iconSideLength, height: iconSideLength)
        toTitle?.size = CGSize(width: iconSideLength, height: iconSideLength)
        undo?.size = CGSize(width: iconSideLength, height: iconSideLength)
        
        chessBoard.xScale = (scene!.size.width * 7/8) / chessBoard.mapSize.width
        chessBoard.yScale = chessBoard.xScale
        borderWidth = (view.frame.width - chessBoard!.mapSize.width * chessBoard!.xScale * 5 / 6.0) / 2.0
        borderHeight = (view.frame.height -         chessBoard!.mapSize.height * chessBoard!.yScale * 5 / 6.0) / 2.0
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
        let grid = Grid(blockSize: blockSize, rows: 6, cols: 6)!
        grid.position = CGPoint (x:0, y:0)
        grid.name = "grid"
        grid.zPosition = 1
        addChild(grid)
        
        let chessBoardScaledWidth = chessBoard!.mapSize.width * chessBoard.xScale
        let chessBoardScaledHeight = chessBoard!.mapSize.height * chessBoard.yScale
        
        
        //initialize stateIndicator with mask and show upArrow
        
        let stateIndicatorSize =
            CGSize(
            width: chessBoard!.mapSize.width * chessBoard!.xScale / 6.0,
            height: chessBoard!.mapSize.height * chessBoard!.yScale / 6.0)
        
        stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "upArrow"), size: stateIndicatorSize)
        let stateIndicatorColorLeft = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: view.frame.width / 2, height: view.frame.height))
        stateIndicatorColorLeft.position = CGPoint(x:-0.25 * view.frame.width,y:0)
        stateIndicatorColorLeft.name = "stateIndicatorColorLeft"
        stateIndicator.addChild(stateIndicatorColorLeft)
        

        let stateIndicatorColorRight = SKSpriteNode.init(color: UIColor.black, size: CGSize(width: view.frame.width / 2, height: view.frame.height))
        stateIndicatorColorRight.position = CGPoint(x: 0.25 * view.frame.width,y:0)
        stateIndicatorColorRight.name = "stateIndicatorColorRight"
        stateIndicator.addChild(stateIndicatorColorRight)
        
        stateIndicator.position = CGPoint(x:0,y: (-8.0 / 12.0) * chessBoard!.mapSize.height * chessBoard!.yScale)
        stateIndicator.zPosition = -1
        addChild(stateIndicator)
        
        Game[nowAt].showBoard(labels: labels, whiteScoreLabel: whiteScore_label, blackScoreLabel: blackScore_label, stateIndicator: stateIndicator, stateIndicatorColorLeft: stateIndicatorColorLeft, stateIndicatorColorRight: stateIndicatorColorRight ,chessBoardScaledWidth: chessBoardScaledWidth, chessBoardScaledHeight: chessBoardScaledHeight, isWhite: isColorWhiteNow)
       
    }
    
    
    func touchDownOnGrid(row: Int, col: Int) {


        let grid = self.childNode(withName: "grid")! as! Grid
        var needToShake = false
        if Game[nowAt].fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){
            isColorWhiteNow = !isColorWhiteNow
        }
        else {
            //shake!!
            needToShake = true
            print("Unavailable move at \(row), \(col)")
        }
        
        let stateIndicatorColorLeft = stateIndicator.childNode(withName: "stateIndicatorColorLeft") as! SKSpriteNode
        let stateIndicatorColorRight = stateIndicator.childNode(withName: "stateIndicatorColorRight") as! SKSpriteNode
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
        let chessBoardScaledWidth = chessBoard!.mapSize.width * chessBoard.xScale
        let chessBoardScaledHeight = chessBoard!.mapSize.height * chessBoard.yScale
        Game[nowAt].showBoard(labels: labels, whiteScoreLabel: whiteScore_label, blackScoreLabel: blackScore_label, stateIndicator: stateIndicator, stateIndicatorColorLeft: stateIndicatorColorLeft, stateIndicatorColorRight: stateIndicatorColorRight, chessBoardScaledWidth: chessBoardScaledWidth, chessBoardScaledHeight: chessBoardScaledHeight, isWhite: isColorWhiteNow)
        Game[nowAt].showBoard(isWhite: isColorWhiteNow)
    
        
        
        blackScore_label!.text = "\(Game[nowAt].getBlackScore())"
        whiteScore_label!.text = "\(Game[nowAt].getWhiteScore())"
        
        if needToShake {
            isUserInteractionEnabled = false
            var nodes: [SKNode] = []
            for i in 0...35{
                nodes.append(labels[i/6][i % 6] as SKNode)
            }
            nodes.append(chessBoard! as SKNode)
            grid.shake(duration: 0.5, amplitudeX:20.0, numberOfShakes: 4, completion: {self.isUserInteractionEnabled = true})
            for node in nodes{
                node.shake(duration: 0.5, amplitudeX: 20.0, numberOfShakes: 4, completion: {self.isUserInteractionEnabled = true})
            }
            needToShake = false
        }
        
        //change the color of stateIndicator
        if !Game[nowAt].isEnd() {
            let stateIndicatorColorLeft = stateIndicator.childNode(withName: "stateIndicatorColorLeft") as! SKSpriteNode
            stateIndicatorColorLeft.color = isColorWhiteNow ? UIColor.white : UIColor.black
            let stateIndicatorColorRight = stateIndicator.childNode(withName: "stateIndicatorColorRight") as! SKSpriteNode
            stateIndicatorColorRight.color = isColorWhiteNow ? UIColor.white : UIColor.black
        }
        ///take the first screenshot
        
        let bounds = self.scene!.view?.bounds
        UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
        self.scene?.view?.drawHierarchy(in: bounds!,afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let review = SKSpriteNode(texture: SKTexture(image: image!))
        reviews.append(review)
        review.name = "review_\(reviews.count - 1)"
        ///take the first screenshot
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
    func showReview(){
        for i in 0...reviews.count - 1{
            reviews[i].setScale(UIScreen.main.scale)
            reviews[i].position = CGPoint(x:  -CGFloat(reviews.count - 1 - i) * scene!.size.width / CGFloat(reviews.count), y: 0.0)
            reviews[i].zPosition = 4.0 + cos(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            addChild(reviews[i])
            let scaleAnimation = SKAction.scale(by: 3/5 * cos(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width), duration: 1)
            isUserInteractionEnabled = false
            reviews[i].run(scaleAnimation){self.isUserInteractionEnabled = true}
        }
    }
    func undo(){
        
        ///take the first screenshot
        let bounds = self.scene!.view?.bounds
        UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
        self.scene?.view?.drawHierarchy(in: bounds!,afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let review = SKSpriteNode(texture: SKTexture(image: image!))
        reviews.append(review)
        review.name = "review_\(reviews.count - 1)"
        ///take the first screenshot
        
        let reviewBackground = SKSpriteNode(color: .black, size: scene!.size)
        print(scene!.size)
        reviewBackground.name = "reviewBackground"
        reviewBackground.zPosition = 2
        addChild(reviewBackground)
        showReview()
        //removeChildren(in: [reviewBackground])
        
    }
    func touchMoved(toPoint pos : CGPoint) {
        if reviews.first!.position.x > 0 || reviews.last!.position.x < 0{
            for i in 0...reviews.count - 1{
                reviews[i].position.x += (touchOrigin.x - pos.x) / 20
            }
        }
        else{
            for i in 0...reviews.count - 1{
                reviews[i].position.x += (touchOrigin.x - pos.x) / 5
                reviews[i].setScale(3/5 * cos(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width) * UIScreen.main.scale)
                reviews[i].zPosition = 4.0 + cos(reviews[i].position.x * CGFloat.pi / 2 / scene!.size.width)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        if reviews.first!.position.x > 0 {
            isUserInteractionEnabled = false
            for i in 0...reviews.count - 1{
                reviews[i].run(SKAction.moveTo(x: CGFloat(i) * scene!.size.width / CGFloat(reviews.count), duration: 1)){self.isUserInteractionEnabled = true}
            }
        }
        else if reviews.last!.position.x < 0{
            isUserInteractionEnabled = false
            for i in 0...reviews.count - 1{
                reviews[i].run(SKAction.moveTo(x: -CGFloat(reviews.count - 1 - i) * scene!.size.width / CGFloat(reviews.count), duration: 1)){self.isUserInteractionEnabled = true}
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in: self)
            touchOrigin = pos
            let node = self.atPoint(pos)
            print(node)
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
            case let review where (reviews as [SKNode]).contains(review):
                var turnString = review.name
                turnString?.removeFirst(7)
                let turn = Int(turnString!)
                
                isUserInteractionEnabled = false
                review.run(SKAction.scale(to: UIScreen.main.scale, duration: 1)){
                    print("nowAt:", self.nowAt)
                    self.nowAt = turn!
                    print("turn:", turn!)
                    self.isColorWhiteNow = self.Game[self.nowAt].isColorWhiteNow
                    print("Colo:\(self.isColorWhiteNow ? "white" : "black")")
                    self.removeChildren(in: [self.childNode(withName: "reviewBackground")!])
                    self.removeChildren(in: self.reviews)
                    self.reviews.removeLast(self.reviews.count - self.nowAt)
                    
                    self.isUserInteractionEnabled = true
                    
                }
                //TODO: 1,check nowAt = 0  2,reviews.count = 1  3,when black  4, review wipe speed not good  5, reviews have wierd screenshot  6,highCPU, 7,indexOutOfRange 8,clickoutside bad sigabat
            
            case childNode(withName: "grid")! :
                let touchPosOnGrid = (node as! Grid).positionToGridPosition(position: pos)
                if let row = touchPosOnGrid?.row, let col = touchPosOnGrid?.col{
                    ///take a screenshot
                    /*
                    if let review = childNode(withName: "review") {removeChildren(in: [review])}
                    let bounds = self.scene!.view?.bounds
                    UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
                    self.scene?.view?.drawHierarchy(in: bounds!,afterScreenUpdates: false)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    let review = SKSpriteNode(texture: SKTexture(image: image!), color: UIColor.red, size: CGSize(width: bounds!.size.width * 0.3, height: bounds!.size.height * 0.3))
                    review.anchorPoint = CGPoint(x: 0.5,y: 0)
                    review.position = CGPoint(x: 0, y: chessBoard!.mapSize.height * chessBoard!.yScale / 2.0)
                    review.zPosition = 1
                    review.scale(to: CGSize(width: 100, height: 300))
                    review.name = "review"
                    addChild(review)
 */
                    
                    ///take a screenshot
                    if !isAIMode || isColorWhiteNow != isComputerWhite{
                        if Game[nowAt].isAvailable(Row: row, Col: col, isWhite: isColorWhiteNow){
                            if nowAt == Game.count - 1{
                                Game.append(Game[nowAt])
                            }
                            else {
                                Game[nowAt + 1] = Game[nowAt]
                                
                            }
                            nowAt = nowAt + 1
                        }
                        touchDownOnGrid(row: row, col: col)
                    }
                }
            default:
                print(pos)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { self.touchMoved(toPoint: t.location(in: self)) }
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
     /*
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
 */
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        //start after animation
        if isUserInteractionEnabled{
             /*if let grid = childNode(withName: "grid") as? Grid{
                 if grid.color != (isColorWhiteNow ? .white : .black){
                 grid.setGridColor(color: isColorWhiteNow ? .white : .black)
                 }
             }
            //AI turn (white)
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
            }*/
        }
    }
 
}
