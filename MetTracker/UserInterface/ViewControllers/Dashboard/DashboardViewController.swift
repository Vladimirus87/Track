//
//  DashboardViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gaugeProgress: MTGauge!
    @IBOutlet weak var labelWeek: MTLabel!
    @IBOutlet weak var labelWeekday: MTLabel!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var metsProgress: UILabel!
    
    var weekCounts: Int?
    var dayOfWeek: String?
    var roundProgress: Double?
    var countOfMeets: Float?
    
    var metsData = [Tracking]()
    var pictureData = [Design]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var themes = ["DashboardQuoteTableViewCell", "DashboardPictureTableViewCell", "DashboardCrabsTableViewCell"]
    
    let dashboardHint = "DashboardHintTableViewCell"
    
    var showingThem: String {
        return themes[UserDefaults.standard.integer(forKey: "designTheme")]
    }
    
    var cellIdentifiers = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPictureCell), name: NSNotification.Name.init("reloadDATA"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name.init("reloadDashboard"), object: nil)
    
        getDesignData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    

    
    func registerCells() {
        
        let imageForDshd = UserDefaults.standard.integer(forKey: "designTheme")
        
        if imageForDshd == 1 {
            bottomView.isHidden = true
            tableViewData.isUserInteractionEnabled = false
            bottomViewHeight.constant = 0
        } else {
            bottomView.isHidden = false
            tableViewData.isUserInteractionEnabled = true
            bottomViewHeight.constant = 100
        }
        
        cellIdentifiers = [showingThem]
        
        if UserDefaults.standard.bool(forKey: "addHint"), imageForDshd != 1 {
            cellIdentifiers.insert(dashboardHint, at: 0)
        }
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }



    override func resizeSubviews() {
        super.resizeSubviews()

    }
    
    
     // MARK: - UI
    
    func updateUI() {

        let today = Date()
        updateProgress(withPredicate: today)
        dayOfWeek = today.string(with: "EEEE")
        
        weekCounts = getWeek(today)
        
        labelWeekday.text = today.string(with: "EEEE")
        labelWeek.text = "\(LS("week")) \(weekCounts ?? 0)".uppercased()
    }
    
    
    
    
    func getWeek(_ today : Date) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
        let myComponents = myCalendar.components(.weekOfYear, from: today)
        let weekNumber = myComponents.weekOfYear
        return weekNumber!
    }
    
    
    
    func updateProgress(withPredicate: Date) {
        
        do {
            let firstLastDays = withPredicate.getFirstLastDaysOfWeek()
            
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [firstLastDays.0, firstLastDays.1])
            
            let fetchRequest : NSFetchRequest<Tracking> = Tracking.fetchRequest()
            fetchRequest.predicate = datePredicate
            
            metsData = try contex.fetch(fetchRequest)
            
            var countOfMets: Float = 0
            for i in metsData {
                countOfMets += i.mets
            }
            
            let progMaxWidth = 18.0
            
            let percentFromMets = (Double(countOfMets.rounded(toPlaces: 1)) * 100.0) / 18.0
            let progressWidth = progMaxWidth * percentFromMets / 100
            
            roundProgress = progressWidth
            countOfMeets = countOfMets
           
            if countOfMets > UserDefaults.standard.float(forKey: "MaxWeekResult") {
                 UserDefaults.standard.set(countOfMets.rounded(toPlaces: 2), forKey: "MaxWeekResult")
            }
            
            let formattedString = NSMutableAttributedString()
            
            metsProgress.attributedText = formattedString.bold("\(countOfMets.rounded(toPlaces: 2))").normal("/18")
            
            UserDefaults.standard.set(countOfMets, forKey: "countOfMets")
            
            gaugeProgress.updateWithProgress((roundProgress ?? 0) / 18.0, width: 8.0, color: Config.shared.baseColor())
            
            
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    
    func getDesignData() {
        do {
            pictureData = try contex.fetch(Design.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    func randomQuote() -> NSDictionary? {
        let path = Bundle.main.path(forResource: "SettingsMotivationalQuotes", ofType: "plist")
        guard let quotesArr = NSArray(contentsOfFile: path!) else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(quotesArr.count)))
        let quote = quotesArr[randomIndex] as! NSDictionary
        return quote
    }
    
    
    @objc func reloadPictureCell() {
        DispatchQueue.main.async {
            self.registerCells()
            self.tableViewData.reloadData()
        }
    }
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.updateProgress(withPredicate: Date())
            self.tableViewData.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch cell {
        case is DashboardHintTableViewCell :
            (cell as! DashboardHintTableViewCell).delegate = self
            (cell as! DashboardHintTableViewCell).viewBackground.backgroundColor = Config.shared.baseColor()
            (cell as! DashboardHintTableViewCell).textLbl.updateTextSize()
        case is DashboardPictureTableViewCell :
            let pictureCell = cell as! DashboardPictureTableViewCell
            pictureCell._countOfMeets = self.countOfMeets
            pictureCell._dayOfWeek = self.dayOfWeek
            pictureCell._roundProgress = self.roundProgress
            pictureCell._weekCounts = self.weekCounts
            pictureCell.pictureData = self.pictureData
            pictureCell.weekCounts.updateTextSize()
            pictureCell.dayOfWeek.updateTextSize()
        case is DashboardQuoteTableViewCell :
            let quoteCell = cell as! DashboardQuoteTableViewCell
            let random = UserDefaults.standard.integer(forKey: "randomQuotes")
            let quote = random == 1 ? randomQuote() : UserDefaults.standard.object(forKey: "motivationalQuote") as? NSDictionary
            let _quote = quote?.object(forKey: LS("quote")) as? String
            let _autor =  quote?.object(forKey: "autor") as? String
            quoteCell.labelQuote.text =  "\"\(_quote ?? "Be the change you wish for this world.")\""
            quoteCell.labelAuthor.text = "- \(_autor ?? "Mahatma Ghandi")"
        case is DashboardCrabsTableViewCell: (cell as! DashboardCrabsTableViewCell).countOfMets = self.countOfMeets
            
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let imageForDshd = UserDefaults.standard.integer(forKey: "designTheme")
        
        if indexPath.row == 1, cellIdentifiers.count == 2 && indexPath.row == 0, cellIdentifiers.count == 1, UserDefaults.standard.integer(forKey: "designTheme") == 0 {
            return 248
        } else if indexPath.row == 0, cellIdentifiers.count == 1, UserDefaults.standard.integer(forKey: "designTheme") == 1 && UserDefaults.standard.integer(forKey: "designTheme") == 2 {
            return self.tableViewData.frame.height
        } 
        
        return UITableViewAutomaticDimension
    }

    
    
    // MARK: - Actions
    
    @IBAction func buttonPlusPressed(_ sender: UIButton) {
            
        performSegue(withIdentifier: "toTrackingVC", sender: self)
    }
    

    // Mark: - Notifications
    
    override func updateColorScheme() {
//        updateUI()
        
        buttonPlus.backgroundColor = Config.shared.baseColor()
        gaugeProgress.updateWithProgress((roundProgress ?? 0) / 18.0, width: 8.0, color: Config.shared.baseColor())
    }
    
    override func updateTextSize() {
        
        labelWeekday.updateTextSize()
        labelWeek.updateTextSize()
//        self.tableViewData.reloadData()
    }
    
    // MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}





extension DashboardViewController: DashboardHintTableViewCellDelegate {
    
    
    
    func closeBtnPressed() {
        
        UserDefaults.standard.set(false, forKey: "addHint")
        cellIdentifiers.remove(at: 0)
//        tableViewData.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableViewData.reloadData()
    }
    
    func showSettingsBtnPressed() {
        
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsDashboardDesignViewController") as! SettingsDashboardDesignViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

}




//extension DashboardViewController: DashboardInfoTableViewCellDelegate {
//    func infoBtnPressed() {
//        
//        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsTutorialViewController") as! SettingsTutorialViewController
//        
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//}



