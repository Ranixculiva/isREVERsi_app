//
//  SKMultilineLabel.swift
//
//  Created by Craig on 10/04/2015.
//  Copyright (c) 2015 Interactive Coconut.
//  MIT License, http://www.opensource.org/licenses/mit-license.php
//
/*   USE:
 (most component parameters have defaults)
 let multiLabel = SKMultilineLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", labelWidth: 250, pos: CGPoint(x: size.width / 2, y: size.height / 2))
 self.addChild(multiLabel)
 */

import SpriteKit

class SKMultilineLabel: SKNode {
    //props
    override var frame: CGRect{
        var x:CGFloat = position.x
        var y:CGFloat = position.y
        if !labels.isEmpty {
            x = labels.last!.frame.minX + position.x
            y = labels.last!.frame.minY + position.y
        }
        let resultFrame = CGRect(x: x, y: y, width: frameWidth, height: labelHeight)
        return resultFrame
        
    }
    fileprivate var frameWidth = CGFloat(0)
    var labelWidth:CGFloat {didSet {update()}}
    var labelHeight:CGFloat = 0
    var text:String {
        didSet {
            words = text.tokenize()
            update()
        }
    }
    var fontName:String {didSet {update()}}
    var fontSize:CGFloat {
        didSet {
            leading = fontSize*leadingRatio
            update()
        }
    }
    var pos:CGPoint {didSet {update()}}
    var fontColor:UIColor? {didSet {update()}}
    var leading:CGFloat {didSet {update()}}
    var leadingRatio: CGFloat = 1.5 {didSet{update()}}
    var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}
    var dontUpdate = false
    var shouldShowBorder:Bool = false {didSet {update()}}
    //display objects
    var rect:SKShapeNode?
    var labels:[SKLabelNode] = []
    //key for encode and decode
    enum codeKey: String{
        case labelWidth = "labelWidth"
    }
    var anchorPoint = CGPoint(x: 0.5, y: 1) {didSet{update()}}
    fileprivate var words: [String] = []
    init(text:String, labelWidth:CGFloat, pos:CGPoint = CGPoint.zero, fontName:String=UI.SKMultilineLabelNodeFontName,fontSize:CGFloat=10,fontColor:UIColor=UIColor.white,leading:CGFloat? = nil, alignment:SKLabelHorizontalAlignmentMode = .left, shouldShowBorder:Bool = false)
    {
        self.text = text
        self.words = text.tokenize()
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading ?? fontSize*1.5
        self.shouldShowBorder = shouldShowBorder
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        //self.labelWidth = aDecoder.decodeFloat(forKey: codeKey.labelWidth.rawValue)
        fatalError("init(coder:) has not been implemented")
    }
    override func encode(with aCoder: NSCoder) {
        //super.encode(with: aCoder)
        //aCoder.encode(labelWidth, forKey: codeKey.labelWidth.rawValue)
    }
    
    //if you want to change properties without updating the text field,
    //  set dontUpdate to false and call the update method manually.
    func update() {
        if (dontUpdate) {return}
        ////m
        if words.count == 0 {return}
        ////m
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        //let separators = NSCharacterSet.whitespacesAndNewlines
        //let words = text.tokenize()
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        while (!finalLine) {
            lineCount+=1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            // creation of the SKLabelNode itself
            let label = SKLabelNode(fontNamed: fontName)
            // name each label node so you can animate it if u wish
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            
            while label.frame.width <= labelWidth, lineString.last != "\n"
            {
                wordCount+=1
                if wordCount > words.count-1
                {
                    finalLine = true
                    wordCount = words.count-1
                    break
                }
                else
                {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString)\(words[wordCount])"
                    label.text = lineString
                }
            }
            //MARK: clear all last space characters of lineString
            while(lineString.last == " ") {lineString.removeLast()}
            let lineStringLabelForLength = SKLabelNode(text: lineString)
            lineStringLabelForLength.fontSize = fontSize
            lineStringLabelForLength.fontName = fontName
            lineLength = lineStringLabelForLength.frame.width
            //MARK: adjust the postition of each line.
            if lineLength > 0 {
                //MARK: avoid a dead loop when the width of a sigle word larger than labelWidth
                var testWord = words[wordCount]
                while(testWord.last == " ") {testWord.removeLast()}
                let testLabel = SKLabelNode(text: testWord)
                testLabel.fontSize = fontSize
                testLabel.fontName = fontName
                if (lineLength > labelWidth && testLabel.frame.width <= CGFloat(labelWidth)) || (testLabel.frame.width > CGFloat(labelWidth) && lineStringBeforeAddingWord != ""){
                    wordCount-=1
                    if (!finalLine) {
                        lineString = lineStringBeforeAddingWord
                    }
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .left) {
                    label.horizontalAlignmentMode = .left
                } else if (alignment == .right) {
                    label.horizontalAlignmentMode = .right
                }
                linePos.y += -leading * CGFloat(lineCount)
                label.position = CGPoint(x:linePos.x , y:linePos.y )
                self.addChild(label)
                labels.append(label)
                frameWidth = max(label.frame.width, frameWidth)
            }
        }
        labelHeight = 0
        if !labels.isEmpty {
            labelHeight = labels.first!.frame.maxY - labels.last!.frame.minY
            let minMinXOfLabels = labels.map{$0.frame.minX}.min()!
            let offset = pos - CGPoint(x: (minMinXOfLabels + anchorPoint.x * frameWidth), y: (labels.last!.frame.minY + anchorPoint.y * labelHeight))
            for line in labels{
                line.position += offset
            }
        }
        showBorder()
    }
    func showBorder() {
        if (!shouldShowBorder) {return}
        if let rect = self.rect {
            self.removeChildren(in: [rect])
        }
        //self.rect = SKShapeNode(rectOf: CGSize(width: labelWidth, height: labelHeight))
        var x:CGFloat = 0
        var y:CGFloat = 0
        if !labels.isEmpty {
            x = labels.last!.frame.minX
            y = labels.last!.frame.minY
        }
        let resultFrame = CGRect(x: x, y: y, width: frameWidth, height: labelHeight)
        self.rect = SKShapeNode(rect: resultFrame)
        if let rect = self.rect {
            rect.strokeColor = UIColor.white
            rect.lineWidth = 2
            rect.position = CGPoint(x: pos.x, y: pos.y)
            self.addChild(rect)
        }
        
    }
}
