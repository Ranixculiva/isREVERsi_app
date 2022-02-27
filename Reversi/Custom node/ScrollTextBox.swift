//
//  ScrollText.swift
//  Reversitest2
//
//  Created by john gospai on 2019/3/27.
//  Copyright © 2019 john gospai. All rights reserved.
//
////m
import SpriteKit
class ScrollTextBox: SKSpriteNode {
    var text = ""{
        didSet{
            self.textNode.text = text
            setUpScrollBar()
        }
    }
    var insets = UI.scrollTextInsets{
        didSet{
            self.textNode.labelWidth = labelWidth
            textNode.position.x = -size.width/2 + insets.left
            textNode.position.y = size.height/2 - insets.top
            let maskWidth = max(0, size.width - insets.right - insets.left)
            let maskHeight = max(0, size.height - insets.top - insets.bottom)
            self.mask.maskNode = SKSpriteNode(color: .white, size: CGSize(width: maskWidth, height: maskHeight))
        }
    }
    override var size: CGSize{
        didSet{
            if self.textNode.labelWidth != labelWidth{
                self.textNode.labelWidth = labelWidth
            }
            
            let maskWidth = max(0, size.width - insets.right - insets.left)
            let maskHeight = max(0, size.height - insets.top - insets.bottom)
            self.mask.maskNode = SKSpriteNode(color: .white, size: CGSize(width: maskWidth, height: maskHeight))
            self.texture = scrollTextTexture()
            let anchorPointDiff = CGPoint(x: 0.5, y: 0.5) - anchorPoint
            let offset = CGPoint(x: anchorPointDiff.x * frame.width, y: anchorPointDiff.y * frame.height)
            mask.position = offset
            textNode.position.x = -mask.frame.width/2
            textNode.position.y = mask.frame.height/2
            setUpScrollBar()
            
            //            scrollBar.position.x = (mask.frame.maxX + frame.width*anchorPoint.x)/2
            //            scrollBar.position.y = textNode.position.y
            //            scrollBar.position += offset
        }
    }
    var cornerRadius = UI.scrollTextCornerRadius{
        didSet{
            self.texture = scrollTextTexture()
        }
    }//TODO: not test yet
    var fontSize = UI.scrollTextFontSize{
        didSet{
            self.textNode.fontSize = fontSize
            setUpScrollBar()
        }
    }
    var fontColor = UI.scrollTextFontColor{
        didSet{
            self.textNode.fontColor = fontColor
        }
    }
    fileprivate var labelWidth: CGFloat{
        return size.width - insets.left - insets.right
    }
    override var anchorPoint: CGPoint{
        didSet{
            let anchorPointDiff = CGPoint(x: 0.5, y: 0.5) - anchorPoint
            let offset = CGPoint(x: anchorPointDiff.x * frame.width, y: anchorPointDiff.y * frame.height)
            mask.position = offset
            scrollBar.position.x = (mask.frame.maxX + frame.width*anchorPoint.x)/2
            scrollBar.position.y = textNode.position.y
            scrollBar.position += offset
        }
    }
    fileprivate var mask = SKCropNode()
    fileprivate var textNode = SKMultilineLabel(text: "", labelWidth: UI.scrollTextSize.width - UI.scrollTextInsets.left - UI.scrollTextInsets.right)
    fileprivate var scrollBar = SKSpriteNode()
    convenience init(text: String, insets: (top: CGFloat, bottom: CGFloat, right: CGFloat, left: CGFloat) = UI.scrollTextInsets, size: CGSize = UI.scrollTextSize, cornerRadius: CGFloat = UI.scrollTextCornerRadius, fontSize: CGFloat = UI.scrollTextFontSize, fontColor: UIColor = UI.scrollTextFontColor, color: UIColor = UI.scrollTextColor) {
        self.init(texture: SKTexture(), color: UIColor.clear, size: size)
        self.isUserInteractionEnabled = true
        let maskWidth = max(0, size.width - insets.right - insets.left)
        let maskHeight = max(0, size.height - insets.top - insets.bottom)
        mask.maskNode = SKSpriteNode(color: .white, size: CGSize(width: maskWidth, height: maskHeight))
        mask.zPosition = 10
        if mask.parent == nil {addChild(mask)}
        textNode.zPosition = UI.zPosition.croppedNode
        textNode.anchorPoint.x = 0
        textNode.position.x = -size.width/2 + insets.left
        textNode.position.y = size.height/2 - insets.top
        textNode.alignment = .left
        if textNode.parent == nil {mask.addChild(textNode)}
        self.color = color
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor
        //set up textNode
        self.textNode.dontUpdate = true
        self.textNode.fontSize = fontSize
        self.textNode.fontColor = fontColor
        self.textNode.labelWidth = labelWidth
        self.textNode.dontUpdate = false
        self.textNode.text = text
        //set up scrollBar
        setUpScrollBar()
        if scrollBar.parent == nil {addChild(scrollBar)}
        
        self.cornerRadius = cornerRadius
        self.texture = scrollTextTexture()
    }
    fileprivate func setUpScrollBar(){
        scrollBar.texture = scrollBarTexture()
        scrollBar.size = (scrollBar.texture?.size())!
        scrollBar.anchorPoint = CGPoint(x: 0.5, y: 1)
        scrollBar.position.x = (mask.frame.maxX + frame.width*anchorPoint.x)/2
        scrollBar.position.y = textNode.position.y// - 600
        let anchorPointDiff = CGPoint(x: 0.5, y: 0.5) - anchorPoint
        let offset = CGPoint(x: anchorPointDiff.x * frame.width, y: anchorPointDiff.y * frame.height)
        scrollBar.position += offset
        scrollBar.zPosition = 11
        scrollBar.isHidden = true
        
    }
    fileprivate func scrollBarTexture() -> SKTexture{
        let barWidth = insets.right * 0.6
        var barHeight = mask.frame.height
        if textNode.frame.height > mask.frame.height, mask.frame.height > 0 {barHeight *= (mask.frame.height)/textNode.frame.height}
        UIGraphicsBeginImageContextWithOptions(CGSize(width: barWidth, height: barHeight), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let bounds = CGRect(x: 0, y: 0, width: barWidth, height: barHeight)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: barWidth/2)
        context.addPath(roundedRect.cgPath)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).setFill()
        context.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: image)
        
    }
    fileprivate func scrollTextTexture() -> SKTexture{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        context.addPath(roundedRect.cgPath)
        color.setFill()
        context.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: image)
    }
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var textNodeOrigin = CGFloat(0)
    fileprivate var scrollBarOrigin = CGFloat(0)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self)
        touchOrigin = pos
        if mask.frame.contains(pos){
            textNodeOrigin = textNode.position.y
            scrollBarOrigin = scrollBar.position.y
            scrollBar.isHidden = false
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self)
        if mask.frame.contains(touchOrigin){
            var offset = pos.y - touchOrigin.y
            if textNode.frame.height <= mask.frame.height {offset = 0}
            else if offset > textNode.frame.height - mask.frame.height{
                offset = textNode.frame.height - mask.frame.height
            }
            let textNodeYMin = size.height/2 - insets.top
            let textNodeYMax = textNodeYMin + textNode.frame.height - mask.frame.height
            
            textNode.position.y = max(textNodeYMin ,min(textNodeYMax, textNodeOrigin + offset))
            var offsetForBar = textNodeOrigin - textNode.position.y
            if textNode.frame.height > mask.frame.height {offsetForBar *= (mask.frame.height - scrollBar.frame.height)/(textNode.frame.height - mask.frame.height)}
            scrollBar.position.y = scrollBarOrigin + offsetForBar
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard let touch = touches.first else {return}
        scrollBar.isHidden = true
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
////m
