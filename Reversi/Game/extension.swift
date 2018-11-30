//
//  extraAction.swift
//  Reversi
//
//  Created by john gospai on 2018/11/14.
//  Copyright © 2018 john gospai. All rights reserved.
//

import SpriteKit

extension SKNode{
    func shake(duration: CGFloat, amplitudeX: CGFloat, numberOfShakes: Int, completion: @escaping () -> Void = {}){
        
        let period: CGFloat = CGFloat(duration) / CGFloat(numberOfShakes)
        let numberOfSamples: Int = 100
        var actionsArray:[SKAction] = []
        for t in 0...numberOfShakes * numberOfSamples {
            let moveToX = CGFloat(amplitudeX) * sin(CGFloat.pi * 2 * CGFloat(t) /  CGFloat(numberOfSamples)) + self.position.x
            let shakeAction = SKAction.moveTo(x: moveToX, duration: TimeInterval(period / CGFloat(numberOfSamples)))
            actionsArray.append(shakeAction)
        }
        
        let actionSeq = SKAction.sequence(actionsArray)
        self.run(actionSeq, completion: completion)
        
    }
}

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

