//
//  AboutViewController.swift
//  Passkeyp
//
//  Created by Ryan Travers on 8/13/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var blurb: UILabel!
    @IBOutlet weak var developers: UILabel!
    @IBOutlet weak var ryan: UILabel!
    @IBOutlet weak var daniel: UILabel!
    @IBOutlet weak var silvana: UILabel!
    @IBOutlet weak var rachel: UILabel!
    @IBOutlet weak var repo: UILabel!
    @IBOutlet weak var repoLink: UILabel!
    @IBOutlet weak var devBlurb: UILabel!
    @IBOutlet weak var web: UILabel!
    @IBOutlet weak var webLink: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = ModeSettingDataController.controller.getUserAccentColor()
        let labels: [UILabel] = [header,blurb ,developers,ryan,daniel,silvana,rachel,repo,repoLink,devBlurb,web,webLink]
        
        for label in labels {
            label.textColor = uIColor
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
