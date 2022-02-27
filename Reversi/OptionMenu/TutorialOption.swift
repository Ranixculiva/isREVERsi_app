//
//  TutorialOption.swift
//  Reversi
//
//  Created by john gospai on 2019/10/6.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class TutorialOption: Button {
    fileprivate let tutorialText = UI.Texts.tutorial
    fileprivate let onText = UI.Texts.on
    fileprivate let offText = UI.Texts.off
    convenience init() {
        self.init(buttonColor: UI.tutorialButtonColor, cornerRadius: UI.tutorialButtonCornerRadius, fontSize: UI.tutorialButtonFontSize)!
        self.text = SharedVariable.needToGuide ? onText : offText
        //MARK: set up tutorial label
        let tutorialLabel = SKLabelNode(text: tutorialText)
        tutorialLabel.fontColor = UI.tutorialOptionFontColor
        tutorialLabel.fontSize = UI.tutorialOptionFontSize
        tutorialLabel.fontName = UI.tutorialOptionFontName
        addChild(tutorialLabel)
        tutorialLabel.horizontalAlignmentMode = .left
        tutorialLabel.verticalAlignmentMode = .center
        
        
        self.position.x = tutorialLabel.frame.width/2
        tutorialLabel.position.x = -(UI.gridSize - UI.optionMenuSpacing*2 - tutorialLabel.frame.width)/2 - tutorialLabel.frame.width
        
        
            //(UI.gridSize/2 - UI.optionMenuSpacing)/2 + (-UI.gridSize/2 + UI.optionMenuSpacing + tutorialLabel.frame.width)/2
        
        
        self.isUserInteractionEnabled = true
    }
    
    
    fileprivate var origin = CGPoint.zero
    fileprivate var hasMoved = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            origin = touch.location(in: self)
            hasMoved = false
            if contains(origin){
                self.fontColor = self.fontColor?.withAlphaComponent(0.5)
            }
            else{
                self.fontColor = self.fontColor?.withAlphaComponent(1)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            if (pos - origin).norm > 10{
                hasMoved = true
            }
            if contains(pos){
                self.fontColor = self.fontColor?.withAlphaComponent(0.5)
            }
            else{
                self.fontColor = self.fontColor?.withAlphaComponent(1)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            if !hasMoved, contains(pos){
                SharedVariable.needToGuide = !SharedVariable.needToGuide
                text = SharedVariable.needToGuide ? onText : offText
            }
            self.fontColor = self.fontColor?.withAlphaComponent(1)
            
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    override func contains(_ p: CGPoint) -> Bool {
        var buttonRect = self.frame
        buttonRect.origin = CGPoint(x: -buttonRect.width/2, y: -buttonRect.height/2)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        return buttonPath.contains(p)
    }
}
