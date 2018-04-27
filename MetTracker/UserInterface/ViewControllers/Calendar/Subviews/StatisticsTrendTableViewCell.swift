//
//  StatisticsTrendTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsTrendTableViewCell: StatisticsTableViewCell {
    
    @IBOutlet weak var periodOfStatistics: MTLabel!
    @IBOutlet weak var scheduleView: UIView!

    let pointsSize: CGFloat = 10
    
    
    
    var pointsXY = [CGPoint]() {
        didSet {
            let pnt = CGPoint(x: (pointsXY.last?.x)!, y: (pointsXY.last?.y)!)
            let point = createPointWith(frame: CGRect(x: pnt.x, y: pnt.y, width: pointsSize, height: pointsSize))
            scheduleView.addSubview(point)
            
            let lbl = addMonths(point: pnt, index: pointsXY.count - 1)
            scheduleView.addSubview(lbl)
            let lblMets = addMets(point: pnt, index: pointsXY.count - 1)
            scheduleView.addSubview(lblMets)
            
            if pointsXY.count == currentMonths.count {
                
                shapeLayerFill = CAShapeLayer()
                scheduleView.layer.insertSublayer(shapeLayerFill, at: 0)
                drawFillOfStatistics(sl: shapeLayerFill, frame: scheduleView.bounds, points: pointsXY)
                
                shapeLayer = CAShapeLayer()
                scheduleView.layer.insertSublayer(shapeLayer, at: 1)
                shapeLayerConfig(shapeLayer, frame: scheduleView.bounds, points: pointsXY)
            }
        }
    }
    
    var shapeLayer: CAShapeLayer! {
        didSet {
            shapeLayer.lineWidth = 3
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = Config.shared.baseColor().cgColor
            shapeLayer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    var shapeLayerFill: CAShapeLayer! {
        didSet {
            shapeLayerFill.lineWidth = 3
            shapeLayerFill.fillColor = Config.shared.baseColor().withAlphaComponent(0.2).cgColor
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    

    
    override func prepareForReuse() {
        
        
        calculatePoints(currentMonths.count, frame: scheduleView.frame)
        periodOfStatistics.text = "\(currentMonths.count) \(LS("month_trend"))"
    }

    
    func calculatePoints(_ countOfPoints: Int, frame: CGRect) {
       
        let between = frame.width / CGFloat(countOfPoints - 1)
        for point in 0...countOfPoints - 1 {
            var xY = CGPoint.zero
            xY.x = between * CGFloat(point)
            
            let progMaxWidth = frame.height - pointsSize - 80.0
            let countM = mets[point].reduce(0, +).rounded(toPlaces: 2)
            let countMets = countM > 72 ? 72 : countM
            let percentFromMets = (countMets * 100) / 72
            let progressWidth = progMaxWidth * CGFloat(percentFromMets) / 100
            let height = progMaxWidth - progressWidth + 40.0
            
            xY.y = height
            pointsXY.append(xY)
        }
    }
    
    
    func createPointWith(frame: CGRect) -> UIView {
        
        let pointView = UIView(frame: frame)
        pointView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pointView.layer.cornerRadius = pointView.frame.height / 2
        pointView.layer.borderColor = Config.shared.baseColor().cgColor
        pointView.layer.borderWidth = 2
        
        return pointView
    }
    
    
    func shapeLayerConfig(_ sl: CAShapeLayer, frame: CGRect, points: [CGPoint]) {
        
        sl.frame = frame
        let myPath = UIBezierPath()
        
        if points.count > 1 {
            
            myPath.move(to: CGPoint(x: points[0].x + (pointsSize / 2), y: points[0].y + (pointsSize / 2)))
            
            for i in 1 ..< points.count {
                myPath.addLine(to: CGPoint(x: points[i].x + (pointsSize / 2), y: points[i].y + (pointsSize / 2)))
            }
            sl.path = myPath.cgPath
        } else {
            sl.path = nil
        }
    }
    
    
    func drawFillOfStatistics(sl: CAShapeLayer, frame: CGRect, points: [CGPoint]) {
        sl.frame = frame
        let myPath = UIBezierPath()
        
        if points.count > 1 {
            
            myPath.move(to: CGPoint(x: points[0].x + (pointsSize / 2), y: points[0].y + (pointsSize / 2)))
            
            for i in 1 ..< points.count - 1 {
                myPath.addLine(to: CGPoint(x: points[i].x + (pointsSize / 2), y: points[i].y + (pointsSize / 2)))
            }
            
            myPath.addLine(to: CGPoint(x: (points.last?.x)! + pointsSize / 2, y: (points.last?.y)! + pointsSize / 2))
            myPath.addLine(to: CGPoint(x: scheduleView.frame.width + pointsSize / 2, y: scheduleView.frame.height - 40.0))
            myPath.addLine(to: CGPoint(x: scheduleView.frame.origin.x + (pointsSize / 2), y: scheduleView.frame.height - 40.0))
            myPath.addLine(to: CGPoint(x: (points.first?.x)! + (pointsSize / 2), y: (points.first?.y)! + (pointsSize / 2)))
            
            sl.path = myPath.cgPath
        } else {
            sl.path = nil
        }
    }
    
    
    func addMonths(point: CGPoint, index: Int) -> UILabel {
        
        let lb = MTLabel()
        lb.text = Calendar.current.shortMonthSymbols[currentMonths[index] - 1]
        let lblWidth: CGFloat = Config.shared.textSizeIsEnlarged() ? 40.0 : 34.0
        let lblHeight: CGFloat = Config.shared.textSizeIsEnlarged() ? 30.0 : 25.0
        lb.frame = CGRect(x: point.x == 0 ? 0 : point.x - pointsSize, y: scheduleView.frame.height - lblHeight - 10, width: lblWidth, height: lblHeight)
        lb.textAlignment = .center
        lb.font = UIFont.medium(Config.shared.textSizeIsEnlarged() ? 18.0 : 14.0)
        
        return lb
    }
    
    
    func addMets(point: CGPoint, index: Int) -> UILabel {
        
        let lb = MTLabel()
        let sumOfMets = mets[index].reduce(0, +).rounded(toPlaces: 2)
        lb.text = "\(sumOfMets)"
        let lblWidth: CGFloat = Config.shared.textSizeIsEnlarged() ? 60.0 : 45.0
        lb.frame = CGRect(x: point.x == 0 ? 0 : point.x - pointsSize, y: point.y - 35.0, width: lblWidth, height: 25)
        lb.textAlignment = .center
        lb.font = UIFont.medium(Config.shared.textSizeIsEnlarged() ? 18.0 : 14.0)
        
        return lb
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
