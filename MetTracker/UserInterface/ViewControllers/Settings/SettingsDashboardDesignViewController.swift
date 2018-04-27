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
    
    @IBOutlet weak var buttonBackView: UIView!
    
    @IBOutlet weak var underButtonText: MTLabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var chooseBtn: MTButton!
    @IBOutlet weak var tableViewData: UITableView!
    
    var data = ["motivational quotes", "picture"]
    var firstQuote: NSDictionary!
    
    var pictureData = [Design](){
        didSet {
            DispatchQueue.main.async {
                if self.pictureData.count > 0 {
                    let checked = self.pictureData.filter { $0.selected == true }
                    if checked.count == 0 {
                        self.pictureData.first?.selected = true
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }
            }
        }
    }
  
    
    let cellIdentifiers = ["SettingsDashboardDesignTableViewCell",
                           "SettingsPictureTableViewCell", "DashboardQuoteTableViewCell"]
    
    var imagePicker = UIImagePickerController()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        let path = Bundle.main.path(forResource: "SettingsMotivationalQuotes", ofType: "plist")
        let quotesArr = NSArray(contentsOfFile: path!)
        firstQuote = quotesArr?.firstObject as! NSDictionary
        
        tableViewData.delegate = self
        tableViewData.dataSource = self
        imagePicker.delegate = self
        
        getData()
        updateUI()
        
    }
    
    func updateUI() {
        chooseBtn.backgroundColor = Config.shared.baseColor()
        switcher.onTintColor = Config.shared.baseColor()
        
        let selectedIndex = UserDefaults.standard.integer(forKey: "designTheme")
        
        underButtonText.text = selectedIndex == 1 ? LS("tap_and_hold") : LS("show_random_quotes")
        switcher.isHidden = selectedIndex == 1 ? true : false
        underButtonText.textAlignment = selectedIndex == 1 ? .center : .left
        switcher.isOn = UserDefaults.standard.integer(forKey: "randomQuotes") == 1 ? true : false
    }
    
    @IBAction func addPressed(_ sender: MTButton) {
        
        let selectedIndex = UserDefaults.standard.integer(forKey: "designTheme")
        selectedIndex == 1 ? addPhotoOrImage() : addQuates()
    }
    
    func addQuates() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "QuotesAlertController") as? QuotesAlertController {
            
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            controller.phather = self
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    func addPhotoOrImage() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: LS("photo"), style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let gallery = UIAlertAction(title: LS("gallery"), style: .default) { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: LS("cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(photo)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func switcherPressed(_ sender: UISwitch) {
        
        UserDefaults.standard.set(switcher.isOn ? 1 : 0, forKey: "randomQuotes")
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("reloadDATA"), object: nil)
        
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
    
    
    func indexPathsForRowsInSection(_ section: Int, numberOfRows: Int) -> [IndexPath] {
        return (0..<numberOfRows).map{IndexPath(row: $0, section: section)}
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
            
            let selectedIndex = UserDefaults.standard.integer(forKey: "designTheme")
            if selectedIndex == 0 {
                let quoteCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[2], for: indexPath) as! DashboardQuoteTableViewCell
                
                let choosedQuote = UserDefaults.standard.object(forKey: "motivationalQuote") as? NSDictionary
                
                let quote = choosedQuote?.object(forKey: LS("quote")) ?? firstQuote.object(forKey: LS("quote"))
                let autor = choosedQuote?.object(forKey: "autor") ?? firstQuote.object(forKey: "autor")
                
                quoteCell.labelQuote.text = "\"\(quote ?? "")\""
                quoteCell.labelAuthor.text = "- \(autor ?? "")"
                
                return quoteCell
            
            } else {
                
                let picturesCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[1], for: indexPath) as! SettingsPictureTableViewCell
                picturesCell.delegate = self
                
                return picturesCell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[0], for: indexPath) as! SettingsDashboardDesignTableViewCell
            
            cell.nameOfDesign.text = data[indexPath.row]
            cell.check.isHidden = UserDefaults.standard.integer(forKey: "designTheme") == indexPath.row ? false : true
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == data.count {
            
            return UserDefaults.standard.integer(forKey: "designTheme") == 1 ? lastRowHeight(pictureData.count) : 230
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(indexPath.row, forKey: "designTheme")
        let ips = indexPathsForRowsInSection(0, numberOfRows: data.count + 1)
        
        if indexPath.row == 1 {
            switcher.isHidden = true
            underButtonText.text = LS("tap_and_hold")
            underButtonText.textAlignment = .center
            tableViewData.reloadRows(at: ips, with: .automatic)
        } else if indexPath.row == 0 {
            switcher.isHidden = false
            underButtonText.text = LS("show_random_quotes")
            underButtonText.textAlignment = .left
            tableViewData.reloadRows(at: ips, with: .automatic)
        }
        
        
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

        if indexPath.row > 5 {
            
            let alertController = UIAlertController(title: nil, message: LS("want_delete"), preferredStyle: .alert)
            let ok = UIAlertAction(title: LS("ok"), style: .default) { _ in
                
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
            let cancel = UIAlertAction(title: LS("cancel"), style: .cancel, handler: nil)
            
            alertController.addAction(ok)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
       
        } else {
            
            let alert = UIAlertController(title: "", message: LS("can_not_delete"), preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}


