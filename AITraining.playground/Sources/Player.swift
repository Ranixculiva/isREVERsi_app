public struct Player: CustomStringConvertible{
    public init(name: String = "", searchDepth: UInt = 0, weights: [Weight] = [Weight()]) {
        self.name = name
        self.searchDepth = searchDepth
        self.weights = weights
    }
    public var description: String{
        var des = ""
        des += "name: \(name)\n"
        des += "searchDepth: \(searchDepth)\n"
        des += "weight: \(weights)"
        return des
    }
    
    public var name: String = ""
    public var searchDepth: UInt = 0
    public var weights = [Weight()]
    /**
     It will tell you the weight you should use in the current turn according to the given weights.
     Divide game into weights.count parts. For the first part, use weights[0], and for the second part use weight[1], and so on.
     - Parameters:
     - turn: the turn of the current game.
     - gameSize: aka. the 'n' in nxn reversi game.
     */
    public func weight(turn: Int, gameSize: Int) -> Weight{
        //It may be over or less, so this is just an estimation.
        let maxTurn = gameSize * gameSize - 4
        //the number of parts that the game being divided into.
        let n = weights.count - 1
        var turnBeingCut = turn
        if turn / maxTurn > n {turnBeingCut = n}
        return weights[turnBeingCut / maxTurn]
    }
}

