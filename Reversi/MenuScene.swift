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
           
            
            let scene:SKScene = GameScene(fileNamed: "GameScene")!
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            scene.scaleMode = .aspectFill
            self.isUserInteractionEnabled = false
            self.view?.presentScene(scene, transition: transition)
            
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
