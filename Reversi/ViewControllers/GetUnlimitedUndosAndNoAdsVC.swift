//
//  getUnlimitedUndosAndNoAdsVC.swift
//  Reversi
//
//  Created by john gospai on 2019/9/24.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
import UIKit

class GetUnlimitedUndosAndNoAdsVC: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        //MARK: set up background
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.colors =
            [#colorLiteral(red: 0.8328224696, green: 0.9371918091, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.7774476259, blue: 0.8279836738, alpha: 1),#colorLiteral(red: 0.8265523245, green: 0.9354773165, blue: 0.9764705896, alpha: 1)].map{$0.cgColor}
        
        backgroundLayer.locations = [0,0.5,1]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(backgroundLayer, at: 1)
        
        //MARK: set up image
        let w = UI.frameWidth/4
        let h = w
        let x = view.center.x - w/2
        let y = view.center.y - h/2
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        imageView.image = #imageLiteral(resourceName: "UndoAndNoAds")
        view.insertSubview(imageView, at: 2)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
