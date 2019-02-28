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
    var gameSize = 4
    var isAIMode = false
    //parameters for time
    var timingToSetIsUserInteractionEnabledToTrue: TimeInterval = TimeInterval(0){
        didSet{
            if oldValue > timingToSetIsUserInteractionEnabledToTrue{
                timingToSetIsUserInteractionEnabledToTrue = oldValue
                print("didSet timingToSet ", timingToSetIsUserInteractionEnabledToTrue)
            }
        }
    }
    var canSetIsUserInteractionEnabledToTrue: Bool{
        get{
            if Date().timeIntervalSince1970 >= timingToSetIsUserInteractionEnabledToTrue {
                print("can set")
                return true
                
            }
            print("cannot set")
            return false
        }
    }
    override var isUserInteractionEnabled: Bool{
        didSet{
            if !canSetIsUserInteractionEnabledToTrue, isUserInteractionEnabled{
                isUserInteractionEnabled = false
                print("set userenable back to false")
            }
        }
    }
    
    
    
    
    var redblock = SKSpriteNode()
    var isUserLabel = SKLabelNode()
    var gameSizeLabel:SKLabelNode!
    var fourLabel:SKLabelNode!
    var sixLabel:SKLabelNode!
    var eightLabel:SKLabelNode!
    var gameModeLabel: SKLabelNode!
    var single: SKLabelNode!
    var two: SKLabelNode!
    var gameMode = 1
     override func didMove(to view: SKView) {
//        var safeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *){
//            safeAreaInsets = view.safeAreaInsets
//        }
        self.size = CGSize(width: view.frame.size.width * UIScreen.main.scale,height: view.frame.size.height * UIScreen.main.scale)
        //let size = CGSize(width: 300, height: 300)
        let size = CGSize(width: self.size.width / 2, height: self.size.height / 2)
        //UIGraphicsBeginImageContext(size)
        //guard
         //else{fatalError("cannot set safeAreaInsets")}
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
        let bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        //print(safeAreaInsets)
//        let roundedBounds = UIBezierPath.init(roundedRect: bounds, cornerRadius: 40)
//        //roundedBounds.addClip()
//        context.saveGState()
//        roundedBounds.addClip()
//        context.addRect(bounds)
//        UIColor.blue.setFill()
//        context.fill(bounds)
//        context.restoreGState()
//        //context.addPath(roundedBounds.cgPath)
//        //context.fillPath()
//        //context.cli
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        ///start to draw
//        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
//        UIImage(named: "backgroundImage")!.drawAsPattern(in: rect)
//        context.addRect(rect)
        ///end drawing
        //let image = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
        //let testBox = SKSpriteNode(texture: SKTexture(image: image!), size: size)
        //addChild(testBox)
//        redblock = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
//        addChild(redblock)
//        isUserLabel = SKLabelNode(text: "touch me U c U")
//        isUserLabel.position = CGPoint(x: 0, y: 100)
//        isUserLabel.fontName = "chalkboard SE"
//        addChild(isUserLabel)
//        isUserLabel.run(SKAction.repeatForever(SKAction.sequence([
//            SKAction.move(to: CGPoint(x: -100, y: 0), duration: 1),
//            SKAction.move(to: CGPoint(x: 100, y: 0), duration: 1)
//            ])))
        let fontColor = UIColor.white
        let fontSize = UI.gridSize / 16
        let fontName = "chalkboard SE"
        
        gameSizeLabel = SKLabelNode(text: "choose game size")
        gameSizeLabel.position.y = size.height / 4
        gameSizeLabel.fontSize = fontSize
        gameSizeLabel.fontColor = fontColor
        gameSizeLabel.fontName = fontName
        addChild(gameSizeLabel)
        
        fourLabel = SKLabelNode(text: "four")
        fourLabel.position.x = -size.width / 2
        fourLabel.fontSize = fontSize
        fourLabel.fontColor = fontColor
        fourLabel.fontName = fontName
        addChild(fourLabel)
        
        sixLabel = SKLabelNode(text: "six")
        sixLabel.fontSize = fontSize
        sixLabel.fontColor = fontColor
        sixLabel.fontName = fontName
        addChild(sixLabel)
        
        eightLabel = SKLabelNode(text: "eight")
        eightLabel.position.x = size.width / 2
        eightLabel.fontSize = fontSize
        eightLabel.fontColor = fontColor
        eightLabel.fontName = fontName
        addChild(eightLabel)
        
        gameModeLabel = SKLabelNode(text: "choose mode")
        gameModeLabel.position.y = -size.height / 4
        gameModeLabel.fontSize = fontSize
        gameModeLabel.fontColor = fontColor
        gameModeLabel.fontName = fontName
        addChild(gameModeLabel)
        
        single = SKLabelNode(text: "single")
        single.position.y = -size.height / 2
        single.position.x = size.width / 2
        single.fontSize = fontSize
        single.fontColor = fontColor
        single.fontName = fontName
        addChild(single)
        
        two = SKLabelNode(text: "two")
        two.position.y = -size.height / 2
        two.position.x = -size.width / 2
        two.fontSize = fontSize
        two.fontColor = fontColor
        two.fontName = fontName
        addChild(two)
    }
    /**/
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
//            print("Don't touch me!! ", Date().timeIntervalSince1970)
//            self.isUserInteractionEnabled = false
//            timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSince1970 + 10
//            redblock.run(SKAction.rotate(byAngle: CGFloat.pi, duration: 10)){
//                print(Date().timeIntervalSince1970)
//                self.isUserInteractionEnabled = true}
//            timingToSetIsUserInteractionEnabledToTrue = Date().timeIntervalSince1970 + 3
//            redblock.run(SKAction.colorize(with: UIColor(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: 1), colorBlendFactor: 0.5, duration: 3)){
//                print(Date().timeIntervalSince1970)
//                self.isUserInteractionEnabled = true}
            
            
        //follow path
            
//            let path = CGMutablePath()
//            path.move(to: CGPoint(x: 0, y: 0))
//            path.addQuadCurve(to: CGPoint(x: 300, y: 300), control: CGPoint(x: 200, y: 0))
//            redblock.run(SKAction.follow(path, asOffset: true, orientToPath: false, duration: 1))
            
//            let background = SKSpriteNode(color: .blue, size: size)
//            UIGraphicsBeginImageContext(size)
//            let ctx = UIGraphicsGetCurrentContext()
//            UIColor.green.setFill()
//            ctx?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            ctx?.addPath(path)
//            ctx?.setLineWidth(6)
//            UIColor.black.setStroke()
//            ctx?.strokePath()
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            background.texture = SKTexture(image: image!)
//            addChild(background)
///test region
            
///screenshot test region
//            let ctx = UIGraphicsGetCurrentContext()
//            self.view!.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size), afterScreenUpdates: true)
//            ctx?.addRect(UIScreen.main.bounds)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            let screenshot = SKSpriteNode(color: .red, size: size)
//
//
///screenshot test region
            let node = atPoint(touch.location(in: self))
            switch node{
            case fourLabel:
                fourLabel.fontColor = .red
                sixLabel.fontColor = .white
                eightLabel.fontColor = .white
                gameSize = 4
            case sixLabel:
                fourLabel.fontColor = .white
                sixLabel.fontColor = .red
                eightLabel.fontColor = .white
                gameSize = 6
            case eightLabel:
                fourLabel.fontColor = .white
                sixLabel.fontColor = .white
                eightLabel.fontColor = .red
                gameSize = 8
            case single:
                single.fontColor = .red
                two.fontColor = .white
                isAIMode = true
            case two:
                single.fontColor = .white
                two.fontColor = .red
                isAIMode = false
            default:
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                
                
                let scene = GameScene(fileNamed: "GameScene")!
                scene.gameSize = gameSize
                scene.isAIMode = isAIMode
                scene.isComputerWhite = false
                scene.AIlevel = UInt(1)
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
            }
            
        }
    }
    override func update(_ currentTime: TimeInterval) {
        //isUserLabel.text = isUserInteractionEnabled == true ? "touch me!! U c U" : "Don't touch me T T"
        isUserLabel.text = "\(isUserLabel.position)"
    }
   /*
    func touchMoved(toPoint pos : CGPoint) {
        redblock.position = pos
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
   
    func touchDownOnGrid(row: Int, col: Int) {
        
       
    }
    
    
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
        }
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
