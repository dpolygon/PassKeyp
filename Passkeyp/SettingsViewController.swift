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
    let userSettings = ModeSettingDataController.controller

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uIColor = userSettings.getUserAccentColor()
        matchSystemSwitch.onTintColor = uIColor
        darkModeSwitch.onTintColor = uIColor
        faqButton.setTitleColor(uIColor, for: .normal)
        aboutButton.setTitleColor(uIColor, for: .normal)
        self.navigationController?.navigationBar.tintColor = uIColor
        
        // set switches to current settings
        matchSystemSwitch.setOn(userSettings.getMatchSystem(), animated: true)
        darkModeSwitch.setOn(userSettings.getUserDarkMode(), animated: true)
    }
    
    @IBAction func matchChanged(_ sender: Any) {
        if matchSystemSwitch.isOn {
            // cannot both be on
            userSettings.setMatchSystem(matchSystem: true)
            darkModeSwitch.setOn(false, animated: true)
            darkModeSwitch.sendActions(for: .valueChanged)// this line will run changeToMode(true, false)
        } else {
            // default to light mode
            userSettings.setMatchSystem(matchSystem: false)
            changeToMode(matchBool: userSettings.getMatchSystem(), darkBool: userSettings.getUserDarkMode())
        }
    }
    
    @IBAction func darkChanged(_ sender: Any) {
        if darkModeSwitch.isOn {
            // cannot have both turned on
            userSettings.setUserDarkMode(darkMode: true)
            matchSystemSwitch.setOn(false, animated: true)
            matchSystemSwitch.sendActions(for: .valueChanged)// this line will run changeToMode(false, true)
        } else {
            // default value of match
            userSettings.setUserDarkMode(darkMode: false)
            changeToMode(matchBool: userSettings.getMatchSystem(), darkBool: userSettings.getUserDarkMode())
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselecting row animation enabled
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func changeToMode(matchBool: Bool, darkBool: Bool){
        var style : UIUserInterfaceStyle!
        if matchBool {
            style = UITraitCollection.current.userInterfaceStyle
        } else if darkBool {
            style = UIUserInterfaceStyle.dark
        } else {
            style = UIUserInterfaceStyle.light
        }
        view.window?.overrideUserInterfaceStyle = style
        overrideUserInterfaceStyle = style
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
