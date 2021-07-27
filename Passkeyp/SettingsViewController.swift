//
//  SettingsViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var matchSystemSwitch: UISwitch!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matchSystemSwitch.onTintColor = accentColor
        darkModeSwitch.onTintColor = accentColor
        faqButton.setTitleColor(accentColor, for: .normal)
        aboutButton.setTitleColor(accentColor, for: .normal)
    }
    
    @IBAction func matchChanged(_ sender: Any) {
        if matchSystemSwitch.isOn {
            darkModeSwitch.isOn = false
            let current = UITraitCollection.current.userInterfaceStyle
            view.window?.overrideUserInterfaceStyle = current
            overrideUserInterfaceStyle = current
        } else {
            // default to light
            view.window?.overrideUserInterfaceStyle = .light
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func darkChanged(_ sender: Any) {
        if darkModeSwitch.isOn {
            // cannot have both turned on
            matchSystemSwitch.isOn = false
            view.window?.overrideUserInterfaceStyle = .dark
            overrideUserInterfaceStyle = .dark
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            overrideUserInterfaceStyle = .light
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
