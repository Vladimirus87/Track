//
//  StatisticsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifiers = ["StatisticsTrendTableViewCell", "StatisticsPeaksTableViewCell", "StatisticsFavoriteTableViewCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
    }

    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = cellIdentifiers[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StatisticsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        

        return cell
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("statistics")
         
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
