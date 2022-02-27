//
//  LogoSwitch.swift
//  Reversi
//
//  Created by john gospai on 2019/8/24.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
protocol logoSwitchDelegate: AnyObject {
    func touch(touches: Set<UITouch>)
}
extension LogoSwitch{
    override var frame: CGRect{
        let origin = position - CGPoint(x: UI.logoSize.width/2, y: UI.logoSize.height/2)
        return CGRect(origin: origin, size: UI.logoSize)
    }
}
class LogoSwitch: SKEffectNode{
    enum touchType: Int{
        case began = 0, moved, ended, cancelled
    }
    enum state: Int{
        case black = 0, half, white
    }
    var currentState = state.half{
        didSet{
            update()
        }
    }
    weak var delegate: logoSwitchDelegate?
    fileprivate var logoRightBlack: SKSpriteNode!
    fileprivate var logoLeftWhite: SKSpriteNode!
    convenience init(state: state) {
        self.init()
        currentState = state
        update()
    }
    override init() {
        super.init()
        //MARK: - set up logo
        let logoSize = UI.logoSize
        let logoImage = CIImage(image: #imageLiteral(resourceName: "Logo").resize(to: logoSize))!
        
        let maskFilter = CIFilter(name: "CISourceInCompositing", parameters: [kCIInputBackgroundImageKey : logoImage])
        self.filter = maskFilter
        self.position = UI.logoPosition
        self.zPosition = UI.zPosition.logo
        self.isUserInteractionEnabled = true
        //MARK: set up left-half white
        logoLeftWhite = SKSpriteNode(color: .white, size: CGSize())
        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentState.rawValue), height: logoSize.height)
        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
        logoLeftWhite.zPosition = 2
        self.addChild(logoLeftWhite)
        //MARK: set up right-half black
        //logoRightBlack = SKSpriteNode(color: .black, size: logoSize)
        logoRightBlack = SKSpriteNode(color: .black, size: logoSize)
        //logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
        //logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
        logoRightBlack.zPosition = 1
        self.addChild(logoRightBlack)
    }
    //FIXME: sometimes it crashes
    fileprivate func update(){
        let logoSize = UI.logoSize
        //MARK: set up left-half white
        logoLeftWhite.size = CGSize(width: logoSize.width/2 *  CGFloat(currentState.rawValue), height: logoSize.height)
        logoLeftWhite.position.x = -logoSize.width / 2 + logoLeftWhite.size.width/2
        //MARK: set up right-half black

        //logoRightBlack.position.x = logoLeftWhite.position.x + logoSize.width/2
        //logoRightBlack.size = CGSize(width: logoSize.width - logoLeftWhite.size.width, height: logoSize.height)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate var currentWhiteSwitchPosition = CGPoint.zero
    fileprivate var touchOrigin = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            currentWhiteSwitchPosition = logoLeftWhite.position
            touchOrigin = touch.location(in: self)
            everMoved = false
        }
        
        delegate?.touch(touches: touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let offset = pos.x - touchOrigin.x
            if abs(offset) > 10 {everMoved = true}
            logoLeftWhite.position.x = currentWhiteSwitchPosition.x + offset/2
            logoLeftWhite.position.x = min(max(logoLeftWhite.position.x,-frame.width/2),0)
            logoLeftWhite.size.width = (logoLeftWhite.position.x + frame.width/2)*2
            //logoRightBlack.position.x = logoLeftWhite.position.x + frame.width/2
            //logoRightBlack.size.width = frame.width - logoLeftWhite.size.width
        }
        
        delegate?.touch(touches: touches)
    }
//    override func contains(_ p: CGPoint) -> Bool {
//        return self.frame.contains(p)
//    }
    fileprivate var switchTouchCycle = 1
    fileprivate var everMoved = false
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let offset = pos.x - touchOrigin.x
            var state = floor(2 * logoLeftWhite.size.width / frame.width + 0.5)
            state = min(max(state,0),2)
            if abs(offset) < 10, !everMoved{
                switch state{
                case 0:
                    state = 1
                    switchTouchCycle = 1
                case 1:
                    state = CGFloat(2 * switchTouchCycle)
                    switchTouchCycle = 1 - switchTouchCycle
                case 2:
                    state = 1
                    switchTouchCycle = 0
                default:
                    break
                }
            }
            currentState = LogoSwitch.state(rawValue: Int(state))!
            logoLeftWhite.size.width = state * frame.width/2
            logoLeftWhite.position.x = -frame.width / 2 + logoLeftWhite.size.width/2
            //logoRightBlack.position.x = logoLeftWhite.position.x + frame.width/2
            //logoRightBlack.size.width = frame.width - logoLeftWhite.size.width
        }
        delegate?.touch(touches: touches)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
        delegate?.touch(touches: touches)
    }
}
