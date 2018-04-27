//
//  TrackingSuccessImageTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//




import UIKit
import UICircularProgressRing


protocol TrackingSuccessImageTableViewCellDelegate {
    func endAnimation()
}

class TrackingSuccessImageTableViewCell: UITableViewCell, UICircularProgressRingDelegate {


    @IBOutlet weak var metsCount: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    var delegate: TrackingSuccessImageTableViewCellDelegate?
    var progress: UICircularProgressRingView!
    
    let planMetsCount = UserDefaults.standard.value(forKey: "planMetsCount") as? Float ?? 18.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
  
    
    
    func startAnimationWith(lastUserMetsCount: Float, newUserMetsCount: Float) {
        
        progress = UICircularProgressRingView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 60, y: 35, width: 120, height: 120))
        
        progress.maxValue = CGFloat(planMetsCount)
        progress.value = CGFloat(lastUserMetsCount)
        progress.outerRingColor = Config.shared.baseColor(0.3)
        progress.shouldShowValueText = false
        progress.outerRingWidth = 13
        progress.innerRingWidth = 13
        progress.ringStyle = .gradient
        progress.startAngle = 270
        progress.innerRingColor = Config.shared.baseColor()
        progress.delegate = self
        
        self.contentView.addSubview(progress)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.progress.setProgress(to: CGFloat(newUserMetsCount), duration: 1.5, completion: {
                if newUserMetsCount > self.planMetsCount {
                    if let delegate = self.delegate {
                        delegate.endAnimation()
                    }
                }
            })
        }
    }

    
    func didUpdateProgressValue(for ring: UICircularProgressRingView, to newValue: CGFloat) {
        
        let formattedString = NSMutableAttributedString()
        let metsProgInfo = formattedString.bold("\(Float(newValue).rounded(toPlaces: 2))").normal("/\(planMetsCount)")
        metsCount.attributedText = metsProgInfo
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
