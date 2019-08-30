//
//  OptionContainer.swift
//  Reversi
//
//  Created by john gospai on 2019/7/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit
import SpriteKit
@objc protocol optionMenuDelegate: AnyObject {
    @objc optional func didTapOnButton(type: OptionMenuVC.type, sender: OptionMenu)
}
class OptionMenuVC: UIViewController{
    deinit {
        print("optionMenuVC deinit")
    }
    @objc enum type: Int{
        case close = 0, confirm
    }
    weak var delegate: optionMenuDelegate? = nil
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate var optionMenu: OptionMenu!
    override func viewDidLoad() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
        
        let optionMenuScene = SKScene(size: UI.rootSize)
        optionMenuScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        optionMenu = OptionMenu()
        optionMenuScene.addChild(optionMenu)
        optionMenuScene.backgroundColor = .clear
        let optionMenuView = SKView(frame: UIScreen.main.bounds)
        optionMenuView.backgroundColor = .clear
        optionMenuView.allowsTransparency = true
        optionMenuView.presentScene(optionMenuScene)
        view.insertSubview(optionMenuView, at: 1)
        
        //MARK: set up close button and action
        let closeButton = UIButton(frame: UI.closeButtonFrame)
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(tapOnCloseButton), for: .touchUpInside)
        optionMenuView.insertSubview(closeButton, at: 10)
        
        //MARK: set up confirm button and action
        let confirmButton = UIButton(frame: UI.confirmButtonFrame)
        confirmButton.setBackgroundImage(#imageLiteral(resourceName: "confirm"), for: .normal)
        confirmButton.addTarget(self, action: #selector(tapOnConfirmButton), for: .touchUpInside)
        
        optionMenuView.insertSubview(confirmButton, at: 10)
        
        //MARK: save variables
        optionMenu.savedVariables[.originalLanguageOption] = SharedVariable.language
    }
    @objc func tapOnCloseButton(){
        self.dismiss(animated: true){ [unowned self] in
            self.delegate?.didTapOnButton?(type: .close, sender: self.optionMenu)
        }
    }
    @objc func tapOnConfirmButton(){
        self.dismiss(animated: true){[unowned self] in
            self.delegate?.didTapOnButton?(type: .confirm, sender: self.optionMenu)
        }
        
    }
}
