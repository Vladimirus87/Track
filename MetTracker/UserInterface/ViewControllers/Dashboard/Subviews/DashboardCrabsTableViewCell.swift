//
//  DashboardCrabsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardCrabsTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    
    var dataArray : NSArray!

    var daysWithoutActivity: Int = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = Bundle.main.path(forResource: "Crabs", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)
//
//        let array = createCrabs(arr: dataArray)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.crabsCreator(images: array)
//        }

    }
    
    
    func createCrabs(arr: NSArray) -> [UIImageView] {

        var arrImages = [UIImageView]()
        for imageName in arr {
            if let img = imageName as? String {
                let new = UIImageView()
                let crab = UIImage(named: img)
                new.image = crab
                arrImages.append(new)
            }
        }
        return arrImages
    }
    
    
    func crabsCreator(images: [UIImageView]) {
        
        var counter = 0
        
        for side in 0...3 {
            let points = randomPoint(for: side, crabs: dataArray.count - 1)
            for point in points {
                let img = images[counter]
                img.frame = CGRect(x: point.x, y: point.y, width: sizeForCrab(days: daysWithoutActivity), height: sizeForCrab(days: daysWithoutActivity))
                self.addSubview(img)
                counter += 1
            }
        }
 
    }
    
    
    func randomPoint(for side: Int, crabs count: Int) -> [CGPoint] {
        
        var point = [CGPoint]()

        let part = Double(count) / 4.0
        let crabsInPart = Double(Int(part)) + Double(side) * 0.25 <= part ? Int(part) + 1 : Int(part)
        
        switch side {
        case 0:
            //left
            for i in 0...crabsInPart - 1 {
                let yHeight = (background.frame.height / CGFloat(crabsInPart))
                
                let onePoint = CGPoint(x: /*CGFloat(Int.random(from: 3, to: 20))*/ 3, y: CGFloat(Int.random(from: Int(yHeight * CGFloat(i)), to: Int(yHeight * CGFloat(i + 1)))))
                point.append(onePoint)
            }
        case 1:
            //right
            for i in 0...crabsInPart - 1 {
                let yHeight = (background.frame.height / CGFloat(crabsInPart))
                
                let onePoint = CGPoint(x: /*CGFloat(Int.random(from: Int(background.frame.width - sizeForCrab(days: daysWithoutActivity)) - 20, to: Int(background.frame.width - sizeForCrab(days: daysWithoutActivity)) - 3))*/background.frame.width - (sizeForCrab(days: daysWithoutActivity)/2), y: CGFloat(Int.random(from: Int(yHeight * CGFloat(i)), to: Int(yHeight * CGFloat(i + 1)))))
                point.append(onePoint)
            }
        case 2:
            //up
            for i in 0...crabsInPart - 1 {
                let xHeight = (background.frame.width - (sizeForCrab(days: daysWithoutActivity) * 2) / CGFloat(crabsInPart))
                
                let onePoint = CGPoint(x: CGFloat(Int.random(from: Int(xHeight * CGFloat(i) + sizeForCrab(days: daysWithoutActivity)), to: Int(xHeight * CGFloat(i + 1) + sizeForCrab(days: daysWithoutActivity)))), y: CGFloat(Int.random(from: 3, to: 20)))
                point.append(onePoint)
            }
        case 3:
            //down
            for i in 0...crabsInPart - 1 {
                let xHeight = (background.frame.width / CGFloat(crabsInPart))
                
                let onePoint = CGPoint(x: CGFloat(Int.random(from: Int(xHeight * CGFloat(i) + sizeForCrab(days: daysWithoutActivity)), to: Int(xHeight * CGFloat(i + 1) + sizeForCrab(days: daysWithoutActivity)))), y: CGFloat(Int.random(from: Int(background.frame.height) - 20, to: Int(background.frame.height) - 3)))
                point.append(onePoint)
            }
        default:
            print("w")
        }
        
        
        return point
    }
    
    
    func sizeForCrab(days: Int) -> CGFloat {
        let size: CGFloat = CGFloat(10 * days)
        
        return size
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
