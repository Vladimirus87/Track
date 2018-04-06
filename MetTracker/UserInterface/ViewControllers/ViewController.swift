//
//  ViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
//    var isFirstRun = true // instead this var will use bottom var
///Code for show OnBoardingViewController only once(with first start app)
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
        UserDefaults.standard.set(true, forKey: "addHint")//temp
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (isFirstRun) {
            
            isFirstRun = false
            
            /// add in full version
            addDashBoard(pictures: [UIImage(named: "test_picture")!, UIImage(named: "test_crabs")!, UIImage(named: "test_crabs")!, UIImage(named: "test_crabs")!])
            UserDefaults.standard.set(true, forKey: "addHint")
            
            UserDefaults.standard.set(0, forKey: "designTheme")
            
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
    
    //add pictures with to dashboard with first run
    
    func addDashBoard(pictures: [UIImage]) {
        
        let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for image in pictures {
            
            let rndm = randomString()
            
            saveImageDocumentDirectory(image: image, name: rndm)
            saveImageDocumentDirectory(image: compressImage(image), name: rndm + "small")
            
            let newPicture = Design(context: contex)
            newPicture.date = NSDate()
            newPicture.picturePath = rndm
            newPicture.selected = false//image != pictures.first ? false : true
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

