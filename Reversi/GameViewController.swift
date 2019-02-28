//
//  GameViewController.swift
//  Reversi
//
//  Created by john gospai on 2018/11/10.
//  Copyright © 2018 john gospai. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        if #available(iOS 11.0, *) {
            guard let topInset = UIApplication.shared.delegate?.window.unsafelyUnwrapped?.safeAreaInsets.top else{return true}
            if topInset > CGFloat(20) {return false}
            
        }
        return true
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let view = self.view as! SKView? {
            
            //view.preferredFramesPerSecond = 30
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "MenuScene") {
            let scene = TitleScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            //view.presentScene(scene)
            view.presentScene(scene)
            //}
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
 */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            
            //view.preferredFramesPerSecond = 30
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "MenuScene") {
            let scene = TitleScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            //view.presentScene(scene)
            view.presentScene(scene)
            //}
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
//        print(UIApplication.shared.delegate?.window??.safeAreaInsets.top)
//        //TODO: prepare SharedVariable
//        let scene = SKScene()
//        scene.backgroundColor = SKColor(red: 0, green: 122/255, blue: 1, alpha: 1)
//        if let view = self.view as! SKView?{
//            view.presentScene(scene)
//        }
        
//        if let view = self.view as! SKView? {
//            
//            //view.preferredFramesPerSecond = 30
//            // Load the SKScene from 'GameScene.sks'
//            //if let scene = SKScene(fileNamed: "TitleScene") {
//            let scene = TitleScene()
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//                // Present the scene
//                view.presentScene(scene)
//            //}
//            
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}
