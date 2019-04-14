//
//  MessageAction.swift
//  Reversitest2
//
//  Created by john gospai on 2019/3/29.
//  Copyright © 2019 john gospai. All rights reserved.
//

////m
import UIKit
class MessageAction{
    var title = ""
    var style = UIAlertAction.Style.default
    var handler: (() -> Void) = {}
    init(title: String, style: UIAlertAction.Style, handler: @escaping (() -> Void) = {}) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
////m
