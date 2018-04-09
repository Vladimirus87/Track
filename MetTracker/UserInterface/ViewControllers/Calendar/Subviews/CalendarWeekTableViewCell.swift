//
//  CalendarWeekTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

public extension Int {
    static func random(from: Int, to: Int) -> Int {
        guard to > from else {
            assertionFailure("Can not generate negative random numbers")
            return 0
        }
        return Int(arc4random_uniform(UInt32(to - from)) + UInt32(from))
    }
}


import UIKit

class CalendarWeekTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWeek: UICollectionView!
    
    var data: [String]?
    let cellIdentifier = "CalendarWeekDayCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    
    
    override func prepareForReuse() {
        data = nil
        collectionViewWeek.delegate = self
        collectionViewWeek.dataSource = self
        
        collectionViewWeek.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        progressWidth.constant = CGFloat(Int.random(from: 0, to: Int(UIScreen.main.bounds.width - 48)))
        
        viewProgress.backgroundColor = Config.shared.baseColor()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 7
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarWeekDayCollectionViewCell
        
        if let day = data?[indexPath.row] {
            cell.labelDay.text = day
            cell.labelWeekday.text = Calendar.current.shortWeekdaySymbols[indexPath.row]
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWeek.frame.width / 7, height: collectionViewWeek.frame.height)
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
