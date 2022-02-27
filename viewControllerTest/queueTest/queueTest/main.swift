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
    enum a: Equatable {
        static func == (lhs: A.a, rhs: A.a) -> Bool {
            switch (lhs,rhs){
            case (.c(let c1), .c(let c2)):
                return c1 == c2
            case (.b(let b1), .b(let b2)):
                switch(b1,b2){
                case (.c(let c1),.c(let c2)):
                    return c1 == c2
                case (.d,.d):
                    return true
                default:
                    return false
                }
            default:
                return false
            }
            
        }
        
        case c(C)
        case b(B)
        
        
        enum B{
            case c(C)
            case d
            enum C{
                case d
                case e
            }
        }
        enum C{
            case d
            case e
        }
    }
}
print(A.a.b(.d) == A.a.b(.d))
