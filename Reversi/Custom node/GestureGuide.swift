//
//  GestureGuide.swift
//  Reversitest2
//
//  Created by john gospai on 2019/3/24.
//  Copyright © 2019 john gospai. All rights reserved.
//
////m
import SpriteKit

class GestureGuide: SKSpriteNode{
    deinit {
        print("guidegesture deinit")
    }
    var isOnTouch = false{didSet{update()}}
    var strokeWidth = UI.gestureGuideStrokeWidth {didSet {update()}}
    convenience init(color: UIColor, isOnTouch: Bool = false) {
        self.init()
        self.size = UI.gestureGuideSize
        self.color = color
        self.texture = gestureGuideTexture()
        self.isOnTouch = isOnTouch
    }
    func gestureGuideTexture(innerCircleRadiusRatio: CGFloat = 0.5) -> SKTexture{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let bounds = CGRect(x: strokeWidth/2, y: strokeWidth/2, width: size.width - strokeWidth, height: size.height - strokeWidth)
        context.setLineWidth(strokeWidth)
        color.setStroke()
        context.strokeEllipse(in: bounds)
        if !isOnTouch{
            //let innerBounds = CGRect(x: size.width/4 + strokeWidth/2, y: size.height/4 + strokeWidth/2, width: size.width/2 - strokeWidth, height: size.height/2 - strokeWidth)
            let innerBounds = CGRect(x: (size.width/2 - strokeWidth/2) * (1 - innerCircleRadiusRatio) + strokeWidth/2, y: (size.height/2 - strokeWidth/2) * (1 - innerCircleRadiusRatio) + strokeWidth/2, width: (size.width - strokeWidth) * innerCircleRadiusRatio, height: (size.height - strokeWidth) * innerCircleRadiusRatio)
            context.strokeEllipse(in: innerBounds)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: image)
    }
    func update(){
        self.texture = gestureGuideTexture()
    }
    func generateTouchDownAnimatedFrames(numberOfAtlas: Int = 5) -> [SKTexture]{
        var animatedFrames: [SKTexture] = []
        if numberOfAtlas > 0{
            for i in 1...numberOfAtlas{
                let innerCircleRadiusRatio = 0.2 + 0.8 * Double(i) / Double(numberOfAtlas)
                let animatedFrame = gestureGuideTexture(innerCircleRadiusRatio: CGFloat(innerCircleRadiusRatio))
                animatedFrames.append(animatedFrame)
            }
        }
        return animatedFrames
    }
    func generateTouchUpAnimatedFrames(numberOfAtlas: Int = 5) -> [SKTexture]{
        var animatedFrames: [SKTexture] = []
        if numberOfAtlas > 0{
            for i in 1...numberOfAtlas{
                let innerCircleRadiusRatio = 1 - 0.8 * Double(i) / Double(numberOfAtlas)
                let animatedFrame = gestureGuideTexture(innerCircleRadiusRatio: CGFloat(innerCircleRadiusRatio))
                animatedFrames.append(animatedFrame)
            }
        }
        return animatedFrames
    }
    func tapGuide(afterDelay: TimeInterval = 0.3,forDuration: TimeInterval = 0.6){
        removeAllActions()
        isOnTouch = false
        let touchDownAnimationFrames = generateTouchDownAnimatedFrames(numberOfAtlas: Int(forDuration/2 * 30))
        let touchUpAnimationFrames = generateTouchUpAnimatedFrames(numberOfAtlas: Int(forDuration/2 * 30))
        let tapAnimationFrames = touchDownAnimationFrames + touchUpAnimationFrames
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: afterDelay),
                SKAction.unhide(),
                SKAction.animate(with: tapAnimationFrames, timePerFrame: 1.0/30.0),
                SKAction.hide()])
        ))
    }
    func swipeGuide(by vector: CGVector, afterDelay: TimeInterval = 0.3, downForDuration: TimeInterval = 0.3, swipeSpeed: CGFloat = 2000, upForDuration: TimeInterval = 0.3){
        removeAllActions()
        let origin = position
        if swipeSpeed == 0 {return}
        let swipeForDuration = TimeInterval(sqrt(vector.dx*vector.dx + vector.dy*vector.dy)/swipeSpeed)
        let touchDownAnimationFrames = generateTouchDownAnimatedFrames(numberOfAtlas: Int(downForDuration * 30))
        let touchUpAnimationFrames = generateTouchUpAnimatedFrames(numberOfAtlas: Int(upForDuration * 30))
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: afterDelay),
            SKAction.unhide(),
            SKAction.animate(with: touchDownAnimationFrames, timePerFrame: 1.0/30.0),
            SKAction.move(by: vector, duration: swipeForDuration),
            SKAction.animate(with: touchUpAnimationFrames, timePerFrame: 1.0/30.0),
            SKAction.hide(),
            SKAction.run{self.position = origin}
            ])))
    }
    func holdGuide(afterDelay: TimeInterval = 0.3, downForDuration: TimeInterval = 0.5, holdForDuration: TimeInterval = 0.8){
        removeAllActions()
        isOnTouch = false
        let holdAnimationFrames = generateTouchDownAnimatedFrames(numberOfAtlas: Int(downForDuration * 30))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: afterDelay),
                SKAction.unhide(),
                SKAction.animate(with: holdAnimationFrames, timePerFrame: 1.0/30.0),
                SKAction.wait(forDuration: holdForDuration),
                SKAction.hide()])
        ))
    }
    func moveGuide(){
        removeAllActions()
    }
}

////m
