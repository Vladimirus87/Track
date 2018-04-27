//
//  SettingsPictureTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

protocol SettingsPictureTableViewCellDelegate {
    func deleteCellWith(indexPath: IndexPath)
}

class SettingsPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var sectionTitle: MTLabel!
    
    var delegate: SettingsPictureTableViewCellDelegate?
    
    let cellIdentifier = "SettingsPictureCollectionViewCell"
    var data = [Design]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        sectionTitle.text = LS("choose_img")
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self

        self.imagesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        getData()
        imagesCollectionView.reloadData()
        
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.8
        lpgr.delegate = self
        self.imagesCollectionView.addGestureRecognizer(lpgr)
    }
    
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {

        if gesture.state == .ended {
            return
        }
        
        let p = gesture.location(in: self.imagesCollectionView)
        
        if let indexPath = self.imagesCollectionView.indexPathForItem(at: p) {
            
            if let delegate = delegate {
                delegate.deleteCellWith(indexPath: indexPath)
            }
        }
    }
    
    func getData() {
        do {
            data = try contex.fetch(Design.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


// MARK: - CollectionView

extension SettingsPictureTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SettingsPictureCollectionViewCell
        
        cell.imageURL = data[indexPath.row].picturePath
        cell.checkBox.isHidden = data[indexPath.row].selected ? false : true
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: - LastCellDelegate

extension SettingsPictureTableViewCell: PictureCellDelegate {
    
    func picturePressed(cell: UICollectionViewCell) {

        guard let ip = imagesCollectionView.indexPath(for: cell) else { return }
        var arrForReload = [ip]
        var lastCheckIP: IndexPath? {
            didSet {
                arrForReload.append(lastCheckIP!)
            }
        }
        
        for image in data {
            if image.selected == true && image != data[ip.row] {
                image.selected = false
                let index = data.index(of: image)
                lastCheckIP = IndexPath(row: index!, section: 0)
            }
        }
        data[ip.row].selected = true
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        getData()
        
        imagesCollectionView.reloadItems(at: arrForReload)
    }
    
}

