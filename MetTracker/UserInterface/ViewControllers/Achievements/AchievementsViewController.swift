//
//  AchievementsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class AchievementsViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableViewData: UITableView!
    
    var data = [Tracking]()
    
     let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        
        do {
            let sortDescr = NSSortDescriptor(key: "date", ascending: false)
            let fetchRequest : NSFetchRequest<Tracking> = Tracking.fetchRequest()
            fetchRequest.sortDescriptors = [sortDescr]
            data = try contex.fetch(fetchRequest)
            backgroundForTableView()
        } catch {
            print("Fetching Failed")
        }
    }
    
    func backgroundForTableView() {
        
        if data.isEmpty {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: view.frame.height / 2 - 150), size: CGSize(width: view.frame.width, height: 200)))
            imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "tableViewIsEmpty")!
            imageView.image = image
            view.addSubview(imageView)
            tableViewData.alpha = 0
        }
    }
    

    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AchievementTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AchievementTableViewCell
        
        cell.dataForCell(self.data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AchievementDetailsViewController") as? AchievementDetailsViewController {
            
            controller.tracking = data[indexPath.row]
            
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
            
            
        }
    }

    
    // MARK: - Notifications
    
    override func updateColorScheme() {
     
        
    }
    
    // MARK: -

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
