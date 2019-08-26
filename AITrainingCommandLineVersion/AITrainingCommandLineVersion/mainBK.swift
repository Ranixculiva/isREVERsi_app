//import Cocoa
//
//var stopFinding = false
//var testNumber = 10
//var draws = 0.0
//var wins = [0.0, 0.0]
//let gameSize = 6
//let home = FileManager.default.homeDirectoryForCurrentUser
//let desktopWeightsAutoWritePath =  "Desktop/WeightsAutoWrite.txt"
//let path = home.appendingPathComponent(desktopWeightsAutoWritePath)
//
//
//let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
////struct Player: CustomStringConvertible{
////    var description: String{
////        var des = ""
////        des += "name: \(name)\n"
////        des += "searchDepth: \(searchDepth)\n"
////        des += "weight: \(weights)"
////        return des
////    }
////
////    var name: String = "p"
////    var searchDepth: UInt = 1
////    var weights = [Weight](repeating: Weight(), count: 3)
////    //var weight = Weight(scoreDifferenceWeight: 1, sideWeight: 2, CWeight: 5, XWeight: 20, cornerWeight: 50)
////}
//func test(players: [Player], whoFirst: Int, testOfNumber i: Int,description: Bool = false, isComputerWhite: Bool = true){
//    
//    var Game = Reversi.init(n: gameSize)
//    Reversi.withAbility = .translate
//    if description{
//        print("•test number: ", i, ", ", Double(i) / Double(testNumber) * 100.0 , "%")
//        Game.showBoard(isWhite: false)
//        print(" \(players[0].name): search depth = ", players[0].searchDepth)
//        print(" \(players[1].name): search depth = ", players[1].searchDepth)
//    }
//    
//    while !Game.isEnd(){
//        Game.showBoard(isWhite: Game.isColorWhiteNow)
//        print(Game.isColorWhiteNow ? "now is white" : "now is black")
//        print("cool down white:", Game.getAbilityCoolDown(isWhite: true), ", black", Game.getAbilityCoolDown(isWhite: false))
//        //black
//        if Game.isColorWhiteNow == false{
//            let weight = players[whoFirst].weight(turn: Game.turn, gameSize: gameSize)
//            if let bestSolution = Game.bestSolution(isWhite: Game.isColorWhiteNow, searchDepth: players[whoFirst].searchDepth, stopFinding: &stopFinding,
//                                                    weight: weight, isComputerWhite: isComputerWhite){
//                Game.play(Row: bestSolution.row, Col: bestSolution.col,isComputerWhite: isComputerWhite)
//            }
//            else{
//                Game.play(Row: 0, Col: 0,isComputerWhite: isComputerWhite)
//                print("translate!!!!")
//            }
//        }
//        else{
//            //white
//            let weight = players[1 - whoFirst].weight(turn: Game.turn, gameSize: gameSize)
//            if let bestSolution = Game.bestSolution(isWhite: Game.isColorWhiteNow, searchDepth: players[1 - whoFirst].searchDepth, stopFinding: &stopFinding, weight: weight, isComputerWhite: isComputerWhite){
//                Game.play(Row: bestSolution.row, Col: bestSolution.col,isComputerWhite: isComputerWhite)
//            }
//            else {
//                Game.play(Row: 0, Col: 0,isComputerWhite: isComputerWhite)
//                print("translate!!!!!")
//            }
//        }
//        
//        
//    }
//    if description{
//        Game.showBoard(isWhite: Game.isColorWhiteNow)
//    }
//    
//    if Game.getBlackScore() > Game.getWhiteScore(){
//        if description{
//            print(" \(players[whoFirst].name) wins")
//        }
//        
//        wins[whoFirst] += 1
//    }
//    else if Game.getBlackScore() < Game.getWhiteScore(){
//        if description{
//            print(" \(players[whoFirst].name) wins")
//        }//
//        wins[1 - whoFirst] += 1
//    }
//    else {
//        if description{
//            print(" Draw")
//        }
//        //
//        draws += 1
//    }
//    if description{
//        print(" \(players[0].name) wins = " , (wins[0] + 0.5 * draws) / Double(i) * 100.0, "%")
//        print(" \(players[1].name) wins = ", (wins[1] + 0.5 * draws) / Double(i) * 100.0, "%")
//        print(" Draws = ", draws / Double(i) * 100.0, "%")
//        print("")
//        
//    }
//    
//    
//}
//func whoWins(players: [Player], testNumber: Int = 500) -> Int {
//    var whoFirst = 0
//    draws = 0.0
//    wins = [0.0, 0.0]
//    for i in 1...testNumber{
//        //print("\(players[whoFirst].name) First")
//        test(players: players,whoFirst: whoFirst, testOfNumber: i)
//        whoFirst = 1 - whoFirst
//    }
//    return wins[0] == wins.max() ? 0 : 1
//}
//
////initialize two players p0 and p1
//var initialStartWeight = Weight(scoreDifferenceWeight: 1,
//                                sideWeight: 11,
//                                CWeight: -30,
//                                XWeight: -50,
//                                cornerWeight: 60,
//                                mobilityWeight: 100
//)
//var initialMiddleWeight = Weight(scoreDifferenceWeight: 1,
//                                 sideWeight: 22,
//                                 CWeight: -30,
//                                 XWeight: -50,
//                                 cornerWeight: 40,
//                                 mobilityWeight: 100
//)
//var initialFinalWeight = Weight(scoreDifferenceWeight: 1,
//                                sideWeight: 20,
//                                CWeight: -30,
//                                XWeight: -50,
//                                cornerWeight: 19,
//                                mobilityWeight: 100
//)
//let initialWeights = [initialStartWeight, initialMiddleWeight, initialFinalWeight]
//var p0 = Player(
//    name: "player0",
//    searchDepth: 4, weights: initialWeights
//)
//var p1 = Player(
//    name: "player1",
//    searchDepth: 4,
//    weights: initialWeights)
//var players = [p0,p1]
//var bestWeightChoice = p0.weights
//var winsInARow = 0
//var maxConsecutiveWins = 0
//var winner = 0
//for _ in 0...30{
//    test(players: players, whoFirst: 0, testOfNumber: 2, description: false, isComputerWhite: true)
//    print(wins)
//}
//
//
////var game = Reversi(n: 4)
////var stop = false
////game.bestSolution(isWhite: false, searchDepth: 4, stopFinding: &stop, weight: Weight())
////while true{
////    var total = 0.0
////
////    print(players[0].name, " first.")
////    test(players: players, whoFirst: 0, testOfNumber: 1)
////    total = wins[0] + wins[1]
////    print(players[0].name, " wins ", wins[0] / total * 100, "%")
////    print(players[1].name, " wins ", wins[1] / total * 100, "%\n")
////    print(players[1].name, " first.")
////    test(players: players, whoFirst: 1, testOfNumber: 1)
////    total = wins[0] + wins[1]
////    print(players[0].name, " wins ", wins[0] / total * 100, "%")
////    print(players[1].name, " wins ", wins[1] / total * 100,"%\n")
////
////}
//
//
////test(players: players, whoFirst: 0, testOfNumber: 1, description: true)
//
//
////while true{
////
////        //print(players[0])
////        //print(players[1])
////        let loser = 1 - whoWins(players: players, testNumber: testNumber)
////        players[loser].weights = [Weight.random(),Weight.random(),Weight.random()]
////        if winner == 1 - loser{
////            winsInARow += 1
////            if winsInARow > maxConsecutiveWins{
////                maxConsecutiveWins += 1
////                bestWeightChoice = players[winner].weights
////                let text = "maxConsecutiveWins = \(maxConsecutiveWins)\n" + bestWeightChoice.description
////                try? text.write(to: path, atomically: false, encoding: .utf8)
////            }
////        }
////        else {
////            winsInARow = 0
////            winner = 1 - loser
////        }
////        print("\(players[winner].name) wins having \(winsInARow) wins in a row")
////        print("max consecutive win is = ", maxConsecutiveWins)
////        print("the best weight choice is \(bestWeightChoice)\n\n")
////
////}
