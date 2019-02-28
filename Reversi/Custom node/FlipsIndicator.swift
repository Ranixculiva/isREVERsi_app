//
//  FlipsIndicator.swift
//  Reversi
//
//  Created by john gospai on 2019/3/1.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class FlipsIndicator: SKSpriteNode {
    fileprivate var flipAnimation: SKAction{
        return SKAction.sequence([
            SKAction.scaleX(to: 0, duration: 0.4),
            SKAction.changeFontColor(to: flipsColor == .black ? .white : .black),
            SKAction.scaleX(to: 1, duration: 0.4),
            SKAction.scaleX(to: 0, duration: 0.4),
            SKAction.changeFontColor(to: flipsColor),
            SKAction.scaleX(to: 1, duration: 0.4),
            ])
    }
    var flips = 0{
        didSet{
            texture = flipsBackground(flips: flips)
            size = texture!.size()
        }
    }
    var withAnimation = true{
        didSet{
            if withAnimation == true{
                flipsLabel.run(SKAction.repeatForever(flipAnimation))
            }
            else {
                flipsLabel.removeAllActions()
                flipsLabel.xScale = 1
            }
        }
    }
    var flipsColor = UIColor.black{
        didSet{
            withAnimation = false
            flipsLabel.fontColor = flipsColor
        }
    }
    var flipsLabelPosition: CGPoint{
        return flipsLabel.position + position
    }
    var flipsSize: CGSize{
        return CGSize(width: flipsLabel.frame.height, height: flipsLabel.frame.height)
    }
    fileprivate var flipsLabel = SKLabelNode(text: "\(Unicode.circledNumber(1))")
    fileprivate var flipsNumberLabel = SKLabelNode()
    convenience init?(flips: Int) {
        self.init(texture: SKTexture(), color:SKColor.clear, size: CGSize())
        flipsLabel.verticalAlignmentMode = .center
        flipsLabel.fontColor = .black
        flipsLabel.fontName = "negative-circled-number"
        flipsLabel.fontSize = UI.flipsFontSize
        flipsLabel.zPosition = UI.zPosition.flips
        flipsLabel.removeFromParent()
        addChild(flipsLabel)
        
        flipsNumberLabel.text = "\(flips)"
        flipsNumberLabel.verticalAlignmentMode = .center
        flipsNumberLabel.horizontalAlignmentMode = .left
        flipsNumberLabel.fontColor = UIColor.black
        flipsNumberLabel.fontName = "chalkboard SE"
        flipsNumberLabel.fontSize = UI.flipsFontSize
        flipsNumberLabel.zPosition = UI.zPosition.flipNumber
        flipsNumberLabel.removeFromParent()
        addChild(flipsNumberLabel)
        
        guard let texture = flipsBackground(flips: flips) else {
            return nil
        }
        self.texture = texture
        self.size = texture.size()
        self.flips = flips
        flipsLabel.position.x = -texture.size().width/2 + flipsLabel.frame.height * 3/4
        flipsNumberLabel.position.x = flipsLabel.position.x + 10*UIScreen.main.scale + flipsLabel.frame.height/2
        if withAnimation{
            flipsLabel.run(SKAction.repeatForever(flipAnimation))
        }
        self.isUserInteractionEnabled = false
    }
    func flipsBackground(flips: Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        flipsNumberLabel.text = "\(flips)"
        let size = CGSize(width: flipsLabel.frame.height + flipsNumberLabel.frame.width + 10*UIScreen.main.scale + UI.flipsFontSize/2 , height: flipsLabel.frame.height)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Draw
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: UI.flipsFontSize/2)
        context.addPath(roundedRect.cgPath)
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).setFill()
        context.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        flipsLabel.position.x = -size.width/2 + flipsLabel.frame.height * 3/4
        flipsNumberLabel.position.x = flipsLabel.position.x + 10*UIScreen.main.scale + flipsLabel.frame.height/2
        return SKTexture(image: image!)
    }
}

