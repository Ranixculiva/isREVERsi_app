//
//  AboutOption.swift
//  Reversi
//
//  Created by john gospai on 2019/9/3.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
import WebKit

class AboutOption: Button{
    fileprivate var aboutWebPage: MessageViewController!
    weak var VCToPresentAboutWebPage: UIViewController? = nil
    convenience init(VCToPresentAboutWebPage: UIViewController? = nil) {
        self.init(buttonColor: UI.aboutButtonColor, cornerRadius: UI.aboutButtonCornerRadius, fontSize: UI.aboutButtonFontSize)!
        self.text = UI.Texts.about
        self.aboutWebPage = MessageViewController(title: UI.Texts.message.about.title, url: URL.html.about, actions: [MessageAction(title: UI.Texts.message.about.default, style: .default)])
        self.VCToPresentAboutWebPage = VCToPresentAboutWebPage
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
                VCToPresentAboutWebPage?.present(aboutWebPage, animated: true, completion: nil)
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


extension URL.html{
    static var about: URL?{
        return Bundle.main.url(forResource: "about", withExtension: "html")
    }
}
