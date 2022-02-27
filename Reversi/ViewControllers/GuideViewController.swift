//
//  GuideViewController.swift
//  Reversi
//
//  Created by john gospai on 2019/9/10.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit

class GuideView: UIImageView{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return path?.contains(point) ?? true
    }
    var path: CGPath? = nil
    fileprivate func guideImage() -> UIImage{
        self.backgroundColor = .clear
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6008133562).cgColor)
        if let path = path{
            ctx?.addPath(path)
        }
        ctx?.addPath(UIBezierPath(rect: self.bounds).cgPath)
        ctx?.fillPath(using: .evenOdd)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func setGuide(guide: GuideViewController.guide){
        func SKtoUI(_ SK: CGPoint) -> CGPoint{
            let x = SK.x + UI.frameWidth/2
            let y = -SK.y + UI.frameHeight/2
            return CGPoint(x: x, y: y)
        }
        switch guide {
        case .title(.welcome):
            path = nil
        case .title(.hint):
            let helpNodeSize = UI.menuIconSize
            let helpNodeOrigin = SKtoUI(UI.getMenuIconPosition(indexFromLeft: 1, numberOfMenuIcon: 4)) - CGPoint(x: helpNodeSize.width/2, y: helpNodeSize.height/2)
            let bounds = CGRect(origin: helpNodeOrigin, size: helpNodeSize)
            path = UIBezierPath(ovalIn: bounds).cgPath
        //TODO: implement
        case .title(.help):
            path = nil
        case .title(.logo):
            path = UIBezierPath(rect: CGRect(origin: SKtoUI(UI.logoSwitch.frame.origin), size: UI.logoSwitch.frame.size)).cgPath
        case .title(.gameboardSwipe):
            let w = UI.gridSize
            let h = w
            let x = UI.frameWidth/2 - UI.gridSize/2
            let y = UI.frameHeight/2 - UI.gridSize/2
            let rect = CGRect(x: x, y: y, width: w, height: h)
            path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
        case .title(.gameboardTap):
            let w = UI.gridSize
            let h = w
            let x = UI.frameWidth/2 - UI.gridSize/2
            let y = UI.frameHeight/2 - UI.gridSize/2
            let rect = CGRect(x: x, y: y, width: w, height: h)
            path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
        default:
            path = nil
        }
        self.image = guideImage()
    }
}
class GuideViewController: UIViewController{
    weak var touchDelegate: UIResponder? = nil
    enum guide: Equatable, Hashable{
        case title(Title)
        case game(Game)
        enum Title: String{
            case welcome = "guide.welcome"
            case hint = "guide.hint"
            case help = "guide.help"
            case logo = "guide.logo"
            case gameboardSwipe = "guide.gameboard.swipe"
            case gameboardTap = "guide.gameboard.tap"
        }
        enum Game: String{
            case ability = "guide.ability"
            case undo = "guide.undo"
            case translate = "guide.translate"
        }
    }
    func setGuide(guide: GuideViewController.guide){
        if let view = view as! GuideView?{
            view.setGuide(guide: guide)
        }
    }
    func showGuide(animated: Bool, completion: (()-> Void)?){
        UI.topMostController()?.present(self, animated: animated, completion: completion)
    }
    override func loadView() {
        self.view = GuideView(frame: UIScreen.main.bounds)
        view.isUserInteractionEnabled = true
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        if !view.point(inside: touch.location(in: view), with: event) {return}
        touchDelegate?.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        if !view.point(inside: touch.location(in: view), with: event) {return}
        touchDelegate?.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        if !view.point(inside: touch.location(in: view), with: event) {return}
        touchDelegate?.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        if !view.point(inside: touch.location(in: view), with: event) {return}
        touchDelegate?.touchesCancelled(touches, with: event)
    }
}
