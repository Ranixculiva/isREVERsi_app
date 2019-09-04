//
//  SelectButtons.swift
//  Reversi
//
//  Created by john gospai on 2019/7/9.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

protocol FetchValueDelegate: AnyObject {
    func didFetchValue(value: Int, name: String?)
}
class SelectButtons: SKNode {
    weak var fetchValueDelegate: FetchValueDelegate? = nil
    var spacing: CGFloat = 0.0
    var leftButton: SKSpriteNode{
        willSet{
            leftButton.removeFromParent()
            leftButton.name = nil
        }
        didSet{
            self.leftButton.position.y = leftButton.frame.height*(leftButton.anchorPoint.y-0.5)
            self.leftButton.position.x = -spacing/2 - leftButton.frame.width*(1-leftButton.anchorPoint.x)
            leftButton.zPosition = 1
            leftButton.isUserInteractionEnabled = false
            leftButton.name = "leftButton"
            leftButton.removeFromParent()
            addChild(leftButton)
        }
    }
    var rightButton: SKSpriteNode{
        willSet{
            rightButton.removeFromParent()
            rightButton.name = nil
        }
        didSet{
            self.rightButton.position.y = rightButton.frame.height*(rightButton.anchorPoint.y-0.5)
            self.rightButton.position.x = spacing/2 + rightButton.frame.width*(rightButton.anchorPoint.x)
            rightButton.zPosition = 1
            rightButton.isUserInteractionEnabled = false
            rightButton.name = "rightButton"
            rightButton.removeFromParent()
            addChild(rightButton)
        }
    }
    var value: Int = 0{
        didSet{
            if !isCyclic{
                leftButton.isHidden = false
                rightButton.isHidden = false
                if value == lowerBound{
                    leftButton.isHidden = true
                }
                if value == upperBound{
                    rightButton.isHidden = true
                }
            }
        }
    }
    var isCyclic: Bool = true{
        didSet{
            if !isCyclic{
                leftButton.isHidden = false
                rightButton.isHidden = false
                if value == lowerBound{
                    leftButton.isHidden = true
                }
                if value == upperBound{
                    rightButton.isHidden = true
                }
            }
        }
    }
    var upperBound: Int = 1
    var lowerBound: Int = 0
    init(spacing: CGFloat, leftButton: SKSpriteNode, rightButton: SKSpriteNode, isCyclic: Bool = true, upperBound: Int, lowerBound: Int = 0) {
        self.spacing = spacing
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.isCyclic = isCyclic
        self.upperBound = upperBound
        self.lowerBound = lowerBound
        self.value = lowerBound
        super.init()
        
        self.isUserInteractionEnabled = true
        self.leftButton.position.y = leftButton.frame.height*(leftButton.anchorPoint.y-0.5)
        self.leftButton.position.x = -spacing/2 - leftButton.frame.width*(1-leftButton.anchorPoint.x)
        self.rightButton.position.y = rightButton.frame.height*(rightButton.anchorPoint.y-0.5)
        self.rightButton.position.x = spacing/2 + rightButton.frame.width*(rightButton.anchorPoint.x)
        leftButton.zPosition = 1
        rightButton.zPosition = 1
        leftButton.isUserInteractionEnabled = false
        rightButton.isUserInteractionEnabled = false
        leftButton.name = "leftButton"
        rightButton.name = "rightButton"
        if !isCyclic{
            leftButton.isHidden = true
        }
        
        leftButton.removeFromParent()
        addChild(leftButton)
        rightButton.removeFromParent()
        addChild(rightButton)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func increase(){
        if isCyclic || value + 1 <= upperBound{
            value += 1
            if value > upperBound{
                value -= upperBound - lowerBound + 1
            }
        }
        fetchValueDelegate?.didFetchValue(value: value, name: self.name)
        print("increased value = ", value)
    }
    fileprivate func decrease(){
        if isCyclic || value - 1 >= lowerBound{
            value -= 1
            if value < lowerBound{
                value += upperBound - lowerBound + 1
            }
        }
        fetchValueDelegate?.didFetchValue(value: value, name: self.name)
        print("decreased value = ", value)
    }
    fileprivate var originPos = CGPoint.zero
    fileprivate var moved = false
    fileprivate var lastTouchedNode: SKNode? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            originPos = touch.location(in: self)
            moved = false
            let node = atPoint(originPos)
            lastTouchedNode = node
            node.alpha = 0.5
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            if (pos - originPos).norm > 10{
                moved = true
                lastTouchedNode?.alpha = 1
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            lastTouchedNode?.alpha = 1
            if !moved{
                let node = atPoint(pos)
                switch node{
                case rightButton:
                    increase()
                case leftButton:
                    decrease()
                default:
                    break
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

