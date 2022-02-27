//
//  musicPlayer.swift
//  Reversi
//
//  Created by john gospai on 2019/2/1.
//  Copyright © 2019 john gospai. All rights reserved.
//

import Foundation
import AVFoundation
extension MusicPlayer.music: RawRepresentable, CaseIterable{
    init?(rawValue: String) {
        for music in MusicPlayer.music.allCases{
            if rawValue == music.rawValue{
                self = music
                return
            }
        }
        return nil
    }
    
    typealias RawValue = String
    
    typealias AllCases = [MusicPlayer.music]
    
    static var allCases: [MusicPlayer.music]{
        let bgmAllCases = MusicPlayer.music.BGM.allCases.map{MusicPlayer.music.bgm($0)}
        let sfxAllCases = MusicPlayer.music.SFX.allCases.map{MusicPlayer.music.sfx($0)}
        return bgmAllCases + sfxAllCases
    }
    
    var rawValue: RawValue{
        switch self {
        case .bgm(let bgm):
            return "bgm." + bgm.rawValue
        case .sfx(let sfx):
            return "sfx." + sfx.rawValue
        }
    }
}
class MusicPlayer{
    enum music: Hashable{
        case bgm(BGM)
        case sfx(SFX)
        
        enum BGM: String, CaseIterable{
            case title = "title"
            case game = "game"
        }
        enum SFX: String, CaseIterable{
            case putChess = "putChess"
            case flip = "flip"
            case win = "win"
            case lose = "lose"
            case tap = "tap"
            case shake = "shake"
            case wind = "wind"
            case goUp = "goUp"
            case goDown = "goDown"
        }
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
            guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else {
                print("cannot load \(music.rawValue).mp3")
                return}
            let player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            if let player = player {
                player.prepareToPlay()
                preparedPlayers[music] = player
                updatePlayerVolume(music: music)
                switch music{
                case .bgm(_):
                    player.numberOfLoops = -1
                case .sfx(_):
                    player.numberOfLoops = 0
                }
            }
        }
    }
    static func updatePlayerVolume(music: music){
        switch music{
        case .bgm(_):
            preparedPlayers[music]?.volume = SharedVariable.bgmVolume
        case .sfx(_):
            preparedPlayers[music]?.volume = SharedVariable.sfxVolume
        }
    }
    static func updatePlyersVolume(){
        for musicPlayer in preparedPlayers{
            switch musicPlayer.key{
                case .bgm(_):
                    musicPlayer.value.volume = SharedVariable.bgmVolume
                case .sfx(_):
                    musicPlayer.value.volume = SharedVariable.sfxVolume
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
    static func reset(music: music){
        if let player = preparedPlayers[music]{
            player.currentTime = 0
        }
    }
    static func replay(music: music){
        if let player = preparedPlayers[music]{
            player.currentTime = 0
            player.play()
        }
    }
    //release memory
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
            preparedPlayers[music]?.play()
        }
    }
    static func removePreparedMusic(music: music){
        stop(music: music)
        preparedPlayers.removeValue(forKey: music)
    }
    static func removeAllPreparedMusics(){
        stopAll()
        preparedPlayers.removeAll()
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

