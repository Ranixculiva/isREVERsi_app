//
//  MessageViewController.swift
//  Reversi
//
//  Created by john gospai on 2019/8/24.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
import UIKit
import WebKit

class MessageBoxButton: UIButton{
    
    var touchablePath = UIBezierPath()
    weak var action: MessageAction? = nil
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if !point(inside: touch.location(in: self), with: event){
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            return false
        }
        return true
    }
    convenience init(action: MessageAction) {
        self.init(frame: .zero)
        self.action = action
        self.setTitle(action.title, for: .normal)
        self.titleLabel?.font = UIFont(name: UI.messageBoxActionButtonFontName, size: UI.messageBoxActionButtonFontSize)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.sizeToFit()
        //self.layer.frame = titleLabel?.frame ?? self.frame
        self.touchablePath = UIBezierPath(rect: frame)
        switch action.style{
        case .cancel:
            self.setTitleColor(.darkGray, for: .normal)
        case .default:
            self.setTitleColor(.black, for: .normal)
        case .destructive:
            self.setTitleColor(.red, for: .normal)
        @unknown default:
            fatalError("actionSytleUnknown default")
        }
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        print("touchBean")
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2037457192)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first{
            if !point(inside: touch.location(in: self), with: event){
                self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        print("touchEnd")
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesEnded(touches, with: event)
    }
    @objc func didTapButton(){
        DispatchQueue.main.async{
            [unowned self] in
            self.action?.handler?()
        }
        
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchablePath.contains(point)
    }
}

class MessageAction{
    var title = ""
    var style = UIAlertAction.Style.default
    var handler: (() -> Void)? = nil
    init(title: String, style: UIAlertAction.Style, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class MessageViewController: UIViewController, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView?.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView?.stopAnimating()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url{
            switch url.scheme{
            case "mailto":
                if UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    decisionHandler(.cancel)
                    return
                }
            default:
                break
            }
        }
        decisionHandler(.allow)
    }
    override var title: String?{
        didSet{
            if !withoutUpdate{
                setTitle()
                resizing()
                positioning()
                setGradientBackground()
            }
        }
    }
    var message: String?{
        didSet{
            if !withoutUpdate{
                setMessage()
                resizing()
                positioning()
                setGradientBackground()
            }
        }
    }
    fileprivate var storedActions: [MessageAction] = []
    var actions: [MessageAction] {
        return storedActions
    }
    fileprivate var actionButtons: [MessageBoxButton] = []
    fileprivate var isActionButtonsDistributedVertically = true
    func addActions(_ actions: [MessageAction]){
        storedActions.append(contentsOf: actions)
        setButtons()
        resizing()
        positioning()
        setGradientBackground()
    }
    func changeTheLastActionTitle(withText: String){
        storedActions.last?.title = withText
        setButtons()
        resizing()
        positioning()
        setGradientBackground()
    }
    fileprivate var titleNode: UILabel? = nil
    fileprivate var messageNode: UILabel? = nil
    fileprivate var messageBoxView: UIView!
    fileprivate func setupMessageBoxView(){
        if messageBoxView != nil{
            messageBoxView.removeFromSuperview()
        }
        messageBoxView = UIView()
    }
    fileprivate var backgroundLayer: CAGradientLayer? = nil
    override func viewDidLoad() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
        print("viewDidLoad")
    }
    fileprivate func setTitle(){
        if titleNode?.superview != nil{
            titleNode?.removeFromSuperview()
        }
        if let title = title{
            let spacing = UI.messageBoxCornerRadius
            let w = UI.messageBoxSize.width
            let titleW = w - 2*spacing
            titleNode = UILabel(frame: CGRect(x: 0, y: 0, width: titleW, height: 0))
            titleNode?.lineBreakMode = .byWordWrapping
            titleNode?.numberOfLines = 0
            titleNode?.text = title
            titleNode?.font = UIFont(name: UI.messageBoxTitleFontName, size: UI.messageBoxTitleFontSize)
            titleNode?.textAlignment = .center
            titleNode?.textColor = .white
            titleNode?.sizeToFit()
            messageBoxView!.insertSubview(titleNode!
                , at: 10)
        }
        else{
            titleNode = nil
        }
    }
    fileprivate func setMessage(){
        if messageNode?.superview != nil{
            messageNode?.removeFromSuperview()
        }
        if let message = message{
            let spacing = UI.messageBoxCornerRadius
            let w = UI.messageBoxSize.width
            let messageW = w - 2*spacing
            messageNode = UILabel(frame: CGRect(x: 0, y: 0, width: messageW, height: 0))
            messageNode?.lineBreakMode = .byWordWrapping
            messageNode?.numberOfLines = 0
            messageNode?.text = message
            messageNode?.font = UIFont(name: UI.messageBoxTitleFontName, size: UI.scrollTextFontSize)
            messageNode?.textAlignment = .center
            messageNode?.textColor = .black
            messageNode?.sizeToFit()
            messageBoxView!.insertSubview(messageNode!, at: 10)
            
        }
        else {
            messageNode = nil
        }
    }
    fileprivate func setButtons(){
        for actionButton in actionButtons{
            actionButton.removeFromSuperview()
        }
        actionButtons = []
        let spacing = UI.messageBoxCornerRadius
        let w = UI.messageBoxSize.width - 2*spacing
        isActionButtonsDistributedVertically = false
        for action in actions{
            let actionButton = MessageBoxButton(action: action)
            actionButton.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
            actionButtons.append(actionButton)
            let maxActionButtonW = w/CGFloat(storedActions.count)
            
            actionButton.sizeToFit()
            if actionButton.frame.width > maxActionButtonW, !isActionButtonsDistributedVertically{
                isActionButtonsDistributedVertically = true
            }
            messageBoxView.insertSubview(actionButton, at: 10)
        }
        if !isActionButtonsDistributedVertically{
            for actionButton in actionButtons{
                actionButton.titleLabel?.frame.size = CGSize(width: w/CGFloat(actionButtons.count), height: 0)
                actionButton.titleLabel?.sizeToFit()
                actionButton.frame.size = CGSize(width: (w + 2*spacing)/CGFloat(actionButtons.count), height: actionButton.frame.height+spacing)
            }
        }
        else {
            for actionButton in actionButtons{
                actionButton.titleLabel?.frame.size = CGSize(width: w/2, height: 0)
                actionButton.titleLabel?.sizeToFit()
                actionButton.frame.size = CGSize(width: w + 2*spacing, height: actionButton.frame.height+spacing)
            }
        }
    }
    @objc func didTapOnButton(){
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func resizing(){
        if messageBoxView.superview != nil{
            messageBoxView.removeFromSuperview()
        }
        messageBoxView.layer.cornerRadius = UI.messageBoxCornerRadius
        messageBoxView.clipsToBounds = true
        //MARK: set up messageBox.frame
        let w = UI.messageBoxSize.width
        let spacing = UI.messageBoxCornerRadius
        var h = spacing
        if let titleNode = titleNode{
            h += titleNode.frame.height + spacing
        }
        if let messageNode = messageNode{
            h += messageNode.frame.height + spacing
        }
        if !actionButtons.isEmpty{
            if isActionButtonsDistributedVertically{
                var totalButtonH = CGFloat.zero
                actionButtons.forEach{totalButtonH += $0.frame.height}
                h += totalButtonH
            }
            else{
                h += actionButtons.first!.frame.height
            }
        }
        if let webView = webView{
            webView.frame.size = CGSize(width: w - 2*spacing, height: UI.messageBoxSize.height - h - spacing)
            h = UI.messageBoxSize.height
        }
        let x = view.frame.width/2 - w/2
        let y = view.frame.height/2 - h/2
        
        messageBoxView.frame = CGRect(x: x, y: y, width: w, height: h)
        view.insertSubview(messageBoxView, at: 1)
    }
    fileprivate func setGradientBackground(){
        //MARK: set up message box background
        if backgroundLayer?.superlayer != nil{
            backgroundLayer?.removeFromSuperlayer()
            backgroundLayer = nil
        }
        backgroundLayer = CAGradientLayer()
        backgroundLayer?.frame = messageBoxView!.bounds
            backgroundLayer?.colors =
                [#colorLiteral(red: 0.3921568627, green: 0.5882352941, blue: 1, alpha: 1),#colorLiteral(red: 0.4352941176, green: 0.6823529412, blue: 0.9803921569, alpha: 1),#colorLiteral(red: 0.4784313725, green: 0.7764705882, blue: 0.937254902, alpha: 1)].map{$0.cgColor}
        
        backgroundLayer?.locations = [0,0.2,1]
        backgroundLayer?.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer?.endPoint = CGPoint(x: 0, y: 1)
        messageBoxView.layer.insertSublayer(backgroundLayer!, at: 0)
        //MARK: add lines
        if isActionButtonsDistributedVertically{
            for actionButton in actionButtons{
                let line = CAShapeLayer()
                let mutablePath = CGMutablePath()
                let startPoint = actionButton.frame.origin
                let endPoint = actionButton.frame.origin + CGPoint(x: actionButton.frame.width,y: 0)
                mutablePath.move(to: startPoint)
                mutablePath.addLine(to: endPoint)
                line.path = mutablePath
                line.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                line.lineWidth = UI.gridSize/6/20
                backgroundLayer?.insertSublayer(line, at: 3)
            }
        }
        else{
            for (i, actionButton) in actionButtons.enumerated(){
                let line = CAShapeLayer()
                let mutablePath = CGMutablePath()
                let startPoint = actionButton.frame.origin
                var endPoint = CGPoint.zero
                if i == 0{
                    endPoint = CGPoint(x: actionButtons.last!.frame.maxX ,y: actionButton.frame.origin.y)
                }
                else{
                    endPoint = actionButton.frame.origin + CGPoint(x: 0,y: actionButton.frame.height)
                }
                mutablePath.move(to: startPoint)
                mutablePath.addLine(to: endPoint)
                line.path = mutablePath
                line.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                line.lineWidth = UI.gridSize/6/20
                backgroundLayer?.insertSublayer(line, at: 3)
            }
        }
    }
    fileprivate func positioning(){
        let spacing = UI.messageBoxCornerRadius
        
        var y = spacing
        let w = UI.messageBoxSize.width
        //MARK: positioning titleNode
        if let titleNode = titleNode{
            let titleW = titleNode.frame.width
            titleNode.frame.origin = CGPoint(x: w/2 - titleW/2, y: y)
            y += titleNode.frame.height + spacing
        }
        //MARK: positioning messageNode
        if let messageNode = messageNode{
            let messageW = messageNode.frame.width
            messageNode.frame.origin = CGPoint(x: w/2 - messageW/2, y: y)
            y += messageNode.frame.height + spacing
        }
        
        //MARK: positioning and resize webView
        if let webView = webView{
            webView.frame.origin = CGPoint(x: w/2 - webView.frame.width/2, y: y)
            y += webView.frame.height + spacing
            
            //MARK: positioning activity view
            activityView!.frame.origin = webView.center +  messageBoxView.frame.origin
        }
        
        //MARK: positioning action button
        let maxActionButtonWidth = actionButtons.isEmpty ? 0 : w/CGFloat(actionButtons.count)
        if isActionButtonsDistributedVertically{
            for (i,actionButton) in actionButtons.enumerated(){
                actionButton.frame.origin = CGPoint(x: 0, y: y)
                y += actionButton.frame.height
                let buttonFrame = CGRect(origin: .zero, size: actionButton.frame.size)
                if i == actionButtons.count - 1{
                    actionButton.touchablePath = UIBezierPath(roundedRect: buttonFrame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: UI.messageBoxCornerRadius, height: UI.messageBoxCornerRadius) )
                }
                else{
                    actionButton.touchablePath = UIBezierPath(rect: buttonFrame)
                }
            }
        }
        else{
            var actionButtonX = CGFloat.zero
            for (i,actionButton) in actionButtons.enumerated(){
                actionButton.frame.origin = CGPoint(x: actionButtonX, y: y)
                actionButtonX += maxActionButtonWidth
                let buttonFrame = CGRect(origin: .zero, size: actionButton.frame.size)
                var byRoundingCorners: UIRectCorner = []
                if i == actionButtons.count - 1{ byRoundingCorners.formUnion(.bottomRight)
                }
                if i == 0{
                    byRoundingCorners.formUnion(.bottomLeft)
                }
                actionButton.touchablePath = UIBezierPath(roundedRect: buttonFrame, byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: UI.messageBoxCornerRadius, height: UI.messageBoxCornerRadius))
            }
        }
        
    }
    fileprivate var withoutUpdate = true
    var url: URL? = nil{
        didSet{
            setWebView()
            resizing()
            positioning()
            setGradientBackground()
        }
    }
    fileprivate var webView: WKWebView?
    fileprivate var activityView: UIActivityIndicatorView?
    fileprivate func setActivityView(){
        if activityView != nil{
            activityView?.removeFromSuperview()
        }
        activityView = UIActivityIndicatorView()
        view.insertSubview(activityView!, at: 100)
        let acOrigin = view.center
        activityView?.style = .whiteLarge
        activityView?.color = .darkGray
        activityView?.frame.origin = acOrigin
        activityView?.hidesWhenStopped = true
    }
    fileprivate func setWebView(){
        if webView?.superview != nil{
            webView?.removeFromSuperview()
        }
        if let url = url{
            webView = WKWebView(frame: CGRect(x: 10, y: 10, width: 100, height: 400))
            messageBoxView.insertSubview(webView!, at: 1)
            //let request = URLRequest(url: url)
            //webView?.load(request)
            webView?.loadFileURL(url, allowingReadAccessTo: url)
            webView?.navigationDelegate = self
            activityView?.startAnimating()
            webView?.layer.cornerRadius = UI.messageBoxCornerRadius/2
            webView?.clipsToBounds = true
        }
        else{
            webView = nil
        }
        
    }
    convenience init(title: String? = nil, message: String? = nil, url: URL? = nil, actions: [MessageAction] = []) {
        self.init()
        self.title = title
        self.message = message
        self.url = url
        withoutUpdate = false
        setActivityView()
        setupMessageBoxView()
        setTitle()
        setMessage()
        setWebView()
        addActions(actions)
        setButtons()
        resizing()
        positioning()
        setGradientBackground()
        print("con init")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        //view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        print("nib init")
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
extension URL{
//    fileprivate func htmlLocalizationURL() -> URL?{
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let path3 = Bundle.main.url(forResource: "help", withExtension: "html", subdirectory: nil, localization: SharedVariable.language.rawValue)
//        let bundle = Bundle(path: path!)
//    }
    //FIXME: default lang
    struct html{
        static var help: URL?{
            return Bundle.main.url(forResource: "help", withExtension: "html", subdirectory: nil, localization: SharedVariable.localization)
        }
        //static let help = URL(fileURLWithPath: Bundle.main.path(forResource: "help", ofType: "html")!)
    }
}
