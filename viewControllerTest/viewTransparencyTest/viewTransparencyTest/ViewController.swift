//
//  ViewController.swift
//  viewTransparencyTest
//
//  Created by john gospai on 2019/8/20.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.backgroundColor = .green
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func tapOnButton(){
        let storyBoard = UIStoryboard(name: "alert", bundle: .main)
        let alert = storyBoard.instantiateViewController(withIdentifier: "alertVC")
        present(alert, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }


}

