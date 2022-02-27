//
//  TextOptionsWithSelectButtons.swift
//  Reversi
//
//  Created by john gospai on 2019/7/10.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit

class TextOptionsWithSelectButtons: SKNode, FetchValueDelegate {
    override var name: String?{
        didSet{
            selectButtons.name = self.name
        }
    }
    weak var fetchValueDelegate: FetchValueDelegate? = nil
    func didFetchValue(value: Int, name: String?) {
        self.value = value
        fetchValueDelegate?.didFetchValue(value: value, name: name)
    }
    var value: Int = 0{
        willSet{
            selectButtons.value = newValue
            hideOldTextOption(value: value)
            showCurrentTextOption(value: newValue)
        }
    }
    var numberOfOptions = 1
    var texts = [""]
    fileprivate var labels: [SKLabelNode] = []
    var spacing: CGFloat = 0.0
    var rightButton: SKSpriteNode
    var leftButton: SKSpriteNode
    var isCyclic: Bool
    var selectButtons: SelectButtons!
    init(texts: [String], spacing: CGFloat, leftButton: SKSpriteNode, rightButton: SKSpriteNode, isCyclic: Bool = true, fontNames: [String]? = nil, fontSize: CGFloat = UI.fontSize.difficultySelector, fontColor: UIColor = .black) {
        
        
        
        numberOfOptions = texts.count
        if numberOfOptions == 0 {fatalError("numberOfOptions < 1")}
        self.spacing = spacing
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.isCyclic = isCyclic
        self.selectButtons = SelectButtons(spacing: spacing, leftButton: leftButton, rightButton: rightButton, isCyclic: isCyclic, upperBound: numberOfOptions - 1)
        selectButtons.zPosition = 1
        
        
        super.init()
        self.texts = texts
        var innerFontNames: [String]
        if fontNames == nil {
            innerFontNames = Array(repeating: UI.difficultySelectorFontName, count: numberOfOptions)
        }
        else {
            if fontNames!.count != numberOfOptions {fatalError("fontNames!.count != numberOfOptions")}
            else{
                innerFontNames = fontNames!
            }
        }
        for (index, text) in texts.enumerated(){
            let label = SKLabelNode(text: text)
            label.isHidden = true
            label.fontColor = .black
            label.verticalAlignmentMode = .center
            label.fontName = innerFontNames[index]
            label.fontSize = fontSize
            label.fontColor = fontColor
            label.zPosition = 1
            labels.append(label)
            self.addChild(label)
        }
        labels[0].isHidden = false
        self.addChild(selectButtons)
        selectButtons.fetchValueDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("TextOptionWithSelectButtons.init(coder:) has not been implemented")
    }
    fileprivate func hideOldTextOption(value: Int){
        labels[value].isHidden = true
    }
    fileprivate func showCurrentTextOption(value: Int){
        labels[value].isHidden = false
    }
    override var frame: CGRect{
        let x = leftButton.frame.minX
        let y = leftButton.frame.minY
        let w = rightButton.frame.maxX - leftButton.frame.minX
        let h = max(leftButton.frame.maxY, rightButton.frame.maxY) - min(leftButton.frame.minY, rightButton.frame.minY)
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
