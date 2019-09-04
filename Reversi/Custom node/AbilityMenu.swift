//
//  AbilityMenu.swift
//  Reversi
//
//  Created by john gospai on 2019/5/3.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class AbilityMenu: SKSpriteNode{
    var currentItemNumber = 0
    var isMenuOpened = false
    fileprivate let abilities = [Reversi.ability.translate]
    fileprivate var numberOfItems = 1
    fileprivate var imageNames: [String] = ["translate.png"]
    fileprivate var itemSpriteNodes: [SKSpriteNode] = []
    var isActive = false{
        didSet{
            if isActive != oldValue{
                for itemSpriteNode in itemSpriteNodes{
                    itemSpriteNode.alpha = isActive ? 1:0.5
                }
            }
        }
    }
    var handler: (_ ability: Reversi.ability) -> Void = {_ in }
    var attachTo: (SKNode & attachable)?{
        didSet{
            updatePosition()
        }
    }
    fileprivate var popAnimationFrames: [SKTexture] = []
    fileprivate var collapseAnimationFrames: [SKTexture] = []

    fileprivate func updatePosition(){
        guard let attachTo = attachTo else {return}
        self.position.x = attachTo.position.x + (0.5 - attachTo.anchorPoint.x) * attachTo.frame.width
        self.position.y = attachTo.position.y + (1 - attachTo.anchorPoint.y) * attachTo.frame.height + UI.abilityMenuSpace + self.frame.height/2
    }
    convenience init(isActive: Bool = true, numberOfItems: Int = 1, handler: @escaping (_ ability: Reversi.ability) -> Void) {
        
        //MARK: - draw background
        let width = UI.abilityMenuWidth
        let height = UI.abilityMenuSpace + (UI.abilityMenuItemWidth + UI.abilityMenuSpace)*CGFloat(numberOfItems)
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        
        let backgroundBounds = CGRect(origin: CGPoint.zero, size: size)
        let roundedBackgroundBounds = UIBezierPath(roundedRect: backgroundBounds, cornerRadius: UI.abilityMenuRoundedCornerRadius)
        context.addPath(roundedBackgroundBounds.cgPath)
        let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        backgroundColor.setFill()
        context.fillPath()
        
        let abilityBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(texture: SKTexture(image: abilityBackgroundImage), color: .clear, size: size)
        self.isActive = isActive
        self.numberOfItems = numberOfItems
        self.handler = handler
        self.isHidden = true
        self.isUserInteractionEnabled = true
        //MARK: - draw items
        for (index, imageName) in imageNames.enumerated(){
            let itemSize = CGSize(width: UI.abilityMenuItemWidth, height: UI.abilityMenuItemWidth)
            let itemBounds = CGRect(origin: CGPoint.zero, size: itemSize)
            UIGraphicsBeginImageContext(itemSize)
            let roundedItemBounds = UIBezierPath(roundedRect: itemBounds, cornerRadius: UI.abilityMenuItemRoundedCornerRadius)
            let itemContext = UIGraphicsGetCurrentContext()!
            ///clips
            itemContext.saveGState()
            roundedItemBounds.addClip()
            
            let itemOriginalImage = UIImage(named: imageName)
            itemOriginalImage?.draw(in: itemBounds)
            
            itemContext.restoreGState()
            ///clips
            let itemImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let item = SKSpriteNode(texture: SKTexture(image: itemImage), size: itemSize)
            item.zPosition = UI.zPosition.abilityMenuItem
            item.position.y = -size.height/2 + UI.abilityMenuSpace + UI.abilityMenuItemWidth/2 + CGFloat(index) * (UI.abilityMenuItemWidth + UI.abilityMenuSpace)
            item.name = "\(index)"
            self.itemSpriteNodes.append(item)
            if !isActive{
                item.alpha = 0.5
            }
            self.addChild(item)
        }
        self.zPosition = UI.zPosition.abilityMenu
        self.popAnimationFrames = generatePopAnimationFrames()
        self.collapseAnimationFrames = generateCollapseAnimationFrames()
    }
    fileprivate func generatePopAnimationFrames(numberOfFrames: Int = Int(0.3*30)) -> [SKTexture]{
        var resultFrames: [SKTexture] = []
        if numberOfFrames == 0 {fatalError("wrong number of frames")}
        let width = UI.abilityMenuWidth
        let height = UI.abilityMenuSpace + (UI.abilityMenuItemWidth + UI.abilityMenuSpace)*CGFloat(numberOfItems)
        let size = CGSize(width: width, height: height)
        for i in 1...numberOfFrames{
            
            
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()!
            let boundsSize = CGSize(width: width, height: height * CGFloat(i)/CGFloat(numberOfFrames))
            let backgroundBoundsOriginY = size.height - boundsSize.height
            let backgroundBounds = CGRect(origin: CGPoint(x: 0, y: backgroundBoundsOriginY), size: boundsSize)
            let roundedBackgroundBounds = UIBezierPath(roundedRect: backgroundBounds, cornerRadius: UI.abilityMenuRoundedCornerRadius)
            context.addPath(roundedBackgroundBounds.cgPath)
            let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8 * CGFloat(i)/CGFloat(numberOfFrames))
            backgroundColor.setFill()
            context.fillPath()
            
            let abilityBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            resultFrames.append(SKTexture(image: abilityBackgroundImage))
        }
        return resultFrames
    }
    fileprivate func generateCollapseAnimationFrames(numberOfFrames: Int = Int(0.3*30)) -> [SKTexture]{
        let resultFrames = generatePopAnimationFrames(numberOfFrames: numberOfFrames)
        return resultFrames.reversed()
    }
    func popAnimation(completion: @escaping ()->Void = {}){
        self.removeAllActions()
        self.isMenuOpened = true
        self.isHidden = false
        var backgroundAnimation = SKAction.animate(with: popAnimationFrames, timePerFrame: 1.0/30.0)
        backgroundAnimation = SKAction.group([
            backgroundAnimation,
            SKAction.wait(forDuration: 0.3)
            ])
        var itemAnimation = SKAction()
        for itemSpriteNode in itemSpriteNodes{
            itemSpriteNode.isHidden = true
            itemAnimation = SKAction.sequence([
                itemAnimation,
                SKAction.group([
                    SKAction.wait(forDuration: 0.1)]),
                SKAction.run{
                    itemSpriteNode.isHidden = false
                }
                ])
        }
        self.run(SKAction.sequence([
                backgroundAnimation,
                itemAnimation
            ])
        ){completion()}
    }
    func collapseAnimation(completion: @escaping ()->Void = {}){
        self.removeAllActions()
        self.isMenuOpened = false
        var backgroundAnimation = SKAction.animate(with: collapseAnimationFrames, timePerFrame: 1.0/30.0)
        backgroundAnimation = SKAction.group([
            backgroundAnimation,
            SKAction.wait(forDuration: 0.3)
            ])
        var itemAnimation = SKAction()
        for itemSpriteNode in itemSpriteNodes{
            itemAnimation = SKAction.sequence([
                SKAction.group([
                    SKAction.wait(forDuration: 0.1)]),
                SKAction.run{
                    itemSpriteNode.isHidden = true
                },
                itemAnimation
                ])
        }
        self.run(SKAction.sequence([
            itemAnimation,
            backgroundAnimation
            ])
        ){
            self.isHidden = true
            completion()}
    }
    fileprivate var touchOrigin = CGPoint.zero
    fileprivate var hasEverMovedMoreThanTenPx = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            hasEverMovedMoreThanTenPx = false
            let pos = touch.location(in: self)
            touchOrigin = pos
            let node = atPoint(pos)
            if let node = node as? SKSpriteNode{
                if let itemNumber = itemSpriteNodes.firstIndex(of: node){
                    currentItemNumber = itemNumber
                    node.alpha = 0.5
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            if (pos - touchOrigin).norm > 10 {hasEverMovedMoreThanTenPx = true}
            let node = atPoint(pos)
            itemSpriteNodes[currentItemNumber].alpha = isActive ? 1:0.5
            if let node = node as? SKSpriteNode{
                if let itemNumber = itemSpriteNodes.firstIndex(of: node){
                    currentItemNumber = itemNumber
                    node.alpha = 0.5
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            if (pos - touchOrigin).norm > 10 {hasEverMovedMoreThanTenPx = true}
            let node = atPoint(pos)
            itemSpriteNodes[currentItemNumber].alpha = isActive ? 1:0.5
            if let node = node as? SKSpriteNode{
                if let itemNumber = itemSpriteNodes.firstIndex(of: node){
                    if currentItemNumber == itemNumber, !hasEverMovedMoreThanTenPx{
                        if isActive{handler(abilities[itemNumber])}
                        self.collapseAnimation()
                    }
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
}
