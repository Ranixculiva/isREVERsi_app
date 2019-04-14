//
//  Button.swift
//  Reversi
//
//  Created by john gospai on 2019/3/8.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode{
    var nodesTouched: [SKNode] {
        return [self, labelNode]
    }
    var buttonColor = SKColor.white{
        didSet{
            texture = buttonTexture()
            size = texture!.size()
        }
    }
    var cornerRadius = CGFloat(30.0){
        didSet{
            texture = buttonTexture()
            size = texture!.size()
        }
    }
    var text: String?{
        get{
            return labelNode.text
        }
        set(newText){
            labelNode.text = newText
            texture = buttonTexture()
            size = texture!.size()
        }
    }
    var fontSize: CGFloat {
        get{
            return labelNode.fontSize
        }
        set(newFontSize){
            labelNode.fontSize = newFontSize
            texture = buttonTexture()
            size = texture!.size()
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
            texture = buttonTexture()
            size = texture!.size()
        }
    }
    fileprivate var labelNode = SKLabelNode()
    convenience init?(buttonColor color: UIColor, cornerRadius: CGFloat){
        self.init(texture: SKTexture(), color:SKColor.clear, size: CGSize())
        self.buttonColor = color
        self.text = ""
        self.cornerRadius = cornerRadius
        self.texture = buttonTexture()
        self.size = (texture?.size())!
        
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 30.0
        labelNode.fontName = UI.buttonLabelFontName
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.zPosition = 1
        labelNode.isUserInteractionEnabled = false
        addChild(labelNode)
        
        
    }
    fileprivate func buttonTexture() -> SKTexture? {
        let size = CGSize(width: labelNode.frame.width + fontSize, height: labelNode.frame.height + fontSize * 20.0 / 30.0)
        labelNode.position.x = size.width/2
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        ///start to draw
        let buttonRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        context.addPath(buttonPath.cgPath)
        buttonColor.setFill()
        context.fillPath()
        ///end drawing
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: image!)
    }
}
