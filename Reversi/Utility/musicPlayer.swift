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
    enum music: String, Hashable, CaseIterable{
        case bgm = "background"
        case putChess = "putChess"
        case win = "win"
    }
    
    static fileprivate var preparedPlayers: [music:AVAudioPlayer] = [:]
    static fileprivate var pausedMusics: [music] = []
    static func setPlayerLoopNumber(music: music, loopNumber: Int = -1){
        preparePlayer(music: music)
        if let player = preparedPlayers[music]{
            player.numberOfLoops = loopNumber
        }
    }
    static func preparePlayer(music: music){
        if preparedPlayers[music] == nil{
            guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else {return}
            let player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            if let player = player {
                player.prepareToPlay()
                preparedPlayers[music] = player
            }
        }
    }
    static func play(music: music){
        preparePlayer(music: music)
        if let player = preparedPlayers[music]{
            player.play()
        }
    }
    static func pause(music: music){
        if let player = preparedPlayers[music]{
            if player.isPlaying{
                player.pause()
            }
        }
    }
    static func stop(music: music){
        if let player = preparedPlayers[music]{
            if player.isPlaying{
                player.stop()
            }
        }
    }
    static func stopAll(){
        for player in preparedPlayers.values{
            if player.isPlaying{
                player.stop()
            }
        }
    }
    static func savePlayersState(){
        pausedMusics = []
        for player in preparedPlayers{
            if player.value.isPlaying{
                pausedMusics.append(player.key)
                player.value.pause()
            }
        }
    }
    static func restorePlayersState(){
        for music in pausedMusics{
            play(music: music)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
//    static var bgmPlayer: [AVAudioPlayer]{
//        guard let url = Bundle.main.url(forResource: music.bgm.rawValue, withExtension: "mp3") else { return []}
//        do {
//            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//            player.prepareToPlay()
//            player.numberOfLoops = -1
//            return [player]
//        }catch let error{
//            print(error.localizedDescription)
//        }
//
//
//    }
//    static var effectPlayer: [AVAudioPlayer] = []
//    static func prepareBGM(loopNumber: Int = -1){
//        guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else { return }
//        do {
//            //The following code allows you to play audio in background, but needs you to go to Capabilities and turn on background modes.
//            /*
//             try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//             try AVAudioSession.sharedInstance().setActive(true)
//             */
//
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            musicPlayer.bgmPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = musicPlayer.bgmPlayer else {
//                print("Warning: file is empty.")
//                return }
//            player.prepareToPlay()
//            player.numberOfLoops = loopNumber
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    static func prepareMusic(music: music, loopNumber: Int = -1){
//        guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else { return }
//        do {
//            //The following code allows you to play audio in background, but needs you to go to Capabilities and turn on background modes.
//            /*
//             try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//             try AVAudioSession.sharedInstance().setActive(true)
//             */
//
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            musicPlayer.bgmPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = musicPlayer.bgmPlayer else {
//                print("Warning: file is empty.")
//                return }
//            player.prepareToPlay()
//            player.numberOfLoops = loopNumber
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    static func playMusic() {
//        guard let player = musicPlayer.player else {
//            print("Warning: file is empty.")
//            return }
//        player.play()
//    }
//
//    static func pauseMusic() {
//        guard let player = musicPlayer.player else {
//            print("Warning: file is empty.")
//            return }
//        if player.isPlaying{
//            player.pause()
//        }
//    }
}

