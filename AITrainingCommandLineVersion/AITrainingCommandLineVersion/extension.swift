//
//  extraAction.swift
//  Reversi
//
//  Created by john gospai on 2018/11/14.
//  Copyright © 2018 john gospai. All rights reserved.
//

import SpriteKit

extension CGPoint{
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
    }
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x:lhs.x - rhs.x, y:lhs.y - rhs.y)
    }
    static func += ( lhs: inout CGPoint, rhs: CGPoint){
        return lhs = lhs + rhs
    }
}

public extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
