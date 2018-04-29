//
//  CalendarWeekTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//




import UIKit

class CalendarWeekTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWeek: UICollectionView!

    var trackingData : [Tracking]?
    var data: [String]?{
        didSet{
            if data?.count == 7 {
                DispatchQueue.main.async {
                    self.collectionViewWeek.reloadData()
                }
            }
        }
    }
    
    let cellIdentifier = "CalendarWeekDayCollectionViewCell"
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    
    override func prepareForReuse() {
        collectionViewWeek.delegate = self
        collectionViewWeek.dataSource = self
        
        collectionViewWeek.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        progressWidth.constant = 0
        
        getTrackData()
    }
    
    
    func getTrackData() {
        do {
            trackingData = try contex.fetch(Tracking.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 7
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewWeek.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarWeekDayCollectionViewCell

        let symbolwOfWeek = getWeekDay()
        
        
        if let day = data?[indexPath.row] {
            cell.configureCell(date: day, trDates: trackingData,  weekday: symbolwOfWeek[indexPath.row])
        }
        
        return cell
    }
    
    
    func getWeekDay() -> [String] {
        
        let firstWeekday = 2
        let arr = Calendar.current.shortWeekdaySymbols
        let symbols = Array(arr[firstWeekday-1..<arr.count]) + arr[0..<firstWeekday-1]
        
        return symbols
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
