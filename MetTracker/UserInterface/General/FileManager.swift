//
//  FileManager.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 05.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

func createDirectory() {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
    if !fileManager.fileExists(atPath: paths){
        try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
    }
}


func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}


func getImage(name: String) -> UIImage? {
    let fileManager = FileManager.default
    let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent(name)
    if fileManager.fileExists(atPath: imagePAth) {
        return UIImage(contentsOfFile: imagePAth)
    }else{
        return nil
    }
}


func saveImageDocumentDirectory(image: UIImage, name: String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    let imageData = UIImageJPEGRepresentation(image, 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}


func randomString() -> String {
    let pswdChars = Array("abcdefghijklmnopqrstuvwxyz")
    let rndPswd = String((0..<8).map { _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})
    return rndPswd
}



func compressImage (_ image: UIImage) -> UIImage {
    
    let actualHeight:CGFloat = image.size.height
    let actualWidth:CGFloat = image.size.width
    let imgRatio:CGFloat = actualWidth/actualHeight
    let maxWidth:CGFloat = 716.8
    let resizedHeight:CGFloat = maxWidth/imgRatio
    let compressionQuality:CGFloat = 0.7
    
    let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
    UIGraphicsEndImageContext()
    
    return UIImage(data: imageData)!
    
}
