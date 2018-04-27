//
//  QuotesAlertController.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 22.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class QuotesAlertController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var okBtn: MTButton!
    @IBOutlet weak var cancelBtn: MTButton!
    
    var phather: SettingsDashboardDesignViewController?
    var dataArr : NSArray!
    var choosedComponent: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "SettingsMotivationalQuotes", ofType: "plist")
        dataArr = NSArray(contentsOfFile: path!)
        
        
        picker.delegate = self
        picker.dataSource = self
        
        
        okBtn.backgroundColor = Config.shared.baseColor()
        cancelBtn.tintColor = Config.shared.baseColor()
        cancelBtn.setTitle(LS("cancel"), for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func okBtnPressed(_ sender: MTButton) {

        UserDefaults.standard.set(choosedComponent ?? dataArr.firstObject, forKey: "motivationalQuote")
        phather?.tableViewData.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: MTButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}



extension QuotesAlertController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = dataArr[row] as! NSDictionary
        let quote = data.object(forKey: LS("quote")) as! String
        let autor = data.object(forKey: "autor") as! String
        
        let viewRow = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 150))
        let quoteLbl = UILabel(frame: CGRect(x: 12, y: 8, width: viewRow.frame.width - 24, height: viewRow.frame.height - 28))
        quoteLbl.text = quote
        quoteLbl.font = UIFont(name:"Quicksand-Medium", size: 20.0)
        quoteLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        quoteLbl.textAlignment = .center
        quoteLbl.numberOfLines = 0
        
        let autorLbl = UILabel(frame: CGRect(x: 12, y: quoteLbl.frame.height + 8, width: viewRow.frame.width - 24, height: 12))
        autorLbl.text = autor
        autorLbl.font = UIFont(name:"Quicksand-Medium", size: 16.0)
        autorLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        autorLbl.textAlignment = .right
        autorLbl.numberOfLines = 1
        
        viewRow.addSubview(quoteLbl)
        viewRow.addSubview(autorLbl)
        
        return viewRow
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 150
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedComponent = dataArr[row] as? NSDictionary
    }
    
    
}
