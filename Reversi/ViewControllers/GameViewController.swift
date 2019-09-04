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
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate {
    fileprivate let rewardBasedVideoAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    fileprivate let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    var adRequestInProgress = false
    var rewardBasedVideo: GADRewardBasedVideoAd?
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        SharedVariable.flips += 1
    }
    func loadRewardedVideoAd(){
        if !adRequestInProgress && rewardBasedVideo?.isReady == false && SharedVariable.withAds {
            rewardBasedVideo?.load(GADRequest(),
                                   withAdUnitID: rewardBasedVideoAdUnitID)
            adRequestInProgress = true
        }
    }
    @objc func showRewardedVideoAd(){
        
        if rewardBasedVideo?.isReady == true, SharedVariable.withAds{
            rewardBasedVideo?.present(fromRootViewController: self)
        } else {
            adRequestInProgress = false
            loadRewardedVideoAd()
            //TODO: show alert no ads to present for now!!
        }
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        adRequestInProgress = false
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adRequestInProgress = false
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        musicPlayer.savePlayersState()
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        musicPlayer.restorePlayersState()
        loadRewardedVideoAd()
        print("Reward based video ad is closed.")
        NotificationCenter.default.post(name: .rewardBasedVideoAdDidClose, object: nil)
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
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
    //MARK: - For rewarded video
    
    //MARK: - For interstitial ads
    @objc func showAds(){
        if interstitial.isReady, SharedVariable.withAds {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    var interstitial: GADInterstitial!
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: interstitialAdUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        musicPlayer.restorePlayersState()
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial){
        musicPlayer.savePlayersState()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        rewardBasedVideo?.load(GADRequest(), withAdUnitID: rewardBasedVideoAdUnitID)
        
        if SharedVariable.withAds{
            NotificationCenter.default.addObserver(self, selector: #selector(showAds), name: .showGoogleAds, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(showRewardedVideoAd), name: .showRewardedVideos, object: nil)
        }
        
        
        if let view = self.view as! SKView? {
            
            //view.preferredFramesPerSecond = 30
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "MenuScene") {
            UI.rootViewController = self
            UI.loadUIEssentials()
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
    deinit {
        NotificationCenter.default.removeObserver(self, name: .showGoogleAds, object: nil)
        NotificationCenter.default.removeObserver(self, name: .showRewardedVideos, object: nil)
    }
}
