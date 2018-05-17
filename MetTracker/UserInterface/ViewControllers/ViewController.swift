//
//  ViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isFirstRun: Bool {
        get { return UserDefaults.standard.value(forKey: "isFirstRun") as? Bool ?? true }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "isFirstRun")
            userDefaults.synchronize()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.loadData()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (isFirstRun) {
            
            isFirstRun = false
            
            let path = Bundle.main.path(forResource: "SettingsPictures", ofType: "plist")
            if let imageData: NSArray = NSArray(contentsOfFile: path!) {
                var arrOfImgs = [UIImage]()
                
                for img in imageData {
                    if let image = UIImage(named: img as! String) {
                        arrOfImgs.append(image)
                    }
                }
                addDashBoard(pictures: arrOfImgs)
            }
            
            
            
            UserDefaults.standard.set(true, forKey: "addHint")
            UserDefaults.standard.set(2, forKey: "designTheme")
            UserDefaults.standard.set(0, forKey: "MaxWeekResult")
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            controller.currentPageSet = 0
            let navigation = UINavigationController.init(rootViewController: controller)
            navigation.setNavigationBarHidden(true, animated: false)
            self.present(navigation, animated: false)
            
        } else {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainDashboardViewController") as! MainDashboardViewController
            
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    
    func addDashBoard(pictures: [UIImage]) {
        
        let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var selected = true
        
        for image in pictures {
            
            let rndm = randomString()
            
            saveImageDocumentDirectory(image: image, name: rndm)
            saveImageDocumentDirectory(image: strongCompressImage(image), name: rndm + "small")
            
            let newPicture = Design(context: contex)
            newPicture.date = NSDate()
            newPicture.picturePath = rndm
            newPicture.selected = selected
            selected = false
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToStart(segue:UIStoryboardSegue) {
        
        dismiss(animated: false, completion: {
          
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainDashboardViewController") as! MainDashboardViewController
            
            self.navigationController?.pushViewController(controller, animated: false)
            
        })
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

