import Cocoa
import AVFoundation
enum difficultyType: Int{
    case easy = 0, normal, hard
}
//settings
let gameSize = 6
var isPlayerWhite = true
var withAbility = false
var difficulty = difficultyType.hard

let url = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/Morioh Cho Radio Theme Extended - JoJos Bizarre Adventure Diamond is Unbreakable OST.wav")
var music = try AVAudioPlayer(contentsOf: url)
music.numberOfLoops = -1

var stopFinding = false
var testNumber = 4
var draws = 0.0
var wins = [0.0, 0.0]

let home = FileManager.default.homeDirectoryForCurrentUser
var desktopWeightsAutoWritePath =  "Desktop/WeightsAutoWrite.txt"
var path = home.appendingPathComponent(desktopWeightsAutoWritePath)

var canChallengerWin = false
var howManyPointsCanChallengerGet = 0
var howManyPointsCanChallengerWinBy = 0

let serialQueue = DispatchQueue(label: "com.beAwesome.Reversi", qos: DispatchQoS.userInteractive)
//struct Player: CustomStringConvertible{
//    var description: String{
//        var des = ""
//        des += "name: \(name)\n"
//        des += "searchDepth: \(searchDepth)\n"
//        des += "weight: \(weights)"
//        return des
//    }
//
//    var name: String = "p"
//    var searchDepth: UInt = 1
//    var weights = [Weight](repeating: Weight(), count: 3)
//    //var weight = Weight(scoreDifferenceWeight: 1, sideWeight: 2, CWeight: 5, XWeight: 20, cornerWeight: 50)
//}
func test(players: [Player], whoFirst: Int, testOfNumber i: Int, description: Bool = false, forSearch: Bool = true){
    let isComputerWhite = (whoFirst == 1)
    var Game = Reversi.init(n: gameSize)
    if withAbility{ Reversi.withAbility = .translate}
    if description{
        print("•test number: ", i, ", ", Double(i) / Double(testNumber) * 100.0 , "%")
        //Game.showBoard(isWhite: false)
        print(" \(players[0].name): search depth = ", players[0].searchDepth)
        print(" \(players[1].name): search depth = ", players[1].searchDepth)
    }
    
    while !Game.isEnd(){
        //Game.showBoard(isWhite: Game.isColorWhiteNow)
        //print(Game.isColorWhiteNow ? "now is white" : "now is black")
        //print("cool down white:", Game.getAbilityCoolDown(isWhite: true), ", black", Game.getAbilityCoolDown(isWhite: false))
        //black
        if Game.isColorWhiteNow == false{
            let weight = players[whoFirst].weight(turn: Game.turn, gameSize: gameSize)
            //MARK: - bestSolRecur
            if let bestSolution = Game.bestSolRecur(isWhite: false, searchDepth: players[whoFirst].searchDepth, stopFinding: &stopFinding, weight: weight, isComputerWhite: isComputerWhite){
                Game.play(Row: bestSolution.row, Col: bestSolution.col,isComputerWhite: isComputerWhite)
            }
            else{
                Game.play(Row: 0, Col: 0,isComputerWhite: isComputerWhite)
                print("translate!!!!")
            }
        }
        else{
            //white
            let weight = players[1 - whoFirst].weight(turn: Game.turn, gameSize: gameSize)
            //MARK: - bestSolRecur
            if let bestSolution = Game.bestSolRecur(isWhite: true, searchDepth: players[1 - whoFirst].searchDepth, stopFinding: &stopFinding, weight: weight, isComputerWhite: isComputerWhite){
                Game.play(Row: bestSolution.row, Col: bestSolution.col,isComputerWhite: isComputerWhite)
            }
            else {
                Game.play(Row: 0, Col: 0,isComputerWhite: isComputerWhite)
                print("translate!!!!!")
            }
        }
        
        
    }
    if description{
        Game.showBoard(isWhite: Game.isColorWhiteNow)
    }
    
    if Game.getBlackScore() > Game.getWhiteScore(){
        if description && whoFirst == 1{
            print(" \(players[1].name) wins", Game.getBlackScore() - Game.getWhiteScore(), "points and get", Game.getBlackScore(), "points")
            canChallengerWin = true
            let scoreDifference = Game.getBlackScore() - Game.getWhiteScore()
            if  scoreDifference > howManyPointsCanChallengerWinBy{
                howManyPointsCanChallengerWinBy = scoreDifference
            }
        }
        
        wins[whoFirst] += 1
    }
    else if Game.getBlackScore() < Game.getWhiteScore(){
        if description, whoFirst == 0{
            print(" \(players[1].name) wins", Game.getWhiteScore() - Game.getBlackScore(), "points and get", Game.getWhiteScore(), "points")
            canChallengerWin = true
            let scoreDifference =  Game.getWhiteScore()-Game.getBlackScore()
            if  scoreDifference > howManyPointsCanChallengerWinBy{
                howManyPointsCanChallengerWinBy = scoreDifference
            }
        }//
        wins[1 - whoFirst] += 1
    }
    else {
        if description{
            print(" Draw")
        }
        //
        draws += 1
    }
    if description{
        print(" \(players[0].name) wins = " , (wins[0] + 0.5 * draws) / Double(i) * 100.0, "%")
        print(" \(players[1].name) wins = ", (wins[1] + 0.5 * draws) / Double(i) * 100.0, "%")
        print(" Draws = ", draws / Double(i) * 100.0, "%")
        print("")
        
    }
    if whoFirst == 1{
        if Game.getBlackScore() > howManyPointsCanChallengerGet{
            howManyPointsCanChallengerGet = Game.getBlackScore()
        }
    }
    else{
        if Game.getWhiteScore() > howManyPointsCanChallengerGet{
            howManyPointsCanChallengerGet = Game.getWhiteScore()
        }
    }
    
    
}
func whoWins(players: [Player], testNumber: Int = 500) -> Int {
    var whoFirst = 0
    draws = 0.0
    wins = [0.0, 0.0]
    for i in 1...testNumber{
        //print("\(players[whoFirst].name) First")
        test(players: players,whoFirst: whoFirst, testOfNumber: i)
        whoFirst = 1 - whoFirst
    }
    return wins[0] == wins.max() ? 0 : 1
}

//initialize two players p0 and p1
//var initialStartWeight = Weight(scoreDifferenceWeight: 1,
//                                sideWeight: 11,
//                                CWeight: -30,
//                                XWeight: -50,
//                                cornerWeight: 60,
//                                mobilityWeight: 50
//)
//var initialMiddleWeight = Weight(scoreDifferenceWeight: 1,
//                                 sideWeight: 22,
//                                 CWeight: -30,
//                                 XWeight: -50,
//                                 cornerWeight: 40,
//                                 mobilityWeight: 50
//)
//var initialFinalWeight = Weight(scoreDifferenceWeight: 1,
//                                sideWeight: 20,
//                                CWeight: -30,
//                                XWeight: -50,
//                                cornerWeight: 19,
//                                mobilityWeight: 50
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
var computer = Player()
var computer0 = Player()
let firstPartWeight0 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -2,
    XWeight: -60,
    cornerWeight: 38,
    mobilityWeight: 0)
let secondPartWeight0 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -26,
    XWeight: -53,
    cornerWeight: 59,
    mobilityWeight: 0)
let thirdPartWeight0 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 10,
    CWeight: -7,
    XWeight: -27,
    cornerWeight: 31,
    mobilityWeight: 0)
//computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
computer0.weights = [firstPartWeight0, secondPartWeight0, thirdPartWeight0]
computer0.name = "computer0"
computer0.searchDepth = 2

var computer1 = Player()
let firstPartWeight1 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -2,
    XWeight: -60,
    cornerWeight: 38)
let secondPartWeight1 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -26,
    XWeight: -53,
    cornerWeight: 59)
let thirdPartWeight1 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 10,
    CWeight: -7,
    XWeight: -27,
    cornerWeight: 31)
//computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
computer1.weights = [firstPartWeight1, secondPartWeight1, thirdPartWeight1]
computer1.name = "computer1"
computer1.searchDepth = 4

var computer2 = Player()
let firstPartWeight2 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -2,
    XWeight: -60,
    cornerWeight: 38)
let secondPartWeight2 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -26,
    XWeight: -53,
    cornerWeight: 59)
let thirdPartWeight2 = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 10,
    CWeight: -7,
    XWeight: -27,
    cornerWeight: 31)
//computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
computer2.weights = [firstPartWeight2, secondPartWeight2, thirdPartWeight2]
computer2.name = "computer2"
computer2.searchDepth = 5

//top computer
var computerTop = Player()
let firstPartWeightTop = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -2,
    XWeight: -60,
    cornerWeight: 38,
    mobilityWeight: 50)
let secondPartWeightTop = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 54,
    CWeight: -26,
    XWeight: -53,
    cornerWeight: 59,
    mobilityWeight: 50)
let thirdPartWeightTop = Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 10,
    CWeight: -7,
    XWeight: -27,
    cornerWeight: 31,
    mobilityWeight: 50)
//computer.weights = [firstPartWeight, secondPartWeight, thirdPartWeight]
computerTop.weights = [firstPartWeightTop, secondPartWeightTop, thirdPartWeightTop]
computerTop.name = "computerTop"
computerTop.searchDepth = 4
///set up computer
switch difficulty{
case .easy:
    computer = computer0
case .normal:
    computer = computer1
case .hard:
    computer = computer2
}
var challenger = Player()
challenger.name = "challenger"
challenger.weights = [Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 4,
    CWeight: -11,
    XWeight: -46,
    cornerWeight: 40,
    mobilityWeight: 33)
    ,Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 3,
    CWeight: -27,
    XWeight: -45,
    cornerWeight: 43,
    mobilityWeight: 56)
    ,Weight(
    scoreDifferenceWeight: 1,
    sideWeight: 2,
    CWeight: -28,
    XWeight: -35,
    cornerWeight: 33,
    mobilityWeight: 51)


]
challenger.searchDepth = 4
//MARK: player setting
var players = [computer,challenger]
var bestWeightChoice = challenger.weights
var winsInARow = 0
var maxConsecutiveWins = 0
var winner = 0








//var game = Reversi(n: 4)
//var stop = false
//game.bestSolution(isWhite: false, searchDepth: 4, stopFinding: &stop, weight: Weight())
//while true{
//    var total = 0.0
//
//    print(players[0].name, " first.")
//    test(players: players, whoFirst: 0, testOfNumber: 1)
//    total = wins[0] + wins[1]
//    print(players[0].name, " wins ", wins[0] / total * 100, "%")
//    print(players[1].name, " wins ", wins[1] / total * 100, "%\n")
//    print(players[1].name, " first.")
//    test(players: players, whoFirst: 1, testOfNumber: 1)
//    total = wins[0] + wins[1]
//    print(players[0].name, " wins ", wins[0] / total * 100, "%")
//    print(players[1].name, " wins ", wins[1] / total * 100,"%\n")
//
//}


//test(players: players, whoFirst: 0, testOfNumber: 1, description: true)


while true{

        //print(players[0])
        //print(players[1])
        let loser = 1 - whoWins(players: players, testNumber: testNumber)
        players[loser].weights = [Weight.random(),Weight.random(),Weight.random()]
        if winner == 1 - loser{
            winsInARow += 1
            if winsInARow > maxConsecutiveWins{
                maxConsecutiveWins += 1
                bestWeightChoice = players[winner].weights
                let text = "maxConsecutiveWins = \(maxConsecutiveWins)\n" + bestWeightChoice.description
                try? text.write(to: path, atomically: false, encoding: .utf8)
            }
        }
        else {
            winsInARow = 0
            winner = 1 - loser
        }
        print("\(players[winner].name) wins having \(winsInARow) wins in a row")
        print("max consecutive win is = ", maxConsecutiveWins)
        print("the best weight choice is \(bestWeightChoice)\n\n")

}
