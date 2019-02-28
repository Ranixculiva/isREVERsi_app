//
//  musicPlayer.swift
//  Reversi
//
//  Created by john gospai on 2019/2/1.
//  Copyright © 2019 john gospai. All rights reserved.
//

import Foundation
import AVFoundation

class musicPlayer{
    
    var player: AVAudioPlayer?
    init(musicName: String, loopNumber: Int = -1) {
        guard let url = Bundle.main.url(forResource: musicName, withExtension: "mp3") else { return }
        do {
            //The following code allows you to play audio in background, but needs you to go to Capabilities and turn on background modes.
            /*
             try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
             try AVAudioSession.sharedInstance().setActive(true)
             */
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else {
                print("Warning: file is empty.")
                return }
            player.prepareToPlay()
            player.numberOfLoops = loopNumber
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMusic() {
        guard let player = player else {
            print("Warning: file is empty.")
            return }
        player.play()
    }
    
    func pauseMusic() {
        guard let player = player else {
            print("Warning: file is empty.")
            return }
        if player.isPlaying{
            player.pause()
        }
    }
}

