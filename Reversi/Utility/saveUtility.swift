//
//  saveUtility.swift
//  Reversi
//
//  Created by john gospai on 2018/12/19.
//  Copyright © 2018 john gospai. All rights reserved.
//

import Foundation
import SpriteKit
class saveUtility{
    enum ErrorType: Error{
        case fileDoesNotExist
    }
    static func saveGames(games: [Reversi]){
        //save with JSONEncoder
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("games.dat")
        let encoder = JSONEncoder()
        print(path)
        guard let data = try? encoder.encode(games) else {
            print("saving game failed")
            return
        }
        try? data.write(to: path)
        
        //save with propertyList
//        path = URL.appendingPathComponent("games.plist")
//        let propertylist = PropertyListEncoder()
//        guard let propertyData = try? propertylist.encode(games) else{
//            return
//        }
//        try? propertyData.write(to: path)
        
        //UserDefaults.standard.set(data, forKey: "car")
    }
    static func loadGames() -> [Reversi]?{
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("games.dat")
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: path) else {return nil}
        // let data = UserDefaults.standard.data(forKey: "car")
        return try? decoder.decode([Reversi].self, from: data)
    }
    static func removeGamesData(){
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("games.dat")
        try? filemanager.removeItem(at: path)
    }
    static func saveImage(image: UIImage, filenameOfImage: String){
        let pngData = image.pngData()
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = URL.appendingPathComponent("\(filenameOfImage).png")
        do {try pngData?.write(to: path)}
        catch{print(error)}
    }
    static func saveImages(images: [UIImage], filenamesOfImages: [String]){
        if images.count == 0 {return}
        let pngDatas = images.map{$0.pngData()}
        UserDefaults.standard.set(pngDatas.count, forKey: "numberOfImages")
        UserDefaults.standard.set(filenamesOfImages, forKey: "filenamesOfImages")
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for i in 0...images.count - 1{
            let path = URL.appendingPathComponent("\(filenamesOfImages[i]).png")
            do {try pngDatas[i]?.write(to: path)}
            catch{print(error)}
        }
    }
    static func loadImage(scale: CGFloat, filenameOfImage: String) -> UIImage?{
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let path = URL.appendingPathComponent("\(filenameOfImage).png")
        guard let pngData = try? Data(contentsOf: path) else{return nil}
        let image = UIImage(data: pngData, scale: scale)!
    
        return image
    }
    static func loadImages(scale: CGFloat) -> [UIImage]?{
        var images: [UIImage] = []
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let numberOfImages = UserDefaults.standard.value(forKey: "numberOfImages") as! Int? else {return nil}
        if numberOfImages == 0 {return nil}
        guard let filenamesOfImages = UserDefaults.standard.value(forKey: "filenamesOfImages") as! [String]? else {return nil}
        for i in 0...numberOfImages - 1{
            let path = URL.appendingPathComponent("\(filenamesOfImages[i]).png")
            guard let pngData = try? Data(contentsOf: path) else{return nil}
            let image = UIImage(data: pngData, scale: scale)!
            images.append(image)
        }
        return images
//        var images: [UIImage] = []
//        let filemanager = FileManager()
//        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        for i in 0...numberOfImages - 1{
//            let path = URL.appendingPathComponent("imagesOfReview\(i).png")
//            guard let pngData = try? Data(contentsOf: path) else{return nil}
//            images.append(UIImage(data: pngData)!)
//        }
//        return images
    }
    static func removeImagesData(){
        let filemanager = FileManager()
        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let numberOfImages = UserDefaults.standard.value(forKey: "numberOfImages") as! Int? else {return}
        if numberOfImages == 0 {return}
         guard let filenamesOfImages = UserDefaults.standard.value(forKey: "filenamesOfImages") as! [String]? else {return}
        for i in 0...numberOfImages - 1{
            let path = URL.appendingPathComponent("\(filenamesOfImages[i]).png")
            do{ try filemanager.removeItem(at: path)}
            catch{print(error)}
        }
    }
//    static func saveReviews(reviews: [SKSpriteNode]){
//        //save with JSONEncoder
//        let filemanager = FileManager()
//        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        var path = URL.appendingPathComponent("reviews.dat")
//        let encoder = JSONEncoder()
//        let review = SKSpriteNode()
//        review.data
//        encoder.encode(imageOfReviews)
//        guard let data = try? encoder.encode(reviews.map{$0.texture?.cgImage()}) else {
//            print("saving car failed")
//            return
//        }
//        try? data.write(to: path)
//        
//        //save with propertyList
//        path = URL.appendingPathComponent("games.plist")
//        let propertylist = PropertyListEncoder()
//        guard let propertyData = try? propertylist.encode(games) else{
//            return
//        }
//        try? propertyData.write(to: path)
//        
//        //UserDefaults.standard.set(data, forKey: "car")
//    }
//    static func loadGames() -> [Reversi]?{
//        let filemanager = FileManager()
//        let URL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let path = URL.appendingPathComponent("games.dat")
//        let decoder = JSONDecoder()
//        guard let data = try? Data(contentsOf: path) else {return nil}
//        // let data = UserDefaults.standard.data(forKey: "car")
//        return try? decoder.decode([Reversi].self, from: data)
//    }
}
