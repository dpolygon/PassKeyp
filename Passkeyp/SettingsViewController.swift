//
//  SettingsViewController.swift
//  Passkeyp
//
//  Created by Daniel Gonzalez on 7/20/21.
//

import UIKit
import Firebase

var currMatchSystem = true
var currDarkMode = false

class SettingsViewController: UITableViewController {

    private let segueIdentifier = "logInIdentifier"
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
        
        // set switches to current settings
        matchSystemSwitch.setOn(currMatchSystem, animated: false)
        darkModeSwitch.setOn(currDarkMode, animated: false)
    }
    
    @IBAction func matchChanged(_ sender: Any) {
        if matchSystemSwitch.isOn {
            // cannot both be on
            currMatchSystem = true
            darkModeSwitch.setOn(false, animated: true)
            darkModeSwitch.sendActions(for: .valueChanged)// this line will run changeToMode(true, false)
        } else {
            // default to light mode
            currMatchSystem = false
            changeToMode(matchBool: currMatchSystem, darkBool: currDarkMode)
        }
    }
    
    @IBAction func darkChanged(_ sender: Any) {
        if darkModeSwitch.isOn {
            // cannot have both turned on
            currDarkMode = true
            matchSystemSwitch.setOn(false, animated: true)
            matchSystemSwitch.sendActions(for: .valueChanged)// this line will run changeToMode(false, true)
        } else {
            // default value of match
            currDarkMode = false
            changeToMode(matchBool: currMatchSystem, darkBool: currDarkMode)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // code for log out selection
        if indexPath.section == 3 {
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                performSegue(withIdentifier: segueIdentifier, sender: nil)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
        }
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
