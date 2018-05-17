//
//  UIExtensions.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import Foundation
import UIKit

func LS(_ S: String) -> String {

    return NSLocalizedString(S, comment: "")
    
}

extension UIImage {
    
    func tint(with color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIView {
    
    func roundCorners()
    {
        roundCorners(with: self.frame.size.height / 2.0)
    }
    
    func roundCorners(with radius: CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func addGradientWithColor(colorTop: UIColor, colorBottom: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension UIFont {
    
    static func medium(_ size : CGFloat) -> UIFont {
        return UIFont.init(name: "Quicksand-Medium", size: size)!
    }
    
}

extension Date {
    var components:DateComponents {
        let cal = NSCalendar.current
        return cal.dateComponents(Set([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .yearForWeekOfYear]), from: self)
    }
    
    func add(days : Int) -> Date? {
        
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: self)
        
    }

    
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getMonths(_ count: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: count, to: self)
    }
    
    
    func getFirstLastDaysOfWeek() -> (Date, Date) {
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        
        var endOfWeek : Date {
            var components = DateComponents()
            components.day = 7
            let date = Calendar.current.date(byAdding: components, to: mondayInWeek)
            return (date?.addingTimeInterval(-1))!
        }
        
        return (mondayInWeek, endOfWeek)
    }
    
}




extension Int {
    static func random(from: Int, to: Int) -> Int {
        guard to > from else {
            assertionFailure("Can not generate negative random numbers")
            return 0
        }
        return Int(arc4random_uniform(UInt32(to - from)) + UInt32(from))
    }
}


extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}



extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Quicksand-Medium", size: 35)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}





