////
////  main1.swift
////  AITrainingCommandLineVersion
////
////  Created by john gospai on 2019/8/11.
////  Copyright © 2019 john gospai. All rights reserved.
////
//
//var computer = Player()
//var computer0 = Player()
//let firstPartWeight0 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -2,
//    XWeight: -60,
//    cornerWeight: 38,
//    mobilityWeight: 0)
//let secondPartWeight0 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -26,
//    XWeight: -53,
//    cornerWeight: 59,
//    mobilityWeight: 0)
//let thirdPartWeight0 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 10,
//    CWeight: -7,
//    XWeight: -27,
//    cornerWeight: 31,
//    mobilityWeight: 0)
////computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
//computer0.weights = [firstPartWeight0, secondPartWeight0, thirdPartWeight0]
//computer0.name = "computer0"
//computer0.searchDepth = 2
//
//var computer1 = Player()
//let firstPartWeight1 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -2,
//    XWeight: -60,
//    cornerWeight: 38)
//let secondPartWeight1 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -26,
//    XWeight: -53,
//    cornerWeight: 59)
//let thirdPartWeight1 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 10,
//    CWeight: -7,
//    XWeight: -27,
//    cornerWeight: 31)
////computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
//computer1.weights = [firstPartWeight1, secondPartWeight1, thirdPartWeight1]
//computer1.name = "computer1"
//computer1.searchDepth = 4
//
//var computer2 = Player()
//let firstPartWeight2 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -2,
//    XWeight: -60,
//    cornerWeight: 38)
//let secondPartWeight2 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 54,
//    CWeight: -26,
//    XWeight: -53,
//    cornerWeight: 59)
//let thirdPartWeight2 = Weight(
//    scoreDifferenceWeight: 1,
//    sideWeight: 10,
//    CWeight: -7,
//    XWeight: -27,
//    cornerWeight: 31)
////computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
//computer2.weights = [firstPartWeight2, secondPartWeight2, thirdPartWeight2]
//computer2.name = "computer2"
//computer2.searchDepth = 5
//
//
//var Game = Reversi(n: 4)
//var stopFinding = false
//var isComputerWhite = true
//Game.showBoard(isWhite: false)
//while !Game.isEnd(){
//    if Game.isColorWhiteNow != isComputerWhite{
//        if let rowString = readLine(), let colString = readLine(){
//            let row = Int(rowString)!
//            let col = Int(colString)!
//            Game.play(Row: row, Col: col)
//        }
//    }
//    else {
//        var computer =  computer1
//        computer.searchDepth = 9
//        Reversi.withAbility = .translate
//        let weight = computer.weight(turn: Game.turn, gameSize: 4)
//        if let bestSol = Game.bestSolRecur(isWhite: isComputerWhite, searchDepth: computer.searchDepth, stopFinding: &stopFinding, weight: weight, isComputerWhite: true){
//            Game.play(Row: bestSol.row, Col: bestSol.col)
//        }
//        else {
//            Game.play(Row: 0, Col: 0, isComputerWhite: isComputerWhite)
//        }
//    }
//    Game.showBoard(isWhite: Game.isColorWhiteNow)
//    
//}
