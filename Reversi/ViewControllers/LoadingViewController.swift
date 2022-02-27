//
//  LoadingViewController.swift
//  Reversi
//
//  Created by john gospai on 2019/8/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    deinit {
        print("LoadingVC deinit")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadingLabel.text = UI.Texts.loading
        loadingLabel.font = UIFont(name: UI.loadingTextFontName, size: UI.loadingPhaseFontSize)
        loadingLabel.sizeToFit()
        loadingLabel.frame.origin = view.center - CGPoint(x: loadingLabel.frame.width/2, y: loadingLabel.frame.height/2)
    }
    fileprivate var loadingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.colors =
            [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)].map{$0.cgColor}
        
        backgroundLayer.locations = [0,0.5,1]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(backgroundLayer, at: 0)
        loadingLabel = UILabel()
        //FIXME: texts loading not update when change language
        loadingLabel.text = UI.Texts.loading
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont(name: UI.loadingTextFontName, size: UI.loadingPhaseFontSize)
        loadingLabel.sizeToFit()
        loadingLabel.frame.origin = view.center - CGPoint(x: loadingLabel.frame.width/2, y: loadingLabel.frame.height/2)
        view.insertSubview(loadingLabel, at: 10)
        // Do any additional setup after loading the view.
    }

}
