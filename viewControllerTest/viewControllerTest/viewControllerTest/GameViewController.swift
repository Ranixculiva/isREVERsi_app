//
//  GameViewController.swift
//  viewControllerTest
//
//  Created by john gospai on 2019/8/19.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
extension UIImage{
    func resizeUIImage(to: CGSize, half: Bool = false) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(to, false, 2)
        self.draw(in: CGRect(origin: .zero, size: to))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
class UI{
    static let width = 100
}
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.rootViewController = self
        self.modalPresentationStyle = .currentContext
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        let storyBoard = UIStoryboard(name: "alertTest", bundle: .main)
//        
//        let alert = storyBoard.instantiateViewController(withIdentifier: "alertVC") as! alertViewController
//        AppDelegate.rootViewController?.present(alert, animated: true, completion: nil)
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
