//
//  MusicVolumeSlider.swift
//  Reversi
//
//  Created by john gospai on 2019/9/13.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
extension UI{
    static var MusicVolumeSliderFontSize: CGFloat{
        return UI.languageOptionFontSize
    }
}
class MusicVolumeSlider: SKNode {
    fileprivate var bgmLabelNode: SKLabelNode!
    fileprivate var sfxLabelNode: SKLabelNode!
    fileprivate var bar: SKSpriteNode!
    fileprivate var slider: SKSpriteNode!
    override var frame: CGRect{
        let x = sfxLabelNode.frame.origin.x
        let y = sfxLabelNode.frame.origin.y
        let w = bgmLabelNode.frame.maxX - sfxLabelNode.frame.minX
        let h = max(bgmLabelNode.frame.maxY, sfxLabelNode.frame.maxY) - min(bgmLabelNode.frame.minY, sfxLabelNode.frame.minY)
        return CGRect(x: x, y: y, width: w, height: h)
    }
    fileprivate var barTexture: [SKTexture] = []
    fileprivate var numberOfParts: Int = 14
    fileprivate var strokeWidth: CGFloat{return frame.height/8 }
    fileprivate var barSize: CGSize{
        return CGSize(width: bgmLabelNode.frame.minX - sfxLabelNode.frame.maxX - UI.optionMenuSpacing, height: frame.height)
    }
    override init() {
        super.init()
        isUserInteractionEnabled = true
        MusicPlayer.preparePlayer(music: .sfx(.tap))
        setUpBGMLabelNode()
        setUpSFXLabelNode()
        prepareBarTexture()
        setUpBar()
        setUpSlider()
        positionSlider()
    }
    deinit {
        MusicPlayer.removePreparedMusic(music: .sfx(.tap))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate func setUpBGMLabelNode(){
        bgmLabelNode = SKLabelNode(text: "BGM")
        bgmLabelNode.fontName = UI.fontName.ChalkboardSEBold.rawValue
        bgmLabelNode.fontColor = .black
        bgmLabelNode.fontSize = UI.MusicVolumeSliderFontSize
        bgmLabelNode.horizontalAlignmentMode = .right
        bgmLabelNode.verticalAlignmentMode = .center
        bgmLabelNode.position.x = UI.gridSize/2 - UI.optionMenuSpacing
        bgmLabelNode.zPosition = 1
        addChild(bgmLabelNode)
    }
    fileprivate func setUpSFXLabelNode(){
        sfxLabelNode = SKLabelNode(text: "SFX")
        sfxLabelNode.fontName = UI.fontName.ChalkboardSEBold.rawValue
        sfxLabelNode.fontSize = UI.MusicVolumeSliderFontSize
        sfxLabelNode.fontColor = .black
        sfxLabelNode.horizontalAlignmentMode = .left
        sfxLabelNode.verticalAlignmentMode = .center
        sfxLabelNode.position.x = -UI.gridSize/2 + UI.optionMenuSpacing
        sfxLabelNode.zPosition = 1
        addChild(sfxLabelNode)
    }
    fileprivate func intToColor(_ i: Int, saturation: CGFloat = 1, brightness: CGFloat = 0.3) -> CGColor{
        return UIColor(hue: CGFloat(numberOfParts-1-i)*0.9/CGFloat(numberOfParts), saturation: saturation, brightness: brightness, alpha: 1).cgColor
    }
    fileprivate func prepareBarTexture(numberOfTexture: Int = 10){
        barTexture = []
        for j in 0...numberOfTexture - 1{
            UIGraphicsBeginImageContextWithOptions(barSize
                , false, UIScreen.main.scale)
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.setStrokeColor(UIColor.black.cgColor)
            let w = (barSize.width - strokeWidth)/CGFloat(numberOfParts)
            let h = strokeWidth + CGFloat(j)*(barSize.height - 2*strokeWidth)/CGFloat(numberOfTexture - 1)
            for i in 0...numberOfParts - 1{
                //let x = strokeWidth/2 + CGFloat(i)*w
                let x = strokeWidth/2 + (CGFloat(i)*(barSize.width - strokeWidth)) / CGFloat(numberOfParts)
                let y = barSize.height/2 - h/2
                let rect = CGRect(x: x, y: y, width: w, height: h)
                let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: w/2)
                ctx.setFillColor(intToColor(i))
                ctx.addPath(roundedRect.cgPath)
                ctx.fillPath()
                ctx.setLineWidth(strokeWidth)
                ctx.addPath(roundedRect.cgPath)
                ctx.strokePath()
            }
            let barImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            barTexture.append(SKTexture(image: barImage))
        }
    }
    fileprivate func setUpBar(){
        bar = SKSpriteNode(texture: barTexture.first!)
        bar.zPosition = 1
        bar.position.x = sfxLabelNode.frame.maxX + UI.optionMenuSpacing/2 + bar.frame.size.width/2
        addChild(bar)
    }
    fileprivate func openBar(){
        bar.removeAllActions()
        bar.run(SKAction.animate(with: barTexture, timePerFrame: 1/30))
    }
    fileprivate func closeBar(){
        bar.removeAllActions()
        bar.run(SKAction.animate(with: barTexture.reversed(), timePerFrame: 1/30))
    }
    fileprivate func updateSliderTexture(){
        UIGraphicsBeginImageContextWithOptions(slider.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let w = slider.size.width - strokeWidth
        let h = slider.size.height - strokeWidth
        let x = strokeWidth/2
        let y = strokeWidth/2
        let rect = CGRect(x: x, y: y, width: w, height: h)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: w/2)
        sliderColor(volumeToi()).setFill()
        context.addPath(roundedRect.cgPath)
        context.fillPath()
        context.setLineWidth(strokeWidth)
        UIColor.black.setStroke()
        context.addPath(roundedRect.cgPath)
        context.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        slider.texture = SKTexture(image: image)
    }
    fileprivate func setUpSlider(){
        let w = (barSize.width - strokeWidth)/CGFloat(numberOfParts) + strokeWidth
        let h = frame.height
        slider = SKSpriteNode(color: .red, size: CGSize(width: w, height: h))
        slider.zPosition = 2
        addChild(slider)
    }
    fileprivate func positionSlider(){
        slider.position.x = iToPosition(volumeToi()).x
        updateSliderTexture()
    }
    fileprivate var originNode: SKNode? = nil
    fileprivate func sliderColor(_ i: Int) -> UIColor{
        return UIColor(cgColor: intToColor(i, saturation: 1, brightness: 1))
    }
    fileprivate func playTapSound(){
        MusicPlayer.replay(music: .sfx(.tap))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = atPoint(pos)
            originNode = node
            switch node{
            case bar, slider:
                slider.position.x = cutXInTheRangeOfSlider(x: pos.x)
                let i = positionToi(x: slider.position.x)
                iToVolume(i)
                openBar()
                updateSliderTexture()
                playTapSound()
            default:
                break
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            switch originNode{
            case bar, slider:
                let i = positionToi(x: cutXInTheRangeOfSlider(x: pos.x))
                slider.position.x = iToPosition(i).x
                if volumeToi() != i{
                    iToVolume(i)
                }
                updateSliderTexture()
            default:
                break
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first{
            if originNode == bar || originNode == slider{
                let i = volumeToi()
                playTapSound()
                slider.position.x = iToPosition(i).x
                iToVolume(i)
                closeBar()
                updateSliderTexture()
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    fileprivate func volumeToi() -> Int{
        return min(Int(floor(SharedVariable.bgmVolumeRatio * Float(numberOfParts))), numberOfParts-1)
    }
    fileprivate func iToVolume(_ i0: Int){
        let i = max(min(i0, numberOfParts - 1), 0)
        if i == numberOfParts - 1{
            SharedVariable.bgmVolumeRatio = 1
        }
        else if i >= 0, i < numberOfParts-1{
            SharedVariable.bgmVolumeRatio = Float(i)/Float(numberOfParts)
        }
    }
    fileprivate func positionToi(x: CGFloat) -> Int{
        //let intervalLength = (barSize.width - strokeWidth)/CGFloat(numberOfParts)
        //return Int((x - bar.frame.minX + strokeWidth/2)/intervalLength)
        return Int((x - bar.frame.minX + strokeWidth/2)*CGFloat(numberOfParts)/(barSize.width - strokeWidth))
    }
    fileprivate func iToPosition(_ i: Int) -> CGPoint{
        //let intervalLength = (barSize.width - strokeWidth)/CGFloat(numberOfParts)
        let x = (CGFloat(i)+0.5)*(barSize.width - strokeWidth) / CGFloat(numberOfParts) + bar.frame.minX + strokeWidth/2
        return CGPoint(x: x, y: barSize.height/2)
    }
    fileprivate func cutXInTheRangeOfSlider(x: CGFloat) -> CGFloat{
        let intervalLength = (barSize.width - strokeWidth)/CGFloat(numberOfParts)
        let first = min(x, bar.frame.maxX - strokeWidth/2 - intervalLength/2)
        let second = bar.frame.minX + strokeWidth/2 + intervalLength/2
        let newX = max(first, second)
        return newX
    }
}
