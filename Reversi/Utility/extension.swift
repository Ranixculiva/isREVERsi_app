//
//  extraAction.swift
//  Reversi
//
//  Created by john gospai on 2018/11/14.
//  Copyright © 2018 john gospai. All rights reserved.
//

import SpriteKit
extension String {
    
    func tokenize() -> [String] {
        let inputRange = CFRangeMake(0, self.count)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate( kCFAllocatorDefault, self as CFString, inputRange, 3, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var tokens : [String] = []
        
        while tokenType != []
        {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let substring = self.substringWithRange(aRange: currentTokenRange)
            tokens.append(substring)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        
        return tokens
    }
    
    func substringWithRange(aRange : CFRange) -> String {
        
        let nsrange = NSMakeRange(aRange.location, aRange.length)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }
    /**
     ### Usage Example: ###
     ```
     var val = "THE_KEY_OF_THE_LOCALIZED_STRING".localized("zh")
     ```
     use Locale.current.languageCode to get the current language code.
     */
    func localized(_ lang:String) -> String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    func localized(_ lang: SharedVariable.lang = SharedVariable.language) -> String {
        if lang == .defaultLang {
            return NSLocalizedString(self, comment: "")
        }
        return self.localized(lang.rawValue)
    }
}
extension SKLabelNode{
    func wrapWord(){
        
    }
}
protocol fontColorizable {
    var fontColor: UIColor? {get set}
}
extension SKMultilineLabel: fontColorizable{}
extension SKLabelNode: fontColorizable{}
protocol attachable {
    var anchorPoint: CGPoint{get}
}
extension SKSpriteNode: attachable{}
extension SKCropNode: attachable{
    var anchorPoint: CGPoint {return CGPoint(x: 0.5, y: 0.5)}
    override open var frame: CGRect{
        guard let mask = self.maskNode else {
            return super.frame
        }
        return CGRect(origin: mask.frame.origin + position, size: mask.frame.size)
    }
}
extension SKNode{
    func shake(duration: CGFloat, amplitudeX: CGFloat, numberOfShakes: Int, completion: @escaping () -> Void = {}){
        
        let period: CGFloat = CGFloat(duration) / CGFloat(numberOfShakes)
        let numberOfSamples: Int = 100
        var actionsArray:[SKAction] = []
        for t in 0...numberOfShakes * numberOfSamples {
            let moveToX = CGFloat(amplitudeX) * sin(CGFloat.pi * 2 * CGFloat(t) /  CGFloat(numberOfSamples)) + self.position.x
            let shakeAction = SKAction.moveTo(x: moveToX, duration: TimeInterval(period / CGFloat(numberOfSamples)))
            actionsArray.append(shakeAction)
        }
        
        let actionSeq = SKAction.sequence(actionsArray)
        self.run(actionSeq, completion: completion)
        
    }
}

extension CGPoint{
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
    }
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x:lhs.x - rhs.x, y:lhs.y - rhs.y)
    }
    static func += ( lhs: inout CGPoint, rhs: CGPoint){
        return lhs = lhs + rhs
    }
    static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint{
        return CGPoint(x: rhs.x * lhs, y: rhs.y * lhs)
    }
    ////m
    var norm: CGFloat{
        return sqrt(self.x * self.x + self.y * self.y)
    }
    ////m
}
extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}
extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
extension Unicode{
//    static func circledNumber(_ number: Int) -> String{
//        switch number{
//        case 0:
//            return "\(UnicodeScalar(0x24FF)!)"
//        case 1...10:
//            return "\(UnicodeScalar(0x2776 - 1 + number)!)"
//        case 11...20:
//            return "\(UnicodeScalar(0x24eb - 11 + number)!)"
//        case 21...35:
//            return "\(UnicodeScalar(0x3251 - 21 + number)!)"
//        case 36...50:
//            return "\(UnicodeScalar(0x32b1 - 36 + number)!)"
//        default:
//            return "\(number)"
//        }
//    }
    static func circledNumber(_ number: Int) -> String{
        switch number{
        case 0...99:
            return "\(UnicodeScalar(0xe900 + number)!)"
        default:
            return "\(number)"
        }
    }
}
////m
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
////m
extension SKAction{
    open class func moveZPositionTo(to toZPosition: CGFloat, withDuration: TimeInterval) -> SKAction{
        var firstTimeRunTheBlock = true
        var originalZPosition: CGFloat = 0.0
        var deltaOfZPosition: CGFloat = 0.0
        let customAction = SKAction.customAction(withDuration: withDuration) {
            node, elapsedTime in
            
            if let node = node as? SKSpriteNode {
                if CGFloat(withDuration) > 0{
                    if firstTimeRunTheBlock {
                        originalZPosition = node.zPosition
                        deltaOfZPosition = (toZPosition - originalZPosition) / CGFloat(withDuration)
                        firstTimeRunTheBlock = false
                    }
                    node.zPosition = originalZPosition + elapsedTime * deltaOfZPosition
                }
                
            }
        }
        return customAction
    }
    
    open class func moveValueTo(to toValue: CGFloat, withDuration: TimeInterval) -> SKAction{
        var firstTimeRunTheBlock = true
        var originalValue: CGFloat = 0.0
        var deltaOfValue: CGFloat = 0.0
        let customAction = SKAction.customAction(withDuration: withDuration) {
            node, elapsedTime in
            
            if let slider = node as? CustomSlider {
                if CGFloat(withDuration) > 0{
                    if firstTimeRunTheBlock {
                        originalValue = slider.value
                        deltaOfValue = (toValue - originalValue) / CGFloat(withDuration)
                        firstTimeRunTheBlock = false
                    }
                    slider.value = originalValue + elapsedTime * deltaOfValue
                }
                
            }
        }
        return customAction
    }
    
    open class func changeFontColor(to toColor: UIColor) -> SKAction{
        let customAction = SKAction.customAction(withDuration: 0) {
            node, elapsedTime in
            if var label = node as? fontColorizable {
                label.fontColor = toColor
            }
        }
        return customAction
    }
}
