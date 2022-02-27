//
//  Player.swift
//  Reversi
//
//  Created by john gospai on 2018/12/21.
//  Copyright © 2018 john gospai. All rights reserved.
//

import Foundation
struct Player: CustomStringConvertible{
    var description: String{
        var des = ""
        des += "name: \(name)\n"
        des += "searchDepth: \(searchDepth)\n"
        des += "weight: \(weights)"
        return des
    }
    
    var name: String = ""
    var searchDepth: UInt = 1
    var weights = [Weight()]
    /**
     It will tell you the weight you should use in the current turn according to the given weights.
     Divide game into weights.count parts. For the first part, use weights[0], and for the second part use weight[1], and so on.
     - Parameters:
        - turn: the turn of the current game.
        - gameSize: aka. the 'n' in nxn reversi game.
     */
    func weight(turn: Int, gameSize: Int) -> Weight{
        //It may be over or less, so this is just an estimation.
        let maxTurn = gameSize * gameSize - 4
        //the number of parts that the game being divided into.
        let n = weights.count - 1
        var turnBeingCut = turn
        if turn / maxTurn > n {turnBeingCut = n}
        return weights[turnBeingCut / maxTurn]
    }
}
