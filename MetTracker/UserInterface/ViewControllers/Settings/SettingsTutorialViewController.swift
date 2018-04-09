//
//  SettingsTutorialViewController
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTutorialViewController: MTViewController {

    @IBOutlet weak var infoTitle: MTLabel!
    @IBOutlet weak var tutorialTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialTextView.attributedText = loadRTF(from: "Tutorial")
    }

    func loadRTF(from resource: String) -> NSAttributedString? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "rtf") else { return nil }
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        return try? NSAttributedString(data: data,
                                       options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                       documentAttributes: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

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


