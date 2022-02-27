//
//  GameScene.swift
//  viewControllerTest
//
//  Created by john gospai on 2019/8/19.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.size = UIScreen.main.bounds.size
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        
       
        let help = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "help")))
        help.position.y = 201
        help.position.x = 1
        addChild(help)
        help.size = CGSize(width: 40, height: 40)
        backgroundColor = .green
        
        let testLogo = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "logo")), size: CGSize(width: 200, height: 50))
        //addChild(testLogo)
        testLogo.zPosition = 1
        testLogo.position.y = 0
        
//         let crop = SKCropNode()
//        crop.maskNode = testLogo

        
        let white = SKSpriteNode(color: .white, size: testLogo.size)
//
        
//        crop.addChild(white)
//        addChild(crop)
        var logoImage = #imageLiteral(resourceName: "logo")
        
        logoImage = logoImage.resizeUIImage(to: CGSize(width: 200, height: 200*logoImage.size.height/logoImage.size.width))
        var logo = CIImage(image: logoImage)
        
        
//        let maskFilter = CIFilter(name: "CIBlendWithMask")!
//        maskFilter.setValue(logo, forKey: "inputMaskImage")
//        let resultImage = maskFilter.outputImage
        
        
        
        // Set up your node
        let nodeToMask = white
        // ...
        
        // Set up the mask node
        let maskNode = SKEffectNode()
        
        // Create a filter
        let p = #imageLiteral(resourceName: "logo.png").resizeUIImage(to: white.size, half: true)
        let maskImage = CIImage(image: p)!
        let maskFilter = CIFilter(name: "CISourceInCompositing", parameters: ["inputBackgroundImage":maskImage])
        // Set the filter
        maskNode.filter = maskFilter
       // #imageLiteral(resourceName: "logo")
        maskNode.filter?.setValue( CIImage(image:  #imageLiteral(resourceName: "logo") ), forKey: kCIInputBackgroundImageKey)
        //maskNode.position = CGPoint(x: 100, y: 100)
        print(maskNode.frame)
        // Add childs
        
        let black = SKSpriteNode(color: .black, size: CGSize(width: logoImage.size.width*2, height: logoImage.size.height*2))
        maskNode.addChild(black)
        //maskNode.addChild(nodeToMask)
        
        addChild(maskNode)
        maskNode.position.y = 100
        white.run(SKAction.moveBy(x: 100, y: 0, duration: 10))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            //let testVC = TestVC()
            
            //AppDelegate.rootViewController?.present(testVC, animated: true, completion: {})
            
//            let alert = UIAlertController()
//           alert.message = "asdjlie"
//            alert.addAction(UIAlertAction(title: "adjfl", style: .cancel, handler: nil))
//            AppDelegate.rootViewController?.present(alert, animated: true, completion: {})
            //let test = UIViewController.init(nibName: "testNIB", bundle: nil)
            //AppDelegate.rootViewController?.present(test, animated: true, completion: nil)
//            let storyBoard = UIStoryboard(name: "alertTest", bundle: .main)
//            let alert = storyBoard.instantiateInitialViewController() as! alertViewController
//            AppDelegate.rootViewController?.present(alert, animated: true, completion: nil)
            let testVC = TestVC()
            testVC.delegate = self
            //AppDelegate.rootViewController?.present(testVC, animated: true, completion: nil)
            //let alert = UIAlertController(title: "adfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefa", message: "adfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefaadfefadfefadfefa", preferredStyle: .alert)
            //alert.addAction(UIAlertAction(title: "djfie", style: .cancel, handler: nil))
            //AppDelegate.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
}
