//
//  MenuScene.swift
//  Reversi
//
//  Created by john gospai on 2018/11/16.
//  Copyright © 2018 john gospai. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
     override func didMove(to view: SKView) {
        let picture = SKSpriteNode(color: UIColor.red, size:  CGSize(width: 100, height: 100))
        picture.position = CGPoint(x: 100, y: 100)
        picture.name = "picture"
        addChild(picture)
        
        let dx = picture.position.x / 2
        let dy = picture.position.y / 2
        
        let rad = atan2(dy, dx)
        
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 90, startAngle: rad, endAngle: rad + CGFloat(CGFloat.pi * 4), clockwise: true)
        
        let follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: false, speed: 150)
        //let rotate = SKAction.rotateByAngle(75, duration: 100)
        
        //Slider.runAction(SKAction.repeatActionForever(rotate).reversedAction())
        //let circle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath
    picture.run(SKAction.repeatForever(SKAction.group([
            SKAction.rotate(byAngle: 45, duration: 8),follow])
            )
        )
        
        let light = SKLightNode()
        light.position = CGPoint(x: 0, y: 0)
        light.isEnabled = true
        light.categoryBitMask = 1
        light.falloff = 0
        light.ambientColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.87)
        light.lightColor = SKColor(red: 0.8, green: 0.8, blue: 0.4, alpha: 0.8)
        light.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        addChild(light)
        picture.lightingBitMask = 1
        picture.shadowedBitMask = 1
        picture.shadowCastBitMask = 1
        
        /// bestSolutionTestArea
//        var stopFinding = false
//        var testNumber = 25
//        var draws = 0.0
//        var wins = [0.0, 0.0]
//        let gameSize = 4
//        
//        let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
//        struct Player: CustomStringConvertible{
//            var description: String{
//                var des = ""
//                des += "name: \(name)\n"
//                des += "searchDepth: \(searchDepth)\n"
//                des += "weight: \(weights)"
//                return des
//            }
//            
//            var name: String = "p"
//            var searchDepth: UInt = 1
//            var weights = [Weight](repeating: Weight(), count: 3)
//            //var weight = Weight(scoreDifferenceWeight: 1, sideWeight: 2, CWeight: 5, XWeight: 20, cornerWeight: 50)
//        }
//        func test(players: [Player], whoFirst: Int, testOfNumber i: Int,description: Bool = false){
//            
//            var Game = Reversi.init(n: gameSize)
//            if description{
//                print("•test number: ", i, ", ", Double(i) / Double(testNumber) * 100.0 , "%")
//                Game.showBoard(isWhite: false)
//                print(" \(players[0].name): search depth = ", players[0].searchDepth)
//                print(" \(players[1].name): search depth = ", players[1].searchDepth)
//            }
//            
//            while !Game.isEnd(){
//                //Game.showBoard(isWhite: Game.isColorWhiteNow)
//                //black
//                if Game.isColorWhiteNow == false{
//                    if let bestSolution = Game.bestSolution(isWhite: Game.isColorWhiteNow, searchDepth: players[whoFirst].searchDepth, stopFinding: &stopFinding,
//                                                            weight: players[whoFirst].weights[Game.turn / 32]){
//                        Game.play(Row: bestSolution.row, Col: bestSolution.col)
//                    }
//                }
//                else{
//                    //white
//                    if let bestSolution = Game.bestSolution(isWhite: Game.isColorWhiteNow, searchDepth: players[1 - whoFirst].searchDepth, stopFinding: &stopFinding, weight: players[1 - whoFirst].weights[Game.turn / 32]){
//                        Game.play(Row: bestSolution.row, Col: bestSolution.col)
//                    }
//                }
//                
//                
//            }
//            if description{
//                Game.showBoard(isWhite: Game.isColorWhiteNow)
//            }
//            
//            if Game.getBlackScore() > Game.getWhiteScore(){
//                if description{
//                    print(" \(players[whoFirst].name) wins")
//                }
//                
//                wins[whoFirst] += 1
//            }
//            else if Game.getBlackScore() < Game.getWhiteScore(){
//                if description{
//                    print(" \(players[whoFirst].name) wins")
//                }//
//                wins[1 - whoFirst] += 1
//            }
//            else {
//                if description{
//                    print(" Draw")
//                }
//                //
//                draws += 1
//            }
//            if description{
//                print(" \(players[0].name) wins = " , (wins[0] + 0.5 * draws) / Double(i) * 100.0, "%")
//                print(" \(players[1].name) wins = ", (wins[1] + 0.5 * draws) / Double(i) * 100.0, "%")
//                print(" Draws = ", draws / Double(i) * 100.0, "%")
//                print("")
//                
//            }
//            
//            
//        }
//        func whoWins(players: [Player], testNumber: Int = 500) -> Int {
//            var whoFirst = 0
//            draws = 0.0
//            wins = [0.0, 0.0]
//            for i in 1...testNumber{
//                //print("\(players[whoFirst].name) First")
//                test(players: players,whoFirst: whoFirst, testOfNumber: i)
//                whoFirst = 1 - whoFirst
//            }
//            return wins[0] == wins.max() ? 0 : 1
//        }
//        
//        //initialize two players p0 and p1
//        var initialStartWeight = Weight(scoreDifferenceWeight: 1,
//                                        sideWeight: 21,
//                                        CWeight: 16,
//                                        XWeight: 3,
//                                        cornerWeight: 11
//        )
//        var initialMiddleWeight = Weight(scoreDifferenceWeight: 1,
//                                         sideWeight: 57,
//                                         CWeight: 11,
//                                         XWeight: 41,
//                                         cornerWeight: 60
//        )
//        var initialFinalWeight = Weight(scoreDifferenceWeight: 1,
//                                        sideWeight: 7,
//                                        CWeight: 1,
//                                        XWeight: 9,
//                                        cornerWeight: 19
//        )
//        let initialWeights = [initialStartWeight, initialMiddleWeight, initialFinalWeight]
//        var p0 = Player(
//            name: "player0",
//            searchDepth: 3, weights: initialWeights
//        )
//        var p1 = Player(
//            name: "player1",
//            searchDepth: 3,
//            weights: initialWeights)
//        var players = [p0,p1]
//        var bestWeightChoice = p0.weights
//        var winsInARow = 0
//        var maxConsecutiveWins = 0
//        var winner = 0
//        test(players: players, whoFirst: 0, testOfNumber: 1)
//        print(wins)
        
        
        /// bestSolutionTestArea
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
///test region
            //take a screenshot and show it in GameScene
/*
            //start to take a screenshot
            let bounds = self.scene!.view?.bounds
            UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
            self.scene?.view?.drawHierarchy(in: bounds!,afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            
            
            let review = SKSpriteNode(texture: SKTexture(image: image!), color: UIColor.red, size: CGSize(width: bounds!.size.width, height: bounds!.size.height))
            review.zPosition = 1
            scene.addChild(review)
*/
            
            
///test region
            
             let transition:SKTransition = SKTransition.fade(withDuration: 1)
           
            
            let scene = GameScene(fileNamed: "GameScene")!
            scene.gameSize = 8
            scene.isComputerWhite = false
            if saveUtility.loadGames() == nil{
                scene.scaleMode = .aspectFill
                self.isUserInteractionEnabled = false
                self.view?.presentScene(scene, transition: transition)
            }
            else {
                let handler: (UIAlertAction) -> Void  = { action in
                    switch action.style{
                    case .default:
                        print("default")
                        //remove all saved data
                        //scene.cleanUpSavedFile()
                        scene.needToLoad = true
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")   
                    }
                    scene.scaleMode = .aspectFill
                    self.isUserInteractionEnabled = false
                    self.view?.presentScene(scene, transition: transition)
                }
                let alert = UIAlertController(title: "Alert", message: "Do you want to continue the last game?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cool, sweet!", style: .default, handler: handler))
                alert.addAction(UIAlertAction(title: "Start a new game!", style: .destructive, handler: handler))
                UIApplication.getPresentedViewController()!.present(alert, animated: true){}
                
            }
            
            
            
            
            
            //TODO: avoid multiple touch such that present many scnenes
        }
    }
  /*
    func touchDownOnGrid(row: Int, col: Int) {
        
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
        }
    }
   
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     }
     
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     }
     
     
     override func update(_ currentTime: TimeInterval) {
     // Called before each frame is rendered
     }
     */
}
