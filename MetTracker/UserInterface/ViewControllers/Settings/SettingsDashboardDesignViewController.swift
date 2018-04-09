//
//  SettingsDashboardDesignViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//
//UserDefaults.standard.set(0, forKey: "designTheme")
import UIKit

class SettingsDashboardDesignViewController: MTViewController {

    
    @IBOutlet weak var tableViewData: UITableView!
    
    var data = ["motivational quotes", "picture", "crustanceans"]
    var pictureData = [Design](){
        didSet {
            if pictureData.count > 0 {
                let checked = pictureData.filter { $0.selected == true }
                
                if checked.count == 0 {
                    pictureData.first?.selected = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
    }
    
    let cellIdentifiers = ["SettingsDashboardDesignTableViewCell",
                          "SettingsPictureTableViewCell"]
    
    var imagePicker = UIImagePickerController()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        tableViewData.delegate = self
        tableViewData.dataSource = self
        
        getData()
    }

    
    
    @IBAction func addPressed(_ sender: MTButton) {
    
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        do {
            pictureData = try contex.fetch(Design.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    func roundToInt(_ double: Double) -> Int {
        let number = Int(double)
        if Double(number) < double {
            return Int(double) + 1
        }
        return Int(double)
    }
    
    
    func lastRowHeight(_ pictCount: Int) -> CGFloat {
        
        let temp: Double = Double(pictCount) / 3.0
        let countOfRows = CGFloat(roundToInt(temp))
        let sum = (countOfRows * 88.0) + 46.0
        
        return sum
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension SettingsDashboardDesignViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == data.count {
        
        let picturesCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[1], for: indexPath) as! SettingsPictureTableViewCell
            
            picturesCell.delegate = self
            
            return picturesCell
            
        } else {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[0], for: indexPath) as! SettingsDashboardDesignTableViewCell
            
            cell.nameOfDesign.text = data[indexPath.row]
            cell.check.isHidden = UserDefaults.standard.integer(forKey: "designTheme") == indexPath.row ? false : true
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == data.count {
            return lastRowHeight(pictureData.count)
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(indexPath.row, forKey: "designTheme")
        tableView.reloadData()
        /// SEND NOTIFICATION !
    }
    
}




extension SettingsDashboardDesignViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        
        let rndm = randomString()
        
        DispatchQueue.main.async {
            saveImageDocumentDirectory(image: chosenImage, name: rndm)
            saveImageDocumentDirectory(image: compressImage(chosenImage), name: rndm + "small")
            
            let newPicture = Design(context: self.contex)
            newPicture.date = NSDate()
            newPicture.picturePath = rndm
            newPicture.selected = false
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let ip = IndexPath(row: self.data.count, section: 0)
            
            if let cell = self.tableViewData.cellForRow(at: ip) as? SettingsPictureTableViewCell {
                cell.getData()
                cell.imagesCollectionView.reloadData()
            }
            
            self.getData()
            self.tableViewData.reloadData()
            self.dismiss(animated:true, completion: nil)
        }
    }
}




extension SettingsDashboardDesignViewController: SettingsPictureTableViewCellDelegate {
    
    func deleteCellWith(indexPath: IndexPath) {

        self.contex.delete(self.pictureData[indexPath.row])
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        let ip = IndexPath(row: self.data.count, section: 0)
        if let cell = self.tableViewData.cellForRow(at: ip) as? SettingsPictureTableViewCell {
            cell.getData()
            cell.imagesCollectionView.reloadData()
        }
        self.getData()
        self.tableViewData.reloadData()
        
    }
    
    
}


