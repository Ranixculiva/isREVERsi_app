//
//  main.swift
//  queueTest
//
//  Created by john gospai on 2019/8/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import Foundation
import SpriteKit
//let serialQueue = DispatchQueue(label: "com.Ranixculiva.ISREVERSI", qos: .userInitiated)
//let group = DispatchGroup()
//group.enter()
//
//serialQueue.sync {
//    group.enter()
//    for j in 0...10{
//        print(j)
//    }
//    print("done")
//    group.leave()
//    DispatchQueue.main.async{
//        for d in 11...20{
//            print(d)
//        }
//        group.leave()
//    }
//}
//group.notify(queue: .main){
//    print("done")
//}
//class A{
//    deinit {
//        print(self.name,"which is class A has been deinited.")
//    }
//    var a: A? = nil
//    var name = ""
//    var redundent = Array(repeating: 10, count: 1048576)
//    convenience init?(name: String){
//        self.init()
//        self.name = name
//    }
//}
//class B {
//    var a = A()
//    init() {
//        a = A(name: "second")!
//    }
//}
//for _ in 1...10{
//    var b = B()
//}
//print("done")
//for _ in 1...100{
//    var anA = A(name: "")!
//    anA.a = anA
//}
//print("done")
class A{
    
}
var a: A!
a = A()
print(type(of: a))
for i in 0...10{
    var a = A()
}
print("done")

