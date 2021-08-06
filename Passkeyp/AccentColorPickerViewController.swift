//
//  AccentColorPickerViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

var accentColor: UIColor = UIColor.blue

class AccentColorPickerViewController: UIViewController {
    
    private let imageNames = (blue: "BlueAccent", red: "RedAccent", teal: "TealAccent", green: "GreenAccent", orange: "OrangeAccent", yellow: "YellowAccent")
        
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blueSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemBlue)
        previewImage.image = UIImage(named: imageNames.blue)
    }
    
    @IBAction func tealSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemTeal)
        previewImage.image = UIImage(named: imageNames.teal)
    }
    
    @IBAction func greenSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemGreen)
        previewImage.image = UIImage(named: imageNames.green)
    }
    
    @IBAction func redSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemRed)
        previewImage.image = UIImage(named: imageNames.red)
    }
    
    @IBAction func orangeSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemOrange)
        previewImage.image = UIImage(named: imageNames.orange)
    }
    
    @IBAction func yellowSelected(_ sender: Any) {
        ModeSettingDataController.controller.setUserAccentColor(accentColor: UIColor.systemYellow)
        previewImage.image = UIImage(named: imageNames.yellow)
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
