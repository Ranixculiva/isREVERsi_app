//
//  Reversi.swift
//  Reversi
//
//  Created by john gospai on 2018/11/6.
//  Copyright © 2018 john gospai. All rights reserved.
//

import Foundation
import SpriteKit
struct Reversi{
    
    //direction
    let right       = 0
    let rightUp     = 1
    let up          = 2
    let leftUp      = 3
    let left        = 4
    let leftDown    = 5
    let down        = 6
    let rightDown   = 7
    private var gameBoard = [[Int?]](repeating: [Int?](repeating: nil, count: 6), count: 6)
    private var isColorWhite = [[Bool?]](repeating: [Bool?](repeating: nil, count: 6), count: 6)
    private var whiteScore: Int = 0
    private var blackScore: Int = 0
    var isColorWhiteNow: Bool = false
    var turn: Int = 0
    var CSquares: [chessBoardPos] =
        [chessBoardPos(row: 0,col: 1),
         chessBoardPos(row: 0,col: 4),
         chessBoardPos(row: 1,col: 0),
         chessBoardPos(row: 1,col: 5),
         chessBoardPos(row: 4,col: 0),
         chessBoardPos(row: 4,col: 5),
         chessBoardPos(row: 5,col: 1),
         chessBoardPos(row: 5,col: 4)]
    var XSquares: [chessBoardPos] =
        [chessBoardPos(row: 1,col: 1),
         chessBoardPos(row: 1,col: 4),
         chessBoardPos(row: 4,col: 1),
         chessBoardPos(row: 4,col: 4)]
    var cornerSquares: [chessBoardPos] =
        [chessBoardPos(row: 0,col: 0),
         chessBoardPos(row: 0,col: 5),
         chessBoardPos(row: 5,col: 0),
         chessBoardPos(row: 5,col: 5)]
    var sideSquares: [chessBoardPos] = []
    
    init() {
        for i in 0...5
        {
            for j in 0...5
            {
                if  (i == 2 || i == 3) &&
                    (j == 2 || j == 3)
                {gameBoard[i][j] = 0}
                
                if  (i == 2 && j == 3) ||
                    (i == 3 && j == 2)
                {isColorWhite[i][j] = false}
                else if
                    (i == 2 && j == 2) ||
                        (i == 3 && j == 3)
                {isColorWhite[i][j] = true}
                if i == 0 || i == 5 || j == 0 || j == 5{
                    if !CSquares.contains(chessBoardPos(row: i,col: j))
                    && !XSquares.contains(chessBoardPos(row: i,col: j))
                    && !cornerSquares.contains(chessBoardPos(row: i,col: j)){
                        sideSquares.append(chessBoardPos(row: i, col: j))
                    }
                }
            }
        }
        
    }
    //TODO: getWeight
    //get the information of the number of the position
    func getNumber(Row: Int, Col: Int) -> Int?
    {
        return gameBoard[Row][Col]
    }
    func getColor(Row: Int, Col: Int) -> Bool?
    {
        return isColorWhite[Row][Col]
    }
    func getBlackScore() -> Int
    {
        return blackScore
    }
    //get the information of negative score
    func getWhiteScore() -> Int
    {
        return whiteScore
    }
    //get the information of score
    func getScore(isWhite: Bool) -> Int
    {
        return isWhite ? whiteScore : blackScore
    }
    func getScoreDifference(isWhite: Bool) -> Int{
        return getScore(isWhite: isWhite) - getScore(isWhite: !isWhite)
    }
    //show the game board
    func showBoard(labels: [[SKLabelNode]], whiteScoreLabel: SKLabelNode, blackScoreLabel: SKLabelNode, stateIndicator: SKCropNode, stateIndicatorColorLeft: SKSpriteNode, stateIndicatorColorRight: SKSpriteNode, chessBoardScaledWidth width: CGFloat ,chessBoardScaledHeight height: CGFloat, isWhite: Bool, withAnimation: Bool = true, action: @escaping () -> Void = {})
    {
        if labels.count != 6 {fatalError("wrong rows of labels")}
/// with animation
        if withAnimation{
            if let gameScene = labels[0][0].parent{
                gameScene.isUserInteractionEnabled = false
                let originScaleX = labels[0][0].xScale
                let flipFirstHalfPart = SKAction.scaleX(to: 0, duration: 0.3)
                let flipLastHalfPart = SKAction.scaleX(to: originScaleX, duration: 0.3)
                let flipWait = SKAction.wait(forDuration: 0.6)
                
                
                for row in 0...5{
                    if labels[row].count != 6 {fatalError("wrong columns of labels")}
                    for col in 0...5{
                        let label = labels[row][col]
                        var labelText = String()
                        var labelColor = (red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
                        if let number = self.getNumber(Row: row, Col: col){
                            if "\(number)" != label.text{
                                labelText = "\(number)"
                                labelColor = (self.getColor(Row: row, Col: col)! ? (1, 1, 1, 1) : (0, 0, 0, 1))
                                label.run(flipFirstHalfPart){
                                    label.text = labelText
                                    label.fontColor = SKColor.init(red:labelColor.red, green: labelColor.green, blue: labelColor.blue, alpha: labelColor.alpha)
                                    label.run(flipLastHalfPart)
                                }
                            }
                        }
                        else if self.isAvailable(Row: row, Col: col, isWhite: isWhite){
                            label.text = "+"
                            label.isHidden = true
                            labelColor = isWhite ? (1, 1, 1, 1) : (0, 0, 0, 1)
                            label.run(flipWait){
                                label.isHidden = false
                                label.fontColor = SKColor.init(red:labelColor.red, green: labelColor.green, blue: labelColor.blue, alpha: labelColor.alpha)
                                action()
                            }
                        }
                        else {
                            label.text = ""
                        }
                    }
                }
                
                gameScene.run(SKAction.wait(forDuration: 0.6)){gameScene.isUserInteractionEnabled = true}
            }
        }
//without animation
        else{
            for row in 0...5{
                if labels[row].count != 6 {fatalError("wrong columns of labels")}
                for col in 0...5{
                    let label = labels[row][col]
                    if let number = self.getNumber(Row: row, Col: col){
                        if "\(number)" != label.text{
                            label.text = "\(number)"
                            label.fontColor = self.getColor(Row: row, Col: col)! ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        }
                    }
                    else if self.isAvailable(Row: row, Col: col, isWhite: isWhite){
                        label.text = "+"
                        label.fontColor = isWhite ? UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        
                    }
                    else {
                        label.text = ""
                    }
                }
            }
        }
    
//ScoreLabel
        whiteScoreLabel.text = "\(self.whiteScore)"
        blackScoreLabel.text = "\(self.blackScore)"
//TODO:stateIndicator
        if self.isEnd(){
            
            //show crown
            var isWinnerWhite: Bool? = self.getWhiteScore() > self.getBlackScore()  ? true : false
            if self.getWhiteScore() == self.getBlackScore(){
                isWinnerWhite = nil
            }
            
            if let isWinnerWhite = isWinnerWhite{
                
                let stateIndicatorSize =
                    CGSize(width: width / 2.5, height: height / 4)
                
                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "crown"), size: stateIndicatorSize)
                stateIndicatorColorLeft.color = isWinnerWhite ? UIColor.white : UIColor.black
                stateIndicatorColorRight.color = isWinnerWhite ? UIColor.white : UIColor.black
            }
                //If the state is draw.
            else {
                let stateIndicatorSize =
                    CGSize(width: width / 2.5, height: height / 4)
                stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "scale"), size: stateIndicatorSize)
                stateIndicatorColorLeft.color = UIColor.white
                stateIndicatorColorRight.color = UIColor.black
            }
        }
        else{
            let stateIndicatorSize =
                CGSize(width: width / 6.0, height: height / 6.0)
            stateIndicator.maskNode = SKSpriteNode(texture: SKTexture(imageNamed: "upArrow"), size: stateIndicatorSize)
            let color = isColorWhiteNow ? UIColor.white : UIColor.black
            stateIndicatorColorLeft.color = color
            stateIndicatorColorRight.color = color
        }
    }
    func showBoard(isWhite: Bool)
    {
        print("")
        for i in 0...5 {print("  \(i)", terminator:"")}
        print("")
        for row in 0...5
        {
            print("\(row)|", terminator:"")
            for col in 0...5
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
    func isAvailable(toward Direction: Int = 8, Row: Int, Col: Int, isWhite: Bool) -> Bool
    {
        if Row < 0 || Row > 5 || Col < 0 || Col > 5 {return false}
        //if there's already something at (Row, Col), then you cannot put anything on it.
        if let _ = gameBoard[Row][Col] {return false}
        switch Direction {
        case right:
            if Col < 4 {
                if isColorWhite[Row][Col + 1] == !isWhite {
                    for j in 2...5 - Col {
                        if isColorWhite[Row][Col + j] == nil {return false}
                        if isColorWhite[Row][Col + j] == isWhite {return true}
                    }
                }
            }
        case rightUp:
            if Row > 1 && Col < 4 {
                if isColorWhite[Row - 1][Col + 1] == !isWhite {
                    for j in 2...min(Row, 5 - Col) {
                        if isColorWhite[Row - j][Col + j] == nil {return false}
                        if isColorWhite[Row - j][Col + j] == isWhite {return true}
                    }
                }
            }
        case up:
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
        case leftUp:
            if Row > 1 && Col > 1 {
                if isColorWhite[Row - 1][Col - 1] == !isWhite {
                    for j in 2...min(Row, Col) {
                        if isColorWhite[Row - j][Col - j] == nil {return false}
                        if isColorWhite[Row - j][Col - j] == isWhite {return true}
                    }
                }
            }
        case left:
            if Col > 1 {
                if isColorWhite[Row][Col - 1] == !isWhite {
                    for j in 2...Col {
                        if isColorWhite[Row][Col - j] == nil {return false}
                        if isColorWhite[Row][Col - j] == isWhite {return true}
                    }
                }
            }
        case leftDown:
            if Row < 4 && Col > 1 {
                if isColorWhite[Row + 1][Col - 1] == !isWhite {
                    for j in 2...min(5 - Row, Col){
                        if isColorWhite[Row + j][Col - j] == nil {return false}
                        if isColorWhite[Row + j][Col - j] == isWhite {return true}
                    }
                }
            }
        case down:
            if Row < 4 {
                if isColorWhite[Row + 1][Col] == !isWhite {
                    for i in 2...5 - Row {
                        if isColorWhite[Row + i][Col] == nil {return false}
                        if isColorWhite[Row + i][Col] == isWhite {return true}
                    }
                }
            }
        case rightDown:
            if Row < 4 && Col < 4 {
                if isColorWhite[Row + 1][Col + 1] == !isWhite {
                    for j in 2...min(5 - Row, 5 - Col) {
                        if isColorWhite[Row + j][Col + j] == nil {return false}
                        if isColorWhite[Row + j][Col + j] == isWhite {return true}
                    }
                }
            }
        default:
            for direction in 0...7{
                if(isAvailable(toward: direction, Row: Row, Col: Col, isWhite: isWhite))
                {return true}
            }
        }
        return false
    }
    //with availability checked
    mutating func fillColoredNumber(Row: Int, Col: Int, isWhite: Bool) -> Bool
    {
        if !isAvailable(Row: Row, Col: Col, isWhite: isWhite) {return false}
        isColorWhite[Row][Col] = isWhite
        //flip the known numbers
        //check all eight directions
        if isAvailable(toward: right, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...5 - Col {
                if isColorWhite[Row][Col + j] == isWhite {break}
                if isColorWhite[Row][Col + j] == !isWhite {
                    gameBoard[Row][Col + j]! += 1
                    isColorWhite[Row][Col + j] = isWhite
                }
            }
        }
        if isAvailable(toward: rightUp, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...min(Row, 5 - Col) {
                if isColorWhite[Row - j][Col + j] == isWhite {break}
                if isColorWhite[Row - j][Col + j] == !isWhite {
                    gameBoard[Row - j][Col + j]! += 1
                    isColorWhite[Row - j][Col + j] = isWhite
                }
            }
        }
        if isAvailable(toward: up, Row: Row, Col: Col, isWhite: isWhite){
            for i in 1...Row {
                if isColorWhite[Row - i][Col] == isWhite {break}
                if isColorWhite[Row - i][Col] == !isWhite {
                    gameBoard[Row - i][Col]! += 1
                    isColorWhite[Row - i][Col] = isWhite
                }
            }
        }
        if isAvailable(toward: leftUp, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...min(Row, Col) {
                if isColorWhite[Row - j][Col - j] == isWhite {break}
                if isColorWhite[Row - j][Col - j] == !isWhite {
                    gameBoard[Row - j][Col - j]! += 1
                    isColorWhite[Row - j][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: left, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...Col {
                if isColorWhite[Row][Col - j] == isWhite {break}
                if isColorWhite[Row][Col - j] == !isWhite {
                    gameBoard[Row][Col - j]! += 1
                    isColorWhite[Row][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: leftDown, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...min(5 - Row, Col){
                if isColorWhite[Row + j][Col - j] == isWhite {break}
                if isColorWhite[Row + j][Col - j] == !isWhite {
                    gameBoard[Row + j][Col - j]! += 1
                    isColorWhite[Row + j][Col - j] = isWhite
                }
            }
        }
        if isAvailable(toward: down, Row: Row, Col: Col, isWhite: isWhite){
            for i in 1...5 - Row {
                if isColorWhite[Row + i][Col] == isWhite {break}
                if isColorWhite[Row + i][Col] == !isWhite {
                    gameBoard[Row + i][Col]! += 1
                    isColorWhite[Row + i][Col] = isWhite
                }
            }
        }
        if isAvailable(toward: rightDown, Row: Row, Col: Col, isWhite: isWhite){
            for j in 1...min(5 - Row, 5 - Col) {
                if isColorWhite[Row + j][Col + j] == isWhite {break}
                if isColorWhite[Row + j][Col + j] == !isWhite {
                    gameBoard[Row + j][Col + j]! += 1
                    isColorWhite[Row + j][Col + j] = isWhite
                }
            }
        }
        gameBoard[Row][Col] = 0
        blackScore = 0
        whiteScore = 0
        for i in 0...5
        {
            for j in 0...5
            {
                if isColorWhite[i][j] == true {whiteScore += gameBoard[i][j]!}
                else if isColorWhite[i][j] == false {blackScore += gameBoard[i][j]!}
            }
        }
        return true
    }
    func needToPass(Color: Bool) -> Bool
    {
        for i in 0...5
        {
            for j in 0...5
            {
                if (self.isAvailable(Row: i, Col: j, isWhite: Color)) {return false}
            }
        }
        return true
    }
    func availableSteps(isWhite: Bool) -> [(row: Int, col: Int)]{
        var answer = [(row: Int, col: Int)]()
        for row in 0...5{
            for col in 0...5{
                if isAvailable(Row: row, Col: col, isWhite: isWhite){
                    answer.append((row,col))
                }
            }
        }
        return answer
    }
    func getChessBoardPositions(isWhite: Bool) -> [chessBoardPos]{
        var answer: [chessBoardPos] = []
        for row in 0...5{
            for col in 0...5{
                if getColor(Row: row, Col: col) == isWhite{
                    answer.append(chessBoardPos(row: row, col: col))
                }
            }
        }
        return answer
    }
    //check if the game is end
    func isEnd() -> Bool
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
    mutating func play(Row row: Int, Col col: Int, isColorWhiteNow:
        Bool){
        if !Array(0...5).contains(where: {$0 == row || $0 == col}){fatalError("wrong row or column")}
        if self.fillColoredNumber(Row: row, Col: col, isWhite: isColorWhiteNow){
            self.isColorWhiteNow = !self.isColorWhiteNow
            turn += 1
        }
        else {
            //shake!!
            //print("Unavailable move at \(row), \(col)")
        }
        
        if self.isEnd(){
            
        }
        else if self.needToPass(Color: isColorWhiteNow){
            //print("\(isColorWhiteNowOut ? "White" : "Black") cannot move")
            self.isColorWhiteNow = !self.isColorWhiteNow
        }
    }
    func allStepScores(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
        
        var stepScore = Dictionary<chessBoardPos, Int>()
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col, isColorWhiteNow: isWhite)
            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: isWhite)
        }
        
        return stepScore.count == 0 ? nil : stepScore
    }
    func allStepScoresDifference(isWhite: Bool) -> Dictionary<chessBoardPos, Int>?{
        
        var stepScore = Dictionary<chessBoardPos, Int>()
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col, isColorWhiteNow: isWhite)
            
            stepScore[chessBoardPos((row: availableStep.row, col: availableStep.col))] = testGame.getScore(isWhite: true) - testGame.getScore(isWhite: false)
        }
        return stepScore.count == 0 ? nil : stepScore
    }
    //find a best solution in 3 steps with random solution
    func evaluation() -> Double{
        
        let scoreDifference = getScoreDifference(isWhite: isColorWhiteNow)
        let chessBoardPositions = Set(getChessBoardPositions(isWhite: isColorWhiteNow))
        
        let turnWeight = 1.0 + Double(turn) / 32.0
        /*switch turn {
        case 0...10:
            turnWeight = 1
        case 11...20:
            turnWeight = 2
        case 21...32:
            turnWeight = 3
        default:
            turnWeight = 4
        }*/

        
        let scoreDifferenceWeight = 1
        let sideWeight = 5 * turnWeight
        let CWeight = 10 * turnWeight
        let XWeight = 20 * turnWeight
        let cornerWeight = 50 * turnWeight
       
        let weightedScoreDifference: Double = Double(scoreDifferenceWeight * scoreDifference)
        
        
        let weightedCSquaresScore = CWeight * Double(Set(CSquares).intersection(chessBoardPositions).count)
        let weightedXSquaresScore = XWeight * Double(Set(XSquares).intersection(chessBoardPositions).count)
        let weightedCornerSquaresScore = cornerWeight * Double(Set(cornerSquares).intersection(chessBoardPositions).count)
        let weightedSideSquaresScore = sideWeight * Double(Set(sideSquares).intersection(chessBoardPositions).count)
        let weightedPositionScore = weightedCSquaresScore +
                                    weightedXSquaresScore +
                                    weightedCornerSquaresScore +
                                    weightedSideSquaresScore
        let score = weightedScoreDifference + weightedPositionScore
        return score
    }
    func bestSolution(isWhite: Bool, searchDepth: UInt = 1) -> chessBoardPos?{
        let date = Date()
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: date)
        let nanoseconds = calendar.component(.nanosecond, from: date)
        print("seconds before find:", Double(nanoseconds) / 1000000000.0 + Double(seconds))
        var firstStepGames: [Reversi] = []
        var firstSteps: [chessBoardPos] = []
        //add all first steps to nodesToVist
        for availableStep in self.availableSteps(isWhite: isWhite){
            var testGame = self
            testGame.play(Row: availableStep.row, Col: availableStep.col, isColorWhiteNow: isWhite)
            firstStepGames.append(testGame)
            firstSteps.append(chessBoardPos(availableStep))
            
        }
        var firstStepMinLastScore = Dictionary<chessBoardPos, Double>()

        for i in 0...firstStepGames.count - 1 {
///for fixed fistStepGame
            var minLastScore = Double(Int.max)
            var nodesToVist: [Reversi] = []
            for availableStep in firstStepGames[i].availableSteps(isWhite: firstStepGames[i].isColorWhiteNow){
                var testGame = firstStepGames[i]
                testGame.play(Row: availableStep.row, Col: availableStep.col, isColorWhiteNow: firstStepGames[i].isColorWhiteNow)
                nodesToVist.append(testGame)
            }
            while !nodesToVist.isEmpty{
                let currentNode = nodesToVist.removeFirst()
                if currentNode.turn - self.turn < searchDepth{
                    for availableStep in currentNode.availableSteps(isWhite: currentNode.isColorWhiteNow){
                        var testGame = currentNode
                        testGame.play(Row: availableStep.row, Col: availableStep.col, isColorWhiteNow: testGame.isColorWhiteNow)
                            nodesToVist.insert(testGame, at: 0)
                    }
                }
                else{
                    let currentEvaluation = currentNode.evaluation()
                    if currentEvaluation < Double(minLastScore){
                        minLastScore = currentEvaluation
                    }
                }
            }

            firstStepMinLastScore[firstSteps[i]] = minLastScore
///for fixed fistStepGame
        }
        let max = firstStepMinLastScore.values.max()
        let date1 = Date()
        let calendar1 = Calendar.current
        let seconds1 = calendar1.component(.second, from: date1)
        let nanoseconds1 = calendar1.component(.nanosecond, from: date1)
        print("seconds after find:", Double(nanoseconds1) / 1000000000.0 + Double(seconds1))
        return firstStepMinLastScore.filter({$0.value == max}).keys.randomElement()
    }
}

