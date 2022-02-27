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
import AVFoundation


class GameViewController: UIViewController, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate {
    fileprivate let rewardBasedVideoAdUnitID = "ca-app-pub-5566504586304400/2641675987"
    fileprivate let interstitialAdUnitID = "ca-app-pub-5566504586304400/9620171398"
    var adRequestInProgress = false
    var rewardBasedVideo: GADRewardBasedVideoAd?
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        SharedVariable.flips += [1,1,1,1,1,2,2,2,3].randomElement()!
    }
    func loadRewardedVideoAd(){
        if !adRequestInProgress && rewardBasedVideo?.isReady == false && SharedVariable.withAds {
            //let request = GADRequest()
            //request.testDevices = [ "8cff8799ea0549832397a370ff232f85" ]
            //rewardBasedVideo?.load(request,
            //                       withAdUnitID: rewardBasedVideoAdUnitID)
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
        MusicPlayer.savePlayersState()
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        MusicPlayer.restorePlayersState()
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
        //let request = GADRequest()
        //request.testDevices = [ "8cff8799ea0549832397a370ff232f85" ]
        //interstitial.load(request)
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        MusicPlayer.restorePlayersState()
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial){
        MusicPlayer.savePlayersState()
    }
    @objc func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }
        switch type {
        case .began:
            MusicPlayer.savePlayersState()
        case .ended:
            MusicPlayer.restorePlayersState()
        @unknown default:
            break
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "8cff8799ea0549832397a370ff232f85" ]
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        
        
        if SharedVariable.withAds{
            interstitial = createAndLoadInterstitial()
            
            rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
            rewardBasedVideo?.delegate = self
            
            loadRewardedVideoAd()
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(showAds), name: .showGoogleAds, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(showRewardedVideoAd), name: .showRewardedVideos, object: nil)
            bannerView = GADBannerView(adSize: kGADAdSizeBanner, origin: .zero)
            bannerView?.adUnitID = "ca-app-pub-5566504586304400/1823840108"
            bannerView?.rootViewController = self
            //let request = GADRequest()
            //request.testDevices = [ "8cff8799ea0549832397a370ff232f85" ]
            //bannerView?.load(request)
            bannerView?.load(GADRequest())
            bannerView?.delegate = self
        
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
//            view.showsFPS = true
//            view.showsNodeCount = true
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
    var bannerView: GADBannerView?
}
extension GameViewController: GADBannerViewDelegate{}
