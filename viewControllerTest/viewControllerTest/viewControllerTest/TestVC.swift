//
//  TestVC.swift
//  viewControllerTest
//
//  Created by john gospai on 2019/8/19.
//  Copyright © 2019 john gospai. All rights reserved.
//

import UIKit
import SpriteKit
class TestVC: UIViewController{


//    @objc func touchUpInsideTheCloseButton(){
//        self.dismiss(animated: true, completion: {})
//    }
//    override func loadView() {
//        self.view = SKView()
//
//    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate var stackView = UIStackView()
    @objc func didTapButton(){
        print("touched")
    }
    override func viewDidLoad() {
//        let view1 = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//
//        view1.lineBreakMode = .byWordWrapping
//        view1.numberOfLines = 0
//        view1.text = "asdafjil j fialsjf jele jifejf  f klfjsfk jsdlf as sd fasdfjas s fa;s ;asdfsjf akfj ;f ;sdlfjl fjas ;asj lsf sdf s; fjkf s;a sdklf ; "
//        view1.font = UIFont.preferredFont(forTextStyle: .title1)
//        view1.textColor = .red
//        view1.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        view1.sizeToFit()
//        view.addSubview(view1)
//        let view2 = UIView()
//        view2.backgroundColor = .cyan
//        view2.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        view2.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//
//        class A: UIButton{
//            override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//                return point(inside: touch.location(in: self), with: event)
//            }
//            override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//                return UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)), cornerRadius: 75).contains(point)
//            }
//        }
//        let view3 = UIView()
//        let button = A(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
//        view3.clipsToBounds = true
//        button.backgroundColor = .red
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        button.setTitle("afjile", for: .normal)
//        button.setTitle("tapped", for: .highlighted)
//        button.sizeToFit()
//        view3.addSubview(button)
//        view3.backgroundColor = .green
//        view3.layer.cornerRadius = 75
//        view3.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        view3.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        let view4 = UIView()
//        let button1 = A(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
//        view4.clipsToBounds = true
//        button1.backgroundColor = .green
//        button1.addTarget(self, action: #selector(didTapButton1), for: .touchDown)
//        view4.addSubview(button1)
//        view4.backgroundColor = .red
//        view4.layer.cornerRadius = 75
//        view4.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        view4.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
//        let view5 = UIButton()
//
//        view5.titleLabel?.lineBreakMode = .byCharWrapping
//        view5.titleLabel?.numberOfLines = 0
//        view5.titleLabel?.frame.size = CGSize(width: 100, height: 0)
//        view5.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
//        view5.setTitle("asdafjil j fialsjf jele jifejf  f klfjsfk jsdlf as sd fasdfjas s fa;s ;asdfsjf akfj ;f ;sdlfjl fjas ;asj lsf sdf s; fjkf s;a sdklf ; ", for: .normal)
//        view5.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        view5.heightAnchor
//        view5.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        view5.backgroundColor = .blue
//
//
//
//
//
//
//
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .center
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addArrangedSubview(view1)
//        stackView.addArrangedSubview(view2)
//        stackView.addArrangedSubview(view3)
//        stackView.addArrangedSubview(view4)
//        //view.addSubview(view5)
//        stackView.addArrangedSubview(view5)
//        view.addSubview(stackView)
        let view5 = UIButton(frame: CGRect(x: 100, y: 100, width: 0, height: 0))
        view5.setTitle("world is so beautful. And I want to turn it into a heaven.", for: .normal)
        view5.titleLabel?.lineBreakMode = .byWordWrapping
        view5.titleLabel?.numberOfLines = 0
        view5.titleLabel?.frame = CGRect(x: 100, y: 100, width: 10, height: 10)
        //view5.titleLabel?.sizeToFit()
        view5.backgroundColor = .blue
        view5.sizeToFit()
        
        
    }
    @objc func didTapButton1(){
        print("1")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
