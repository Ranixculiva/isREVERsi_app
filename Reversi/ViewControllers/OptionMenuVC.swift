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
        optionMenu = OptionMenu(VC: self)
        optionMenuScene.addChild(optionMenu)
        optionMenuScene.backgroundColor = .clear
        let optionMenuView = SKView(frame: UIScreen.main.bounds)
        optionMenuView.backgroundColor = .clear
        optionMenuView.allowsTransparency = true
        optionMenuView.presentScene(optionMenuScene)
        view.insertSubview(optionMenuView, at: 1)
        
        //MARK: set up close button and action
        let closeButtonFrame = CGRect(
            x: UI.frameWidth/2 - optionMenu.size.width/2 + UI.optionMenuSpacing/2,
            y: UI.frameHeight/2 - optionMenu.size.height/2 + UI.optionMenuSpacing/2,
            width: UI.closeButtonWidth,
            height: UI.closeButtonHeight)
        let closeButton = UIButton(frame: closeButtonFrame)
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(tapOnCloseButton), for: .touchUpInside)
        optionMenuView.insertSubview(closeButton, at: 10)
        
        //MARK: set up confirm button and action
        let confirmButtonFrame = CGRect(
            x: UI.frameWidth/2 + optionMenu.size.width/2 - UI.optionMenuSpacing/2 - UI.confirmButtonWidth,
            y: UI.frameHeight/2 - optionMenu.size.height/2 + UI.optionMenuSpacing/2,
            width: UI.confirmButtonWidth,
            height: UI.confirmButtonHeight)
        let confirmButton = UIButton(frame: confirmButtonFrame)
        confirmButton.setBackgroundImage(#imageLiteral(resourceName: "confirm"), for: .normal)
        confirmButton.addTarget(self, action: #selector(tapOnConfirmButton), for: .touchUpInside)
        
        optionMenuView.insertSubview(confirmButton, at: 10)
        
        //MARK: save variables
        optionMenu.savedVariables[.originalNeedToGuide] = SharedVariable.needToGuide
        optionMenu.savedVariables[.originalLanguageOption] = SharedVariable.language
        optionMenu.savedVariables[.originalVolumeOption] = SharedVariable.bgmVolumeRatio
    }
    @objc func tapOnCloseButton(){
        SharedVariable.needToGuide = optionMenu.savedVariables[.originalNeedToGuide]! as! Bool
        SharedVariable.language = optionMenu.savedVariables[.originalLanguageOption]! as! SharedVariable.lang
        SharedVariable.bgmVolumeRatio = optionMenu.savedVariables[.originalVolumeOption]! as! Float
        self.dismiss(animated: true){ [unowned self] in
            self.delegate?.didTapOnButton?(type: .close, sender: self.optionMenu)
        }
    }
    @objc func tapOnConfirmButton(){
        SharedVariable.save()
        self.dismiss(animated: true){[unowned self] in
            self.delegate?.didTapOnButton?(type: .confirm, sender: self.optionMenu)
        }
        
    }
}
