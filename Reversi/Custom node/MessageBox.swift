//
//  MessageBox.swift
//  Reversitest2
//
//  Created by john gospai on 2019/3/27.
//  Copyright © 2019 john gospai. All rights reserved.
//
////m
import SpriteKit
class MessageBox: SKSpriteNode {
    deinit {
        print(title,"deinit")
    }
    var title: String = ""{
        didSet{
            titleNode.text = title
            setUpTextBox()
            setUpButtons()
        }
    }
    fileprivate var titleNode = SKLabelNode()
    var text = ""{
        didSet{
            textBoxWithoutScroll.removeFromParent()
            textBoxWithScroll.removeFromParent()
            if isWithScroll {
                addChild(textBoxWithScroll)
            }
            else {
                addChild(textBoxWithoutScroll)
            }
            setUpTextBox()
        }
    }
    //may have problem
    var isWithScroll = false{
        didSet{
            textBoxWithoutScroll.removeFromParent()
            textBoxWithScroll.removeFromParent()
            if isWithScroll {
                self.size = UI.messageBoxSize
                addChild(textBoxWithScroll)
            }
            else {
                addChild(textBoxWithoutScroll)
            }
            if !withoutUpdateText{
                setUpTextBox()
                setUpButtons()
            }
        }
    }
    fileprivate var withoutUpdateText = false
    var textBoxWithScroll: ScrollTextBox!{
        didSet{
            withoutUpdateText = true
            text = textBoxWithScroll.text
            withoutUpdateText = false
        }
    }
    var textBoxWithoutScroll: SKMultilineLabel!{
        didSet{
            withoutUpdateText = true
            text = textBoxWithoutScroll.text
            withoutUpdateText = false
        }
    }
    var actions: [MessageAction] = []{
        didSet{
            setUpButtons()
        }
    }
    //weak var action: MessageAction? = nil
    fileprivate var textBoxSize: CGSize = UI.scrollTextSize{
        didSet{
            textBoxWithScroll.size = textBoxSize
            
        }
    }
    fileprivate var messageBoxBackground: SKSpriteNode!
    fileprivate var grayButtonLayer: SKSpriteNode!
    
    convenience init(title: String = "", text: String, size: CGSize = UI.messageBoxSize, color: UIColor = UI.messageBoxColor, actions: [MessageAction] = [], isWithScroll: Bool = false) {
        self.init()
        self.textBoxWithScroll = ScrollTextBox(text: "")
        self.textBoxWithoutScroll = SKMultilineLabel(text: "", labelWidth: UI.messageBoxLabelWidth)
        self.isWithScroll = isWithScroll
        self.zPosition = UI.zPosition.messageBox
        self.size = isWithScroll ? UI.messageBoxSize : size
        self.isUserInteractionEnabled = true
        self.color = color
        self.title = title
        if titleNode.parent == nil {addChild(titleNode)}
        titleNode.text = title
        titleNode.zPosition = 1
        titleNode.verticalAlignmentMode = .top
        titleNode.horizontalAlignmentMode = .center
        titleNode.position.y = frame.maxY - UI.messageBoxCornerRadius
        titleNode.fontName = UI.messageBoxTitleFontName
        titleNode.fontSize = UI.messageBoxTitleFontSize
        self.text = text
        setUpTextBox()
        self.texture = messageBoxTexture()
        self.actions = actions
        setUpButtons()
        //MARK: set up grayButtonLayer
        grayButtonLayer = SKSpriteNode()
        grayButtonLayer.zPosition = 2
        grayButtonLayer.isHidden = true
        if grayButtonLayer.parent == nil {addChild(grayButtonLayer)}
        
        //MARK: messageBoxBackground
        messageBoxBackground = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7), size: UI.rootSize)
        if messageBoxBackground.parent == nil {addChild(messageBoxBackground)}
        messageBoxBackground.zPosition = -1
        
    }
    fileprivate func grayOutTheButton(index: Int){
        
        let buttonCount = actionButtons.count
        if buttonCount == 0 || index > buttonCount || index < 0{return}
        grayButtonLayer.isHidden = false
        let maxButtonHeight = actionButtons.map{$0.frame.height}.max() ?? 0
        let height = maxButtonHeight + UI.messageBoxCornerRadius*2
        let width = isButtonDistributedVertically ? size.width : size.width/CGFloat(buttonCount)
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context = UIGraphicsGetCurrentContext()!
        let clipBoundsX = isButtonDistributedVertically ? 0 : -width*CGFloat(index)
        let clipBoundsY = isButtonDistributedVertically ? -size.height + height*CGFloat(buttonCount - index) : -size.height + height
        let clipBounds = CGRect(x: clipBoundsX, y: clipBoundsY, width: size.width, height: size.height)
        let roundedRect = UIBezierPath(roundedRect: clipBounds, cornerRadius: UI.messageBoxCornerRadius)
        
        context.saveGState()
        roundedRect.addClip()
        
        let buttonRect = CGRect(x: 0, y: 0, width: width, height: height)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).setFill()
        context.fill(buttonRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        context.restoreGState()
        UIGraphicsEndImageContext()
        grayButtonLayer.texture = SKTexture(image: image)
        grayButtonLayer.size = grayButtonLayer.texture!.size()
        grayButtonLayer.position.x = isButtonDistributedVertically ? 0 : frame.minX + width*(CGFloat(index)+0.5)
        grayButtonLayer.position.y = isButtonDistributedVertically ? frame.minY + height*(CGFloat(buttonCount-1 - index)+0.5) : frame.minY + 0.5*height
    }
    fileprivate func ungrayTheButton(){
        grayButtonLayer.isHidden = true
    }
    fileprivate func setUpTextBox(){
        if isWithScroll{
            textBoxWithScroll.fontSize = UI.scrollTextFontSize
            textBoxWithScroll.fontColor = UI.scrollTextFontColor
            
            textBoxWithScroll.zPosition = 1
            textBoxWithScroll.anchorPoint.y = 1
            textBoxWithScroll.position.y = size.height/2 - UI.messageBoxCornerRadius*(titleNode.frame.height == 0 ? 1 : 2) - titleNode.frame.height
            textBoxWithScroll.text = text
            if textBoxWithScroll.parent == nil{addChild(textBoxWithScroll)}
        }
            //TODO: adjust height
        else {
            textBoxWithoutScroll.dontUpdate = true
            textBoxWithoutScroll.alignment = .left
            textBoxWithoutScroll.fontSize = UI.scrollTextFontSize
            textBoxWithoutScroll.fontColor = UI.scrollTextFontColor
            textBoxWithoutScroll.dontUpdate = false
            textBoxWithoutScroll.text = text
            
            textBoxWithoutScroll.zPosition = 1
            textBoxWithoutScroll.position.y = size.height/2 - UI.messageBoxCornerRadius
            if textBoxWithoutScroll.parent == nil{addChild(textBoxWithoutScroll)}
        }
    }
    fileprivate func messageBoxTexture() -> SKTexture{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: UI.messageBoxCornerRadius)
        context.saveGState()
        roundedRect.addClip()
        //MARK: -draw gradient color
        let bgColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bgStartColor = UIColor(red: 122/255, green: 198/255, blue: 239/255, alpha: 1)
        
        let bgMidColor = UIColor(red: 222/510, green: 348/510, blue: 499/510, alpha: 1)
        
        let bgEndColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
        
        let bgColors = [bgStartColor.cgColor, bgMidColor.cgColor, bgEndColor.cgColor] as CFArray
        
        let maxButtonHeight = actionButtons.map{$0.frame.height}.max() ?? 0
        var bgColorsMidLocations = CGFloat(0.2)
        if !actionButtons.isEmpty {
            if isButtonDistributedVertically{
                bgColorsMidLocations = (maxButtonHeight + 2*UI.messageBoxCornerRadius)*CGFloat(actionButtons.count)/size.height
            }
            else{
                bgColorsMidLocations = (maxButtonHeight + 2*UI.messageBoxCornerRadius)/size.height
            }
        }
        let bgColorsLocations: [CGFloat] = [0.0, bgColorsMidLocations, 1.0]
        
        guard let bgGradient = CGGradient(colorsSpace: bgColorSpace, colors: bgColors, locations: bgColorsLocations) else {fatalError("cannot set up background gradient.")}
        context.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: 0, y: 0), options: .drawsAfterEndLocation)
        //draw button lines
        var lineSegmentEndPoints: [CGPoint] = []
        if !actionButtons.isEmpty{
            if isButtonDistributedVertically{
                for i in 1...actionButtons.count{
                    let y = size.height - (UI.messageBoxCornerRadius*2+maxButtonHeight)*CGFloat(i)
                    lineSegmentEndPoints.append(CGPoint(x: 0, y: y))
                    lineSegmentEndPoints.append(CGPoint(x: size.width, y: y))
                }
            }
            else{
                //the horizontal line
                let y = size.height - (UI.messageBoxCornerRadius*2+maxButtonHeight)
                lineSegmentEndPoints.append(CGPoint(x: 0, y: y))
                lineSegmentEndPoints.append(CGPoint(x: size.width, y: y))
                //vertical lines
                if actionButtons.count > 1{
                    for i in 1...actionButtons.count-1{
                        let x = (CGFloat(i)) * (UI.messageBoxSize.width)/CGFloat(actionButtons.count)
                        lineSegmentEndPoints.append(CGPoint(x: x, y: size.height))
                        lineSegmentEndPoints.append(CGPoint(x: x, y: y))
                    }
                }
            }
        }
        
        context.setLineWidth(UI.messageBoxLineWidth)
        UIColor.gray.setStroke()
        context.strokeLineSegments(between: lineSegmentEndPoints)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        context.restoreGState()
        UIGraphicsEndImageContext()
        return SKTexture(image: image)
    }
    fileprivate var isButtonDistributedVertically = false
    fileprivate var actionButtons: [SKLabelNode] = []
    fileprivate func setUpButtons(){
        //clear all actionButtons on the screen
        for actionButton in actionButtons{actionButton.removeFromParent()}
        actionButtons = []
        for action in actions{
            let actionButton = SKLabelNode(text: action.title)
            actionButton.fontColor = action.style == UIAlertAction.Style.destructive ? UIColor.red : UIColor.black
            actionButton.fontSize = UI.messageBoxActionButtonFontSize
            actionButton.fontName = UI.messageBoxActionButtonFontName
            actionButton.zPosition = 1
            actionButtons.append(actionButton)
        }
        
        
        //set up actionButtons
        var totalWidthOfActionButtons = CGFloat(0)
        actionButtons.map{totalWidthOfActionButtons += $0.frame.width}
        let maxWidthOfActionButtons = actionButtons.map{$0.frame.width}.max() ?? 0
        isButtonDistributedVertically = true
        if !actionButtons.isEmpty, totalWidthOfActionButtons < UI.messageBoxSize.width - UI.messageBoxCornerRadius*2{
            if (frame.width - 2*UI.messageBoxCornerRadius) / CGFloat(actionButtons.count) >= maxWidthOfActionButtons{
                isButtonDistributedVertically = false
            }
        }
        let maxButtonHeight = actionButtons.map{$0.frame.height}.max() ?? 0
        if isWithScroll{
            if isButtonDistributedVertically{
                var actionNumber = 0
                textBoxWithScroll.size.height = size.height - UI.messageBoxCornerRadius*(titleNode.frame.height == 0 ? 2 : 3) - (UI.messageBoxCornerRadius*2 + maxButtonHeight)*CGFloat(actionButtons.count) - titleNode.frame.height
                for actionButton in actionButtons{
                    if actionButton.parent == nil {addChild(actionButton)}
                    actionButton.verticalAlignmentMode = .center
                    actionButton.horizontalAlignmentMode = .center
                    actionButton.position.y = frame.minY + UI.messageBoxCornerRadius + CGFloat(actionButtons.count-1 - actionNumber)*(UI.messageBoxCornerRadius*2 + maxButtonHeight) + maxButtonHeight/2
                    actionNumber += 1
                }
            }
            else {
                var actionNumber = 0
                textBoxWithScroll.size.height = size.height - UI.messageBoxCornerRadius*(titleNode.frame.height == 0 ? 4:5) - maxButtonHeight - titleNode.frame.height
                for actionButton in actionButtons{
                    if actionButton.parent == nil {addChild(actionButton)}
                    actionButton.verticalAlignmentMode = .center
                    actionButton.horizontalAlignmentMode = .center
                    actionButton.position.x = frame.minX + (0.5 + CGFloat(actionNumber)) * (UI.messageBoxSize.width)/CGFloat(actionButtons.count)
                    actionButton.position.y = frame.minY + UI.messageBoxCornerRadius + maxButtonHeight/2
                    actionNumber += 1
                }
            }
        }
        else{
            if isButtonDistributedVertically{
                var actionNumber = 0
                size.height = UI.messageBoxCornerRadius*(titleNode.frame.height == 0 ? 2 : 3) + titleNode.frame.height + textBoxWithoutScroll.frame.height + (UI.messageBoxCornerRadius*2 + maxButtonHeight)*CGFloat(actionButtons.count)
                if size.height > UI.messageBoxSize.height{
                    isWithScroll = true
                    size = UI.messageBoxSize
                    return
                }
                for actionButton in actionButtons{
                    if actionButton.parent == nil {addChild(actionButton)}
                    actionButton.verticalAlignmentMode = .center
                    actionButton.horizontalAlignmentMode = .center
                    actionButton.position.y = frame.minY + UI.messageBoxCornerRadius + CGFloat(actionButtons.count-1 - actionNumber)*(UI.messageBoxCornerRadius*2 + maxButtonHeight) + maxButtonHeight/2
                    actionNumber += 1
                }
            }
            else {
                var actionNumber = 0
                size.height = UI.messageBoxCornerRadius*(titleNode.frame.height == 0 ? 4:5) + titleNode.frame.height + textBoxWithoutScroll.frame.height + maxButtonHeight
                if size.height > UI.messageBoxSize.height{
                    isWithScroll = true
                    size = UI.messageBoxSize
                    return
                }
                for actionButton in actionButtons{
                    if actionButton.parent == nil {addChild(actionButton)}
                    actionButton.verticalAlignmentMode = .center
                    actionButton.horizontalAlignmentMode = .center
                    actionButton.position.x = frame.minX + (0.5 + CGFloat(actionNumber)) * (UI.messageBoxSize.width)/CGFloat(actionButtons.count)
                    actionButton.position.y = frame.minY + UI.messageBoxCornerRadius + maxButtonHeight/2
                    actionNumber += 1
                }
            }
            //textBoxWithoutScroll.position.y = titleNode.frame.minY -  UI.messageBoxCornerRadius
        }
        titleNode.position.y = frame.maxY - UI.messageBoxCornerRadius
        textBoxWithoutScroll.position.y = titleNode.frame.minY -  UI.messageBoxCornerRadius
        
        self.texture = messageBoxTexture()
        self.size = texture!.size()
    }
    var touchOrigin = CGPoint.zero
    var everMovedOverTenPx = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self)
        let node = atPoint(pos)
        print(node)
        touchOrigin = pos
        everMovedOverTenPx = false
        if let touchOnWhichButton = getTouchedButtonIndex(pos: pos){
            theLastButtonTouched = touchOnWhichButton
            grayOutTheButton(index: touchOnWhichButton)
        }
        
    }
    fileprivate var theLastButtonTouched: Int? = nil
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self)
        
        if let touchOnWhichButton = getTouchedButtonIndex(pos: pos){
            if let theLastButtonTouched = theLastButtonTouched{
                if theLastButtonTouched != touchOnWhichButton{
                    self.theLastButtonTouched = touchOnWhichButton
                    grayOutTheButton(index: touchOnWhichButton)
                }
            }
            else{
                theLastButtonTouched = touchOnWhichButton
                grayOutTheButton(index: touchOnWhichButton)
            }
        }
        else {
            theLastButtonTouched = nil
            ungrayTheButton()
        }
        let distance = (touchOrigin - pos).norm
        if distance > 10{everMovedOverTenPx = true}
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self)
        ungrayTheButton()
        theLastButtonTouched = nil
        
        if !everMovedOverTenPx {
            if let touchOnWhichButton = getTouchedButtonIndex(pos: pos){
                //DispatchQueue.main.async{[weak self] in
                
                //}
//                DispatchQueue(label: "com.Ranixculiva.ISREVERSI.message.handler", qos: DispatchQoS.userInteractive).async{
                    self.isHidden = true
                    
//                }
                DispatchQueue.main.async{[weak self] in
                    self?.actions[touchOnWhichButton].handler?()
                }
                
                
                
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    func getTouchedButtonIndex(pos: CGPoint) -> Int?{
        //if isWithScroll{
        if (pos.y < textBoxWithScroll.frame.minY - UI.messageBoxCornerRadius && isWithScroll) || (pos.y < textBoxWithoutScroll.frame.minY - UI.messageBoxCornerRadius && !isWithScroll), pos.y > frame.minY, pos.x > frame.minX, pos.x < frame.maxX, !actionButtons.isEmpty{
            var touchOnWhichButton = 0
            if isButtonDistributedVertically{
                let buttonHeight = actionButtons.map{$0.frame.height}.max() ?? 0
                touchOnWhichButton = actionButtons.count-1 - Int((pos.y - frame.minY) / (buttonHeight + UI.messageBoxCornerRadius*2))
            }
            else {
                let buttonWidth = frame.width/CGFloat(actionButtons.count)
                touchOnWhichButton = Int((pos.x - frame.minX) / buttonWidth)
            }
            return touchOnWhichButton
        }
        //}
        //        else{
        //            if pos.y < textBoxWithoutScroll.frame.minY - UI.messageBoxCornerRadius, pos.y > frame.minY, pos.x > frame.minX, pos.x < frame.maxX, !actionButtons.isEmpty{
        //                var touchOnWhichButton = 0
        //                if isButtonDistributedVertically{
        //                    let buttonHeight = actionButtons.map{$0.frame.height}.max() ?? 0
        //                    touchOnWhichButton = actionButtons.count-1 - Int((pos.y - frame.minY) / (buttonHeight + UI.messageBoxCornerRadius*2))
        //                }
        //                else {
        //                    let buttonWidth = frame.width/CGFloat(actionButtons.count)
        //                    touchOnWhichButton = Int((pos.x - frame.minX) / buttonWidth)
        //                }
        //                return touchOnWhichButton
        //            }
        //        }
        
        return nil
    }
}
////m
