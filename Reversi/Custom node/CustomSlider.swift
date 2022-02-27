//
//  CustomSlider.swift
//  Reversi
//
//  Created by john gospai on 2019/1/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class CustomSlider: SKSpriteNode {
    
    enum touchState{
        case begin, move, end, cancel
    }
    var state: touchState? = nil
    fileprivate var originalPosition: CGFloat = 0.0
    fileprivate var originalValue: CGFloat = 0.0
    fileprivate var isActive: Bool = false
    var notificationName: String!
    var barColor: SKColor!
    var sliderColor: SKColor!
    var activeSliderColor: SKColor!
    var barLength: CGFloat!
    var barWidth: CGFloat!
    fileprivate var sliderPosition: CGFloat!
    fileprivate var storedValue: CGFloat!
    var count: Int!
    var value: CGFloat{
        get{
            return storedValue
        }
        set(newValue){
            var inValue = newValue
            if inValue < 0 {inValue = 0}
            else if inValue > CGFloat(count - 1) {inValue = CGFloat(count - 1)}
            storedValue = inValue
            var integerLength = (barLength + barWidth) / CGFloat(count)
            self.sliderPosition = CGFloat(inValue) * integerLength
            if integerLength < barWidth{
                integerLength = barWidth
                //since barLength > 0 and integerLength < barWidth, count - 1 > 0
                self.sliderPosition = CGFloat(inValue) * barLength/CGFloat(count - 1)
            }
            
            texture = drawSlider(isActive: isActive)
        
        }
    }
    /**
     - Parameters:
        - barLength: the length of the bar without the two rounded corners
     */
    convenience init?(notificationName: String, count: Int, barColor: SKColor, sliderColor: SKColor, activeSliderColor: SKColor, barLength: CGFloat, barWidth: CGFloat, sliderPosition: CGFloat = 0) {
        guard let texture = CustomSlider.sliderTexture(count: count, barColor: barColor, sliderColor: sliderColor, barLength: barLength, barWidth: barWidth) else {
            return nil
        }
        
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.count = count
        self.barColor = barColor
        self.sliderColor = sliderColor
        self.barLength = barLength
        self.barWidth = barWidth
        self.notificationName = notificationName
        self.activeSliderColor = activeSliderColor
        self.value = 0.0
        
        self.isUserInteractionEnabled = true
    }
    class func drawSlider(count: Int, barColor: SKColor, sliderColor: SKColor, barLength: CGFloat,barWidth: CGFloat, sliderPosition: CGFloat) -> SKTexture?{
        let size = CGSize(width: barLength + barWidth, height: barWidth)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let barRect = CGRect(x: 0, y: 0, width: barLength + barWidth, height: barWidth)
        let barPath = UIBezierPath(roundedRect: barRect, cornerRadius: barWidth)
        context.addPath(barPath.cgPath)
        barColor.setFill()
        context.fillPath()
        
        let integerLength = (barWidth + barLength) / CGFloat(count)
        let sliderRect = CGRect(x: sliderPosition, y: 0, width: max(integerLength,barWidth), height: barWidth)
        let sliderPath = UIBezierPath(roundedRect: sliderRect, cornerRadius: barWidth)
        context.addPath(sliderPath.cgPath)
        sliderColor.setFill()
        context.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: image!)
    }
    func drawSlider(isActive: Bool = false) -> SKTexture?{
        if isActive {
            return CustomSlider.drawSlider(count: count, barColor: barColor, sliderColor: activeSliderColor, barLength: barLength, barWidth: barWidth, sliderPosition: sliderPosition)
        }
        return CustomSlider.drawSlider(count: count, barColor: barColor, sliderColor: sliderColor, barLength: barLength, barWidth: barWidth, sliderPosition: sliderPosition)
    }
    class func sliderTexture(count: Int, barColor: SKColor, sliderColor: SKColor, barLength: CGFloat,barWidth: CGFloat) -> SKTexture? {
        
        //let integerLength = (barLength + barWidth) / CGFloat(count)
        return drawSlider(count: count, barColor: barColor, sliderColor: sliderColor, barLength: barLength, barWidth: barWidth, sliderPosition: 0)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            state = .begin
            //let integerLength = (barLength + barWidth) / CGFloat(count)
            isActive = true
            originalPosition = touch.location(in: self).x + size.width * 0.5
            //if not click on the slider, then...
            //if floor(value) != floor(originalPosition / integerLength){
            if floor(value) != floor(originalPosition*CGFloat(count)/(barLength + barWidth)){
                //value = originalPosition / integerLength - 0.5
                value = originalPosition*CGFloat(count)/(barLength + barWidth) - 0.5
            }
            //else {value = floor(originalPosition / integerLength)}
            else {value = floor(originalPosition*CGFloat(count)/(barLength + barWidth))}
            originalValue = value
            originalPosition = originalPosition - size.width * 0.5
            NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            state = .move
            let offset = touch.location(in: self).x - originalPosition

            //let integerLength = (barLength + barWidth) / CGFloat(count)

            //let valueOffset = offset / integerLength
            let valueOffset = offset*CGFloat(count)/(barLength + barWidth)
            value = originalValue + valueOffset

            NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            state = .end
            isActive = false
            //set value to the nearest integer.
            value = floor(value + 0.5)
            NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            state = .cancel
            isActive = false
            value = floor(value + 0.5)
            NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil)
        }
    }
}
