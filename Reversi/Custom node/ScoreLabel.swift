//
//  ScoreLabel.swift
//  Reversi
//
//  Created by john gospai on 2019/5/17.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKSpriteNode {
    
    var fontColor = UIColor.black
    var fontSize = CGFloat(12){
        didSet{
            update()
        }
    }
    var numberOfParts = Int(3)
    var currentNumber = Int(3)
    var score = Int(0){
        didSet{
            update()
        }
    }
    class func scoreLabelTexture(fontColor: UIColor, fontSize: CGFloat, numberOfParts: Int, currentNumber: Int, score: Int) -> SKTexture{
        
        let fontColorComponents = fontColor.rgba
        let R = fontColorComponents.red
        let G = fontColorComponents.green
        let B = fontColorComponents.blue
        let upperFontColor = UIColor(red: R, green: G, blue: B, alpha: 0.4)
        let attributes: [NSAttributedString.Key : Any] = [
            .baselineOffset: fontSize/4,
            .font: UIFont.init(name: UI.scoreFontName, size: fontSize)!,
            .foregroundColor: upperFontColor
        ]
        
        let myText = "\(score)"
        let attributedString = NSMutableAttributedString(string: myText, attributes: attributes)
        
        var stringRectSize = attributedString.size()
        stringRectSize.height = stringRectSize.height/2
        let upperRect = CGRect(x: 0, y: 0, width: stringRectSize.width, height: stringRectSize.height*(1-CGFloat(currentNumber)/CGFloat(numberOfParts)))
        let lowerRect = CGRect(x: 0, y: upperRect.maxY, width: stringRectSize.width, height: stringRectSize.height*(CGFloat(currentNumber)/CGFloat(numberOfParts)))
        UIGraphicsBeginImageContextWithOptions(stringRectSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        UIColor.red.setStroke()
        
        //MARK: draw the upper part.
        context.saveGState()
        UIBezierPath(rect: upperRect).addClip()
        
        let upperAttributedString = attributedString.copy() as! NSAttributedString
        upperAttributedString.draw(at: CGPoint(x: 0, y: -stringRectSize.height/2))
        context.restoreGState()
        context.saveGState()
        //MARK: draw the lower part.
        UIBezierPath(rect: lowerRect).addClip()
        attributedString.addAttribute(.foregroundColor, value: fontColor, range: NSRange(location: 0, length: attributedString.length))
        attributedString.draw(at: CGPoint(x: 0, y: -stringRectSize.height/2))
        context.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: resultImage)
        
        
    }
    convenience init(fontColor: UIColor, fontSize: CGFloat = UI.secondaryScoreFontSize,  numberOfParts: Int = 3, currentNumber: Int = 3, score: Int = 0) {
        let texture = ScoreLabel.scoreLabelTexture(fontColor: fontColor, fontSize: fontSize, numberOfParts: numberOfParts, currentNumber: currentNumber, score: score)
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.numberOfParts = numberOfParts
        self.currentNumber = currentNumber
        self.score = score
        
    }
    func update(){
        let texture = ScoreLabel.scoreLabelTexture(fontColor: fontColor, fontSize: fontSize, numberOfParts: numberOfParts, currentNumber: currentNumber, score: score)
        self.texture = texture
        self.size = texture.size()
    }
}

