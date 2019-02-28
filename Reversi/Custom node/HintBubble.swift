//
//  hintBubble.swift
//  Reversi
//
//  Created by john gospai on 2019/2/1.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
/*
 addChild to the SKNode you want to attach to.
 */
/**
It will create a hint bubble and attach it to some SKNode.
 
 ### Usage Example: ###
 ````
 let nodeWithHint = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
 let BoundsOfHintBubble = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
 let hintBubble = hintBubble(bubbleColor: .white, bounds: BoundsOfHintBubble)!
 hintBubble.attachTo = nodeWithHint
 hintBubble.text = "hint"
 addChild(hintBubble)
 ````
 ## Important Notes ##
 */
class HintBubble: SKSpriteNode {
    var bubbleColor = SKColor.white
    var text: String?{
        get{
            return labelNode.text
        }
        set(newText){
            labelNode.text = newText
            texture = hintBubbleTexture(bubbleColor: bubbleColor)
            size = texture!.size()
            fitInBounds()
        }
    }
    /**
     This bounds is in the coordinate system of the parent of the attachTo.
     */
    var bounds: CGRect?
    var attachTo: (SKNode & attachable)?{
        didSet{
            fitInBounds()
        }
    }
    var fontSize: CGFloat {
        get{
            return labelNode.fontSize
        }
        set(newFontSize){
            labelNode.fontSize = newFontSize
            texture = hintBubbleTexture(bubbleColor: bubbleColor)
            size = texture!.size()
            fitInBounds()
        }
    }
    var fontColor: UIColor? {
        get{
            return labelNode.fontColor
        }
        set(newFontColor){
            labelNode.fontColor = newFontColor
        }
    }
    var fontName: String? {
        get{
            return labelNode.fontName
        }
        set(newFontName){
            labelNode.fontName = newFontName
            texture = hintBubbleTexture(bubbleColor: bubbleColor)
            size = texture!.size()
            fitInBounds()
        }
    }
    fileprivate var labelNode = SKLabelNode()
    fileprivate class AttachedNode: SKSpriteNode{
        
    }
    convenience init?(bubbleColor color: SKColor, bounds: CGRect? = nil) {
        self.init(texture: SKTexture(), color:SKColor.clear, size: CGSize())
        self.bounds = bounds
        self.bubbleColor = color
        self.text = ""
        
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 30.0
        labelNode.fontName = "Chalkboard SE"
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.zPosition = 1
        addChild(labelNode)
        
        self.isUserInteractionEnabled = false
    }
    fileprivate func hintBubbleTexture(bubbleColor: SKColor) -> SKTexture? {
        // Add fontSize for spacing from labelNode to the border of bubble, and 10.0 for the indicator.
        let size = CGSize(width: labelNode.frame.width + fontSize, height: labelNode.frame.height + fontSize * 20.0 / 30.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        ///start to draw
        let bubbleRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let bubblePath = UIBezierPath(roundedRect: bubbleRect, cornerRadius: fontSize)
        context.addPath(bubblePath.cgPath)
        bubbleColor.setFill()
        context.fillPath()
        ///end drawing
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    /**
     call this function to let the hint bubble fit in bounds.
     */
    fileprivate func fitInBounds(){
        guard let attachTo = attachTo, let bounds = bounds else {return}
        position.x = attachTo.frame.width * (0.5 - attachTo.anchorPoint.x) + attachTo.position.x
        position.y = (attachTo.frame.height * (1 - attachTo.anchorPoint.y) + size.height * 0.5) + 10.0 + attachTo.position.y
        let LeftXOfBounds = bounds.minX - bounds.width * 0.5
        let RightXOfBounds = bounds.minX + bounds.width * 0.5
        let UpYOfBounds = bounds.minY + bounds.height * 0.5

        if position.x - size.width * 0.5 < LeftXOfBounds{
            self.position.x = LeftXOfBounds + size.width * 0.5// - attachTo.position.x
        }
        else if position.x + size.width * 0.5 > RightXOfBounds{
            self.position.x = RightXOfBounds - size.width * 0.5// - attachTo.position.x
        }
        if position.y + size.height * 0.5 > UpYOfBounds{
            self.position.y = -(attachTo.frame.height * attachTo.anchorPoint.y + size.height * 0.5) - 10.0 + attachTo.position.y
        }
    }
}

