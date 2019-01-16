//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // draw stuff
        let rect = UIBezierPath(roundedRect: CGRect(x: 150, y: 150, width: 100, height: 100), cornerRadius: 5.0)
        UIColor.green.set()
        rect.fill()
    }
}

let containerView = CustomView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
containerView.backgroundColor = UIColor.blue

PlaygroundPage.current.liveView = containerView
