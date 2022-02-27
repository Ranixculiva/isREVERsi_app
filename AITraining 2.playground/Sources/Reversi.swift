//
//  Reversi.swift
//  Reversi
//
//  Created by john gospai on 2018/11/6.
//  Copyright © 2018 john gospai. All rights reserved.
//
//TODO: findbestsolution for, out of range
import Foundation
import SpriteKit
public struct Reversi{
    
    var description: String{
        
        var des = "\n"
        for i in 0...n - 1 {des += "  \(i)"}
        des += "\n"
        for row in 0...n - 1
        {
            des += "\(row)|"
            for col in 0...n - 1
            {
                if let gameBoard = gameBoard[row][col]
                {
                    if isColorWhite[row][col]!
                    {des += "+"}
                    else {des += "-"}
                    des += "\(gameBoard)|"
                }
                else if (self.isAvailable(Row: row, Col: col, isWhite: self.isColorWhiteNow)) {des += " ?|"}
                else {des += "  |"}
            }
            des += "\n"
        }
        des += "whiteScore = \(whiteScore)\n"
        des += "blackScore = \(blackScore)\n"
        des += "isColorWhiteNow = \(isColorWhiteNow)\n"
        des += "turn = \(turn)\n"
        des += "n = \(n)\n\n"
        return des
    }
    public enum direction: Int, CaseIterable{
        case right = 0, rightUp, up, leftUp, left, leftDown, down, rightDown, allDirctions
    }
    /**
     Only for CSquares, XSquares, cornerSquares and sideSquares
     */
    public enum sizeEnum: Int, Codable{
        
        case four = 0, six, eight
    }
    public var size: sizeEnum = .six
    public var gameBoard: [[Int?]]
    public var isColorWhite: [[Bool?]]
    public var whiteScore: Int = 0
    public var blackScore: Int = 0
    public var isColorWhiteNow: Bool = false
    public var turn: Int = 0
    static let CSquares: [[chessBoardPos]] =
        [[],
         [chessBoardPos(row: 0,col: 1),
          chessBoardPos(row: 0,col: 4),
          chessBoardPos(row: 1,col: 0),
          chessBoardPos(row: 1,col: 5),
          chessBoardPos(row: 4,col: 0),
          chessBoardPos(row: 4,col: 5),
          chessBoardPos(row: 5,col: 1),
          chessBoardPos(row: 5,col: 4)],
         [chessBoardPos(row: 0,col: 1),
          chessBoardPos(row: 0,col: 6),
          chessBoardPos(row: 1,col: 0),
          chessBoardPos(row: 1,col: 7),
          chessBoardPos(row: 6,col: 0),
          chessBoardPos(row: 6,col: 7),
          chessBoardPos(row: 7,col: 1),
          chessBoardPos(row: 7,col: 6)]]
    static let XSquares: [[chessBoardPos]] =
        [[],
         [chessBoardPos(row: 1,col: 1),
          chessBoardPos(row: 1,col: 4),
          chessBoardPos(row: 4,col: 1),
          chessBoardPos(row: 4,col: 4)],
         [chessBoardPos(row: 1,col: 1),
          chessBoardPos(row: 1,col: 6),
          chessBoardPos(row: 6,col: 1),
          chessBoardPos(row: 6,col: 6)]]
    static let cornerSquares: [[chessBoardPos]] =
        [[chessBoardPos(row: 0,col: 0),
          chessBoardPos(row: 0,col: 3),
          chessBoardPos(row: 3,col: 0),
          chessBoardPos(row: 3,col: 3)],
         [chessBoardPos(row: 0,col: 0),
          chessBoardPos(row: 0,col: 5),
          chessBoardPos(row: 5,col: 0),
          chessBoardPos(row: 5,col: 5)],
         [chessBoardPos(row: 0,col: 0),
          chessBoardPos(row: 0,col: 7),
          chessBoardPos(row: 7,col: 0),
          chessBoardPos(row: 7,col: 7)]]
    static func getSideSquares(size: sizeEnum) -> [chessBoardPos]{
        var sideSquares: [chessBoardPos] = []
        let n = size == .four ? 4 : (size == .six ? 6 : 8)
        for i in 0...n - 1
        {
            for j in 0...n - 1
            {
                if i == 0 || i == n - 1 || j == 0 || j == n - 1{
                    if !Reversi.CSquares[size.rawValue].contains(chessBoardPos(row: i,col: j))
                        && !Reversi.XSquares[size.rawValue].contains(chessBoardPos(row: i,col: j))
                        && !Reversi.cornerSquares[size.rawValue].contains(chessBoardPos(row: i,col: j)){
                        sideSquares.append(chessBoardPos(row: i, col: j))
                    }
                }
            }
        }
        return sideSquares
    }
    static let sideSquares = [Reversi.getSideSquares(size: .four), Reversi.getSideSquares(size: .six),Reversi.getSideSquares(size: .eight)]
    /**
     nxn reversi game
     */
    public var n: Int
    
    /**
     create a 4x4, 6x6 or 8x8 reversi game
     - Parameters:
     - n: must be either 4, 6 or 8
     */
    public init(n: Int) {
        
        if n != 4 && n != 6 && n != 8 {fatalError("wrong size")}
        size = n == 4 ? .four : (n == 6 ? .six : .eight)
        self.n = n
        gameBoard = [[Int?]](repeating: [Int?](repeating: nil, count: n), count: n)
        isColorWhite = [[Bool?]](repeating: [Bool?](repeating: nil, count: n), count: n)
        for i in 0...n - 1
        {
            for j in 0...n - 1
            {
                if  (i == n / 2 - 1 || i == n / 2) &&
                    (j == n / 2 - 1 || j == n / 2)
                {gameBoard[i][j] = 0}
                
                if  (i == n / 2 - 1 && j == n / 2) ||
                    (i == n / 2 && j == n / 2 - 1)
                {isColorWhite[i][j] = false}
                else if
                    (i == n / 2 - 1 && j == n / 2 - 1) ||
                        (i == n / 2 && j == n / 2)
                {isColorWhite[i][j] = true}
            }
        }
    }
    //TODO: getWeight
    /**get the information of the number of the position*/
    public func getNumber(Row: Int, Col: Int) -> Int?
    {
        return gameBoard[Row][Col]
    }
    public func getColor(Row: Int, Col: Int) -> Bool?
    {
        return isColorWhite[Row][Col]
    }
    public func getBlackScore() -> Int
    {
        return blackScore
    }
    /**get the information of negative score*/
    public func getWhiteScore() -> Int
    {
        return whiteScore
    }
    //get the information of score
    public func getScore(isWhite: Bool) -> Int
    {
        return isWhite ? whiteScore : blackScore
    }
    public func getScoreDifference(isWhite: Bool) -> Int{
        return getScore(isWhite: isWhite) - getScore(isWhite: !isWhite)
    }
    //show the game board
    public func showBoard(isWhite: Bool)
    {
        //print("")
        for i in 0...n - 1 {print("  \(i)", terminator:"")}
        print("")
        for row in 0...n - 1
        {
            print("\(row)|", terminator:"")
            for col in 0...n - 1
            {
                if let gameBoard = gameBoard[row][col]
                {
                    if isColorWhite[row][col]!
                    {print("+", terminator:"")}
                    else {print("-", terminator:"")}
                    print("\(gameBoard)|", terminator:"")
                }
                else if (self.isAvailable(Row: row, Col: col, isWhite: isWhite)) {print(" ?|", terminator:"")}
                else {print("  |", terminator:"")}
            }
            print("")
        }
    }
    public func isAvailable(toward Direction: direction = .allDirctions, Row: Int, Col: Int, isWhite: Bool) -> Bool
    {
        if Row < 0 || Row > n - 1 || Col < 0 || Col > n - 1 {return false}
        //if there's already something at (Row, Col), then you cannot put anything on it.
        if let _ = gameBoard[Row][Col] {return false}
        switch Direction {
        case .right:
            if Col < n - 2 {
                if isColorWhite[Row][Col + 1] == !isWhite {
                    for j in 2...n - 1 - Col {
                        if isColorWhite[Row][Col + j] == nil {return false}
                        if isColorWhite[Row][Col + j] == isWhite {return true}
                    }
                }
            }
        case .rightUp:
            if Row > 1 && Col < n - 2 {
                if isColorWhite[Row - 1][Col + 1] == !isWhite {
                    for j in 2...min(Row, n - 1 - Col) {
                        if isColorWhite[Row - j][Col + j] == nil {return false}
                        if isColorWhite[Row - j][Col + j] == isWhite {return true}
                    }
                }
            }
        case .up:
            if Row > 1 {
                //able to be toward up
                if isColorWhite[Row - 1][Col] == !isWhite {
                    for i in 2...Row
                    {
                        if isColorWhite[Row - i][Col] == nil {return false}
                        if isColorWhite[Row - i][Col] == isWhite {return true}
                    }
                }
            }
        case .leftUp:
            if Row > 1 && Col > 1 {
                if isColorWhite[Row - 1][Col - 1] == !isWhite {
                    for j in 2...min(Row, Col) {
                        if isColorWhite[Row - j][Col - j] == nil {return false}
                        if isColorWhite[Row - j][Col - j] == isWhite {return true}
                    }
                }
            }
        case .left:
            if Col > 1 {
                if isColorWhite[Row][Col - 1] == !isWhite {
                    for j in 2...Col {
                        if isColorWhite[Row][Col - j] == nil {return false}
                        if isColorWhite[Row][Col - j] == isWhite {return true}
                    }
                }
            }
        case .leftDown:
            if Row < n - 2 && Col > 1 {
                if isColorWhite[Row + 1][Col - 1] == !isWhite {
                    for j in 2...min(n - 1 - Row, Col){
                        if isColorWhite[Row + j][Col - j] == nil {return false}
                        if isColorWhite[Row + j][Col - j] == isWhite {return true}
                    }
                }
            }
        case .down:
            if Row < n - 2 {
                if isColorWhite[Row + 1][Col] == !isWhite {
                    for i in 2...n - 1 - Row {
                        if isColorWhite[Row + i][Col] == nil {return false}
                        if isColorWhite[Row + i][Col] == isWhite {return true}
                    }
                }
            }
        case .rightDown:
            if Row < n - 2 && Col < n - 2 {
                if isColorWhite[Row + 1][Col + 1] == !isWhite {
                    for j in 2...min(n - 1 - Row, n - 1 - Col) {
                        if isColorWhite[Row + j][Col + j] == nil {return false}
                        if isColorWhite[Row + j][Col + j] == isWhite {return true}
                    }
                }
            }
        default:
            for direction in 0...7{
                if(isAvailable(toward: Reversi.direction(rawValue: direction)!, Row: Row, Col: Col, isWhite: isWhite))
                {return true}
            }
        }
        return false
    }
    /**
     it will check availibility of the direction, and flip chess toward that direction.
     
     - Parameters:
     - Row: the row where you want to place your chess
     - Col: the col where you want to place your chess
     - isWhite: Is the color of the current player white?
     */
    public mutating func fillColoredNumber(Row: Int, Col: Int, isWhite: Bool) -> Bool
    {
        var isSomeAvailable = false
        //if !isAvailable(Row: Row, Col: Col, isWhite: isWhite) {return false}
        
        //flip the known numbers
        //check all eight directions
        if isAvailable(toward: .right, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...n - 1 - Col {
                if isColorWhite[Row][Col + j] == isWhite {break}
                if isColorWhite[Row][Col + j] == !isWhite {
                    gameBoard[Row][Col + j]! += 1
                    isColorWhite[Row][Col + j] = isWhite
                }
            }
        }
        if isAvailable(toward: .rightUp, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...min(Row, n - 1 - Col) {
                if isColorWhite[Row - j][Col + j] == isWhite {break}
                if isColorWhite[Row - j][Col + j] == !isWhite {
                    gameBoard[Row - j][Col + j]! += 1
                    isColorWhite[Row - j][Col + j] = isWhite
                }
            }
        }
        if isAvailable(toward: .up, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for i in 1...Row {
                if isColorWhite[Row - i][Col] == isWhite {break}
                if isColorWhite[Row - i][Col] == !isWhite {
                    gameBoard[Row - i][Col]! += 1
                    isColorWhite[Row - i][Col] = isWhite
                }
            }
        }
        if isAvailable(toward: .leftUp, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...min(Row, Col) {
                if isColorWhite[Row - j][Col - j] == isWhite {break}
                if isColorWhite[Row - j][Col - j] == !isWhite {
                    gameBoard[Row - j][Col - j]! += 1
                    isColorWhite[Row - j][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: .left, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...Col {
                if isColorWhite[Row][Col - j] == isWhite {break}
                if isColorWhite[Row][Col - j] == !isWhite {
                    gameBoard[Row][Col - j]! += 1
                    isColorWhite[Row][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: .leftDown, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...min(n - 1 - Row, Col){
                if isColorWhite[Row + j][Col - j] == isWhite {break}
                if isColorWhite[Row + j][Col - j] == !isWhite {
                    gameBoard[Row + j][Col - j]! += 1
                    isColorWhite[Row + j][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: .down, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for i in 1...n - 1 - Row {
                if isColorWhite[Row + i][Col] == isWhite {break}
                if isColorWhite[Row + i][Col] == !isWhite {
                    gameBoard[Row + i][Col]! += 1
                    isColorWhite[Row + i][Col] = isWhite
                }
            }
        }
        if isAvailable(toward: .rightDown, Row: Row, Col: Col, isWhite: isWhite){
            isSomeAvailable = true
            for j in 1...min(n - 1 - Row, n - 1 - Col) {
                if isColorWhite[Row + j][Col + j] == isWhite {break}
                if isColorWhite[Row + j][Col + j] == !isWhite {
                    gameBoard[Row + j][Col + j]! += 1
                    isColorWhite[Row + j][Col + j] = isWhite
                }
            }
        }
        if !isSomeAvailable {return false}
        isColorWhite[Row][Col] = isWhite
        gameBoard[Row][Col] = 0
        blackScore = 0
        whiteScore = 0
        for i in 0...n - 1
        {
            for j in 0...n - 1
            {
                if isColorWhite[i][j] == true {whiteScore += gameBoard[i][j]!}
                else if isColorWhite[i][j] == false {blackScore += gameBoard[i][j]!}
            }
        }
        return true
    }
    public func needToPass(Color: Bool) -> Bool
    {
        for i in 0...n - 1
        {
            for j in 0...n - 1
            {
                if (self.isAvailable(Row: i, Col: j, isWhite: Color)) {return false}
            }
        }
        return true
    }
    public func availableSteps(isWhite: Bool) -> [(row: Int, col: Int)]{
        var answer = [(row: Int, col: Int)]()
        for row in 0...n - 1{
            for col in 0...n - 1{
                if isAvailable(Row: row, Col: col, isWhite: isWhite){
                    answer.append((row,col))
                }
            }
        }
        return answer
    }
    public func getChessBoardPositions(isWhite: Bool) -> [chessBoardPos]{
        var answer: [chessBoardPos] = []
        for row in 0...n - 1{
            for col in 0...n - 1{
                if getColor(Row: row, Col: col) == isWhite{
                    answer.append(chessBoardPos(row: row, col: col))
                }
            }
        }
        return answer
    }
    //check if the game is end
    public func isEnd() -> Bool
    {
        if (self.needToPass(Color: true) && self.needToPass(Color: false)) {return true}
        return false
    }
    /* mutating func play(Row row: Int, Col col: Int, isColorWhiteNowIn:
     Bool) -> Bool
     {
     var isColorWhiteNowOut = isColorWhiteNowIn
     if !Array(0...5).contains(where: {$0 == row || $0 == col}){fatalError("wrong row or column")}
     if self.fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNowOut){
     isColorWhiteNowOut = !isColorWhiteNowOut
     
     }
     else {
     //shake!!
     //print("Unavailable move at \(row), \(col)")
     }
     
     if self.isEnd(){
     
     }
     else if self.needToPass(Color: isColorWhiteNowOut){
     //print("\(isColorWhiteNowOut ? "White" : "Black") cannot move")
     isColorWhiteNowOut = !isColorWhiteNowOut
     }
     return isColorWhiteNowOut
     }*/
    public mutating func play(Row row: Int, Col col: Int){
        if !Array(0...n - 1).contains(where: {$0 == row || $0 == col}){fatalError("wrong row or column")}
        if self.fillColoredNumber(Row: row, Col: col, isWhite: self.isColorWhiteNow){
            self.isColorWhiteNow = !self.isColorWhiteNow
            turn += 1
        }
        else {
            //shake!!
            //print("Unavailable move at \(row), \(col)")
        }
        
        if self.isEnd(){
            
        }
        else if self.needToPass(Color: self.isColorWhiteNow){
            //print("\(isColorWhiteNowOut ? "White" : "Black") cannot move")
            self.isColorWhiteNow = !self.isColorWhiteNow
        }
    }
    public func allStepScores(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
        
        var stepScore = Dictionary<chessBoardPos, Int>()
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col)
            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: isWhite)
        }
        
        return stepScore.count == 0 ? nil : stepScore
    }
    public func allStepScoresDifference(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
        
        var stepScore = Dictionary<chessBoardPos, Int>()
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col)
            
            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: true) - testGame.getScore(isWhite: false)
        }
        return stepScore.count == 0 ? nil : stepScore
    }
    //find a best solution in 3 steps with random solution
    public func evaluation(weight: Weight) -> Int{
        
        let scoreDifference = getScoreDifference(isWhite: isColorWhiteNow)
        let chessBoardPositionsForMyself = Set(getChessBoardPositions(isWhite: isColorWhiteNow))
        let chessBoardPositionsForEnemy = Set(getChessBoardPositions(isWhite: !isColorWhiteNow))
        
        let scoreDifferenceWeight = weight.scoreDifferenceWeight
        let sideWeight = weight.sideWeight
        let CWeight = weight.CWeight
        let XWeight = weight.XWeight
        let cornerWeight = weight.cornerWeight
        
        let weightedScoreDifference: Int = scoreDifferenceWeight * scoreDifference
        
        let weightedCSquaresScorePositive = CWeight * Set(Reversi.CSquares[size.rawValue]).intersection(chessBoardPositionsForMyself).count
        let weightedXSquaresScorePositive = XWeight * Set(Reversi.XSquares[size.rawValue]).intersection(chessBoardPositionsForMyself).count
        let weightedCornerSquaresScorePositive = cornerWeight * Set(Reversi.cornerSquares[size.rawValue]).intersection(chessBoardPositionsForMyself).count
        let weightedSideSquaresScorePositive = sideWeight * Set(Reversi.sideSquares[size.rawValue]).intersection(chessBoardPositionsForMyself).count
        
        let weightedCSquaresScoreNegative = CWeight * Set(Reversi.CSquares[size.rawValue]).intersection(chessBoardPositionsForEnemy).count
        let weightedXSquaresScoreNegative = XWeight * Set(Reversi.XSquares[size.rawValue]).intersection(chessBoardPositionsForEnemy).count
        let weightedCornerSquaresScoreNegative = cornerWeight * Set(Reversi.cornerSquares[size.rawValue]).intersection(chessBoardPositionsForEnemy).count
        let weightedSideSquaresScoreNegative = sideWeight * Set(Reversi.sideSquares[size.rawValue]).intersection(chessBoardPositionsForEnemy).count
        
        let weightedCSquaresScore = weightedCSquaresScorePositive - weightedCSquaresScoreNegative
        let weightedXSquaresScore = weightedXSquaresScorePositive - weightedXSquaresScoreNegative
        let weightedCornerSquaresScore = weightedCornerSquaresScorePositive - weightedCornerSquaresScoreNegative
        let weightedSideSquaresScore = weightedSideSquaresScorePositive - weightedSideSquaresScoreNegative
        
        let weightedPositionScore = weightedCSquaresScore +
            weightedXSquaresScore +
            weightedCornerSquaresScore +
        weightedSideSquaresScore
        let score = weightedScoreDifference + weightedPositionScore
        return score
    }
    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
        
        if self.turn == 0{return self.availableSteps(isWhite: isWhite).map{chessBoardPos($0)}.randomElement()}
        //if self.turn == 0{return self.availableSteps(isWhite: isWhite).map{chessBoardPos($0)}[2]}
        //print("\n\nnew search \n\n")
        ///description
        ///var space = ""
        ///description
        var firstStepGames: [Reversi] = []
        var firstSteps: [chessBoardPos] = []
        //add all first steps to nodesToVist
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col)
            firstStepGames.append(testGame)
            firstSteps.append(chessBoardPos(availableStep))
            
        }
        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
        //if game is already end, then load game, will cause a problem
        if firstStepGames.count == 0{return nil}
        for i in 0...firstStepGames.count - 1 {
            //print("branch #\(i)")
            ///for a fixed firstStepGame
            var lastDepth = 0
            var scoreStack: [Int] = []
            /**
             for maximizer
             */
            var alphaStack: [Int?] = []
            /**
             for minimizer
             */
            var betaStack: [Int?] = []
            /**
             - false: take the min of scoreStack
             - true: take the max of scoreStack
             */
            var isMaxOperatorStack: [Bool] = []
            var nodesToVisit = [firstStepGames[i]]
            var numberOfScoresToCalculateStack: [Int] = []
            var nodeNumberStack: [Int] = []
            while !nodesToVisit.isEmpty{
                if stopFinding {return nil}
                let currentNode = nodesToVisit.removeFirst()
                
                //print(String(Array(repeating: "●", count: currentNode.turn)), currentNode.description)
                
                ///discription
                //                space = ""
                //                for _ in 0...currentNode.turn{
                //                    space += "●"
                //                }
                //                print(space)
                //                currentNode.showBoard(isWhite: currentNode.isColorWhiteNow)
                
                ///discription
                var currentDepth = currentNode.turn - self.turn
                if currentDepth < lastDepth{
                    var isMaxOperator = false
                    for _ in 1...lastDepth - currentDepth{
                        isMaxOperator = isMaxOperatorStack.removeFirst()
                        let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
                        nodeNumberStack.removeFirst()
                        //if !nodeNumberStack.isEmpty { nodeNumberStack[0] += 1}
                        nodeNumberStack[0] += 1
                        let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
                        scoreStack.removeFirst(numberOfScoresToCalculate)
                        scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
                        alphaStack.removeFirst()
                        betaStack.removeFirst()
//                        print("currentDepth < lastDepth  i: ", i)
//                        print("currentDepth < lastDepth use operator: ", isMaxOperator ? "max" : "min")
//                        print("currentDepth < lastDepth numberOfScoresToCalculate: ", numberOfScoresToCalculate)
//                        print("currentDepth < lastDepth scoreStack: ", scoreStack)
                    }
                    //BUG
                    if isMaxOperatorStack.first!{
                        if alphaStack[0] != nil{alphaStack[0] = scoreStack[0] > alphaStack[0]! ? scoreStack[0] : alphaStack[0]}
                        else {alphaStack[0] = scoreStack[0]}
                        
                        
                    }
                    else {
                        if betaStack[0] != nil{betaStack[0] = scoreStack[0] < betaStack[0]! ? scoreStack[0] : betaStack[0]}
                        else {betaStack[0] = scoreStack[0]}
                        
                    }
//                    print("currentDepth < lastDepth alphaStack ",alphaStack)
//                    print("currentDepth < lastDepth betaStack ",betaStack)
                    if let alpha = alphaStack[0], let beta = betaStack[0] {
                        if alpha > beta{
//                            print("currentDepth < lastDepth α > β, address ", nodeNumberStack)
//                            print("currentDepth < lastDepth nodesToVisit = \n", nodesToVisit)
//                            print("currentDepth < lastDepth numberOfScoresToCalculateStack ", numberOfScoresToCalculateStack)
//                            print("currentDepth < lastDepth nodeNumberStack ",nodeNumberStack)
//                            print("")
                            nodesToVisit.removeFirst(numberOfScoresToCalculateStack[0] - nodeNumberStack[0] - 1)
                            let score = scoreStack[0]
                            scoreStack.removeFirst(nodeNumberStack[0])
                            scoreStack.insert(score, at: 0)
                            nodeNumberStack.removeFirst()
                            nodeNumberStack[0] += 1
                            lastDepth = currentDepth - 1
                            isMaxOperatorStack.removeFirst()
                            numberOfScoresToCalculateStack.removeFirst()
                            alphaStack.removeFirst()
                            betaStack.removeFirst()
                            continue
                        }
                    }
                    
                }
                
                
                
                isMaxOperatorStack.insert(currentNode.isColorWhiteNow == isWhite ? true : false, at: 0)
                if alphaStack.isEmpty{
                    alphaStack = [nil]
                    betaStack = [nil]
                }
                else {
                    alphaStack.insert(alphaStack.first!, at: 0)
                    betaStack.insert(betaStack.first!,at: 0)
                }
//                print("init isMaxOperatorStack ", isMaxOperatorStack)
//                print("init alhpaStack ", alphaStack)
//                print("init betaStack ", betaStack)
                
                if currentDepth < searchDepth - 1 && !currentNode.isEnd(){
                    
                    
                    ///expand the current node
                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
                    //let samepleOfAvailableSteps = Array(currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow).suffix(2))
                    numberOfScoresToCalculateStack.insert(samepleOfAvailableSteps.count, at: 0)
                    nodeNumberStack.insert(0, at: 0)
//                    print("currentDepth < searchDepth - 1  numberOfScoresToCalculateStack: ", numberOfScoresToCalculateStack)
                    for availableStep in samepleOfAvailableSteps{
                        var testGame = currentNode
                        testGame.play(Row: availableStep.row, Col: availableStep.col)
                        nodesToVisit.insert(testGame, at: 0)
                    }
//                    print("currentDepth < searchDepth - 1  nodesToVisit: ", nodesToVisit)
                    ///expand the current node
                    
                    //print("if isMaxOperatorStack", isMaxOperatorStack)
                    
                }
                    //end node
                else if currentNode.isEnd(){
                    isMaxOperatorStack.removeFirst()
                    alphaStack.removeFirst()
                    betaStack.removeFirst()
                    
                    let currentEvaluation = currentNode.evaluation(weight: weight)
                    scoreStack.insert(currentEvaluation, at: 0)
                    
                    
//                    print("current Node end scoreStack ", scoreStack)
//                    print("current Node end isMaxOperatorStack ", isMaxOperatorStack)
                }
                else{
                    ///expand the current node according to alpha, beta
                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
                    //let samepleOfAvailableSteps = Array(currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow).suffix(2))
                    let isMaxOperator = isMaxOperatorStack.first!
                    
                    var alpha = alphaStack.first!
                    var beta = betaStack.first!
                    var numberOfScoreToCalculate = 0
                    
                    for availableStep in samepleOfAvailableSteps{
                        numberOfScoreToCalculate += 1
                        var testGame = currentNode
                        testGame.play(Row: availableStep.row, Col: availableStep.col)
                        //nodesToVist.insert(testGame, at: 0)
                        currentDepth = testGame.turn - self.turn
                        let currentEvaluation = testGame.evaluation(weight: weight)
//                        print("endpoint: ", currentEvaluation)
                        scoreStack.insert(currentEvaluation, at: 0)
                        
                        ///alpha-beta cut
                        if isMaxOperator{
                            //for the first time
                            if alpha == nil{
                                alpha = currentEvaluation
                            }
                            else {
                                alpha = currentEvaluation > alpha! ? currentEvaluation : alpha
                            }
                            if beta != nil{
                                if alpha! > beta! {break}
                            }
                        }
                        else{
                            if beta == nil{
                                beta = currentEvaluation
                            }
                            else {
                                beta = currentEvaluation < beta! ? currentEvaluation : beta
                            }
                            if alpha != nil{
                                if alpha! > beta! {break}
                            }
                        }
                        ///alpha-beta cut
                    }
                    ///expand the current node according to alpha, beta
                    
                    //                    print("else lastDepth: ", lastDepth)
                    //                    print("else scoreStack: ", scoreStack)
                    ///description
                    //                    print("currentEvaluation ", currentEvaluation)
                    //                    print("")
                    ///description
                    numberOfScoresToCalculateStack.insert(numberOfScoreToCalculate, at: 0)
                    nodeNumberStack.insert(0, at: 0)
                    
                }
                lastDepth = currentDepth
            }
            ///while
            for isMaxOperator in isMaxOperatorStack{
                let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
                let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
                scoreStack.removeFirst(numberOfScoresToCalculate)
                scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
//                print("end use operator: ", isMaxOperator ? "max" : "min")
//                print("end numberOfScoresToCalculateStack: ", numberOfScoresToCalculate)
//                print("end scoreStack: ", scoreStack)
//                print("")
            }
            firstStepMinLastScore[firstSteps[i]] = scoreStack.first!
//            print("end one branch, and score is ", scoreStack.first!)
//            print("")
            
            
            
        }
        let max = firstStepMinLastScore.values.max()
        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
    }
//    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
//        ///description
//        ///var space = ""
//        ///description
//        var firstStepGames: [Reversi] = []
//        var firstSteps: [chessBoardPos] = []
//        //add all first steps to nodesToVist
//        for availableStep in self.availableSteps(isWhite: isWhite){
//            var testGame = self
//            testGame.play(Row: availableStep.row, Col: availableStep.col)
//            firstStepGames.append(testGame)
//            firstSteps.append(chessBoardPos(availableStep))
//
//        }
//        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
//        //if game is already end, then load game, will cause a problem
//        if firstStepGames.count == 0{return nil}
//        for i in 0...firstStepGames.count - 1 {
//            ///for a fixed firstStepGame
//            var lastDepth = 0
//            var scoreStack: [Int] = []
//            /**
//             for maximizer
//             */
//            var alphaStack: [Int?] = []
//            /**
//             for minimizer
//             */
//            var betaStack: [Int?] = []
//            /**
//             - false: take the min of scoreStack
//             - true: take the max of scoreStack
//             */
//            var isMaxOperatorStack: [Bool] = []
//            var nodesToVist = [firstStepGames[i]]
//            var numberOfScoresToCalculateStack: [Int] = []
//            while !nodesToVist.isEmpty{
//                if stopFinding {return nil}
//                let currentNode = nodesToVist.removeFirst()
//                ///discription
//                //                space = ""
//                //                for _ in 0...currentNode.turn{
//                //                    space += "●"
//                //                }
//                //                print(space)
//                //                currentNode.showBoard(isWhite: currentNode.isColorWhiteNow)
//
//                ///discription
//                let currentDepth = currentNode.turn - self.turn
//                if currentDepth < lastDepth{
//                    for _ in 1...lastDepth - currentDepth{
//                        let isMaxOperator = isMaxOperatorStack.removeFirst()
//                        let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
//                        let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
//                        scoreStack.removeFirst(numberOfScoresToCalculate)
//                        scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
//                            print("if i: ", i)
//                            print("use operator: ", isMaxOperator ? "max" : "min")
//                            print("if numberOfScoresToCalculate: ", numberOfScoresToCalculate)
//                            print("if scoreStack: ", scoreStack)
//                    }
//                }
//
//               isMaxOperatorStack.insert(currentNode.isColorWhiteNow == isWhite ? true : false, at: 0)
//                if alphaStack.isEmpty{
//                    alphaStack = [nil]
//                    betaStack = [nil]
//                }
//                else {
//                    alphaStack.insert(alphaStack.first!, at: 0)
//                    betaStack.insert(betaStack.first!,at: 0)
//                }
//
//
//                if currentDepth < searchDepth - 1 && !currentNode.isEnd(){
//
//
//                    ///expand the current node
//                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
//
//                    numberOfScoresToCalculateStack.insert(samepleOfAvailableSteps.count, at: 0)
//                    print("if numberOfScoresToCalculateStack: ", numberOfScoresToCalculateStack)
//                    for availableStep in samepleOfAvailableSteps{
//                        var testGame = currentNode
//                        testGame.play(Row: availableStep.row, Col: availableStep.col)
//                        nodesToVist.insert(testGame, at: 0)
//                    }
//                    ///expand the current node
//
//                    //print("if isMaxOperatorStack", isMaxOperatorStack)
//
//                }
//                //end node
//                else{
//                    ///expand the current node according to alpha, beta
//                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
//
//                    let isMaxOperator = isMaxOperatorStack.removeFirst()
//                    var alpha = alphaStack.removeFirst()
//                    var beta = betaStack.removeFirst()
//
//
//                    for availableStep in samepleOfAvailableSteps{
//
//                        var testGame = currentNode
//                        testGame.play(Row: availableStep.row, Col: availableStep.col)
//                        nodesToVist.insert(testGame, at: 0)
//
//                        let currentEvaluation = currentNode.evaluation(weight: weight)
//                        scoreStack.insert(currentEvaluation, at: 0)
//
//
//
//                        if isMaxOperator{
//                            if alpha == nil{
//                                alpha = currentEvaluation
//                            }
//                            else {
//                                if isMaxOperatorStack.first != nil{
//                                    if !isMaxOperatorStack.first!{
//                                        if currentEvaluation > alphaStack.first!! {break}
//                                    }
//                                    else{
//
//                                    }
//                                }
//                                alpha = currentEvaluation > alpha! ? currentEvaluation : alpha
//                            }
//                        }
//                        else{
//                            if beta == nil{
//                                beta = currentEvaluation
//                            }
//                            else {
//                                beta = currentEvaluation < beta! ? currentEvaluation : beta
//                            }
//
//                        }
//
//                    }
//                    ///expand the current node according to alpha, beta
//                    alphaStack[0] = alpha
//                    betaStack[0] = beta
//
//
//                    //                    print("else lastDepth: ", lastDepth)
//                    //                    print("else scoreStack: ", scoreStack)
//                    ///description
//                    //                    print("currentEvaluation ", currentEvaluation)
//                    //                    print("")
//                    ///description
//                }
//
//
//
//
//                lastDepth = currentDepth
//            }
//            ///while
//            for isMaxOperator in isMaxOperatorStack{
//                let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
//                let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
//                scoreStack.removeFirst(numberOfScoresToCalculate)
//                scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
//                print("end use operator: ", isMaxOperator ? "max" : "min")
//                print("end numberOfScoresToCalculateStack: ", numberOfScoresToCalculateStack)
//                print("end scoreStack: ", scoreStack)
//            }
//            firstStepMinLastScore[firstSteps[i]] = scoreStack.first!
//            print("end one branch, and score is ", scoreStack.first!)
//
//
//
//        }
//        let max = firstStepMinLastScore.values.max()
//        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
//    }
    
    
    //    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
    //        ///description
    //        ///var space = ""
    //        ///description
    //        var firstStepGames: [Reversi] = []
    //        var firstSteps: [chessBoardPos] = []
    //        //add all first steps to nodesToVist
    //        for availableStep in self.availableSteps(isWhite: isWhite){
    //            var testGame = self
    //            testGame.play(Row: availableStep.row, Col: availableStep.col)
    //            firstStepGames.append(testGame)
    //            firstSteps.append(chessBoardPos(availableStep))
    //
    //        }
    //        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
    //        //if firstStepGames.count == 0{return nil}
    //        for i in 0...firstStepGames.count - 1 {
    //            ///for fixed firstStepGame
    //            var scoreStack: [Int] = []
    //            /**
    //             - false: take the min of scoreStack
    //             - true: take the max of scoreStack
    //             */
    //            var isMaxOperatorStack: [Bool] = []
    //            var nodesToVist = [firstStepGames[i]]
    //
    //            while !nodesToVist.isEmpty{
    //                if stopFinding {return nil}
    //                let currentNode = nodesToVist.removeFirst()
    //                ///discription
    ////                space = ""
    ////                for _ in 0...currentNode.turn{
    ////                    space += "●"
    ////                }
    ////                print(space)
    ////                currentNode.showBoard(isWhite: currentNode.isColorWhiteNow)
    //
    //                ///discription
    //                if currentNode.turn - self.turn < searchDepth && !currentNode.isEnd(){
    //                    if !scoreStack.isEmpty{
    //                        if let isMaxOperator = isMaxOperatorStack.first{
    //                            scoreStack = [ isMaxOperator ? scoreStack.max()! : scoreStack.min()!]
    //                        }
    //                    }
    //                    isMaxOperatorStack.insert(currentNode.isColorWhiteNow == isWhite ? true : false, at: 0)
    //                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow).choose(3)
    //                    for availableStep in samepleOfAvailableSteps{
    //                        var testGame = currentNode
    //                        testGame.play(Row: availableStep.row, Col: availableStep.col)
    //                        nodesToVist.insert(testGame, at: 0)
    //                    }
    //                }
    //                else{
    //                    let currentEvaluation = currentNode.evaluation(weight: weight)
    //                    scoreStack.append(currentEvaluation)
    //                    ///description
    ////                    print("currentEvaluation ", currentEvaluation)
    ////                    print("")
    //                    ///description
    //                }
    //            }
    //
    //            if let isMaxOperator = isMaxOperatorStack.first{
    //                 firstStepMinLastScore[firstSteps[i]] = isMaxOperator ? scoreStack.max()! : scoreStack.min()!
    //            }
    //            else {firstStepMinLastScore[firstSteps[i]] = scoreStack.first!}
    //            ///description
    ////            print("choosen score ", firstStepMinLastScore[firstSteps[i]]!,"\n")
    //            ///description
    //
    //            ///for fixed firstStepGame
    //        }
    //        let max = firstStepMinLastScore.values.max()
    //        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
    //    }
    //    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
    //        var firstStepGames: [Reversi] = []
    //        var firstSteps: [chessBoardPos] = []
    //        //add all first steps to nodesToVist
    //        for availableStep in self.availableSteps(isWhite: isWhite){
    //            var testGame = self
    //            testGame.play(Row: availableStep.row, Col: availableStep.col)
    //            firstStepGames.append(testGame)
    //            firstSteps.append(chessBoardPos(availableStep))
    //
    //        }
    //        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
    //        if firstStepGames.count == 0{return nil}
    //        for i in 0...firstStepGames.count - 1 {
    //            ///for fixed firstStepGame
    //            var minLastScore = Int.max
    //            var nodesToVist: [Reversi] = []
    //            for availableStep in firstStepGames[i].availableSteps(isWhite: firstStepGames[i].isColorWhiteNow){
    //                var testGame = firstStepGames[i]
    //                testGame.play(Row: availableStep.row, Col: availableStep.col)
    //                nodesToVist.append(testGame)
    //            }
    //            while !nodesToVist.isEmpty{
    //                if stopFinding {return nil}
    //                let currentNode = nodesToVist.removeFirst()
    //
    //
    //                if currentNode.turn - self.turn < searchDepth{
    //                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(3)
    //                    for availableStep in samepleOfAvailableSteps{
    //
    //                        var testGame = currentNode
    //                        testGame.play(Row: availableStep.row, Col: availableStep.col)
    //                        nodesToVist.insert(testGame, at: 0)
    //                    }
    //                }
    //                else{
    //                    let currentEvaluation = currentNode.evaluation(
    //                        weight: weight)
    //
    //                    if currentEvaluation < minLastScore{
    //                        minLastScore = currentEvaluation
    //                    }
    //                }
    //            }
    //
    //            firstStepMinLastScore[firstSteps[i]] = minLastScore
    //            ///for fixed firstStepGame
    //        }
    //        let max = firstStepMinLastScore.values.max()
    //        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
    //    }
}


////
////  Reversi.swift
////  Reversi
////
////  Created by john gospai on 2018/11/6.
////  Copyright © 2018 john gospai. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//public struct Reversi: Codable{
//    
//    public enum direction: Int, CaseIterable{
//        case right = 0, rightUp, up, leftUp, left, leftDown, down, rightDown, allDirctions
//    }
//    public var gameBoard = [[Int?]](repeating: [Int?](repeating: nil, count: 6), count: 6)
//    public var isColorWhite = [[Bool?]](repeating: [Bool?](repeating: nil, count: 6), count: 6)
//    public var whiteScore: Int = 0
//    public var blackScore: Int = 0
//    public var isColorWhiteNow: Bool = false
//    public var turn: Int = 0
//    public static let CSquares: [chessBoardPos] =
//        [chessBoardPos(row: 0,col: 1),
//         chessBoardPos(row: 0,col: 4),
//         chessBoardPos(row: 1,col: 0),
//         chessBoardPos(row: 1,col: 5),
//         chessBoardPos(row: 4,col: 0),
//         chessBoardPos(row: 4,col: 5),
//         chessBoardPos(row: 5,col: 1),
//         chessBoardPos(row: 5,col: 4)]
//    public static let XSquares: [chessBoardPos] =
//        [chessBoardPos(row: 1,col: 1),
//         chessBoardPos(row: 1,col: 4),
//         chessBoardPos(row: 4,col: 1),
//         chessBoardPos(row: 4,col: 4)]
//    public static let cornerSquares: [chessBoardPos] =
//        [chessBoardPos(row: 0,col: 0),
//         chessBoardPos(row: 0,col: 5),
//         chessBoardPos(row: 5,col: 0),
//         chessBoardPos(row: 5,col: 5)]
//    public static func getSideSquares() -> [chessBoardPos]{
//        var sideSquares: [chessBoardPos] = []
//        for i in 0...5
//        {
//            for j in 0...5
//            {
//                if i == 0 || i == 5 || j == 0 || j == 5{
//                    if !Reversi.CSquares.contains(chessBoardPos(row: i,col: j))
//                        && !Reversi.XSquares.contains(chessBoardPos(row: i,col: j))
//                        && !Reversi.cornerSquares.contains(chessBoardPos(row: i,col: j)){
//                        sideSquares.append(chessBoardPos(row: i, col: j))
//                    }
//                }
//            }
//        }
//        return sideSquares
//    }
//    public static let sideSquares = Reversi.getSideSquares()
//    
//    public init() {
//        for i in 0...5
//        {
//            for j in 0...5
//            {
//                if  (i == 2 || i == 3) &&
//                    (j == 2 || j == 3)
//                {gameBoard[i][j] = 0}
//                
//                if  (i == 2 && j == 3) ||
//                    (i == 3 && j == 2)
//                {isColorWhite[i][j] = false}
//                else if
//                    (i == 2 && j == 2) ||
//                        (i == 3 && j == 3)
//                {isColorWhite[i][j] = true}
//            }
//        }
//        
//    }
//    //TODO: getWeight
//    //get the information of the number of the position
//    public func getNumber(Row: Int, Col: Int) -> Int?{
//        return gameBoard[Row][Col]
//    }
//    public func getColor(Row: Int, Col: Int) -> Bool?{
//        return isColorWhite[Row][Col]
//    }
//    public func getBlackScore() -> Int{
//        return blackScore
//    }
//    //get the information of negative score
//    public func getWhiteScore() -> Int{
//        return whiteScore
//    }
//    //get the information of score
//    public func getScore(isWhite: Bool) -> Int{
//        return isWhite ? whiteScore : blackScore
//    }
//    public func getScoreDifference(isWhite: Bool) -> Int{
//        return getScore(isWhite: isWhite) - getScore(isWhite: !isWhite)
//    }
//    public func showBoard(isWhite: Bool){
//        print(isWhite)
//        for i in 0...5 {print("  \(i)", terminator:"")}
//        print("")
//        for row in 0...5
//        {
//            print("\(row)|", terminator:"")
//            for col in 0...5
//            {
//                if let gameBoard = gameBoard[row][col]
//                {
//                    if isColorWhite[row][col]!
//                    {print("+", terminator:"")}
//                    else {print("-", terminator:"")}
//                    print("\(gameBoard)|", terminator:"")
//                }
//                else if (self.isAvailable(Row: row, Col: col, isWhite: isWhite)) {print(" ?|", terminator:"")}
//                else {print("  |", terminator:"")}
//            }
//            print("")
//        }
//    }
//    public func isAvailable(toward Direction: direction = .allDirctions, Row: Int, Col: Int, isWhite: Bool) -> Bool{
//        if Row < 0 || Row > 5 || Col < 0 || Col > 5 {return false}
//        //if there's already something at (Row, Col), then you cannot put anything on it.
//        if let _ = gameBoard[Row][Col] {return false}
//        switch Direction {
//        case .right:
//            if Col < 4 {
//                if isColorWhite[Row][Col + 1] == !isWhite {
//                    for j in 2...5 - Col {
//                        if isColorWhite[Row][Col + j] == nil {return false}
//                        if isColorWhite[Row][Col + j] == isWhite {return true}
//                    }
//                }
//            }
//        case .rightUp:
//            if Row > 1 && Col < 4 {
//                if isColorWhite[Row - 1][Col + 1] == !isWhite {
//                    for j in 2...min(Row, 5 - Col) {
//                        if isColorWhite[Row - j][Col + j] == nil {return false}
//                        if isColorWhite[Row - j][Col + j] == isWhite {return true}
//                    }
//                }
//            }
//        case .up:
//            if Row > 1 {
//                //able to be toward up
//                if isColorWhite[Row - 1][Col] == !isWhite {
//                    for i in 2...Row
//                    {
//                        if isColorWhite[Row - i][Col] == nil {return false}
//                        if isColorWhite[Row - i][Col] == isWhite {return true}
//                    }
//                }
//            }
//        case .leftUp:
//            if Row > 1 && Col > 1 {
//                if isColorWhite[Row - 1][Col - 1] == !isWhite {
//                    for j in 2...min(Row, Col) {
//                        if isColorWhite[Row - j][Col - j] == nil {return false}
//                        if isColorWhite[Row - j][Col - j] == isWhite {return true}
//                    }
//                }
//            }
//        case .left:
//            if Col > 1 {
//                if isColorWhite[Row][Col - 1] == !isWhite {
//                    for j in 2...Col {
//                        if isColorWhite[Row][Col - j] == nil {return false}
//                        if isColorWhite[Row][Col - j] == isWhite {return true}
//                    }
//                }
//            }
//        case .leftDown:
//            if Row < 4 && Col > 1 {
//                if isColorWhite[Row + 1][Col - 1] == !isWhite {
//                    for j in 2...min(5 - Row, Col){
//                        if isColorWhite[Row + j][Col - j] == nil {return false}
//                        if isColorWhite[Row + j][Col - j] == isWhite {return true}
//                    }
//                }
//            }
//        case .down:
//            if Row < 4 {
//                if isColorWhite[Row + 1][Col] == !isWhite {
//                    for i in 2...5 - Row {
//                        if isColorWhite[Row + i][Col] == nil {return false}
//                        if isColorWhite[Row + i][Col] == isWhite {return true}
//                    }
//                }
//            }
//        case .rightDown:
//            if Row < 4 && Col < 4 {
//                if isColorWhite[Row + 1][Col + 1] == !isWhite {
//                    for j in 2...min(5 - Row, 5 - Col) {
//                        if isColorWhite[Row + j][Col + j] == nil {return false}
//                        if isColorWhite[Row + j][Col + j] == isWhite {return true}
//                    }
//                }
//            }
//        default:
//            for direction in 0...7{
//                if(isAvailable(toward: Reversi.direction(rawValue: direction)!, Row: Row, Col: Col, isWhite: isWhite))
//                {return true}
//            }
//        }
//        return false
//    }
//    //with availability checked
//    public mutating func fillColoredNumber(Row: Int, Col: Int, isWhite: Bool) -> Bool{
//        if !isAvailable(Row: Row, Col: Col, isWhite: isWhite) {return false}
//        isColorWhite[Row][Col] = isWhite
//        //flip the known numbers
//        //check all eight directions
//        if isAvailable(toward: .right, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...5 - Col {
//                if isColorWhite[Row][Col + j] == isWhite {break}
//                if isColorWhite[Row][Col + j] == !isWhite {
//                    gameBoard[Row][Col + j]! += 1
//                    isColorWhite[Row][Col + j] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .rightUp, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...min(Row, 5 - Col) {
//                if isColorWhite[Row - j][Col + j] == isWhite {break}
//                if isColorWhite[Row - j][Col + j] == !isWhite {
//                    gameBoard[Row - j][Col + j]! += 1
//                    isColorWhite[Row - j][Col + j] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .up, Row: Row, Col: Col, isWhite: isWhite){
//            for i in 1...Row {
//                if isColorWhite[Row - i][Col] == isWhite {break}
//                if isColorWhite[Row - i][Col] == !isWhite {
//                    gameBoard[Row - i][Col]! += 1
//                    isColorWhite[Row - i][Col] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .leftUp, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...min(Row, Col) {
//                if isColorWhite[Row - j][Col - j] == isWhite {break}
//                if isColorWhite[Row - j][Col - j] == !isWhite {
//                    gameBoard[Row - j][Col - j]! += 1
//                    isColorWhite[Row - j][Col - j] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .left, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...Col {
//                if isColorWhite[Row][Col - j] == isWhite {break}
//                if isColorWhite[Row][Col - j] == !isWhite {
//                    gameBoard[Row][Col - j]! += 1
//                    isColorWhite[Row][Col - j] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .leftDown, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...min(5 - Row, Col){
//                if isColorWhite[Row + j][Col - j] == isWhite {break}
//                if isColorWhite[Row + j][Col - j] == !isWhite {
//                    gameBoard[Row + j][Col - j]! += 1
//                    isColorWhite[Row + j][Col - j] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .down, Row: Row, Col: Col, isWhite: isWhite){
//            for i in 1...5 - Row {
//                if isColorWhite[Row + i][Col] == isWhite {break}
//                if isColorWhite[Row + i][Col] == !isWhite {
//                    gameBoard[Row + i][Col]! += 1
//                    isColorWhite[Row + i][Col] = isWhite
//                }
//            }
//        }
//        if isAvailable(toward: .rightDown, Row: Row, Col: Col, isWhite: isWhite){
//            for j in 1...min(5 - Row, 5 - Col) {
//                if isColorWhite[Row + j][Col + j] == isWhite {break}
//                if isColorWhite[Row + j][Col + j] == !isWhite {
//                    gameBoard[Row + j][Col + j]! += 1
//                    isColorWhite[Row + j][Col + j] = isWhite
//                }
//            }
//        }
//        gameBoard[Row][Col] = 0
//        blackScore = 0
//        whiteScore = 0
//        for i in 0...5
//        {
//            for j in 0...5
//            {
//                if isColorWhite[i][j] == true {whiteScore += gameBoard[i][j]!}
//                else if isColorWhite[i][j] == false {blackScore += gameBoard[i][j]!}
//            }
//        }
//        return true
//    }
//    public func needToPass(Color: Bool) -> Bool{
//        for i in 0...5
//        {
//            for j in 0...5
//            {
//                if (self.isAvailable(Row: i, Col: j, isWhite: Color)) {return false}
//            }
//        }
//        return true
//    }
//    public func availableSteps(isWhite: Bool) -> [(row: Int, col: Int)]{
//        var answer = [(row: Int, col: Int)]()
//        for row in 0...5{
//            for col in 0...5{
//                if isAvailable(Row: row, Col: col, isWhite: isWhite){
//                    answer.append((row,col))
//                }
//            }
//        }
//        return answer
//    }
//    public func getChessBoardPositions(isWhite: Bool) -> [chessBoardPos]{
//        var answer: [chessBoardPos] = []
//        for row in 0...5{
//            for col in 0...5{
//                if getColor(Row: row, Col: col) == isWhite{
//                    answer.append(chessBoardPos(row: row, col: col))
//                }
//            }
//        }
//        return answer
//    }
//    //check if the game is end
//    public func isEnd() -> Bool{
//        if (self.needToPass(Color: true) && self.needToPass(Color: false)) {return true}
//        return false
//    }
//
//     /**
//     - Parameters:
//        - row: the row you want to click
//        - col: the col you want to click
//        - isColorWhiteNow: the color of the player who plays now
//     */
//    public mutating func play(Row row: Int, Col col: Int){
//        if !Array(0...5).contains(where: {$0 == row || $0 == col}){fatalError("wrong row or column")}
//        if self.fillColoredNumber(Row: row, Col: col, isWhite: self.isColorWhiteNow){
//            self.isColorWhiteNow = !self.isColorWhiteNow
//            turn += 1
//        }
//        else {
//            //shake!!
//            //print("Unavailable move at \(row), \(col)")
//        }
//        
//        if self.isEnd(){
//            //print("end")
//            //print("\( getBlackScore() > getWhiteScore() ? "Black" : ( (getBlackScore() < getWhiteScore() ) ? "White" : "Draw" ) )")
//        }
//        else if self.needToPass(Color: self.isColorWhiteNow){
//            //print("\(self.isColorWhiteNow ? "White" : "Black") cannot move")
//            self.isColorWhiteNow = !self.isColorWhiteNow
//        }
//    }
//    public func allStepScores(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
//        
//        var stepScore = Dictionary<chessBoardPos, Int>()
//        for availableStep in self.availableSteps(isWhite: isWhite){
//            var testGame = self
//            testGame.play(Row: availableStep.row, Col: availableStep.col)
//            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: isWhite)
//        }
//        
//        return stepScore.count == 0 ? nil : stepScore
//    }
//    public func allStepScoresDifference(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
//        
//        var stepScore = Dictionary<chessBoardPos, Int>()
//        for availableStep in self.availableSteps(isWhite: isWhite){
//            var testGame = self
//            testGame.play(Row: availableStep.row, Col: availableStep.col)
//            
//            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: true) - testGame.getScore(isWhite: false)
//        }
//        return stepScore.count == 0 ? nil : stepScore
//    }
//    //find a best solution in 3 steps with random solution
//    //can replace
//    public func evaluation(weight: Weight) -> Int{
//        
//        let scoreDifference = getScoreDifference(isWhite: isColorWhiteNow)
//        let chessBoardPositionsForMyself = Set(getChessBoardPositions(isWhite: isColorWhiteNow))
//        let chessBoardPositionsForEnemy = Set(getChessBoardPositions(isWhite: !isColorWhiteNow))
//        
//        //let turnWeight = 1.0// + Double(turn) / 32.0
//        /*switch turn {
//        case 0...10:
//            turnWeight = 1
//        case 11...20:
//            turnWeight = 2
//        case 21...32:
//            turnWeight = 3
//        default:
//            turnWeight = 4
//        }*/
//
//        
////        let scoreDifferenceWeight = 1
////        let sideWeight = 5 * turnWeight
////        let CWeight = 10 * turnWeight
////        let XWeight = 20 * turnWeight
////        let cornerWeight = 50 * turnWeight
//        let scoreDifferenceWeight = weight.scoreDifferenceWeight
//        let sideWeight = weight.sideWeight
//        let CWeight = weight.CWeight
//        let XWeight = weight.XWeight
//        let cornerWeight = weight.cornerWeight
//        
//       
//        let weightedScoreDifference: Int = scoreDifferenceWeight * scoreDifference
//        
//        let weightedCSquaresScorePositive = CWeight * Set(Reversi.CSquares).intersection(chessBoardPositionsForMyself).count
//        let weightedXSquaresScorePositive = XWeight * Set(Reversi.XSquares).intersection(chessBoardPositionsForMyself).count
//        let weightedCornerSquaresScorePositive = cornerWeight * Set(Reversi.cornerSquares).intersection(chessBoardPositionsForMyself).count
//        let weightedSideSquaresScorePositive = sideWeight * Set(Reversi.sideSquares).intersection(chessBoardPositionsForMyself).count
//        
//        let weightedCSquaresScoreNegative = CWeight * Set(Reversi.CSquares).intersection(chessBoardPositionsForEnemy).count
//        let weightedXSquaresScoreNegative = XWeight * Set(Reversi.XSquares).intersection(chessBoardPositionsForEnemy).count
//        let weightedCornerSquaresScoreNegative = cornerWeight * Set(Reversi.cornerSquares).intersection(chessBoardPositionsForEnemy).count
//        let weightedSideSquaresScoreNegative = sideWeight * Set(Reversi.sideSquares).intersection(chessBoardPositionsForEnemy).count
//        
//        let weightedCSquaresScore = weightedCSquaresScorePositive - weightedCSquaresScoreNegative
//        let weightedXSquaresScore = weightedXSquaresScorePositive - weightedXSquaresScoreNegative
//        let weightedCornerSquaresScore = weightedCornerSquaresScorePositive - weightedCornerSquaresScoreNegative
//        let weightedSideSquaresScore = weightedSideSquaresScorePositive - weightedSideSquaresScoreNegative
//        
//        let weightedPositionScore = weightedCSquaresScore +
//                                    weightedXSquaresScore +
//                                    weightedCornerSquaresScore +
//                                    weightedSideSquaresScore
//        let score = weightedScoreDifference + weightedPositionScore
//        return score
//    }
//    //can replace
//    ///calculate and put prefer one
//    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
//        ///description
//        ///var space = ""
//        ///description
//        var firstStepGames: [Reversi] = []
//        var firstSteps: [chessBoardPos] = []
//        //add all first steps to nodesToVist
//        for availableStep in self.availableSteps(isWhite: isWhite){
//            var testGame = self
//            testGame.play(Row: availableStep.row, Col: availableStep.col)
//            firstStepGames.append(testGame)
//            firstSteps.append(chessBoardPos(availableStep))
//
//        }
//        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
//        //if firstStepGames.count == 0{return nil}
//        for i in 0...firstStepGames.count - 1 {
//            ///for fixed firstStepGame
//            var lastDepth = 0
//            var scoreStack: [Int] = []
//            /**
//             - false: take the min of scoreStack
//             - true: take the max of scoreStack
//             */
//            var isMaxOperatorStack: [Bool] = []
//            var nodesToVist = [firstStepGames[i]]
//            var numberOfScoresToCalculateStack: [Int] = []
//            while !nodesToVist.isEmpty{
//                if stopFinding {return nil}
//                let currentNode = nodesToVist.removeFirst()
//                ///discription
//                //                space = ""
//                //                for _ in 0...currentNode.turn{
//                //                    space += "●"
//                //                }
//                //                print(space)
//                //                currentNode.showBoard(isWhite: currentNode.isColorWhiteNow)
//
//                ///discription
//                let currentDepth = currentNode.turn - self.turn
//                if currentDepth < lastDepth{
//                    for i in 1...lastDepth - currentDepth{
//                        let isMaxOperator = isMaxOperatorStack.removeFirst()
//                        let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
//                        let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
//                        scoreStack.removeFirst(numberOfScoresToCalculate)
//                        scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
//                    }
//                }
//                if currentDepth < searchDepth && !currentNode.isEnd(){
//
////                    if !endNodeScoreStack.isEmpty{
////                        let isMaxOperator = isMaxOperatorStack.removeFirst()
////                        scoreStack.append(isMaxOperator ? endNodeScoreStack.max()! : endNodeScoreStack.min()!)
////
////                    }
//
//                    lastDepth = currentDepth
//                   
//                    isMaxOperatorStack.insert(currentNode.isColorWhiteNow == isWhite ? true : false, at: 0)
//                   
//                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
//                    numberOfScoresToCalculateStack.insert(samepleOfAvailableSteps.count, at: 0)
//                    for availableStep in samepleOfAvailableSteps{
//                        var testGame = currentNode
//                        testGame.play(Row: availableStep.row, Col: availableStep.col)
//                        nodesToVist.insert(testGame, at: 0)
//                    }
//                }
//                else{
//                    lastDepth = currentNode.turn - self.turn
//                    let currentEvaluation = currentNode.evaluation(weight: weight)
//                    scoreStack.insert(currentEvaluation, at: 0)
//                   
//                    ///description
//                    //                    print("currentEvaluation ", currentEvaluation)
//                    //                    print("")
//                    ///description
//                }
//            }
//            for isMaxOperator in isMaxOperatorStack{
//                let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
//                let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
//                scoreStack.removeFirst(numberOfScoresToCalculate)
//                scoreStack.insert(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!, at: 0)
//               
//            }
//            firstStepMinLastScore[firstSteps[i]] = scoreStack.first!
//            
//
//
////            if let isMaxOperator = isMaxOperatorStack.first{
////                firstStepMinLastScore[firstSteps[i]] = isMaxOperator ? scoreStack.max()! : scoreStack.min()!
////            }
////            else {firstStepMinLastScore[firstSteps[i]] = scoreStack.first!}
//            ///description
//            //            print("choosen score ", firstStepMinLastScore[firstSteps[i]]!,"\n")
//            ///description
//
//            ///for fixed firstStepGame
//        }
//        let max = firstStepMinLastScore.values.max()
//        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
//    }
//    
//    
//    
//    ///calculate at once
////    public func bestSolution(isWhite: Bool, searchDepth: UInt = 1, stopFinding: inout Bool, weight: Weight = Weight()) -> chessBoardPos?{
////        ///description
////        ///var space = ""
////        ///description
////        var firstStepGames: [Reversi] = []
////        var firstSteps: [chessBoardPos] = []
////        //add all first steps to nodesToVist
////        for availableStep in self.availableSteps(isWhite: isWhite){
////            var testGame = self
////            testGame.play(Row: availableStep.row, Col: availableStep.col)
////            firstStepGames.append(testGame)
////            firstSteps.append(chessBoardPos(availableStep))
////
////        }
////        var firstStepMinLastScore = Dictionary<chessBoardPos, Int>()
////        //if firstStepGames.count == 0{return nil}
////        for i in 0...firstStepGames.count - 1 {
////            ///for fixed firstStepGame
////            var lastDepth = 0
////            var scoreStack: [Int] = []
////            /**
////             - false: take the min of scoreStack
////             - true: take the max of scoreStack
////             */
////            var isMaxOperatorStack: [Bool] = []
////            var nodesToVist = [firstStepGames[i]]
////            var numberOfScoresToCalculateStack: [Int] = []
////            while !nodesToVist.isEmpty{
////                if stopFinding {return nil}
////                let currentNode = nodesToVist.removeFirst()
////                ///discription
////                //                space = ""
////                //                for _ in 0...currentNode.turn{
////                //                    space += "●"
////                //                }
////                //                print(space)
////                //                currentNode.showBoard(isWhite: currentNode.isColorWhiteNow)
////
////                ///discription
////                let currentDepth = currentNode.turn - self.turn
////                if currentDepth < searchDepth && !currentNode.isEnd(){
////
////                    //                    if !endNodeScoreStack.isEmpty{
////                    //                        let isMaxOperator = isMaxOperatorStack.removeFirst()
////                    //                        scoreStack.append(isMaxOperator ? endNodeScoreStack.max()! : endNodeScoreStack.min()!)
////                    //
////                    //                    }
////
////
////                    print("if lastDepth: ", lastDepth)
////                    isMaxOperatorStack.insert(currentNode.isColorWhiteNow == isWhite ? true : false, at: 0)
////                    print("if isMaxOperatorStack", isMaxOperatorStack)
////                    let samepleOfAvailableSteps = currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow)//.choose(2)
////                    numberOfScoresToCalculateStack.insert(samepleOfAvailableSteps.count, at: 0)
////                    print("if numberOfScoresToCalculateStack: ", numberOfScoresToCalculateStack)
////                    for availableStep in samepleOfAvailableSteps{
////                        var testGame = currentNode
////                        testGame.play(Row: availableStep.row, Col: availableStep.col)
////                        nodesToVist.insert(testGame, at: 0)
////                    }
////                }
////                else{
////                    lastDepth = currentNode.turn - self.turn
////                    let currentEvaluation = currentNode.evaluation(weight: weight)
////                    scoreStack.insert(currentEvaluation, at: 0)
////                    print("else lastDepth: ", lastDepth)
////                    print("else scoreStack: ", scoreStack)
////                    ///description
////                    //                    print("currentEvaluation ", currentEvaluation)
////                    //                    print("")
////                    ///description
////                }
////            }
////            for isMaxOperator in isMaxOperatorStack{
////                let numberOfScoresToCalculate = numberOfScoresToCalculateStack.removeFirst()
////                let scoreToCalculate = Array(scoreStack.prefix(numberOfScoresToCalculate))
////                scoreStack.removeFirst(numberOfScoresToCalculate)
////                scoreStack.append(isMaxOperator ? scoreToCalculate.max()! : scoreToCalculate.min()!)
////                print("end use operator: ", isMaxOperator ? "max" : "min")
////                print("end numberOfScoresToCalculateStack: ", numberOfScoresToCalculateStack)
////                print("end scoreStack: ", scoreStack)
////            }
////            firstStepMinLastScore[firstSteps[i]] = scoreStack.first!
////            print("end one branch, and score is ", scoreStack.first!)
////
////
////            //            if let isMaxOperator = isMaxOperatorStack.first{
////            //                firstStepMinLastScore[firstSteps[i]] = isMaxOperator ? scoreStack.max()! : scoreStack.min()!
////            //            }
////            //            else {firstStepMinLastScore[firstSteps[i]] = scoreStack.first!}
////            ///description
////            //            print("choosen score ", firstStepMinLastScore[firstSteps[i]]!,"\n")
////            ///description
////
////            ///for fixed firstStepGame
////        }
////        let max = firstStepMinLastScore.values.max()
////        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
////    }
//}
//
